"""
Demo query service — demonstrates all 12 test query patterns from Phase 1 spec.

These are service-layer functions, not API endpoints.
Run via: python scripts/run_demo_queries.py
"""
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from sqlalchemy.orm import Session
from sqlalchemy import select, func, and_, or_
from pgvector.sqlalchemy import Vector

from app.core.database import SessionLocal
from app.models import (
    Student, StudentEducation, StudentSubject, StudentSkill, StudentInterest,
    Skill, Interest, Career, CareerSkill, CareerCourse,
    Opportunity, Scholarship, Course, CourseInstitution, Institution,
    EntranceExam, EligibilityRule, OpportunityDocument, DocumentChunk,
)
from app.models.opportunity import OpportunityType, OpportunityStatus
from app.models.eligibility import RuleType, RuleOperator


# ── 1. Create a student ───────────────────────────────────────────────────
def demo_create_student(db: Session, name: str, phone: str, preferred_language: str = "en"):
    """Create a new student record."""
    from datetime import date
    from app.models.student import Gender
    student = Student(
        name=name,
        phone=phone,
        preferred_language=preferred_language,
        profile_completeness=0.1,
    )
    db.add(student)
    db.commit()
    db.refresh(student)
    print(f"[Q1] Created student: {student.name} ({student.id})")
    return student


# ── 2. Add education to a student ─────────────────────────────────────────
def demo_add_education(db: Session, student_id, institution_name: str, level, status):
    """Add an education record for a student."""
    from app.models.education import DataSource
    edu = StudentEducation(
        student_id=student_id,
        institution_name=institution_name,
        education_level=level,
        status=status,
        source=DataSource.STUDENT_REPORTED,
    )
    db.add(edu)
    db.commit()
    db.refresh(edu)
    print(f"[Q2] Added education: {edu.education_level} @ {edu.institution_name}")
    return edu


# ── 3. Add skills to a student ────────────────────────────────────────────
def demo_add_skill(db: Session, student_id, skill_name: str):
    """Find a skill by name and link it to a student."""
    from app.models.education import DataSource
    skill = db.execute(select(Skill).where(Skill.canonical_name == skill_name)).scalar_one_or_none()
    if not skill:
        print(f"[Q3] Skill '{skill_name}' not found in catalogue.")
        return None
    student_skill = StudentSkill(student_id=student_id, skill_id=skill.id,
                                 source=DataSource.STUDENT_REPORTED)
    db.add(student_skill)
    db.commit()
    print(f"[Q3] Added skill '{skill_name}' to student {student_id}")
    return student_skill


# ── 4. Add interests to a student ─────────────────────────────────────────
def demo_add_interest(db: Session, student_id, interest_name: str):
    """Find an interest by name and link it to a student."""
    from app.models.education import DataSource
    interest = db.execute(select(Interest).where(Interest.name == interest_name)).scalar_one_or_none()
    if not interest:
        print(f"[Q4] Interest '{interest_name}' not found.")
        return None
    student_interest = StudentInterest(student_id=student_id, interest_id=interest.id,
                                       strength=0.8, source=DataSource.STUDENT_REPORTED)
    db.add(student_interest)
    db.commit()
    print(f"[Q4] Added interest '{interest_name}' to student {student_id}")
    return student_interest


# ── 5. Find careers related to a student's skills/interests ───────────────
def demo_find_careers_for_student(db: Session, student_id) -> list[Career]:
    """
    Find careers that match the student's skills.
    Returns careers where the student has at least one required/preferred skill.
    """
    # Get student's skill IDs
    student_skill_ids = db.execute(
        select(StudentSkill.skill_id).where(StudentSkill.student_id == student_id)
    ).scalars().all()

    if not student_skill_ids:
        print(f"[Q5] No skills found for student {student_id}")
        return []

    # Find careers that have those skills
    careers = db.execute(
        select(Career)
        .join(CareerSkill, Career.id == CareerSkill.career_id)
        .where(CareerSkill.skill_id.in_(student_skill_ids))
        .distinct()
    ).scalars().all()

    print(f"[Q5] Careers matching student's skills: {[c.name for c in careers]}")
    return careers


# ── 6. Find scholarships by location ──────────────────────────────────────
def demo_find_scholarships_by_location(db: Session, state: str) -> list[Opportunity]:
    """
    Find active scholarships available in a given state (or nationally).
    """
    from app.models.location import Location

    scholarships = db.execute(
        select(Opportunity)
        .join(Scholarship, Opportunity.id == Scholarship.opportunity_id)
        .outerjoin(Location, Opportunity.location_id == Location.id)
        .where(
            Opportunity.status == OpportunityStatus.ACTIVE,
            or_(
                Location.state == state,
                Location.state.is_(None),
                Opportunity.location_id.is_(None),  # national opportunities
                Location.id.is_(None),              # no location = national
            )
        )
    ).scalars().all()

    print(f"[Q6] Scholarships available in {state}: {[o.title for o in scholarships]}")
    return scholarships


# ── 7. Find opportunities by type ─────────────────────────────────────────
def demo_find_opportunities_by_type(db: Session, opp_type: OpportunityType) -> list[Opportunity]:
    """Return all active opportunities of a specific type."""
    opportunities = db.execute(
        select(Opportunity)
        .where(
            Opportunity.type == opp_type,
            Opportunity.status == OpportunityStatus.ACTIVE,
        )
        .order_by(Opportunity.application_deadline)
    ).scalars().all()

    print(f"[Q7] {opp_type} opportunities: {[o.title for o in opportunities]}")
    return opportunities


# ── 8. Evaluate basic eligibility rules ───────────────────────────────────
def demo_evaluate_eligibility(db: Session, opportunity_id, student_profile: dict) -> dict:
    """
    Deterministically evaluate eligibility rules for an opportunity
    against a student profile dict.

    student_profile example:
    {
        "income": 300000,
        "state": "Maharashtra",
        "gender": "female",
        "education_level": "bachelor",
        "social_category": "OBC",
        "rural_status": "rural",
    }
    """
    rules = db.execute(
        select(EligibilityRule).where(EligibilityRule.opportunity_id == opportunity_id)
    ).scalars().all()

    results = []
    for rule in rules:
        field = rule.rule_type.value.lower()
        student_value = student_profile.get(field)
        rule_value = rule.value

        passed = None
        reason = ""

        if student_value is None:
            passed = not rule.required  # unknown value: pass if optional, fail if required
            reason = f"Student value for '{field}' is unknown"
        elif rule.operator == RuleOperator.EQ:
            passed = str(student_value).lower() == rule_value.lower()
        elif rule.operator == RuleOperator.NEQ:
            passed = str(student_value).lower() != rule_value.lower()
        elif rule.operator == RuleOperator.LTE:
            passed = float(student_value) <= float(rule_value)
        elif rule.operator == RuleOperator.LT:
            passed = float(student_value) < float(rule_value)
        elif rule.operator == RuleOperator.GTE:
            passed = float(student_value) >= float(rule_value)
        elif rule.operator == RuleOperator.GT:
            passed = float(student_value) > float(rule_value)
        elif rule.operator == RuleOperator.IN:
            allowed = [v.strip().lower() for v in rule_value.split(",")]
            passed = str(student_value).lower() in allowed
        elif rule.operator == RuleOperator.NOT_IN:
            excluded = [v.strip().lower() for v in rule_value.split(",")]
            passed = str(student_value).lower() not in excluded
        elif rule.operator == RuleOperator.EXISTS:
            passed = student_value is not None

        results.append({
            "rule": f"{rule.rule_type} {rule.operator} {rule.value}",
            "required": rule.required,
            "passed": passed,
            "description": rule.description,
        })

    all_required_pass = all(r["passed"] for r in results if r["required"])
    print(f"[Q8] Eligibility for opp={opportunity_id}: {'ELIGIBLE' if all_required_pass else 'NOT ELIGIBLE'}")
    for r in results:
        icon = "✅" if r["passed"] else ("❌" if r["required"] else "⚠️")
        print(f"     {icon} {r['rule']}")
    return {"eligible": all_required_pass, "rules": results}


# ── 9. Find courses related to a career ───────────────────────────────────
def demo_find_courses_for_career(db: Session, career_name: str) -> list[Opportunity]:
    """Find courses linked to a career."""
    from app.models.career import CareerCourse as CareerCourseModel

    career = db.execute(select(Career).where(Career.name == career_name)).scalar_one_or_none()
    if not career:
        print(f"[Q9] Career '{career_name}' not found.")
        return []

    courses = db.execute(
        select(Opportunity)
        .join(Course, Opportunity.id == Course.opportunity_id)
        .join(CareerCourseModel, Course.opportunity_id == CareerCourseModel.course_id)
        .where(CareerCourseModel.career_id == career.id)
    ).scalars().all()

    print(f"[Q9] Courses for '{career_name}': {[c.title for c in courses]}")
    return courses


# ── 10. Find institutions offering a course ────────────────────────────────
def demo_find_institutions_for_course(db: Session, course_title: str) -> list[Institution]:
    """Find institutions offering a specific course."""
    opportunity = db.execute(
        select(Opportunity).where(Opportunity.title == course_title)
    ).scalar_one_or_none()

    if not opportunity:
        print(f"[Q10] Course '{course_title}' not found.")
        return []

    institutions = db.execute(
        select(Institution)
        .join(CourseInstitution, Institution.id == CourseInstitution.institution_id)
        .where(CourseInstitution.course_id == opportunity.id)
    ).scalars().all()

    print(f"[Q10] Institutions for '{course_title}': {[i.name for i in institutions]}")
    return institutions


# ── 11. Retrieve documents belonging to an opportunity ─────────────────────
def demo_get_opportunity_documents(db: Session, opportunity_id) -> list[OpportunityDocument]:
    """Retrieve all documents associated with an opportunity."""
    docs = db.execute(
        select(OpportunityDocument).where(OpportunityDocument.opportunity_id == opportunity_id)
    ).scalars().all()

    print(f"[Q11] Documents for opp={opportunity_id}: {len(docs)} found")
    return docs


# ── 12. pgvector similarity search ────────────────────────────────────────
def demo_vector_search(db: Session, query_embedding: list[float], top_k: int = 5) -> list[DocumentChunk]:
    """
    Perform approximate nearest-neighbour search on document_chunks using pgvector.
    Returns the top_k most similar chunks by cosine similarity.

    Note: In Phase 1 no embeddings exist yet, but this validates the schema works.
    """
    from pgvector.sqlalchemy import Vector
    from app.core.config import settings

    results = db.execute(
        select(DocumentChunk)
        .where(DocumentChunk.embedding.isnot(None))
        .order_by(DocumentChunk.embedding.cosine_distance(query_embedding))
        .limit(top_k)
    ).scalars().all()

    print(f"[Q12] Vector search returned {len(results)} chunks")
    return results

"""
Integration tests for demo query functions.
Requires a running PostgreSQL database with seeded data.
Skip if DB is not available.
"""
import pytest
from sqlalchemy import text

from app.core.database import SessionLocal, check_db_connection
from app.models.opportunity import OpportunityType
from app.models.education import EducationLevel, EducationStatus
from app.services.demo_queries import (
    demo_create_student,
    demo_add_education,
    demo_add_skill,
    demo_add_interest,
    demo_find_careers_for_student,
    demo_find_scholarships_by_location,
    demo_find_opportunities_by_type,
    demo_evaluate_eligibility,
    demo_find_courses_for_career,
    demo_find_institutions_for_course,
    demo_get_opportunity_documents,
    demo_vector_search,
)


# Skip all tests if DB is unreachable
pytestmark = pytest.mark.skipif(
    not check_db_connection(),
    reason="PostgreSQL not available"
)


@pytest.fixture(scope="module")
def db():
    session = SessionLocal()
    yield session
    session.close()


def test_q1_create_student(db):
    """Q1: Create a student."""
    student = demo_create_student(db, name="Test Student", phone="+919999000001", preferred_language="en")
    assert student.id is not None
    assert student.name == "Test Student"
    # Cleanup
    db.delete(student)
    db.commit()


def test_q2_add_education(db):
    """Q2: Add education to a student."""
    student = demo_create_student(db, "Test Edu Student", "+919999000002")
    edu = demo_add_education(
        db, student.id, "Test School",
        EducationLevel.SECONDARY, EducationStatus.COMPLETED
    )
    assert edu.id is not None
    assert edu.student_id == student.id
    # Cleanup (cascade deletes education)
    db.delete(student)
    db.commit()


def test_q3_add_skill(db):
    """Q3: Add skill to student."""
    student = demo_create_student(db, "Test Skill Student", "+919999000003")
    result = demo_add_skill(db, student.id, "Python Programming")
    assert result is not None
    db.delete(student)
    db.commit()


def test_q4_add_interest(db):
    """Q4: Add interest to student."""
    student = demo_create_student(db, "Test Interest Student", "+919999000004")
    result = demo_add_interest(db, student.id, "Computers & Technology")
    assert result is not None
    db.delete(student)
    db.commit()


def test_q5_find_careers_for_student(db):
    """Q5: Find careers for student with skills."""
    from sqlalchemy import select
    from app.models import Student
    # Use Priya from seed data
    student = db.execute(select(Student).where(Student.name == "Priya Shinde")).scalar_one_or_none()
    if student is None:
        pytest.skip("Seed data not available")
    careers = demo_find_careers_for_student(db, student.id)
    assert isinstance(careers, list)


def test_q6_find_scholarships_by_location(db):
    """Q6: Find scholarships by location (Maharashtra)."""
    scholarships = demo_find_scholarships_by_location(db, "Maharashtra")
    assert isinstance(scholarships, list)


def test_q7_find_opportunities_by_type(db):
    """Q7: Find opportunities by type."""
    opps = demo_find_opportunities_by_type(db, OpportunityType.SCHOLARSHIP)
    assert isinstance(opps, list)
    for o in opps:
        assert o.type == OpportunityType.SCHOLARSHIP


def test_q8_evaluate_eligibility(db):
    """Q8: Evaluate eligibility rules."""
    from sqlalchemy import select
    from app.models import Opportunity
    from app.models.opportunity import OpportunityType

    opp = db.execute(
        select(Opportunity).where(Opportunity.type == OpportunityType.SCHOLARSHIP)
    ).scalars().first()

    if not opp:
        pytest.skip("No scholarships in DB")

    student_profile = {
        "income": 300000,
        "state": "Maharashtra",
        "gender": "female",
        "education_level": "bachelor",
        "social_category": "OBC",
        "rural_status": "rural",
        "nationality": "Indian",
        "percentage": 85.0,
    }
    result = demo_evaluate_eligibility(db, opp.id, student_profile)
    assert "eligible" in result
    assert isinstance(result["eligible"], bool)
    assert isinstance(result["rules"], list)


def test_q9_find_courses_for_career(db):
    """Q9: Find courses related to a career."""
    courses = demo_find_courses_for_career(db, "Software Engineer")
    assert isinstance(courses, list)


def test_q10_find_institutions_for_course(db):
    """Q10: Find institutions offering a course."""
    institutions = demo_find_institutions_for_course(db, "B.Tech Computer Science & Engineering")
    assert isinstance(institutions, list)


def test_q11_get_opportunity_documents(db):
    """Q11: Retrieve documents for an opportunity."""
    from sqlalchemy import select
    from app.models import Opportunity
    opp = db.execute(select(Opportunity)).scalars().first()
    if not opp:
        pytest.skip("No opportunities in DB")
    docs = demo_get_opportunity_documents(db, opp.id)
    assert isinstance(docs, list)


def test_q12_vector_search(db):
    """Q12: pgvector similarity search should return valid chunks when embeddings exist."""
    from app.core.config import settings
    zero_vector = [0.0] * settings.vector_dim
    results = demo_vector_search(db, zero_vector, top_k=5)
    assert isinstance(results, list)
    assert len(results) <= 5
    if results:
        assert all(chunk.embedding is not None for chunk in results)

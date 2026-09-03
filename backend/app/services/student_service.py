"""
Service layer for Student domain: CRUD, profile completeness, nested sub-resources,
and automated student eligibility matching.
"""
from typing import Optional, List, Tuple, Dict, Any
from uuid import UUID
from datetime import date
from sqlalchemy.orm import Session, joinedload, selectinload
from sqlalchemy import select, func, or_

from app.models.student import Student, Gender
from app.models.education import StudentEducation, StudentSubject
from app.models.skill import StudentSkill, Skill
from app.models.interest import StudentInterest, Interest
from app.models.aspiration import StudentAspiration
from app.models.location import Location
from app.models.opportunity import Opportunity, OpportunityStatus
from app.schemas.student import (
    StudentCreate, StudentUpdate,
    StudentEducationCreate, StudentSkillCreate,
    StudentInterestCreate, StudentAspirationCreate,
)
from app.schemas.opportunity import EligibilityCheckResult
from app.services.opportunity_service import OpportunityService


class StudentService:
    @staticmethod
    def calculate_completeness(student: Student) -> float:
        score = 0.0
        # Core demographic fields
        if student.name:
            score += 0.15
        if student.phone:
            score += 0.10
        if student.email:
            score += 0.05
        if student.date_of_birth:
            score += 0.05
        if student.gender:
            score += 0.05
        if student.location_id:
            score += 0.10

        # Sub-resources
        if student.education_records:
            score += 0.20
        if student.skills:
            score += 0.15
        if student.interests:
            score += 0.10
        if student.aspirations:
            score += 0.05

        return round(min(1.0, max(0.1, score)), 2)

    @staticmethod
    def create_student(db: Session, data: StudentCreate) -> Student:
        student = Student(**data.model_dump())
        student.profile_completeness = 0.20
        db.add(student)
        db.commit()
        db.refresh(student)
        student.profile_completeness = StudentService.calculate_completeness(student)
        db.commit()
        db.refresh(student)
        return student

    @staticmethod
    def get_student(db: Session, student_id: UUID) -> Optional[Student]:
        return db.execute(
            select(Student).where(Student.id == student_id)
        ).scalar_one_or_none()

    @staticmethod
    def get_student_detail(db: Session, student_id: UUID) -> Optional[Student]:
        stmt = (
            select(Student)
            .options(
                joinedload(Student.location),
                selectinload(Student.education_records).selectinload(StudentEducation.subjects),
                selectinload(Student.skills).joinedload(StudentSkill.skill),
                selectinload(Student.interests).joinedload(StudentInterest.interest),
                selectinload(Student.aspirations),
            )
            .where(Student.id == student_id)
        )
        return db.execute(stmt).scalar_one_or_none()

    @staticmethod
    def list_students(
        db: Session,
        search: Optional[str] = None,
        location_id: Optional[UUID] = None,
        limit: int = 20,
        offset: int = 0,
    ) -> Tuple[List[Student], int]:
        stmt = select(Student)
        count_stmt = select(func.count(Student.id))

        if location_id:
            stmt = stmt.where(Student.location_id == location_id)
            count_stmt = count_stmt.where(Student.location_id == location_id)

        if search:
            stmt = stmt.where(
                or_(
                    Student.name.ilike(f"%{search}%"),
                    Student.phone.ilike(f"%{search}%"),
                    Student.email.ilike(f"%{search}%"),
                )
            )
            count_stmt = count_stmt.where(
                or_(
                    Student.name.ilike(f"%{search}%"),
                    Student.phone.ilike(f"%{search}%"),
                    Student.email.ilike(f"%{search}%"),
                )
            )

        total = db.execute(count_stmt).scalar_one()
        items = list(
            db.execute(
                stmt.order_by(Student.created_at.desc())
                .offset(offset)
                .limit(limit)
            ).scalars().all()
        )
        return items, total

    @staticmethod
    def update_student(db: Session, student_id: UUID, data: StudentUpdate) -> Optional[Student]:
        student = StudentService.get_student_detail(db, student_id)
        if not student:
            return None

        for field, value in data.model_dump(exclude_unset=True).items():
            setattr(student, field, value)

        student.profile_completeness = StudentService.calculate_completeness(student)
        db.commit()
        return StudentService.get_student_detail(db, student_id)

    @staticmethod
    def delete_student(db: Session, student_id: UUID) -> bool:
        student = StudentService.get_student(db, student_id)
        if not student:
            return False
        db.delete(student)
        db.commit()
        return True

    # --- Sub-resources ---
    @staticmethod
    def add_education(db: Session, student_id: UUID, data: StudentEducationCreate) -> Optional[StudentEducation]:
        student = StudentService.get_student_detail(db, student_id)
        if not student:
            return None

        subjects_data = data.subjects
        edu_dict = data.model_dump(exclude={"subjects"})
        edu = StudentEducation(student_id=student_id, **edu_dict)
        db.add(edu)
        db.flush()

        if subjects_data:
            for sub_in in subjects_data:
                sub = StudentSubject(student_education_id=edu.id, **sub_in.model_dump())
                db.add(sub)

        student.profile_completeness = StudentService.calculate_completeness(student)
        db.commit()
        # Eager load subjects for response
        return db.execute(
            select(StudentEducation)
            .options(selectinload(StudentEducation.subjects))
            .where(StudentEducation.id == edu.id)
        ).scalar_one()

    @staticmethod
    def delete_education(db: Session, student_id: UUID, education_id: UUID) -> bool:
        edu = db.execute(
            select(StudentEducation).where(
                StudentEducation.id == education_id,
                StudentEducation.student_id == student_id,
            )
        ).scalar_one_or_none()
        if not edu:
            return False
        db.delete(edu)
        db.commit()
        student = StudentService.get_student_detail(db, student_id)
        if student:
            student.profile_completeness = StudentService.calculate_completeness(student)
            db.commit()
        return True

    @staticmethod
    def add_skill(db: Session, student_id: UUID, data: StudentSkillCreate) -> Optional[StudentSkill]:
        student = StudentService.get_student_detail(db, student_id)
        if not student:
            return None

        existing = db.execute(
            select(StudentSkill).where(
                StudentSkill.student_id == student_id,
                StudentSkill.skill_id == data.skill_id,
            )
        ).scalar_one_or_none()
        if existing:
            existing.proficiency = data.proficiency
            existing.years_experience = data.years_experience
            existing.source = data.source
            existing.confidence = data.confidence
            db.commit()
            db.refresh(existing)
            return existing

        sk = StudentSkill(student_id=student_id, **data.model_dump())
        db.add(sk)
        student.profile_completeness = StudentService.calculate_completeness(student)
        db.commit()
        db.refresh(sk)
        return sk

    @staticmethod
    def delete_skill(db: Session, student_id: UUID, skill_id: UUID) -> bool:
        sk = db.execute(
            select(StudentSkill).where(
                StudentSkill.student_id == student_id,
                StudentSkill.skill_id == skill_id,
            )
        ).scalar_one_or_none()
        if not sk:
            return False
        db.delete(sk)
        db.commit()
        student = StudentService.get_student_detail(db, student_id)
        if student:
            student.profile_completeness = StudentService.calculate_completeness(student)
            db.commit()
        return True

    @staticmethod
    def add_interest(db: Session, student_id: UUID, data: StudentInterestCreate) -> Optional[StudentInterest]:
        student = StudentService.get_student_detail(db, student_id)
        if not student:
            return None

        existing = db.execute(
            select(StudentInterest).where(
                StudentInterest.student_id == student_id,
                StudentInterest.interest_id == data.interest_id,
            )
        ).scalar_one_or_none()
        if existing:
            existing.strength = data.strength
            existing.source = data.source
            existing.confidence = data.confidence
            db.commit()
            db.refresh(existing)
            return existing

        st_interest = StudentInterest(student_id=student_id, **data.model_dump())
        db.add(st_interest)
        student.profile_completeness = StudentService.calculate_completeness(student)
        db.commit()
        db.refresh(st_interest)
        return st_interest

    @staticmethod
    def delete_interest(db: Session, student_id: UUID, interest_id: UUID) -> bool:
        si = db.execute(
            select(StudentInterest).where(
                StudentInterest.student_id == student_id,
                StudentInterest.interest_id == interest_id,
            )
        ).scalar_one_or_none()
        if not si:
            return False
        db.delete(si)
        db.commit()
        student = StudentService.get_student_detail(db, student_id)
        if student:
            student.profile_completeness = StudentService.calculate_completeness(student)
            db.commit()
        return True

    @staticmethod
    def add_aspiration(db: Session, student_id: UUID, data: StudentAspirationCreate) -> Optional[StudentAspiration]:
        student = StudentService.get_student_detail(db, student_id)
        if not student:
            return None

        asp = StudentAspiration(student_id=student_id, **data.model_dump())
        db.add(asp)
        student.profile_completeness = StudentService.calculate_completeness(student)
        db.commit()
        db.refresh(asp)
        return asp

    # --- Eligibility Matching ---
    @staticmethod
    def get_eligible_opportunities(db: Session, student_id: UUID) -> List[EligibilityCheckResult]:
        student = StudentService.get_student_detail(db, student_id)
        if not student:
            return []

        # Build profile dict for student
        state = student.location.state if student.location else None
        rural_status = (
            student.location.rural_urban.value
            if student.location and student.location.rural_urban
            else None
        )

        edu_level = None
        max_percentage = None
        for edu in student.education_records:
            if edu.education_level:
                edu_level = edu.education_level.value
            for sub in edu.subjects:
                if sub.percentage is not None:
                    if max_percentage is None or sub.percentage > max_percentage:
                        max_percentage = sub.percentage

        profile_dict = {
            "state": state,
            "gender": student.gender.value if student.gender else None,
            "rural_status": rural_status,
            "education_level": edu_level,
            "percentage": max_percentage,
        }

        # Query all active opportunities
        active_opps = list(
            db.execute(
                select(Opportunity).where(Opportunity.status == OpportunityStatus.ACTIVE)
            ).scalars().all()
        )

        eligible_results: List[EligibilityCheckResult] = []
        for opp in active_opps:
            result = OpportunityService.evaluate_eligibility(db, opp.id, profile_dict)
            if result and result.is_eligible:
                eligible_results.append(result)

        return eligible_results

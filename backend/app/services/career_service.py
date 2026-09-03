"""
Service layer for Career domain: CRUD, pathways, skills/exams junctions,
and skill-based matching for students.
"""
from typing import Optional, List, Tuple
from uuid import UUID
from sqlalchemy.orm import Session, joinedload, selectinload
from sqlalchemy import select, func, or_

from app.models.career import Career, CareerPathway, CareerSkill, CareerCourse, CareerExam, CareerLevel, DemandLevel
from app.models.skill import StudentSkill
from app.schemas.career import CareerCreate, CareerUpdate, CareerPathwayCreate


class CareerService:
    @staticmethod
    def create_career(db: Session, data: CareerCreate) -> Career:
        career = Career(**data.model_dump())
        db.add(career)
        db.commit()
        db.refresh(career)
        return career

    @staticmethod
    def get_career(db: Session, career_id: UUID) -> Optional[Career]:
        return db.execute(select(Career).where(Career.id == career_id)).scalar_one_or_none()

    @staticmethod
    def get_career_detail(db: Session, career_id: UUID) -> Optional[Career]:
        stmt = (
            select(Career)
            .options(
                selectinload(Career.pathways),
                selectinload(Career.career_skills).joinedload(CareerSkill.skill),
                selectinload(Career.career_courses),
                selectinload(Career.career_exams),
            )
            .where(Career.id == career_id)
        )
        return db.execute(stmt).scalar_one_or_none()

    @staticmethod
    def list_careers(
        db: Session,
        industry: Optional[str] = None,
        career_level: Optional[CareerLevel] = None,
        demand_level: Optional[DemandLevel] = None,
        search: Optional[str] = None,
        limit: int = 20,
        offset: int = 0,
    ) -> Tuple[List[Career], int]:
        stmt = select(Career)
        count_stmt = select(func.count(Career.id))

        if industry:
            stmt = stmt.where(Career.industry.ilike(f"%{industry}%"))
            count_stmt = count_stmt.where(Career.industry.ilike(f"%{industry}%"))

        if career_level:
            stmt = stmt.where(Career.career_level == career_level)
            count_stmt = count_stmt.where(Career.career_level == career_level)

        if demand_level:
            stmt = stmt.where(Career.demand_level == demand_level)
            count_stmt = count_stmt.where(Career.demand_level == demand_level)

        if search:
            stmt = stmt.where(
                or_(
                    Career.name.ilike(f"%{search}%"),
                    Career.description.ilike(f"%{search}%"),
                )
            )
            count_stmt = count_stmt.where(
                or_(
                    Career.name.ilike(f"%{search}%"),
                    Career.description.ilike(f"%{search}%"),
                )
            )

        total = db.execute(count_stmt).scalar_one()
        items = list(
            db.execute(
                stmt.order_by(Career.name.asc())
                .offset(offset)
                .limit(limit)
            ).scalars().all()
        )
        return items, total

    @staticmethod
    def update_career(db: Session, career_id: UUID, data: CareerUpdate) -> Optional[Career]:
        career = CareerService.get_career(db, career_id)
        if not career:
            return None

        for field, value in data.model_dump(exclude_unset=True).items():
            setattr(career, field, value)

        db.commit()
        return CareerService.get_career_detail(db, career_id)

    @staticmethod
    def delete_career(db: Session, career_id: UUID) -> bool:
        career = CareerService.get_career(db, career_id)
        if not career:
            return False
        db.delete(career)
        db.commit()
        return True

    @staticmethod
    def add_pathway(db: Session, career_id: UUID, data: CareerPathwayCreate) -> Optional[CareerPathway]:
        career = CareerService.get_career(db, career_id)
        if not career:
            return None

        pathway = CareerPathway(career_id=career_id, **data.model_dump())
        db.add(pathway)
        db.commit()
        db.refresh(pathway)
        return pathway

    @staticmethod
    def find_careers_for_student(db: Session, student_id: UUID) -> List[Career]:
        student_skill_ids = db.execute(
            select(StudentSkill.skill_id).where(StudentSkill.student_id == student_id)
        ).scalars().all()

        if not student_skill_ids:
            return []

        careers = db.execute(
            select(Career)
            .join(CareerSkill, Career.id == CareerSkill.career_id)
            .where(CareerSkill.skill_id.in_(student_skill_ids))
            .distinct()
        ).scalars().all()

        return list(careers)

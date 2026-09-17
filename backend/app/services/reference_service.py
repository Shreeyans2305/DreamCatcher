"""
Reference data service: Languages, Locations, Skills, Interests, Institutions, Organizations.
"""
from typing import Optional, List, Tuple
from uuid import UUID
from sqlalchemy.orm import Session
from sqlalchemy import select, func

from app.models.language import Language
from app.models.location import Location, RuralUrban
from app.models.skill import Skill, SkillCategory
from app.models.interest import Interest, InterestCategory
from app.models.institution import Institution, InstitutionType, GovernmentPrivate
from app.models.organization import Organization, OrganizationType
from app.schemas.reference import (
    LanguageCreate, LocationCreate, SkillCreate,
    InterestCreate, InstitutionCreate, OrganizationCreate,
)


class ReferenceService:
    # --- Languages ---
    @staticmethod
    def list_languages(db: Session, active_only: bool = True) -> List[Language]:
        stmt = select(Language)
        if active_only:
            stmt = stmt.where(Language.is_active == True)
        return list(db.execute(stmt.order_by(Language.name)).scalars().all())

    @staticmethod
    def get_language(db: Session, code: str) -> Optional[Language]:
        return db.execute(select(Language).where(Language.code == code)).scalar_one_or_none()

    @staticmethod
    def create_language(db: Session, data: LanguageCreate) -> Language:
        lang = Language(**data.model_dump())
        db.add(lang)
        db.commit()
        db.refresh(lang)
        return lang

    # --- Locations ---
    @staticmethod
    def list_locations(
        db: Session,
        state: Optional[str] = None,
        district: Optional[str] = None,
        rural_urban: Optional[RuralUrban] = None,
        limit: int = 100,
        offset: int = 0,
    ) -> Tuple[List[Location], int]:
        stmt = select(Location)
        count_stmt = select(func.count(Location.id))

        if state:
            stmt = stmt.where(Location.state.ilike(f"%{state}%"))
            count_stmt = count_stmt.where(Location.state.ilike(f"%{state}%"))
        if district:
            stmt = stmt.where(Location.district.ilike(f"%{district}%"))
            count_stmt = count_stmt.where(Location.district.ilike(f"%{district}%"))
        if rural_urban:
            stmt = stmt.where(Location.rural_urban == rural_urban)
            count_stmt = count_stmt.where(Location.rural_urban == rural_urban)

        total = db.execute(count_stmt).scalar_one()
        items = list(db.execute(stmt.order_by(Location.state, Location.district).offset(offset).limit(limit)).scalars().all())
        return items, total

    @staticmethod
    def get_location(db: Session, location_id: UUID) -> Optional[Location]:
        return db.execute(select(Location).where(Location.id == location_id)).scalar_one_or_none()

    @staticmethod
    def find_or_create_location(
        db: Session,
        country: str = "India",
        state: Optional[str] = None,
        district: Optional[str] = None,
        taluka: Optional[str] = None,
        village: Optional[str] = None,
        pincode: Optional[str] = None,
        rural_urban: RuralUrban = RuralUrban.UNKNOWN,
    ) -> Location:
        stmt = select(Location).where(Location.country == country)
        if state:
            stmt = stmt.where(func.lower(Location.state) == state.strip().lower())
        else:
            stmt = stmt.where(Location.state.is_(None))
            
        if district:
            stmt = stmt.where(func.lower(Location.district) == district.strip().lower())
        else:
            stmt = stmt.where(Location.district.is_(None))

        if taluka:
            stmt = stmt.where(func.lower(Location.taluka) == taluka.strip().lower())
        if village:
            stmt = stmt.where(func.lower(Location.village) == village.strip().lower())
        if pincode:
            stmt = stmt.where(Location.pincode == pincode.strip())

        loc = db.execute(stmt).scalars().first()
        if loc:
            return loc

        loc = Location(
            country=country.strip() if country else "India",
            state=state.strip() if state else None,
            district=district.strip() if district else None,
            taluka=taluka.strip() if taluka else None,
            village=village.strip() if village else None,
            pincode=pincode.strip() if pincode else None,
            rural_urban=rural_urban,
        )
        db.add(loc)
        db.commit()
        db.refresh(loc)
        return loc

    @staticmethod
    def create_location(db: Session, data: LocationCreate) -> Location:
        return ReferenceService.find_or_create_location(
            db,
            country=data.country,
            state=data.state,
            district=data.district,
            taluka=data.taluka,
            village=data.village,
            pincode=data.pincode,
            rural_urban=data.rural_urban,
        )

    # --- Skills ---
    @staticmethod
    def list_skills(
        db: Session,
        category: Optional[SkillCategory] = None,
        limit: int = 100,
        offset: int = 0,
    ) -> Tuple[List[Skill], int]:
        stmt = select(Skill)
        count_stmt = select(func.count(Skill.id))
        if category:
            stmt = stmt.where(Skill.category == category)
            count_stmt = count_stmt.where(Skill.category == category)

        total = db.execute(count_stmt).scalar_one()
        items = list(db.execute(stmt.order_by(Skill.canonical_name).offset(offset).limit(limit)).scalars().all())
        return items, total

    @staticmethod
    def get_skill(db: Session, skill_id: UUID) -> Optional[Skill]:
        return db.execute(select(Skill).where(Skill.id == skill_id)).scalar_one_or_none()

    @staticmethod
    def create_skill(db: Session, data: SkillCreate) -> Skill:
        skill = Skill(**data.model_dump())
        db.add(skill)
        db.commit()
        db.refresh(skill)
        return skill

    # --- Interests ---
    @staticmethod
    def list_interests(
        db: Session,
        category: Optional[InterestCategory] = None,
        limit: int = 100,
        offset: int = 0,
    ) -> Tuple[List[Interest], int]:
        stmt = select(Interest)
        count_stmt = select(func.count(Interest.id))
        if category:
            stmt = stmt.where(Interest.category == category)
            count_stmt = count_stmt.where(Interest.category == category)

        total = db.execute(count_stmt).scalar_one()
        items = list(db.execute(stmt.order_by(Interest.name).offset(offset).limit(limit)).scalars().all())
        return items, total

    @staticmethod
    def get_interest(db: Session, interest_id: UUID) -> Optional[Interest]:
        return db.execute(select(Interest).where(Interest.id == interest_id)).scalar_one_or_none()

    @staticmethod
    def create_interest(db: Session, data: InterestCreate) -> Interest:
        interest = Interest(**data.model_dump())
        db.add(interest)
        db.commit()
        db.refresh(interest)
        return interest

    # --- Institutions ---
    @staticmethod
    def list_institutions(
        db: Session,
        inst_type: Optional[InstitutionType] = None,
        govt_private: Optional[GovernmentPrivate] = None,
        limit: int = 50,
        offset: int = 0,
    ) -> Tuple[List[Institution], int]:
        stmt = select(Institution)
        count_stmt = select(func.count(Institution.id))
        if inst_type:
            stmt = stmt.where(Institution.institution_type == inst_type)
            count_stmt = count_stmt.where(Institution.institution_type == inst_type)
        if govt_private:
            stmt = stmt.where(Institution.government_private == govt_private)
            count_stmt = count_stmt.where(Institution.government_private == govt_private)

        total = db.execute(count_stmt).scalar_one()
        items = list(db.execute(stmt.order_by(Institution.name).offset(offset).limit(limit)).scalars().all())
        return items, total

    @staticmethod
    def get_institution(db: Session, inst_id: UUID) -> Optional[Institution]:
        return db.execute(select(Institution).where(Institution.id == inst_id)).scalar_one_or_none()

    @staticmethod
    def create_institution(db: Session, data: InstitutionCreate) -> Institution:
        inst = Institution(**data.model_dump())
        db.add(inst)
        db.commit()
        db.refresh(inst)
        return inst

    # --- Organizations ---
    @staticmethod
    def list_organizations(
        db: Session,
        org_type: Optional[OrganizationType] = None,
        limit: int = 50,
        offset: int = 0,
    ) -> Tuple[List[Organization], int]:
        stmt = select(Organization)
        count_stmt = select(func.count(Organization.id))
        if org_type:
            stmt = stmt.where(Organization.type == org_type)
            count_stmt = count_stmt.where(Organization.type == org_type)

        total = db.execute(count_stmt).scalar_one()
        items = list(db.execute(stmt.order_by(Organization.name).offset(offset).limit(limit)).scalars().all())
        return items, total

    @staticmethod
    def get_organization(db: Session, org_id: UUID) -> Optional[Organization]:
        return db.execute(select(Organization).where(Organization.id == org_id)).scalar_one_or_none()

    @staticmethod
    def create_organization(db: Session, data: OrganizationCreate) -> Organization:
        org = Organization(**data.model_dump())
        db.add(org)
        db.commit()
        db.refresh(org)
        return org

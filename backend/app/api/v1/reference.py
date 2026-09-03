"""
Reference catalogue endpoints: Languages, Locations, Skills, Interests, Institutions, Organizations.
"""
from typing import Optional, List
from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.models.location import RuralUrban
from app.models.skill import SkillCategory
from app.models.interest import InterestCategory
from app.models.institution import InstitutionType, GovernmentPrivate
from app.models.organization import OrganizationType
from app.schemas.common import PaginationParams, PaginatedResponse
from app.schemas.reference import (
    LanguageResponse, LanguageCreate,
    LocationResponse, LocationCreate,
    SkillResponse, SkillCreate,
    InterestResponse, InterestCreate,
    InstitutionResponse, InstitutionCreate,
    OrganizationResponse, OrganizationCreate,
)
from app.services.reference_service import ReferenceService

router = APIRouter(tags=["Reference Catalogues"])


# ---------------------------------------------------------------------------
# Languages
# ---------------------------------------------------------------------------
@router.get("/languages", response_model=List[LanguageResponse], summary="List supported languages")
def list_languages(
    active_only: bool = Query(True, description="Filter for active languages only"),
    db: Session = Depends(get_db),
):
    return ReferenceService.list_languages(db, active_only=active_only)


@router.get("/languages/{code}", response_model=LanguageResponse, summary="Get language by ISO code")
def get_language(code: str, db: Session = Depends(get_db)):
    lang = ReferenceService.get_language(db, code)
    if not lang:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Language '{code}' not found")
    return lang


@router.post("/languages", response_model=LanguageResponse, status_code=status.HTTP_201_CREATED, summary="Add language")
def create_language(data: LanguageCreate, db: Session = Depends(get_db)):
    existing = ReferenceService.get_language(db, data.code)
    if existing:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=f"Language '{data.code}' already exists")
    return ReferenceService.create_language(db, data)


# ---------------------------------------------------------------------------
# Locations
# ---------------------------------------------------------------------------
@router.get("/locations", response_model=PaginatedResponse[LocationResponse], summary="List locations")
def list_locations(
    state: Optional[str] = Query(None, description="Filter by state name"),
    district: Optional[str] = Query(None, description="Filter by district name"),
    rural_urban: Optional[RuralUrban] = Query(None, description="Filter by rural/urban classification"),
    page: int = Query(1, ge=1),
    page_size: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
):
    params = PaginationParams(page=page, page_size=page_size)
    items, total = ReferenceService.list_locations(
        db, state=state, district=district, rural_urban=rural_urban,
        limit=params.page_size, offset=params.offset,
    )
    return PaginatedResponse.create(items=[LocationResponse.model_validate(i) for i in items], total=total, params=params)


@router.get("/locations/{location_id}", response_model=LocationResponse, summary="Get location by ID")
def get_location(location_id: UUID, db: Session = Depends(get_db)):
    loc = ReferenceService.get_location(db, location_id)
    if not loc:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Location not found")
    return loc


@router.post("/locations", response_model=LocationResponse, status_code=status.HTTP_201_CREATED, summary="Add location")
def create_location(data: LocationCreate, db: Session = Depends(get_db)):
    return ReferenceService.create_location(db, data)


# ---------------------------------------------------------------------------
# Skills
# ---------------------------------------------------------------------------
@router.get("/skills", response_model=PaginatedResponse[SkillResponse], summary="List skills catalogue")
def list_skills(
    category: Optional[SkillCategory] = Query(None, description="Filter by skill category"),
    page: int = Query(1, ge=1),
    page_size: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
):
    params = PaginationParams(page=page, page_size=page_size)
    items, total = ReferenceService.list_skills(
        db, category=category, limit=params.page_size, offset=params.offset
    )
    return PaginatedResponse.create(items=[SkillResponse.model_validate(i) for i in items], total=total, params=params)


@router.get("/skills/{skill_id}", response_model=SkillResponse, summary="Get skill by ID")
def get_skill(skill_id: UUID, db: Session = Depends(get_db)):
    sk = ReferenceService.get_skill(db, skill_id)
    if not sk:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Skill not found")
    return sk


@router.post("/skills", response_model=SkillResponse, status_code=status.HTTP_201_CREATED, summary="Add skill to catalogue")
def create_skill(data: SkillCreate, db: Session = Depends(get_db)):
    return ReferenceService.create_skill(db, data)


# ---------------------------------------------------------------------------
# Interests
# ---------------------------------------------------------------------------
@router.get("/interests", response_model=PaginatedResponse[InterestResponse], summary="List interests catalogue")
def list_interests(
    category: Optional[InterestCategory] = Query(None, description="Filter by interest category"),
    page: int = Query(1, ge=1),
    page_size: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
):
    params = PaginationParams(page=page, page_size=page_size)
    items, total = ReferenceService.list_interests(
        db, category=category, limit=params.page_size, offset=params.offset
    )
    return PaginatedResponse.create(items=[InterestResponse.model_validate(i) for i in items], total=total, params=params)


@router.get("/interests/{interest_id}", response_model=InterestResponse, summary="Get interest by ID")
def get_interest(interest_id: UUID, db: Session = Depends(get_db)):
    interest = ReferenceService.get_interest(db, interest_id)
    if not interest:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Interest not found")
    return interest


@router.post("/interests", response_model=InterestResponse, status_code=status.HTTP_201_CREATED, summary="Add interest")
def create_interest(data: InterestCreate, db: Session = Depends(get_db)):
    return ReferenceService.create_interest(db, data)


# ---------------------------------------------------------------------------
# Institutions
# ---------------------------------------------------------------------------
@router.get("/institutions", response_model=PaginatedResponse[InstitutionResponse], summary="List institutions")
def list_institutions(
    type: Optional[InstitutionType] = Query(None, description="Filter by institution type"),
    government_private: Optional[GovernmentPrivate] = Query(None, description="Filter by government/private"),
    page: int = Query(1, ge=1),
    page_size: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
):
    params = PaginationParams(page=page, page_size=page_size)
    items, total = ReferenceService.list_institutions(
        db, inst_type=type, govt_private=government_private, limit=params.page_size, offset=params.offset
    )
    return PaginatedResponse.create(items=[InstitutionResponse.model_validate(i) for i in items], total=total, params=params)


@router.get("/institutions/{institution_id}", response_model=InstitutionResponse, summary="Get institution by ID")
def get_institution(institution_id: UUID, db: Session = Depends(get_db)):
    inst = ReferenceService.get_institution(db, institution_id)
    if not inst:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Institution not found")
    return inst


@router.post("/institutions", response_model=InstitutionResponse, status_code=status.HTTP_201_CREATED, summary="Add institution")
def create_institution(data: InstitutionCreate, db: Session = Depends(get_db)):
    return ReferenceService.create_institution(db, data)


# ---------------------------------------------------------------------------
# Organizations
# ---------------------------------------------------------------------------
@router.get("/organizations", response_model=PaginatedResponse[OrganizationResponse], summary="List organizations")
def list_organizations(
    type: Optional[OrganizationType] = Query(None, description="Filter by organization type"),
    page: int = Query(1, ge=1),
    page_size: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
):
    params = PaginationParams(page=page, page_size=page_size)
    items, total = ReferenceService.list_organizations(
        db, org_type=type, limit=params.page_size, offset=params.offset
    )
    return PaginatedResponse.create(items=[OrganizationResponse.model_validate(i) for i in items], total=total, params=params)


@router.get("/organizations/{org_id}", response_model=OrganizationResponse, summary="Get organization by ID")
def get_organization(org_id: UUID, db: Session = Depends(get_db)):
    org = ReferenceService.get_organization(db, org_id)
    if not org:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Organization not found")
    return org


@router.post("/organizations", response_model=OrganizationResponse, status_code=status.HTTP_201_CREATED, summary="Add organization")
def create_organization(data: OrganizationCreate, db: Session = Depends(get_db)):
    return ReferenceService.create_organization(db, data)

"""
Career endpoints: Career catalogue, pathways, required skills/exams,
and student skill-based career matching.
"""
from typing import Optional, List
from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.models.career import CareerLevel, DemandLevel
from app.schemas.common import PaginationParams, PaginatedResponse, MessageResponse
from app.schemas.career import (
    CareerCreate, CareerUpdate, CareerResponse, CareerDetailResponse,
    CareerPathwayCreate, CareerPathwayResponse,
)
from app.services.career_service import CareerService

router = APIRouter(prefix="/careers", tags=["Careers"])


# ---------------------------------------------------------------------------
# Core Career CRUD
# ---------------------------------------------------------------------------
@router.post("", response_model=CareerResponse, status_code=status.HTTP_201_CREATED, summary="Create career")
def create_career(data: CareerCreate, db: Session = Depends(get_db)):
    return CareerService.create_career(db, data)


@router.get("", response_model=PaginatedResponse[CareerResponse], summary="List careers")
def list_careers(
    industry: Optional[str] = Query(None, description="Filter by industry"),
    career_level: Optional[CareerLevel] = Query(None, description="Filter by career level"),
    demand_level: Optional[DemandLevel] = Query(None, description="Filter by demand level"),
    search: Optional[str] = Query(None, description="Search career name or description"),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
):
    params = PaginationParams(page=page, page_size=page_size)
    items, total = CareerService.list_careers(
        db, industry=industry, career_level=career_level, demand_level=demand_level, search=search,
        limit=params.page_size, offset=params.offset,
    )
    return PaginatedResponse.create(
        items=[CareerResponse.model_validate(i) for i in items],
        total=total,
        params=params,
    )


@router.get("/{career_id}", response_model=CareerDetailResponse, summary="Get career details with pathways & skills")
def get_career(career_id: UUID, db: Session = Depends(get_db)):
    career = CareerService.get_career_detail(db, career_id)
    if not career:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Career not found")
    return career


@router.put("/{career_id}", response_model=CareerDetailResponse, summary="Update career")
def update_career(career_id: UUID, data: CareerUpdate, db: Session = Depends(get_db)):
    career = CareerService.update_career(db, career_id, data)
    if not career:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Career not found")
    return career


@router.delete("/{career_id}", response_model=MessageResponse, summary="Delete career")
def delete_career(career_id: UUID, db: Session = Depends(get_db)):
    success = CareerService.delete_career(db, career_id)
    if not success:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Career not found")
    return MessageResponse(message="Career deleted successfully")


# ---------------------------------------------------------------------------
# Pathways Sub-resource
# ---------------------------------------------------------------------------
@router.post(
    "/{career_id}/pathways",
    response_model=CareerPathwayResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Add pathway to career",
)
def add_career_pathway(
    career_id: UUID,
    data: CareerPathwayCreate,
    db: Session = Depends(get_db),
):
    pathway = CareerService.add_pathway(db, career_id, data)
    if not pathway:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Career not found")
    return pathway


# ---------------------------------------------------------------------------
# Career Matching for Student
# ---------------------------------------------------------------------------
@router.get(
    "/match/student/{student_id}",
    response_model=List[CareerResponse],
    summary="Match careers based on student's skills",
)
def match_careers_for_student(
    student_id: UUID,
    db: Session = Depends(get_db),
):
    careers = CareerService.find_careers_for_student(db, student_id)
    return [CareerResponse.model_validate(c) for c in careers]

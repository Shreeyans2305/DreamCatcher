"""
Student endpoints: Profile management, education, skills, interests, aspirations,
and automated eligibility discovery.
"""
from typing import Optional, List
from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.schemas.common import PaginationParams, PaginatedResponse, MessageResponse
from app.schemas.student import (
    StudentCreate, StudentUpdate, StudentResponse, StudentDetailResponse,
    StudentEducationCreate, StudentEducationResponse,
    StudentSkillCreate, StudentSkillResponse,
    StudentInterestCreate, StudentInterestResponse,
    StudentAspirationCreate, StudentAspirationResponse,
)
from app.schemas.opportunity import EligibilityCheckResult
from app.services.student_service import StudentService

router = APIRouter(prefix="/students", tags=["Students"])


# ---------------------------------------------------------------------------
# Core Student CRUD
# ---------------------------------------------------------------------------
@router.post("", response_model=StudentResponse, status_code=status.HTTP_201_CREATED, summary="Register a student")
def create_student(data: StudentCreate, db: Session = Depends(get_db)):
    return StudentService.create_student(db, data)


@router.get("", response_model=PaginatedResponse[StudentResponse], summary="List students")
def list_students(
    search: Optional[str] = Query(None, description="Search by name or phone"),
    location_id: Optional[UUID] = Query(None, description="Filter by location ID"),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
):
    params = PaginationParams(page=page, page_size=page_size)
    items, total = StudentService.list_students(
        db, search=search, location_id=location_id,
        limit=params.page_size, offset=params.offset,
    )
    return PaginatedResponse.create(
        items=[StudentResponse.model_validate(i) for i in items],
        total=total,
        params=params,
    )


@router.get("/{student_id}", response_model=StudentDetailResponse, summary="Get student profile details")
def get_student(student_id: UUID, db: Session = Depends(get_db)):
    student = StudentService.get_student_detail(db, student_id)
    if not student:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found")
    return student


@router.put("/{student_id}", response_model=StudentDetailResponse, summary="Update student profile")
def update_student(student_id: UUID, data: StudentUpdate, db: Session = Depends(get_db)):
    student = StudentService.update_student(db, student_id, data)
    if not student:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found")
    return student


@router.delete("/{student_id}", response_model=MessageResponse, summary="Delete a student")
def delete_student(student_id: UUID, db: Session = Depends(get_db)):
    success = StudentService.delete_student(db, student_id)
    if not success:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found")
    return MessageResponse(message="Student deleted successfully")


# ---------------------------------------------------------------------------
# Student Education Sub-resources
# ---------------------------------------------------------------------------
@router.post(
    "/{student_id}/education",
    response_model=StudentEducationResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Add education record for student",
)
def add_student_education(
    student_id: UUID,
    data: StudentEducationCreate,
    db: Session = Depends(get_db),
):
    edu = StudentService.add_education(db, student_id, data)
    if not edu:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found")
    return edu


@router.delete(
    "/{student_id}/education/{education_id}",
    response_model=MessageResponse,
    summary="Delete education record",
)
def delete_student_education(
    student_id: UUID,
    education_id: UUID,
    db: Session = Depends(get_db),
):
    success = StudentService.delete_education(db, student_id, education_id)
    if not success:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Education record not found")
    return MessageResponse(message="Education record deleted successfully")


# ---------------------------------------------------------------------------
# Student Skills Sub-resources
# ---------------------------------------------------------------------------
@router.post(
    "/{student_id}/skills",
    response_model=StudentSkillResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Link skill to student",
)
def add_student_skill(
    student_id: UUID,
    data: StudentSkillCreate,
    db: Session = Depends(get_db),
):
    sk = StudentService.add_skill(db, student_id, data)
    if not sk:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found")
    return sk


@router.delete(
    "/{student_id}/skills/{skill_id}",
    response_model=MessageResponse,
    summary="Unlink skill from student",
)
def delete_student_skill(
    student_id: UUID,
    skill_id: UUID,
    db: Session = Depends(get_db),
):
    success = StudentService.delete_skill(db, student_id, skill_id)
    if not success:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Skill link not found")
    return MessageResponse(message="Skill unlinked successfully")


# ---------------------------------------------------------------------------
# Student Interests Sub-resources
# ---------------------------------------------------------------------------
@router.post(
    "/{student_id}/interests",
    response_model=StudentInterestResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Link interest to student",
)
def add_student_interest(
    student_id: UUID,
    data: StudentInterestCreate,
    db: Session = Depends(get_db),
):
    si = StudentService.add_interest(db, student_id, data)
    if not si:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found")
    return si


@router.delete(
    "/{student_id}/interests/{interest_id}",
    response_model=MessageResponse,
    summary="Unlink interest from student",
)
def delete_student_interest(
    student_id: UUID,
    interest_id: UUID,
    db: Session = Depends(get_db),
):
    success = StudentService.delete_interest(db, student_id, interest_id)
    if not success:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Interest link not found")
    return MessageResponse(message="Interest unlinked successfully")


# ---------------------------------------------------------------------------
# Student Aspirations Sub-resources
# ---------------------------------------------------------------------------
@router.post(
    "/{student_id}/aspirations",
    response_model=StudentAspirationResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Add student aspiration",
)
def add_student_aspiration(
    student_id: UUID,
    data: StudentAspirationCreate,
    db: Session = Depends(get_db),
):
    asp = StudentService.add_aspiration(db, student_id, data)
    if not asp:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found")
    return asp


# ---------------------------------------------------------------------------
# Eligibility Discovery
# ---------------------------------------------------------------------------
@router.get(
    "/{student_id}/eligible-opportunities",
    response_model=List[EligibilityCheckResult],
    summary="Find eligible opportunities for student via deterministic rule engine",
)
def get_eligible_opportunities_for_student(
    student_id: UUID,
    db: Session = Depends(get_db),
):
    student = StudentService.get_student(db, student_id)
    if not student:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Student not found")
    return StudentService.get_eligible_opportunities(db, student_id)

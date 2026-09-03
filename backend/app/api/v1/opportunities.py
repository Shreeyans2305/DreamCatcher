"""
Opportunity endpoints: Opportunities CRUD (polymorphic scholarships, courses, exams, internships),
rule management, and deterministic eligibility evaluation.
"""
from typing import Optional, List
from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.models.opportunity import OpportunityType, OpportunityStatus
from app.schemas.common import PaginationParams, PaginatedResponse, MessageResponse
from app.schemas.opportunity import (
    OpportunityCreate, OpportunityUpdate, OpportunityResponse, OpportunityDetailResponse,
    EligibilityRuleCreate, EligibilityRuleResponse,
    EligibilityCheckRequest, EligibilityCheckResult,
)
from app.services.opportunity_service import OpportunityService

router = APIRouter(prefix="/opportunities", tags=["Opportunities"])


# ---------------------------------------------------------------------------
# Core Opportunity CRUD
# ---------------------------------------------------------------------------
@router.post(
    "",
    response_model=OpportunityDetailResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create opportunity (polymorphic: scholarship, course, exam, internship)",
)
def create_opportunity(data: OpportunityCreate, db: Session = Depends(get_db)):
    return OpportunityService.create_opportunity(db, data)


@router.get("", response_model=PaginatedResponse[OpportunityResponse], summary="List & search opportunities")
def list_opportunities(
    type: Optional[OpportunityType] = Query(None, description="Filter by opportunity type"),
    status: Optional[OpportunityStatus] = Query(None, description="Filter by status (active/draft/expired)"),
    state: Optional[str] = Query(None, description="Filter by state name (includes national/all-India)"),
    location_id: Optional[UUID] = Query(None, description="Filter by location ID"),
    search: Optional[str] = Query(None, description="Search in title and description"),
    page: int = Query(1, ge=1),
    page_size: int = Query(20, ge=1, le=100),
    db: Session = Depends(get_db),
):
    params = PaginationParams(page=page, page_size=page_size)
    items, total = OpportunityService.list_opportunities(
        db, opp_type=type, status=status, state=state, location_id=location_id,
        search=search,
        limit=params.page_size, offset=params.offset,
    )
    return PaginatedResponse.create(
        items=[OpportunityResponse.model_validate(i) for i in items],
        total=total,
        params=params,
    )


@router.get("/{opportunity_id}", response_model=OpportunityDetailResponse, summary="Get opportunity details")
def get_opportunity(opportunity_id: UUID, db: Session = Depends(get_db)):
    opp = OpportunityService.get_opportunity_detail(db, opportunity_id)
    if not opp:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Opportunity not found")
    return opp


@router.put("/{opportunity_id}", response_model=OpportunityDetailResponse, summary="Update opportunity")
def update_opportunity(opportunity_id: UUID, data: OpportunityUpdate, db: Session = Depends(get_db)):
    opp = OpportunityService.update_opportunity(db, opportunity_id, data)
    if not opp:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Opportunity not found")
    return opp


@router.delete("/{opportunity_id}", response_model=MessageResponse, summary="Delete opportunity")
def delete_opportunity(opportunity_id: UUID, db: Session = Depends(get_db)):
    success = OpportunityService.delete_opportunity(db, opportunity_id)
    if not success:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Opportunity not found")
    return MessageResponse(message="Opportunity deleted successfully")


# ---------------------------------------------------------------------------
# Eligibility Rules Management
# ---------------------------------------------------------------------------
@router.post(
    "/{opportunity_id}/rules",
    response_model=EligibilityRuleResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Add an eligibility rule to opportunity",
)
def add_eligibility_rule(
    opportunity_id: UUID,
    data: EligibilityRuleCreate,
    db: Session = Depends(get_db),
):
    rule = OpportunityService.add_rule(db, opportunity_id, data)
    if not rule:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Opportunity not found")
    return rule


@router.delete(
    "/{opportunity_id}/rules/{rule_id}",
    response_model=MessageResponse,
    summary="Delete an eligibility rule",
)
def delete_eligibility_rule(
    opportunity_id: UUID,
    rule_id: UUID,
    db: Session = Depends(get_db),
):
    success = OpportunityService.delete_rule(db, opportunity_id, rule_id)
    if not success:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Eligibility rule not found")
    return MessageResponse(message="Eligibility rule deleted successfully")


# ---------------------------------------------------------------------------
# Deterministic Eligibility Evaluation
# ---------------------------------------------------------------------------
@router.post(
    "/{opportunity_id}/check-eligibility",
    response_model=EligibilityCheckResult,
    summary="Evaluate student profile against opportunity rules (deterministic engine)",
)
def check_opportunity_eligibility(
    opportunity_id: UUID,
    profile: EligibilityCheckRequest,
    db: Session = Depends(get_db),
):
    profile_dict = profile.model_dump(exclude_unset=True)
    result = OpportunityService.evaluate_eligibility(db, opportunity_id, profile_dict)
    if not result:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Opportunity not found")
    return result

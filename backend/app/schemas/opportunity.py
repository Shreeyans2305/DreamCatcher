"""
Schemas for Opportunity domain: opportunities, scholarships, courses, entrance exams,
internships, eligibility rules, and eligibility evaluation.
"""
from typing import Optional, List, Any
from uuid import UUID
from datetime import date, datetime
from pydantic import BaseModel, ConfigDict, Field

from app.models.opportunity import OpportunityType, OpportunityStatus, VerificationStatus
from app.models.scholarship import AwardFrequency
from app.models.course import CourseMode
from app.models.education import EducationLevel
from app.models.exam import ExamMode, ExamFrequency
from app.models.eligibility import RuleType, RuleOperator, GroupOperator
from app.schemas.reference import LocationResponse, OrganizationResponse, InstitutionResponse


# ---------------------------------------------------------------------------
# Eligibility Rules
# ---------------------------------------------------------------------------
class EligibilityRuleBase(BaseModel):
    rule_type: RuleType
    operator: RuleOperator
    value: str = Field(..., max_length=500)
    unit: Optional[str] = Field(None, max_length=50)
    required: bool = True
    rule_group_id: Optional[UUID] = None
    group_operator: GroupOperator = GroupOperator.AND
    description: Optional[str] = None


class EligibilityRuleCreate(EligibilityRuleBase):
    pass


class EligibilityRuleResponse(EligibilityRuleBase):
    id: UUID
    opportunity_id: UUID
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


# ---------------------------------------------------------------------------
# Specialized Opportunity Sub-Schemas
# ---------------------------------------------------------------------------
class ScholarshipBase(BaseModel):
    amount: Optional[float] = Field(None, ge=0.0)
    currency: str = Field("INR", max_length=3)
    award_frequency: AwardFrequency = AwardFrequency.ANNUAL
    renewable: bool = False
    number_of_awards: Optional[int] = Field(None, ge=1)
    application_process: Optional[str] = None
    required_documents: Optional[str] = None


class ScholarshipCreate(ScholarshipBase):
    pass


class ScholarshipResponse(ScholarshipBase):
    opportunity_id: UUID
    model_config = ConfigDict(from_attributes=True)


class CourseBase(BaseModel):
    education_level: Optional[EducationLevel] = None
    field: Optional[str] = Field(None, max_length=200)
    duration: Optional[str] = Field(None, max_length=100)
    mode: CourseMode = CourseMode.FULL_TIME
    description: Optional[str] = None


class CourseCreate(CourseBase):
    pass


class CourseInstitutionResponse(BaseModel):
    institution_id: UUID
    tuition_fee: Optional[float] = None
    duration: Optional[str] = None
    institution: Optional[InstitutionResponse] = None

    model_config = ConfigDict(from_attributes=True)


class CourseResponse(CourseBase):
    opportunity_id: UUID
    course_institutions: List[CourseInstitutionResponse] = []
    model_config = ConfigDict(from_attributes=True)


class EntranceExamBase(BaseModel):
    conducting_body: Optional[str] = Field(None, max_length=300)
    exam_mode: ExamMode = ExamMode.OFFLINE
    exam_frequency: ExamFrequency = ExamFrequency.ANNUAL
    registration_start: Optional[date] = None
    registration_deadline: Optional[date] = None
    examination_date: Optional[date] = None
    application_fee: Optional[float] = Field(None, ge=0.0)
    official_exam_url: Optional[str] = Field(None, max_length=1000)


class EntranceExamCreate(EntranceExamBase):
    pass


class EntranceExamResponse(EntranceExamBase):
    opportunity_id: UUID
    model_config = ConfigDict(from_attributes=True)


class InternshipBase(BaseModel):
    organization_id: Optional[UUID] = None
    location_id: Optional[UUID] = None
    remote: bool = False
    duration: Optional[str] = Field(None, max_length=100)
    stipend: Optional[float] = Field(None, ge=0.0)
    start_date: Optional[date] = None
    end_date: Optional[date] = None
    application_deadline: Optional[date] = None
    work_description: Optional[str] = None


class InternshipCreate(InternshipBase):
    pass


class InternshipResponse(InternshipBase):
    opportunity_id: UUID
    model_config = ConfigDict(from_attributes=True)


# ---------------------------------------------------------------------------
# Core Opportunity
# ---------------------------------------------------------------------------
class OpportunityBase(BaseModel):
    type: OpportunityType
    title: str = Field(..., max_length=500)
    organization_id: Optional[UUID] = None
    description: Optional[str] = None
    status: OpportunityStatus = OpportunityStatus.ACTIVE
    official_url: Optional[str] = Field(None, max_length=1000)
    application_url: Optional[str] = Field(None, max_length=1000)
    application_start: Optional[date] = None
    application_deadline: Optional[date] = None
    location_id: Optional[UUID] = None
    verification_status: VerificationStatus = VerificationStatus.UNVERIFIED


class OpportunityCreate(OpportunityBase):
    # Specialized child payload depending on `type`
    scholarship: Optional[ScholarshipCreate] = None
    course: Optional[CourseCreate] = None
    entrance_exam: Optional[EntranceExamCreate] = None
    internship: Optional[InternshipCreate] = None
    rules: Optional[List[EligibilityRuleCreate]] = None


class OpportunityUpdate(BaseModel):
    title: Optional[str] = Field(None, max_length=500)
    organization_id: Optional[UUID] = None
    description: Optional[str] = None
    status: Optional[OpportunityStatus] = None
    official_url: Optional[str] = Field(None, max_length=1000)
    application_url: Optional[str] = Field(None, max_length=1000)
    application_start: Optional[date] = None
    application_deadline: Optional[date] = None
    location_id: Optional[UUID] = None
    verification_status: Optional[VerificationStatus] = None

    # Child payloads for update
    scholarship: Optional[ScholarshipCreate] = None
    course: Optional[CourseCreate] = None
    entrance_exam: Optional[EntranceExamCreate] = None
    internship: Optional[InternshipCreate] = None


class OpportunityResponse(OpportunityBase):
    id: UUID
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


class OpportunityDetailResponse(OpportunityResponse):
    location: Optional[LocationResponse] = None
    organization: Optional[OrganizationResponse] = None
    scholarship: Optional[ScholarshipResponse] = None
    course: Optional[CourseResponse] = None
    entrance_exam: Optional[EntranceExamResponse] = None
    internship: Optional[InternshipResponse] = None
    eligibility_rules: List[EligibilityRuleResponse] = []

    model_config = ConfigDict(from_attributes=True)


# ---------------------------------------------------------------------------
# Eligibility Check Models
# ---------------------------------------------------------------------------
class EligibilityCheckRequest(BaseModel):
    income: Optional[float] = None
    state: Optional[str] = None
    district: Optional[str] = None
    gender: Optional[str] = None
    social_category: Optional[str] = None
    rural_status: Optional[str] = None
    age: Optional[int] = None
    percentage: Optional[float] = None
    education_level: Optional[str] = None


class RuleEvaluationItem(BaseModel):
    rule: str
    rule_type: RuleType
    operator: RuleOperator
    expected_value: str
    student_value: Optional[Any] = None
    required: bool
    passed: bool
    description: Optional[str] = None


class EligibilityCheckResult(BaseModel):
    opportunity_id: UUID
    opportunity_title: str
    is_eligible: bool
    passed_rules_count: int
    total_rules_count: int
    rule_evaluations: List[RuleEvaluationItem]

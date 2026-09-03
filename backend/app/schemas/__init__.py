"""
Pydantic v2 schemas for DreamCatcher API.
"""
from app.schemas.common import PaginationParams, PaginatedResponse, MessageResponse
from app.schemas.reference import (
    LanguageCreate, LanguageResponse,
    LocationCreate, LocationResponse,
    SkillCreate, SkillResponse,
    InterestCreate, InterestResponse,
    OrganizationCreate, OrganizationResponse,
    InstitutionCreate, InstitutionResponse,
)
from app.schemas.student import (
    StudentCreate, StudentUpdate, StudentResponse, StudentDetailResponse,
    StudentEducationCreate, StudentEducationResponse,
    StudentSubjectCreate, StudentSubjectResponse,
    StudentSkillCreate, StudentSkillResponse,
    StudentInterestCreate, StudentInterestResponse,
    StudentAspirationCreate, StudentAspirationResponse,
)
from app.schemas.opportunity import (
    OpportunityCreate, OpportunityUpdate, OpportunityResponse, OpportunityDetailResponse,
    ScholarshipCreate, ScholarshipResponse,
    CourseCreate, CourseResponse,
    EntranceExamCreate, EntranceExamResponse,
    InternshipCreate, InternshipResponse,
    EligibilityRuleCreate, EligibilityRuleResponse,
    EligibilityCheckRequest, EligibilityCheckResult, RuleEvaluationItem,
)
from app.schemas.career import (
    CareerCreate, CareerUpdate, CareerResponse, CareerDetailResponse,
    CareerPathwayCreate, CareerPathwayResponse,
    CareerSkillResponse, CareerCourseResponse, CareerExamResponse,
)

__all__ = [
    "PaginationParams", "PaginatedResponse", "MessageResponse",
    "LanguageCreate", "LanguageResponse",
    "LocationCreate", "LocationResponse",
    "SkillCreate", "SkillResponse",
    "InterestCreate", "InterestResponse",
    "OrganizationCreate", "OrganizationResponse",
    "InstitutionCreate", "InstitutionResponse",
    "StudentCreate", "StudentUpdate", "StudentResponse", "StudentDetailResponse",
    "StudentEducationCreate", "StudentEducationResponse",
    "StudentSubjectCreate", "StudentSubjectResponse",
    "StudentSkillCreate", "StudentSkillResponse",
    "StudentInterestCreate", "StudentInterestResponse",
    "StudentAspirationCreate", "StudentAspirationResponse",
    "OpportunityCreate", "OpportunityUpdate", "OpportunityResponse", "OpportunityDetailResponse",
    "ScholarshipCreate", "ScholarshipResponse",
    "CourseCreate", "CourseResponse",
    "EntranceExamCreate", "EntranceExamResponse",
    "InternshipCreate", "InternshipResponse",
    "EligibilityRuleCreate", "EligibilityRuleResponse",
    "EligibilityCheckRequest", "EligibilityCheckResult", "RuleEvaluationItem",
    "CareerCreate", "CareerUpdate", "CareerResponse", "CareerDetailResponse",
    "CareerPathwayCreate", "CareerPathwayResponse",
    "CareerSkillResponse", "CareerCourseResponse", "CareerExamResponse",
]

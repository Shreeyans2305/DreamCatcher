"""
Schemas for Student domain: profile, education records, subjects, skills, interests, aspirations.
"""
from typing import Optional, List
from uuid import UUID
from datetime import date, datetime
from pydantic import BaseModel, ConfigDict, Field

from app.models.student import Gender
from app.models.education import EducationLevel, EducationStatus, DataSource
from app.models.skill import ProficiencyLevel
from app.schemas.reference import LocationResponse, SkillResponse, InterestResponse


# ---------------------------------------------------------------------------
# Student Subject
# ---------------------------------------------------------------------------
class StudentSubjectBase(BaseModel):
    subject: str = Field(..., max_length=200)
    marks: Optional[float] = None
    maximum_marks: Optional[float] = 100.0
    percentage: Optional[float] = Field(None, ge=0.0, le=100.0)
    grade: Optional[str] = Field(None, max_length=10)
    source: DataSource = DataSource.STUDENT_REPORTED
    confidence: float = Field(1.0, ge=0.0, le=1.0)


class StudentSubjectCreate(StudentSubjectBase):
    pass


class StudentSubjectResponse(StudentSubjectBase):
    id: UUID
    student_education_id: UUID
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)


# ---------------------------------------------------------------------------
# Student Education
# ---------------------------------------------------------------------------
class StudentEducationBase(BaseModel):
    institution_name: Optional[str] = Field(None, max_length=300)
    education_level: EducationLevel
    curriculum: Optional[str] = Field(None, max_length=100)
    board: Optional[str] = Field(None, max_length=150)
    field_of_study: Optional[str] = Field(None, max_length=200)
    start_date: Optional[date] = None
    end_date: Optional[date] = None
    status: EducationStatus = EducationStatus.COMPLETED
    description: Optional[str] = None
    source: DataSource = DataSource.STUDENT_REPORTED
    confidence: float = Field(1.0, ge=0.0, le=1.0)


class StudentEducationCreate(StudentEducationBase):
    subjects: Optional[List[StudentSubjectCreate]] = None


class StudentEducationResponse(StudentEducationBase):
    id: UUID
    student_id: UUID
    subjects: List[StudentSubjectResponse] = []
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


# ---------------------------------------------------------------------------
# Student Skill
# ---------------------------------------------------------------------------
class StudentSkillCreate(BaseModel):
    skill_id: UUID
    proficiency: Optional[ProficiencyLevel] = ProficiencyLevel.BEGINNER
    years_experience: Optional[float] = Field(None, ge=0.0)
    source: DataSource = DataSource.STUDENT_REPORTED
    confidence: float = Field(1.0, ge=0.0, le=1.0)


class StudentSkillResponse(BaseModel):
    id: UUID
    student_id: UUID
    skill_id: UUID
    proficiency: Optional[ProficiencyLevel] = None
    years_experience: Optional[float] = None
    source: DataSource
    confidence: float
    skill: Optional[SkillResponse] = None
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


# ---------------------------------------------------------------------------
# Student Interest
# ---------------------------------------------------------------------------
class StudentInterestCreate(BaseModel):
    interest_id: UUID
    strength: float = Field(0.5, ge=0.0, le=1.0)
    source: DataSource = DataSource.STUDENT_REPORTED
    confidence: float = Field(1.0, ge=0.0, le=1.0)


class StudentInterestResponse(BaseModel):
    id: UUID
    student_id: UUID
    interest_id: UUID
    strength: float
    source: DataSource
    confidence: float
    interest: Optional[InterestResponse] = None
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


# ---------------------------------------------------------------------------
# Student Aspiration
# ---------------------------------------------------------------------------
class StudentAspirationBase(BaseModel):
    aspiration_text: str
    target_career_id: Optional[UUID] = None
    priority: int = Field(1, ge=1)
    source: DataSource = DataSource.STUDENT_REPORTED
    confidence: float = Field(1.0, ge=0.0, le=1.0)


class StudentAspirationCreate(StudentAspirationBase):
    pass


class StudentAspirationResponse(StudentAspirationBase):
    id: UUID
    student_id: UUID
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


# ---------------------------------------------------------------------------
# Student Core Profile
# ---------------------------------------------------------------------------
class StudentBase(BaseModel):
    name: str = Field(..., max_length=200)
    phone: Optional[str] = Field(None, max_length=20)
    email: Optional[str] = Field(None, max_length=254)
    date_of_birth: Optional[date] = None
    gender: Optional[Gender] = None
    location_id: Optional[UUID] = None
    preferred_language: str = Field("en", max_length=10)


class StudentCreate(StudentBase):
    pass


class StudentUpdate(BaseModel):
    name: Optional[str] = Field(None, max_length=200)
    phone: Optional[str] = Field(None, max_length=20)
    email: Optional[str] = Field(None, max_length=254)
    date_of_birth: Optional[date] = None
    gender: Optional[Gender] = None
    location_id: Optional[UUID] = None
    preferred_language: Optional[str] = Field(None, max_length=10)


class StudentResponse(StudentBase):
    id: UUID
    profile_completeness: float
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


class StudentDetailResponse(StudentResponse):
    location: Optional[LocationResponse] = None
    education_records: List[StudentEducationResponse] = []
    skills: List[StudentSkillResponse] = []
    interests: List[StudentInterestResponse] = []
    aspirations: List[StudentAspirationResponse] = []

    model_config = ConfigDict(from_attributes=True)

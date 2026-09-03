"""
Schemas for Career domain: careers, pathways, skills, courses, entrance exams.
"""
from typing import Optional, List, Any
from uuid import UUID
from datetime import datetime
from pydantic import BaseModel, ConfigDict, Field

from app.models.career import CareerLevel, DemandLevel, ImportanceLevel
from app.schemas.reference import SkillResponse


# ---------------------------------------------------------------------------
# Career Pathway
# ---------------------------------------------------------------------------
class CareerPathwayBase(BaseModel):
    pathway_name: str = Field(..., max_length=200)
    description: Optional[str] = None
    steps: Optional[Any] = None
    is_alternative: bool = False


class CareerPathwayCreate(CareerPathwayBase):
    pass


class CareerPathwayResponse(CareerPathwayBase):
    id: UUID
    career_id: UUID

    model_config = ConfigDict(from_attributes=True)


# ---------------------------------------------------------------------------
# Career Junctions
# ---------------------------------------------------------------------------
class CareerSkillResponse(BaseModel):
    skill_id: UUID
    importance: ImportanceLevel
    skill: Optional[SkillResponse] = None

    model_config = ConfigDict(from_attributes=True)


class CareerCourseResponse(BaseModel):
    course_id: UUID
    importance: ImportanceLevel

    model_config = ConfigDict(from_attributes=True)


class CareerExamResponse(BaseModel):
    exam_id: UUID
    importance: ImportanceLevel

    model_config = ConfigDict(from_attributes=True)


# ---------------------------------------------------------------------------
# Career
# ---------------------------------------------------------------------------
class CareerBase(BaseModel):
    name: str = Field(..., max_length=200)
    description: Optional[str] = None
    industry: Optional[str] = Field(None, max_length=200)
    career_level: CareerLevel = CareerLevel.ENTRY
    demand_level: DemandLevel = DemandLevel.MEDIUM


class CareerCreate(CareerBase):
    pass


class CareerUpdate(BaseModel):
    name: Optional[str] = Field(None, max_length=200)
    description: Optional[str] = None
    industry: Optional[str] = Field(None, max_length=200)
    career_level: Optional[CareerLevel] = None
    demand_level: Optional[DemandLevel] = None


class CareerResponse(CareerBase):
    id: UUID

    model_config = ConfigDict(from_attributes=True)


class CareerDetailResponse(CareerResponse):
    pathways: List[CareerPathwayResponse] = []
    career_skills: List[CareerSkillResponse] = []
    career_courses: List[CareerCourseResponse] = []
    career_exams: List[CareerExamResponse] = []

    model_config = ConfigDict(from_attributes=True)

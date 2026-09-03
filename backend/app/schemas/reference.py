"""
Schemas for reference & catalogue data: Language, Location, Skill, Interest, Institution, Organization.
"""
from typing import Optional, List, Any
from uuid import UUID
from datetime import datetime
from pydantic import BaseModel, ConfigDict, Field

from app.models.location import RuralUrban
from app.models.skill import SkillCategory
from app.models.interest import InterestCategory
from app.models.institution import InstitutionType, GovernmentPrivate
from app.models.organization import OrganizationType


# ---------------------------------------------------------------------------
# Language
# ---------------------------------------------------------------------------
class LanguageBase(BaseModel):
    code: str = Field(..., max_length=10, description="ISO 639-1 code (e.g. en, hi, mr)")
    name: str = Field(..., max_length=100)
    native_name: Optional[str] = Field(None, max_length=100)
    script: Optional[str] = Field(None, max_length=50)
    is_active: bool = True


class LanguageCreate(LanguageBase):
    pass


class LanguageResponse(LanguageBase):
    model_config = ConfigDict(from_attributes=True)


# ---------------------------------------------------------------------------
# Location
# ---------------------------------------------------------------------------
class LocationBase(BaseModel):
    country: str = Field("India", max_length=100)
    state: Optional[str] = Field(None, max_length=100)
    district: Optional[str] = Field(None, max_length=100)
    taluka: Optional[str] = Field(None, max_length=100)
    village: Optional[str] = Field(None, max_length=200)
    pincode: Optional[str] = Field(None, max_length=10)
    rural_urban: RuralUrban = RuralUrban.UNKNOWN


class LocationCreate(LocationBase):
    pass


class LocationResponse(LocationBase):
    id: UUID
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


# ---------------------------------------------------------------------------
# Skill
# ---------------------------------------------------------------------------
class SkillBase(BaseModel):
    canonical_name: str = Field(..., max_length=200)
    category: SkillCategory = SkillCategory.OTHER
    description: Optional[str] = None


class SkillCreate(SkillBase):
    pass


class SkillResponse(SkillBase):
    id: UUID

    model_config = ConfigDict(from_attributes=True)


# ---------------------------------------------------------------------------
# Interest
# ---------------------------------------------------------------------------
class InterestBase(BaseModel):
    name: str = Field(..., max_length=200)
    category: InterestCategory = InterestCategory.OTHER
    description: Optional[str] = None


class InterestCreate(InterestBase):
    pass


class InterestResponse(InterestBase):
    id: UUID

    model_config = ConfigDict(from_attributes=True)


# ---------------------------------------------------------------------------
# Organization
# ---------------------------------------------------------------------------
class OrganizationBase(BaseModel):
    name: str = Field(..., max_length=300)
    type: OrganizationType = OrganizationType.OTHER
    description: Optional[str] = None
    website: Optional[str] = Field(None, max_length=500)


class OrganizationCreate(OrganizationBase):
    pass


class OrganizationResponse(OrganizationBase):
    id: UUID
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)


# ---------------------------------------------------------------------------
# Institution
# ---------------------------------------------------------------------------
class InstitutionBase(BaseModel):
    name: str = Field(..., max_length=300)
    institution_type: InstitutionType = InstitutionType.OTHER
    organization_id: Optional[UUID] = None
    location_id: Optional[UUID] = None
    website: Optional[str] = Field(None, max_length=500)
    government_private: Optional[GovernmentPrivate] = None
    description: Optional[str] = None
    accreditation: Optional[str] = Field(None, max_length=200)


class InstitutionCreate(InstitutionBase):
    pass


class InstitutionResponse(InstitutionBase):
    id: UUID
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)

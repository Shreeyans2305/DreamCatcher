"""
Organization model — government bodies, universities, NGOs, companies, etc.

Organizations are the parent entities that own institutions and opportunities.
"""
import enum

from sqlalchemy import Enum, String, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import enum_values, TimestampMixin, UUIDPrimaryKeyMixin


class OrganizationType(str, enum.Enum):
    GOVERNMENT = "government"
    UNIVERSITY = "university"
    NGO = "ngo"
    COMPANY = "company"
    FOUNDATION = "foundation"
    RESEARCH_INSTITUTION = "research_institution"
    SCHOOL = "school"
    OTHER = "other"


class Organization(UUIDPrimaryKeyMixin, TimestampMixin, Base):
    """
    Top-level organization entity.
    Example: Ministry of Education, IIT Bombay, NSP (National Scholarship Portal).
    """

    __tablename__ = "organizations"

    name: Mapped[str] = mapped_column(String(300), nullable=False)
    type: Mapped[OrganizationType] = mapped_column(
        Enum(OrganizationType, name="organization_type_enum", values_callable=enum_values),
        nullable=False,
        default=OrganizationType.OTHER,
    )
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    website: Mapped[str | None] = mapped_column(String(500), nullable=True)

    # Relationships
    institutions: Mapped[list["Institution"]] = relationship(back_populates="organization")  # noqa: F821
    opportunities: Mapped[list["Opportunity"]] = relationship(back_populates="organization")  # noqa: F821
    sources: Mapped[list["Source"]] = relationship(back_populates="organization")  # noqa: F821
    internships: Mapped[list["Internship"]] = relationship(back_populates="organization")  # noqa: F821

    def __repr__(self) -> str:
        return f"<Organization {self.name} ({self.type})>"

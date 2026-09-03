"""
Institution model — physical or virtual educational/research institution.

An Institution belongs to an Organization and has a Location.
Example: "IIT Bombay" is an Institution belonging to Organization "IIT Bombay" (autonomous body).
"""
import uuid
import enum

from sqlalchemy import Boolean, Enum, ForeignKey, String, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import enum_values, TimestampMixin, UUIDPrimaryKeyMixin


class InstitutionType(str, enum.Enum):
    UNIVERSITY = "university"
    COLLEGE = "college"
    SCHOOL = "school"
    POLYTECHNIC = "polytechnic"
    IIT = "iit"
    NIT = "nit"
    DEEMED_UNIVERSITY = "deemed_university"
    OPEN_UNIVERSITY = "open_university"
    VOCATIONAL = "vocational"
    RESEARCH_INSTITUTE = "research_institute"
    OTHER = "other"


class GovernmentPrivate(str, enum.Enum):
    GOVERNMENT = "government"
    PRIVATE = "private"
    AIDED = "aided"
    AUTONOMOUS = "autonomous"
    DEEMED = "deemed"


class Institution(UUIDPrimaryKeyMixin, TimestampMixin, Base):
    __tablename__ = "institutions"

    organization_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("organizations.id", ondelete="SET NULL"),
        nullable=True,
    )
    name: Mapped[str] = mapped_column(String(300), nullable=False)
    institution_type: Mapped[InstitutionType] = mapped_column(
        Enum(InstitutionType, name="institution_type_enum", values_callable=enum_values),
        nullable=False,
        default=InstitutionType.OTHER,
    )
    location_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("locations.id", ondelete="SET NULL"),
        nullable=True,
    )
    website: Mapped[str | None] = mapped_column(String(500), nullable=True)
    government_private: Mapped[GovernmentPrivate | None] = mapped_column(
        Enum(GovernmentPrivate, name="government_private_enum", values_callable=enum_values),
        nullable=True,
    )
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    accreditation: Mapped[str | None] = mapped_column(
        String(200),
        nullable=True,
        comment="NAAC grade, NBA accreditation, etc.",
    )

    # Relationships
    organization: Mapped["Organization"] = relationship(back_populates="institutions")  # noqa: F821
    location: Mapped["Location"] = relationship(back_populates="institutions")  # noqa: F821
    course_institutions: Mapped[list["CourseInstitution"]] = relationship(back_populates="institution")  # noqa: F821

    def __repr__(self) -> str:
        return f"<Institution {self.name}>"

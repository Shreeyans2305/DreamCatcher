"""
Central Opportunity model — parent entity for all opportunity types.

All specific opportunity types (scholarships, courses, exams, internships)
reference this table via a 1:1 relationship on opportunity_id.

This allows unified search: "find all opportunities matching a student profile"
without joining 4 separate tables.
"""
import uuid
import enum
from datetime import date, datetime

from sqlalchemy import Date, DateTime, Enum, ForeignKey, String, Text, func
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import enum_values, TimestampMixin, UUIDPrimaryKeyMixin


class OpportunityType(str, enum.Enum):
    SCHOLARSHIP = "scholarship"
    COURSE = "course"
    ENTRANCE_EXAM = "entrance_exam"
    INTERNSHIP = "internship"
    HIGHER_EDUCATION = "higher_education"
    OTHER = "other"


class OpportunityStatus(str, enum.Enum):
    ACTIVE = "active"
    INACTIVE = "inactive"
    DRAFT = "draft"
    EXPIRED = "expired"
    UPCOMING = "upcoming"


class VerificationStatus(str, enum.Enum):
    VERIFIED = "verified"
    UNVERIFIED = "unverified"
    PENDING = "pending"
    OUTDATED = "outdated"


class Opportunity(UUIDPrimaryKeyMixin, TimestampMixin, Base):
    """
    Parent entity for all opportunity types.
    Specific types extend this via 1:1 relationships.
    """

    __tablename__ = "opportunities"

    type: Mapped[OpportunityType] = mapped_column(
        Enum(OpportunityType, name="opportunity_type_enum", values_callable=enum_values),
        nullable=False,
        index=True,
    )
    title: Mapped[str] = mapped_column(String(500), nullable=False)
    organization_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("organizations.id", ondelete="SET NULL"),
        nullable=True,
        index=True,
    )
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    status: Mapped[OpportunityStatus] = mapped_column(
        Enum(OpportunityStatus, name="opportunity_status_enum", values_callable=enum_values),
        nullable=False,
        default=OpportunityStatus.ACTIVE,
        index=True,
    )
    official_url: Mapped[str | None] = mapped_column(String(1000), nullable=True)
    application_url: Mapped[str | None] = mapped_column(String(1000), nullable=True)
    application_start: Mapped[date | None] = mapped_column(Date, nullable=True)
    application_deadline: Mapped[date | None] = mapped_column(Date, nullable=True, index=True)
    location_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("locations.id", ondelete="SET NULL"),
        nullable=True,
        comment="Primary geographic scope; NULL = national",
    )
    last_verified: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    verification_status: Mapped[VerificationStatus] = mapped_column(
        Enum(VerificationStatus, name="verification_status_enum", values_callable=enum_values),
        nullable=False,
        default=VerificationStatus.UNVERIFIED,
    )

    # Relationships
    organization: Mapped["Organization"] = relationship(back_populates="opportunities")  # noqa: F821
    location: Mapped["Location"] = relationship(back_populates="opportunities")  # noqa: F821
    eligibility_rules: Mapped[list["EligibilityRule"]] = relationship(  # noqa: F821
        back_populates="opportunity", cascade="all, delete-orphan"
    )
    verification_logs: Mapped[list["VerificationLog"]] = relationship(  # noqa: F821
        back_populates="opportunity", cascade="all, delete-orphan"
    )
    versions: Mapped[list["OpportunityVersion"]] = relationship(  # noqa: F821
        back_populates="opportunity", cascade="all, delete-orphan"
    )
    documents: Mapped[list["OpportunityDocument"]] = relationship(  # noqa: F821
        back_populates="opportunity", cascade="all, delete-orphan"
    )

    # 1:1 specializations
    scholarship: Mapped["Scholarship"] = relationship(back_populates="opportunity", uselist=False)  # noqa: F821
    course: Mapped["Course"] = relationship(back_populates="opportunity", uselist=False)  # noqa: F821
    entrance_exam: Mapped["EntranceExam"] = relationship(back_populates="opportunity", uselist=False)  # noqa: F821
    internship: Mapped["Internship"] = relationship(back_populates="opportunity", uselist=False)  # noqa: F821

    def __repr__(self) -> str:
        return f"<Opportunity [{self.type}] {self.title}>"


class OpportunityVersion(UUIDPrimaryKeyMixin, Base):
    """
    Historical snapshot of an opportunity's data.
    Preserves previous versions when eligibility or deadlines change.
    """

    __tablename__ = "opportunity_versions"

    from datetime import datetime

    opportunity_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("opportunities.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    version: Mapped[int] = mapped_column(nullable=False, default=1)
    valid_from: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    valid_until: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    data: Mapped[dict] = mapped_column(
        "data",
        type_=__import__("sqlalchemy.dialects.postgresql", fromlist=["JSONB"]).JSONB,
        nullable=False,
        default=dict,
        comment="Full snapshot of the opportunity data at this version",
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )

    # Relationship
    opportunity: Mapped["Opportunity"] = relationship(back_populates="versions")

    def __repr__(self) -> str:
        return f"<OpportunityVersion opp={self.opportunity_id} v={self.version}>"

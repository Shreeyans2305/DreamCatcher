"""
Interest models — canonical interest catalogue + student interest associations.

Distinguishing explicitly stated vs. AI-inferred interests is done via
the DataSource enum: STUDENT_REPORTED vs. AI_INFERRED.
"""
import uuid
import enum

from sqlalchemy import Enum, Float, ForeignKey, String, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import enum_values, TimestampMixin, UUIDPrimaryKeyMixin
from app.models.education import DataSource


class InterestCategory(str, enum.Enum):
    SCIENCE = "science"
    TECHNOLOGY = "technology"
    ENGINEERING = "engineering"
    MATHEMATICS = "mathematics"
    ARTS = "arts"
    COMMERCE = "commerce"
    SPORTS = "sports"
    SOCIAL_WORK = "social_work"
    ENVIRONMENT = "environment"
    HEALTHCARE = "healthcare"
    AGRICULTURE = "agriculture"
    MEDIA = "media"
    LAW = "law"
    OTHER = "other"


class Interest(UUIDPrimaryKeyMixin, Base):
    """Canonical interest catalogue."""

    __tablename__ = "interests"

    name: Mapped[str] = mapped_column(String(200), nullable=False, unique=True)
    category: Mapped[InterestCategory] = mapped_column(
        Enum(InterestCategory, name="interest_category_enum", values_callable=enum_values),
        nullable=False,
        default=InterestCategory.OTHER,
    )
    description: Mapped[str | None] = mapped_column(Text, nullable=True)

    # Relationships
    student_interests: Mapped[list["StudentInterest"]] = relationship(back_populates="interest")

    def __repr__(self) -> str:
        return f"<Interest {self.name}>"


class StudentInterest(UUIDPrimaryKeyMixin, TimestampMixin, Base):
    """
    Association between a student and an interest.
    The source field distinguishes explicitly stated from AI-inferred interests.
    """

    __tablename__ = "student_interests"

    student_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("students.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    interest_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("interests.id", ondelete="CASCADE"),
        nullable=False,
    )
    # Strength: 0.0 (weak) to 1.0 (very strong)
    strength: Mapped[float] = mapped_column(Float, nullable=False, default=0.5)
    source: Mapped[DataSource] = mapped_column(
        Enum(DataSource, name="interest_source_enum", values_callable=enum_values),
        nullable=False,
        default=DataSource.STUDENT_REPORTED,
        comment="Use AI_INFERRED for interests discovered by the AI system",
    )
    confidence: Mapped[float] = mapped_column(Float, nullable=False, default=1.0)

    # Relationships
    student: Mapped["Student"] = relationship(back_populates="interests")  # noqa: F821
    interest: Mapped["Interest"] = relationship(back_populates="student_interests")

    def __repr__(self) -> str:
        return f"<StudentInterest student={self.student_id} interest={self.interest_id} source={self.source}>"

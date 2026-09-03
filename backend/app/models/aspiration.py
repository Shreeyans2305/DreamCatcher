"""
Aspiration model — free-text student aspirations with optional career linkage.

Design: aspirations must support free-text because students in rural areas
may not know career terminology. Example:
  "I like computers and astronomy but I don't know what career I can pursue."

The AI system later maps free-text → target_career_id.
"""
import uuid

from sqlalchemy import Enum, Float, ForeignKey, Integer, String, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import enum_values, TimestampMixin, UUIDPrimaryKeyMixin
from app.models.education import DataSource


class StudentAspiration(UUIDPrimaryKeyMixin, TimestampMixin, Base):
    __tablename__ = "student_aspirations"

    student_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("students.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    aspiration_text: Mapped[str] = mapped_column(
        Text,
        nullable=False,
        comment="Free-text aspiration in the student's own words",
    )
    target_career_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("careers.id", ondelete="SET NULL"),
        nullable=True,
        comment="Optionally linked to a canonical career by the AI system",
    )
    priority: Mapped[int] = mapped_column(
        Integer,
        nullable=False,
        default=1,
        comment="1 = highest priority aspiration",
    )
    source: Mapped[DataSource] = mapped_column(
        Enum(DataSource, name="aspiration_source_enum", values_callable=enum_values),
        nullable=False,
        default=DataSource.STUDENT_REPORTED,
    )
    confidence: Mapped[float] = mapped_column(Float, nullable=False, default=1.0)

    # Relationships
    student: Mapped["Student"] = relationship(back_populates="aspirations")  # noqa: F821
    target_career: Mapped["Career"] = relationship()  # noqa: F821

    def __repr__(self) -> str:
        return f"<StudentAspiration '{self.aspiration_text[:40]}...'>"

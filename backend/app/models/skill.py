"""
Skill models — canonical skills catalog + student skill associations.
"""
import uuid
import enum
from datetime import datetime

from sqlalchemy import DateTime, Enum, Float, ForeignKey, Integer, String, Text, func
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import enum_values, TimestampMixin, UUIDPrimaryKeyMixin
from app.models.education import DataSource


class SkillCategory(str, enum.Enum):
    TECHNICAL = "technical"
    SOFT = "soft"
    LANGUAGE = "language"
    DIGITAL = "digital"
    VOCATIONAL = "vocational"
    ARTISTIC = "artistic"
    SCIENTIFIC = "scientific"
    OTHER = "other"


class ProficiencyLevel(str, enum.Enum):
    BEGINNER = "beginner"
    INTERMEDIATE = "intermediate"
    ADVANCED = "advanced"
    EXPERT = "expert"


class Skill(UUIDPrimaryKeyMixin, Base):
    """Canonical skill catalogue — shared across students and careers."""

    __tablename__ = "skills"

    canonical_name: Mapped[str] = mapped_column(String(200), nullable=False, unique=True)
    category: Mapped[SkillCategory] = mapped_column(
        Enum(SkillCategory, name="skill_category_enum", values_callable=enum_values),
        nullable=False,
        default=SkillCategory.OTHER,
    )
    description: Mapped[str | None] = mapped_column(Text, nullable=True)

    # Relationships
    student_skills: Mapped[list["StudentSkill"]] = relationship(back_populates="skill")
    career_skills: Mapped[list["CareerSkill"]] = relationship(back_populates="skill")  # noqa: F821

    def __repr__(self) -> str:
        return f"<Skill {self.canonical_name}>"


class StudentSkill(UUIDPrimaryKeyMixin, TimestampMixin, Base):
    """Association between a student and a skill."""

    __tablename__ = "student_skills"

    student_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("students.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    skill_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("skills.id", ondelete="CASCADE"),
        nullable=False,
    )
    proficiency: Mapped[ProficiencyLevel | None] = mapped_column(
        Enum(ProficiencyLevel, name="proficiency_level_enum", values_callable=enum_values),
        nullable=True,
    )
    years_experience: Mapped[float | None] = mapped_column(Float, nullable=True)
    source: Mapped[DataSource] = mapped_column(
        Enum(DataSource, name="skill_source_enum", values_callable=enum_values),
        nullable=False,
        default=DataSource.STUDENT_REPORTED,
    )
    confidence: Mapped[float] = mapped_column(Float, nullable=False, default=1.0)

    # Relationships
    student: Mapped["Student"] = relationship(back_populates="skills")  # noqa: F821
    skill: Mapped["Skill"] = relationship(back_populates="student_skills")

    def __repr__(self) -> str:
        return f"<StudentSkill student={self.student_id} skill={self.skill_id}>"

"""
Career models — canonical careers, pathways, and relationship tables.

Design:
- A career can be reached via multiple pathways (e.g., B.Tech route OR diploma + lateral entry).
- CareerPathway stores step-by-step education paths using JSONB for flexibility.
- Junction tables link careers to skills, courses, and exams for recommendations.
"""
import uuid
import enum

from sqlalchemy import Column, Enum, Float, ForeignKey, Integer, JSON, String, Text
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import enum_values, UUIDPrimaryKeyMixin


class DemandLevel(str, enum.Enum):
    VERY_HIGH = "very_high"
    HIGH = "high"
    MEDIUM = "medium"
    LOW = "low"
    DECLINING = "declining"


class CareerLevel(str, enum.Enum):
    ENTRY = "entry"
    MID = "mid"
    SENIOR = "senior"
    EXECUTIVE = "executive"


class Career(UUIDPrimaryKeyMixin, Base):
    """Canonical career entity."""

    __tablename__ = "careers"

    name: Mapped[str] = mapped_column(String(200), nullable=False, unique=True)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    industry: Mapped[str | None] = mapped_column(String(200), nullable=True)
    career_level: Mapped[CareerLevel] = mapped_column(
        Enum(CareerLevel, name="career_level_enum", values_callable=enum_values),
        nullable=False,
        default=CareerLevel.ENTRY,
    )
    demand_level: Mapped[DemandLevel] = mapped_column(
        Enum(DemandLevel, name="demand_level_enum", values_callable=enum_values),
        nullable=False,
        default=DemandLevel.MEDIUM,
    )

    # Relationships
    pathways: Mapped[list["CareerPathway"]] = relationship(back_populates="career", cascade="all, delete-orphan")
    career_skills: Mapped[list["CareerSkill"]] = relationship(back_populates="career", cascade="all, delete-orphan")
    career_courses: Mapped[list["CareerCourse"]] = relationship(back_populates="career", cascade="all, delete-orphan")
    career_exams: Mapped[list["CareerExam"]] = relationship(back_populates="career", cascade="all, delete-orphan")
    aspirations: Mapped[list["StudentAspiration"]] = relationship(back_populates="target_career")  # noqa: F821

    def __repr__(self) -> str:
        return f"<Career {self.name}>"


class CareerPathway(UUIDPrimaryKeyMixin, Base):
    """
    A single pathway to reach a career.

    steps: JSONB list of dicts, each describing one step in the pathway.
    Example:
        [
          {"step": 1, "level": "secondary",      "description": "Complete Class 10"},
          {"step": 2, "level": "diploma",         "description": "3-year Diploma in CS"},
          {"step": 3, "level": "bachelor",        "description": "B.Tech Lateral Entry"},
          {"step": 4, "level": "employment",      "description": "Junior Engineer"}
        ]

    This avoids rigid foreign keys to education_level rows and supports
    non-standard education histories.
    """

    __tablename__ = "career_pathways"

    career_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("careers.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    pathway_name: Mapped[str] = mapped_column(
        String(200),
        nullable=False,
        comment="e.g. 'Traditional University Route', 'Diploma → Lateral Entry'",
    )
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    steps: Mapped[dict] = mapped_column(
        JSONB,
        nullable=False,
        default=list,
        comment="Ordered list of pathway steps as JSONB",
    )
    is_alternative: Mapped[bool] = mapped_column(
        default=False,
        comment="True if this is a non-traditional/alternative pathway",
    )

    # Relationship
    career: Mapped["Career"] = relationship(back_populates="pathways")

    def __repr__(self) -> str:
        return f"<CareerPathway {self.pathway_name} for career={self.career_id}>"


# ---------------------------------------------------------------------------
# Career ↔ Skill relationship
# ---------------------------------------------------------------------------
class ImportanceLevel(str, enum.Enum):
    REQUIRED = "required"
    PREFERRED = "preferred"
    HELPFUL = "helpful"


class CareerSkill(Base):
    """Many-to-many: Career ↔ Skill with importance."""

    __tablename__ = "career_skills"

    career_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("careers.id", ondelete="CASCADE"),
        primary_key=True,
    )
    skill_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("skills.id", ondelete="CASCADE"),
        primary_key=True,
    )
    importance: Mapped[ImportanceLevel] = mapped_column(
        Enum(ImportanceLevel, name="importance_level_enum", values_callable=enum_values),
        nullable=False,
        default=ImportanceLevel.PREFERRED,
    )

    # Relationships
    career: Mapped["Career"] = relationship(back_populates="career_skills")
    skill: Mapped["Skill"] = relationship(back_populates="career_skills")  # noqa: F821


# ---------------------------------------------------------------------------
# Career ↔ Course relationship
# ---------------------------------------------------------------------------
class CareerCourse(Base):
    """Many-to-many: Career ↔ Course (opportunity) with importance."""

    __tablename__ = "career_courses"

    career_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("careers.id", ondelete="CASCADE"),
        primary_key=True,
    )
    course_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("courses.opportunity_id", ondelete="CASCADE"),
        primary_key=True,
    )
    importance: Mapped[ImportanceLevel] = mapped_column(
        Enum(ImportanceLevel, name="importance_level_enum", values_callable=enum_values),
        nullable=False,
        default=ImportanceLevel.PREFERRED,
    )

    # Relationships
    career: Mapped["Career"] = relationship(back_populates="career_courses")
    course: Mapped["Course"] = relationship(foreign_keys="[CareerCourse.course_id]", primaryjoin="CareerCourse.course_id == Course.opportunity_id", overlaps="career_courses")  # noqa: F821


# ---------------------------------------------------------------------------
# Career ↔ Exam relationship
# ---------------------------------------------------------------------------
class CareerExam(Base):
    """Many-to-many: Career ↔ EntranceExam with importance."""

    __tablename__ = "career_exams"

    career_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("careers.id", ondelete="CASCADE"),
        primary_key=True,
    )
    exam_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("entrance_exams.opportunity_id", ondelete="CASCADE"),
        primary_key=True,
    )
    importance: Mapped[ImportanceLevel] = mapped_column(
        Enum(ImportanceLevel, name="importance_level_enum", values_callable=enum_values),
        nullable=False,
        default=ImportanceLevel.PREFERRED,
    )

    # Relationships
    career: Mapped["Career"] = relationship(back_populates="career_exams")
    exam: Mapped["EntranceExam"] = relationship(foreign_keys="[CareerExam.exam_id]", primaryjoin="CareerExam.exam_id == EntranceExam.opportunity_id", overlaps="career_exams")  # noqa: F821

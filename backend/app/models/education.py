"""
Education model — student education history.

Deliberately flexible to support non-standard education paths:
school, diploma, vocational, informal learning, self-learning,
alternative curricula, and incomplete education.
"""
import uuid
import enum
from datetime import date

from sqlalchemy import Date, Enum, Float, ForeignKey, String, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import enum_values, TimestampMixin, UUIDPrimaryKeyMixin


class EducationLevel(str, enum.Enum):
    PRIMARY = "primary"                   # Up to Class 5
    UPPER_PRIMARY = "upper_primary"       # Class 6-8
    SECONDARY = "secondary"               # Class 9-10
    SENIOR_SECONDARY = "senior_secondary" # Class 11-12
    DIPLOMA = "diploma"
    VOCATIONAL = "vocational"
    CERTIFICATE = "certificate"
    BACHELOR = "bachelor"
    MASTER = "master"
    DOCTORATE = "doctorate"
    INFORMAL = "informal"
    SELF_LEARNING = "self_learning"
    OTHER = "other"


class EducationStatus(str, enum.Enum):
    COMPLETED = "completed"
    IN_PROGRESS = "in_progress"
    DROPPED_OUT = "dropped_out"
    INCOMPLETE = "incomplete"


class DataSource(str, enum.Enum):
    STUDENT_REPORTED = "student_reported"
    MARKSHEET = "marksheet"
    INSTITUTION_VERIFIED = "institution_verified"
    AI_INFERRED = "ai_inferred"
    VOLUNTEER_ENTERED = "volunteer_entered"
    OTHER = "other"


class StudentEducation(UUIDPrimaryKeyMixin, TimestampMixin, Base):
    """
    One education record per institution / level / period.
    A student can have multiple records for different levels or institutions.
    """

    __tablename__ = "student_education"

    student_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("students.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    institution_name: Mapped[str | None] = mapped_column(
        String(300),
        nullable=True,
        comment="Free-text institution name (may not match institutions table)",
    )
    education_level: Mapped[EducationLevel] = mapped_column(
        Enum(EducationLevel, name="education_level_enum", values_callable=enum_values),
        nullable=False,
    )
    curriculum: Mapped[str | None] = mapped_column(
        String(100),
        nullable=True,
        comment="e.g. CBSE, ICSE, State Board, IGCSE, Homeschool",
    )
    board: Mapped[str | None] = mapped_column(
        String(150),
        nullable=True,
        comment="Examination board, e.g. Maharashtra State Board",
    )
    field_of_study: Mapped[str | None] = mapped_column(
        String(200),
        nullable=True,
        comment="Stream or specialization, e.g. Science, Commerce, Computer Science",
    )
    start_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    end_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    status: Mapped[EducationStatus] = mapped_column(
        Enum(EducationStatus, name="education_status_enum", values_callable=enum_values),
        nullable=False,
        default=EducationStatus.COMPLETED,
    )
    description: Mapped[str | None] = mapped_column(
        Text,
        nullable=True,
        comment="Any additional context, e.g. dropped out due to financial reasons",
    )
    source: Mapped[DataSource] = mapped_column(
        Enum(DataSource, name="education_source_enum", values_callable=enum_values),
        nullable=False,
        default=DataSource.STUDENT_REPORTED,
    )
    confidence: Mapped[float] = mapped_column(
        Float,
        nullable=False,
        default=1.0,
        comment="0.0–1.0 confidence score in this record's accuracy",
    )

    # Relationships
    student: Mapped["Student"] = relationship(back_populates="education_records")  # noqa: F821
    subjects: Mapped[list["StudentSubject"]] = relationship(  # noqa: F821
        back_populates="education", cascade="all, delete-orphan"
    )

    def __repr__(self) -> str:
        return f"<StudentEducation {self.education_level} @ {self.institution_name}>"


class StudentSubject(UUIDPrimaryKeyMixin, Base):
    """Individual subject marks within a StudentEducation record."""

    __tablename__ = "student_subjects"

    from datetime import datetime
    from sqlalchemy import DateTime, func

    student_education_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("student_education.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    subject: Mapped[str] = mapped_column(String(200), nullable=False)
    marks: Mapped[float | None] = mapped_column(Float, nullable=True)
    maximum_marks: Mapped[float | None] = mapped_column(Float, nullable=True)
    percentage: Mapped[float | None] = mapped_column(Float, nullable=True)
    grade: Mapped[str | None] = mapped_column(String(10), nullable=True)
    source: Mapped[DataSource] = mapped_column(
        Enum(DataSource, name="subject_source_enum", values_callable=enum_values),
        nullable=False,
        default=DataSource.STUDENT_REPORTED,
    )
    confidence: Mapped[float] = mapped_column(Float, nullable=False, default=1.0)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )

    # Relationships
    education: Mapped["StudentEducation"] = relationship(back_populates="subjects")

    def __repr__(self) -> str:
        return f"<StudentSubject {self.subject} ({self.percentage}%)>"

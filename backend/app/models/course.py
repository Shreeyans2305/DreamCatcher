"""
Course models — Course (opportunity extension) and CourseInstitution (many-to-many).

A course can exist at multiple institutions with different fees, durations,
and admission methods.
"""
import uuid
import enum

from sqlalchemy import Enum, ForeignKey, Integer, Numeric, String, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import enum_values, UUIDPrimaryKeyMixin
from app.models.education import EducationLevel


class CourseMode(str, enum.Enum):
    FULL_TIME = "full_time"
    PART_TIME = "part_time"
    ONLINE = "online"
    DISTANCE = "distance"
    HYBRID = "hybrid"


class AdmissionMethod(str, enum.Enum):
    MERIT = "merit"
    ENTRANCE_EXAM = "entrance_exam"
    INTERVIEW = "interview"
    DIRECT = "direct"
    LATERAL_ENTRY = "lateral_entry"
    OTHER = "other"


class Course(Base):
    """
    Course-specific fields.
    opportunity_id is the PK and FK to opportunities (1:1 extension).
    """

    __tablename__ = "courses"

    opportunity_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("opportunities.id", ondelete="CASCADE"),
        primary_key=True,
    )
    education_level: Mapped[EducationLevel | None] = mapped_column(
        Enum(EducationLevel, name="course_education_level_enum", values_callable=enum_values),
        nullable=True,
        comment="Level of the course, e.g. bachelor, master",
    )
    field: Mapped[str | None] = mapped_column(
        String(200),
        nullable=True,
        comment="Field of study, e.g. Computer Science, Agriculture",
    )
    duration: Mapped[str | None] = mapped_column(
        String(100),
        nullable=True,
        comment="e.g. '4 years', '6 months'",
    )
    mode: Mapped[CourseMode] = mapped_column(
        Enum(CourseMode, name="course_mode_enum", values_callable=enum_values),
        nullable=False,
        default=CourseMode.FULL_TIME,
    )
    description: Mapped[str | None] = mapped_column(Text, nullable=True)

    # Relationships
    opportunity: Mapped["Opportunity"] = relationship(back_populates="course")  # noqa: F821
    course_institutions: Mapped[list["CourseInstitution"]] = relationship(
        back_populates="course", cascade="all, delete-orphan"
    )
    career_courses: Mapped[list["CareerCourse"]] = relationship(  # noqa: F821
        "CareerCourse",
        foreign_keys="[CareerCourse.course_id]",
        primaryjoin="Course.opportunity_id == CareerCourse.course_id",
    )

    def __repr__(self) -> str:
        return f"<Course opp={self.opportunity_id} field={self.field}>"


class CourseInstitution(UUIDPrimaryKeyMixin, Base):
    """
    A course offered at a specific institution.
    Allows the same course to exist at many institutions with different terms.
    """

    __tablename__ = "course_institutions"

    course_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("courses.opportunity_id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    institution_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("institutions.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    tuition_fee: Mapped[float | None] = mapped_column(
        Numeric(12, 2),
        nullable=True,
        comment="Annual or total tuition fee in INR",
    )
    duration: Mapped[str | None] = mapped_column(
        String(100),
        nullable=True,
        comment="Institution-specific duration override",
    )
    admission_method: Mapped[AdmissionMethod] = mapped_column(
        Enum(AdmissionMethod, name="admission_method_enum", values_callable=enum_values),
        nullable=False,
        default=AdmissionMethod.MERIT,
    )

    # Relationships
    course: Mapped["Course"] = relationship(back_populates="course_institutions")
    institution: Mapped["Institution"] = relationship(back_populates="course_institutions")  # noqa: F821

    def __repr__(self) -> str:
        return f"<CourseInstitution course={self.course_id} institution={self.institution_id}>"

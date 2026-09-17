"""
Student model — core student profile.

Design decisions:
- No passwords stored (auth is out of scope for Phase 1).
- No government ID numbers by default.
- All sensitive PII is isolated to this table for future row-level security.
- profile_completeness is a 0.0–1.0 float updated by application logic.
"""
import uuid
import enum
from datetime import date, datetime

from sqlalchemy import Boolean, Date, Enum, Float, ForeignKey, String, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import enum_values, TimestampMixin, UUIDPrimaryKeyMixin


class Gender(str, enum.Enum):
    MALE = "male"
    FEMALE = "female"
    OTHER = "other"
    PREFER_NOT_TO_SAY = "prefer_not_to_say"


class Student(UUIDPrimaryKeyMixin, TimestampMixin, Base):
    __tablename__ = "students"

    name: Mapped[str] = mapped_column(String(200), nullable=False)
    date_of_birth: Mapped[date | None] = mapped_column(Date, nullable=True)
    gender: Mapped[Gender | None] = mapped_column(
        Enum(Gender, name="gender_enum", values_callable=enum_values),
        nullable=True,
    )
    phone: Mapped[str | None] = mapped_column(
        String(20),
        nullable=True,
        comment="E.164 format recommended, e.g. +919876543210",
    )
    email: Mapped[str | None] = mapped_column(String(254), nullable=True)
    preferred_language: Mapped[str] = mapped_column(
        String(10),
        ForeignKey("languages.code"),
        nullable=False,
        default="en",
        comment="ISO 639-1 language code",
    )
    location_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("locations.id", ondelete="SET NULL"),
        nullable=True,
    )
    avatar_url: Mapped[str | None] = mapped_column(Text, nullable=True)
    profile_completeness: Mapped[float] = mapped_column(
        Float,
        nullable=False,
        default=0.0,
        comment="0.0 to 1.0 completeness score, updated by application logic",
    )

    # Relationships
    location: Mapped["Location"] = relationship(back_populates="students")  # noqa: F821
    education_records: Mapped[list["StudentEducation"]] = relationship(  # noqa: F821
        back_populates="student", cascade="all, delete-orphan"
    )
    skills: Mapped[list["StudentSkill"]] = relationship(  # noqa: F821
        back_populates="student", cascade="all, delete-orphan"
    )
    interests: Mapped[list["StudentInterest"]] = relationship(  # noqa: F821
        back_populates="student", cascade="all, delete-orphan"
    )
    aspirations: Mapped[list["StudentAspiration"]] = relationship(  # noqa: F821
        back_populates="student", cascade="all, delete-orphan"
    )
    documents: Mapped[list["StudentDocument"]] = relationship(  # noqa: F821
        back_populates="student", cascade="all, delete-orphan"
    )
    chat_sessions: Mapped[list["ChatSession"]] = relationship(  # noqa: F821
        back_populates="student", cascade="all, delete-orphan"
    )

    def __repr__(self) -> str:
        return f"<Student {self.name} ({self.id})>"

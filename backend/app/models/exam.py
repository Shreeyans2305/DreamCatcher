"""
Entrance Exam model — extends the central Opportunity model (1:1).
"""
import uuid
import enum
from datetime import date

from sqlalchemy import Date, Enum, ForeignKey, Numeric, String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import enum_values

class ExamMode(str, enum.Enum):
    ONLINE = "online"
    OFFLINE = "offline"
    HYBRID = "hybrid"


class ExamFrequency(str, enum.Enum):
    ANNUAL = "annual"
    BIANNUAL = "biannual"
    QUARTERLY = "quarterly"
    AS_NEEDED = "as_needed"


class EntranceExam(Base):
    """
    Entrance-exam-specific fields.
    opportunity_id is the PK and FK to opportunities (1:1 extension).
    """

    __tablename__ = "entrance_exams"

    opportunity_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("opportunities.id", ondelete="CASCADE"),
        primary_key=True,
    )
    conducting_body: Mapped[str | None] = mapped_column(String(300), nullable=True)
    exam_mode: Mapped[ExamMode] = mapped_column(
        Enum(ExamMode, name="exam_mode_enum", values_callable=enum_values),
        nullable=False,
        default=ExamMode.OFFLINE,
    )
    exam_frequency: Mapped[ExamFrequency] = mapped_column(
        Enum(ExamFrequency, name="exam_frequency_enum", values_callable=enum_values),
        nullable=False,
        default=ExamFrequency.ANNUAL,
    )
    registration_start: Mapped[date | None] = mapped_column(Date, nullable=True)
    registration_deadline: Mapped[date | None] = mapped_column(Date, nullable=True)
    examination_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    application_fee: Mapped[float | None] = mapped_column(
        Numeric(10, 2),
        nullable=True,
        comment="Application fee in INR; NULL if free",
    )
    official_exam_url: Mapped[str | None] = mapped_column(String(1000), nullable=True)

    # Relationship back to parent
    opportunity: Mapped["Opportunity"] = relationship(back_populates="entrance_exam")  # noqa: F821
    career_exams: Mapped[list["CareerExam"]] = relationship(  # noqa: F821
        "CareerExam",
        foreign_keys="[CareerExam.exam_id]",
        primaryjoin="EntranceExam.opportunity_id == CareerExam.exam_id",
    )

    def __repr__(self) -> str:
        return f"<EntranceExam opp={self.opportunity_id}>"

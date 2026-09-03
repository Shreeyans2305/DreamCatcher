"""
Scholarship model — extends the central Opportunity model (1:1).
"""
import uuid
import enum

from sqlalchemy import Boolean, Enum, ForeignKey, Integer, Numeric, String, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import enum_values, UUIDPrimaryKeyMixin


class AwardFrequency(str, enum.Enum):
    ONE_TIME = "one_time"
    ANNUAL = "annual"
    SEMESTER = "semester"
    MONTHLY = "monthly"
    OTHER = "other"


class Scholarship(Base):
    """
    Scholarship-specific fields.
    opportunity_id is the PK and FK to opportunities (1:1 extension).
    """

    __tablename__ = "scholarships"

    opportunity_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("opportunities.id", ondelete="CASCADE"),
        primary_key=True,
    )
    amount: Mapped[float | None] = mapped_column(
        Numeric(12, 2),
        nullable=True,
        comment="Award amount in the specified currency",
    )
    currency: Mapped[str] = mapped_column(String(3), nullable=False, default="INR")
    award_frequency: Mapped[AwardFrequency] = mapped_column(
        Enum(AwardFrequency, name="award_frequency_enum", values_callable=enum_values),
        nullable=False,
        default=AwardFrequency.ANNUAL,
    )
    renewable: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False)
    number_of_awards: Mapped[int | None] = mapped_column(
        Integer,
        nullable=True,
        comment="Total number of awards per cycle; NULL = not specified",
    )
    application_process: Mapped[str | None] = mapped_column(Text, nullable=True)
    required_documents: Mapped[str | None] = mapped_column(
        Text,
        nullable=True,
        comment="Comma-separated or structured list of required documents",
    )

    # Relationship back to parent
    opportunity: Mapped["Opportunity"] = relationship(back_populates="scholarship")  # noqa: F821

    def __repr__(self) -> str:
        return f"<Scholarship opp={self.opportunity_id} amount={self.amount} {self.currency}>"

"""
Internship model — extends the central Opportunity model (1:1).
"""
import uuid
from datetime import date

from sqlalchemy import Boolean, Date, ForeignKey, Numeric, String, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base


class Internship(Base):
    """
    Internship-specific fields.
    opportunity_id is the PK and FK to opportunities (1:1 extension).
    """

    __tablename__ = "internships"

    opportunity_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("opportunities.id", ondelete="CASCADE"),
        primary_key=True,
    )
    organization_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("organizations.id", ondelete="SET NULL"),
        nullable=True,
        comment="Offering organization (may differ from opportunity.organization_id)",
    )
    location_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("locations.id", ondelete="SET NULL"),
        nullable=True,
    )
    remote: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False)
    duration: Mapped[str | None] = mapped_column(
        String(100),
        nullable=True,
        comment="e.g. '2 months', '6 weeks'",
    )
    stipend: Mapped[float | None] = mapped_column(
        Numeric(10, 2),
        nullable=True,
        comment="Monthly stipend in INR; NULL if unpaid",
    )
    start_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    end_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    application_deadline: Mapped[date | None] = mapped_column(Date, nullable=True)
    work_description: Mapped[str | None] = mapped_column(Text, nullable=True)

    # Relationships
    opportunity: Mapped["Opportunity"] = relationship(back_populates="internship")  # noqa: F821
    organization: Mapped["Organization"] = relationship(back_populates="internships")  # noqa: F821
    location: Mapped["Location"] = relationship(back_populates="internships")  # noqa: F821

    def __repr__(self) -> str:
        return f"<Internship opp={self.opportunity_id} remote={self.remote}>"

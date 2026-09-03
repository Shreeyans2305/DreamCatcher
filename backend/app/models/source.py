"""
Source and Verification models.

Sources track where opportunity data came from.
Verification logs track when and by whom opportunities were verified.
"""
import uuid
import enum
from datetime import datetime

from sqlalchemy import DateTime, Enum, Float, ForeignKey, String, Text, func
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import enum_values, UUIDPrimaryKeyMixin
from app.models.opportunity import VerificationStatus


class SourceType(str, enum.Enum):
    OFFICIAL = "OFFICIAL"
    GOVERNMENT = "GOVERNMENT"
    UNIVERSITY = "UNIVERSITY"
    PARTNER = "PARTNER"
    SECONDARY = "SECONDARY"
    USER_SUBMITTED = "USER_SUBMITTED"


class Source(UUIDPrimaryKeyMixin, Base):
    """A source of opportunity data — official portal, government page, etc."""

    __tablename__ = "sources"

    organization_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("organizations.id", ondelete="SET NULL"),
        nullable=True,
    )
    url: Mapped[str | None] = mapped_column(String(1000), nullable=True)
    source_type: Mapped[SourceType] = mapped_column(
        Enum(SourceType, name="source_type_enum", values_callable=enum_values),
        nullable=False,
        default=SourceType.SECONDARY,
    )
    title: Mapped[str | None] = mapped_column(String(500), nullable=True)
    retrieved_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    last_checked: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    reliability: Mapped[float] = mapped_column(
        Float,
        nullable=False,
        default=0.5,
        comment="0.0–1.0 reliability score; 1.0 = official verified source",
    )
    notes: Mapped[str | None] = mapped_column(Text, nullable=True)

    # Relationships
    organization: Mapped["Organization"] = relationship(back_populates="sources")  # noqa: F821
    verification_logs: Mapped[list["VerificationLog"]] = relationship(back_populates="source")
    documents: Mapped[list["OpportunityDocument"]] = relationship(back_populates="source")  # noqa: F821

    def __repr__(self) -> str:
        return f"<Source {self.source_type}: {self.url}>"


class VerificationLog(UUIDPrimaryKeyMixin, Base):
    """Audit trail of opportunity verification events."""

    __tablename__ = "verification_logs"

    opportunity_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("opportunities.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    source_id: Mapped[uuid.UUID | None] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("sources.id", ondelete="SET NULL"),
        nullable=True,
    )
    verification_status: Mapped[VerificationStatus] = mapped_column(
        Enum(VerificationStatus, name="verif_log_status_enum", values_callable=enum_values),
        nullable=False,
    )
    verified_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )
    verified_by: Mapped[str | None] = mapped_column(
        String(200),
        nullable=True,
        comment="User/system that performed the verification",
    )
    notes: Mapped[str | None] = mapped_column(Text, nullable=True)

    # Relationships
    opportunity: Mapped["Opportunity"] = relationship(back_populates="verification_logs")  # noqa: F821
    source: Mapped["Source"] = relationship(back_populates="verification_logs")

    def __repr__(self) -> str:
        return f"<VerificationLog opp={self.opportunity_id} status={self.verification_status}>"

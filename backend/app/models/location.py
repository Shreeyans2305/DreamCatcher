"""
Location model — reusable geographic hierarchy.

Supports granularity from country → state → district → taluka → village.
Opportunities and students both reference locations so that eligibility
can be filtered at any geographic level.
"""
import uuid

from sqlalchemy import Boolean, Enum, ForeignKey, String, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import TimestampMixin, UUIDPrimaryKeyMixin

import enum


class RuralUrban(str, enum.Enum):
    RURAL = "rural"
    URBAN = "urban"
    SEMI_URBAN = "semi_urban"
    UNKNOWN = "unknown"


# Helper to map SQLAlchemy Enum to use .value instead of .name
def _enum_values(enum_class):
    return [e.value for e in enum_class]


class Location(UUIDPrimaryKeyMixin, TimestampMixin, Base):
    """
    Hierarchical location: country → state → district → taluka → village.
    A location record can represent any level of the hierarchy.
    """

    __tablename__ = "locations"

    country: Mapped[str] = mapped_column(String(100), nullable=False, default="India")
    state: Mapped[str | None] = mapped_column(String(100), nullable=True)
    district: Mapped[str | None] = mapped_column(String(100), nullable=True)
    taluka: Mapped[str | None] = mapped_column(String(100), nullable=True, comment="Also called tehsil")
    village: Mapped[str | None] = mapped_column(String(200), nullable=True)
    pincode: Mapped[str | None] = mapped_column(String(10), nullable=True)
    rural_urban: Mapped[RuralUrban] = mapped_column(
        Enum(RuralUrban, name="rural_urban_enum", values_callable=_enum_values),
        nullable=False,
        default=RuralUrban.UNKNOWN,
    )

    # Back-references (populated by other models)
    students: Mapped[list["Student"]] = relationship(back_populates="location")  # noqa: F821
    institutions: Mapped[list["Institution"]] = relationship(back_populates="location")  # noqa: F821
    opportunities: Mapped[list["Opportunity"]] = relationship(back_populates="location")  # noqa: F821
    internships: Mapped[list["Internship"]] = relationship(back_populates="location")  # noqa: F821

    def __repr__(self) -> str:
        parts = [p for p in [self.village, self.taluka, self.district, self.state, self.country] if p]
        return f"<Location {', '.join(parts)}>"

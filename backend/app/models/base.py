"""
DreamCatcher — Shared model base with timestamp columns.
All ORM models import TimestampMixin from here.
"""
import uuid
from datetime import datetime, timezone
from typing import Type

from sqlalchemy import DateTime, func
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column


def utcnow() -> datetime:
    return datetime.now(timezone.utc)


def enum_values(enum_class: Type) -> list[str]:
    """
    Return enum .value list for SQLAlchemy Enum(values_callable=...).

    SQLAlchemy by default maps enums by .name (uppercase).
    PostgreSQL stores them by .value (lowercase).
    Using values_callable ensures SQLAlchemy sends the correct value.

    Usage:
        sa.Column(Enum(MyEnum, name="my_enum", values_callable=enum_values), ...)
    """
    return [e.value for e in enum_class]


class UUIDPrimaryKeyMixin:
    """Adds a UUID primary key column."""

    id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        primary_key=True,
        default=uuid.uuid4,
        server_default=func.gen_random_uuid(),
    )


class TimestampMixin:
    """Adds created_at and updated_at columns with automatic timestamps."""

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
    )

"""
Translation model — stores translated text for any entity field.

Design: canonical data is always stored in English (or language-independent).
Instead of creating separate tables per language (scholarships_hindi, etc.),
a single translations table handles all entities.

Usage:
    Translation(
        entity_type="opportunity",
        entity_id=some_uuid,
        field="title",
        language_code="hi",
        translated_text="..."
    )
"""
import uuid

from sqlalchemy import ForeignKey, String, Text, UniqueConstraint
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import UUIDPrimaryKeyMixin


class Translation(UUIDPrimaryKeyMixin, Base):
    """EAV-style translation storage for any entity field."""

    __tablename__ = "translations"
    __table_args__ = (
        UniqueConstraint("entity_type", "entity_id", "field", "language_code", name="uq_translation"),
    )

    entity_type: Mapped[str] = mapped_column(
        String(100),
        nullable=False,
        comment="Table name of the entity, e.g. 'opportunity', 'career'",
    )
    entity_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        nullable=False,
        comment="UUID of the translated entity",
    )
    field: Mapped[str] = mapped_column(
        String(100),
        nullable=False,
        comment="Field name being translated, e.g. 'title', 'description'",
    )
    language_code: Mapped[str] = mapped_column(
        String(10),
        ForeignKey("languages.code", ondelete="CASCADE"),
        nullable=False,
    )
    translated_text: Mapped[str] = mapped_column(Text, nullable=False)

    # Relationship
    language: Mapped["Language"] = relationship(back_populates="translations")  # noqa: F821

    def __repr__(self) -> str:
        return f"<Translation {self.entity_type}.{self.field} [{self.language_code}]>"

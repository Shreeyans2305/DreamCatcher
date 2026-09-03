"""
Language model — lookup table for supported languages.

Canonical content is language-independent; translations are stored
in the Translation model. Adding a new language requires only a new row here.
"""
from sqlalchemy import Boolean, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base


class Language(Base):
    """ISO 639-1 language codes with display names."""

    __tablename__ = "languages"

    code: Mapped[str] = mapped_column(String(10), primary_key=True, comment="ISO 639-1 code, e.g. 'hi'")
    name: Mapped[str] = mapped_column(String(100), nullable=False, comment="English display name, e.g. 'Hindi'")
    native_name: Mapped[str | None] = mapped_column(String(100), nullable=True, comment="Name in that language")
    is_active: Mapped[bool] = mapped_column(Boolean, nullable=False, default=True)
    script: Mapped[str | None] = mapped_column(String(50), nullable=True, comment="Script name, e.g. Devanagari")

    # Back-reference
    translations: Mapped[list["Translation"]] = relationship(back_populates="language")  # noqa: F821

    def __repr__(self) -> str:
        return f"<Language {self.code} ({self.name})>"

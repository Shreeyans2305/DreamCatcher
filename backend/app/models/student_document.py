"""
Student Document model — metadata for documents uploaded by students.

Actual files are stored in Google Cloud Storage (or local dev storage).
Only metadata and extracted text is stored in PostgreSQL.
"""
import uuid
import enum
from datetime import datetime

from sqlalchemy import Boolean, DateTime, Enum, Float, ForeignKey, String, Text, func
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import enum_values, UUIDPrimaryKeyMixin


class StudentDocumentType(str, enum.Enum):
    MARKSHEET = "marksheet"
    CERTIFICATE = "certificate"
    INCOME_CERTIFICATE = "income_certificate"
    CASTE_CERTIFICATE = "caste_certificate"
    SKILL_CERTIFICATE = "skill_certificate"
    IDENTITY_PROOF = "identity_proof"
    PHOTO = "photo"
    OTHER = "other"


class StudentDocument(UUIDPrimaryKeyMixin, Base):
    """
    Metadata for a document uploaded by a student.
    storage_url references the GCS (or local dev) file location.
    """

    __tablename__ = "student_documents"

    student_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("students.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    document_type: Mapped[StudentDocumentType] = mapped_column(
        Enum(StudentDocumentType, name="student_document_type_enum", values_callable=enum_values),
        nullable=False,
        default=StudentDocumentType.OTHER,
    )
    storage_url: Mapped[str | None] = mapped_column(
        String(1000),
        nullable=True,
        comment="GCS object URI, e.g. gs://dreamcatcher-dev/students/.../doc.pdf",
    )
    filename: Mapped[str | None] = mapped_column(String(500), nullable=True)
    mime_type: Mapped[str | None] = mapped_column(String(100), nullable=True)
    uploaded_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )
    verified: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False)
    extracted_text: Mapped[str | None] = mapped_column(
        Text,
        nullable=True,
        comment="OCR/parsed text extracted from the document",
    )
    extraction_confidence: Mapped[float | None] = mapped_column(
        Float,
        nullable=True,
        comment="Confidence score of text extraction (0.0–1.0)",
    )

    # Relationship
    student: Mapped["Student"] = relationship(back_populates="documents")  # noqa: F821

    def __repr__(self) -> str:
        return f"<StudentDocument {self.document_type}: {self.filename}>"

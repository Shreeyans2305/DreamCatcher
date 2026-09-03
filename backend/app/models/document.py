"""
RAG/Knowledge document models — OpportunityDocument and DocumentChunk.

Uses pgvector for semantic search over document chunks.
Embeddings are stored as VECTOR(dim) where dim defaults to 1536.
"""
import uuid
import enum
from datetime import datetime

from sqlalchemy import DateTime, Enum, ForeignKey, Integer, String, Text, func
from sqlalchemy.dialects.postgresql import JSONB, UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.database import Base
from app.models.base import enum_values, UUIDPrimaryKeyMixin
from app.core.config import settings

# pgvector type — import at module level
try:
    from pgvector.sqlalchemy import Vector
    _VECTOR_TYPE = Vector(settings.vector_dim)
except ImportError:
    # Fallback if pgvector package not installed in environment
    from sqlalchemy import Text as _VECTOR_TYPE  # type: ignore


class DocumentType(str, enum.Enum):
    SCHOLARSHIP_GUIDELINES = "scholarship_guidelines"
    GOVERNMENT_PDF = "government_pdf"
    ADMISSION_BROCHURE = "admission_brochure"
    EXAM_BROCHURE = "exam_brochure"
    COURSE_DESCRIPTION = "course_description"
    INTERNSHIP_DESCRIPTION = "internship_description"
    FAQ = "faq"
    OTHER = "other"


class OpportunityDocument(UUIDPrimaryKeyMixin, Base):
    """
    A full document associated with an opportunity.
    The document is chunked for RAG in DocumentChunk.
    """

    __tablename__ = "opportunity_documents"

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
    document_type: Mapped[DocumentType] = mapped_column(
        Enum(DocumentType, name="document_type_enum", values_callable=enum_values),
        nullable=False,
        default=DocumentType.OTHER,
    )
    title: Mapped[str | None] = mapped_column(String(500), nullable=True)
    content: Mapped[str | None] = mapped_column(Text, nullable=True, comment="Full text content of the document")
    source_url: Mapped[str | None] = mapped_column(String(1000), nullable=True)
    language: Mapped[str] = mapped_column(
        String(10),
        ForeignKey("languages.code"),
        nullable=False,
        default="en",
    )
    last_updated: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )

    # Relationships
    opportunity: Mapped["Opportunity"] = relationship(back_populates="documents")  # noqa: F821
    source: Mapped["Source"] = relationship(back_populates="documents")  # noqa: F821
    chunks: Mapped[list["DocumentChunk"]] = relationship(
        back_populates="document", cascade="all, delete-orphan"
    )

    def __repr__(self) -> str:
        return f"<OpportunityDocument {self.document_type}: {self.title}>"


class DocumentChunk(UUIDPrimaryKeyMixin, Base):
    """
    A chunk of an OpportunityDocument with a pgvector embedding.

    The embedding column stores vectors for semantic similarity search.
    An HNSW index is created on this column in the migration for fast ANN search.
    """

    __tablename__ = "document_chunks"

    document_id: Mapped[uuid.UUID] = mapped_column(
        UUID(as_uuid=True),
        ForeignKey("opportunity_documents.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    chunk_index: Mapped[int] = mapped_column(
        Integer,
        nullable=False,
        comment="Sequential chunk index within the document",
    )
    chunk_text: Mapped[str] = mapped_column(Text, nullable=False)
    embedding: Mapped[list[float] | None] = mapped_column(
        _VECTOR_TYPE,  # type: ignore[arg-type]
        nullable=True,
        comment=f"pgvector embedding of dimension {settings.vector_dim}",
    )
    metadata_: Mapped[dict | None] = mapped_column(
        "metadata",
        JSONB,
        nullable=True,
        comment="Extra metadata, e.g. page number, section title",
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )

    # Relationship
    document: Mapped["OpportunityDocument"] = relationship(back_populates="chunks")

    def __repr__(self) -> str:
        return f"<DocumentChunk doc={self.document_id} idx={self.chunk_index}>"

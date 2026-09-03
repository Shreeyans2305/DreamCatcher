"""
Embedding Service — Vertex AI-powered document embedding and semantic search.

Uses google-genai SDK with Vertex AI to generate embeddings via text-embedding-004
and performs pgvector cosine similarity search for RAG retrieval.
"""
import logging
from typing import List, Optional
from uuid import UUID

import tiktoken
from sqlalchemy.orm import Session
from sqlalchemy import select

from app.core.config import settings
from app.models.document import OpportunityDocument, DocumentChunk

logger = logging.getLogger(__name__)

# Lazy-initialized GenAI client (shared with AIService)
_genai_client = None


def _get_client():
    """Get or create the Vertex AI GenAI client."""
    global _genai_client
    if _genai_client is None:
        try:
            from google import genai
            _genai_client = genai.Client(
                vertexai=True,
                project=settings.gcp_project_id,
                location=settings.gcp_location,
            )
            logger.info(
                "Vertex AI GenAI client initialized (project=%s, location=%s)",
                settings.gcp_project_id,
                settings.gcp_location,
            )
        except Exception as e:
            logger.error("Failed to initialize Vertex AI client: %s", e)
            raise
    return _genai_client


# ---------------------------------------------------------------------------
# Text chunking
# ---------------------------------------------------------------------------
_tokenizer = None


def _get_tokenizer():
    """Get a tokenizer for accurate token counting."""
    global _tokenizer
    if _tokenizer is None:
        _tokenizer = tiktoken.get_encoding("cl100k_base")
    return _tokenizer


def chunk_text(
    text: str,
    chunk_size: int = 512,
    overlap: int = 50,
) -> List[str]:
    """
    Split text into overlapping chunks based on token count.

    Args:
        text: The full document text to chunk.
        chunk_size: Maximum tokens per chunk.
        overlap: Number of overlapping tokens between consecutive chunks.

    Returns:
        List of text chunks.
    """
    if not text or not text.strip():
        return []

    tokenizer = _get_tokenizer()
    tokens = tokenizer.encode(text)

    if len(tokens) <= chunk_size:
        return [text.strip()]

    chunks = []
    start = 0
    while start < len(tokens):
        end = min(start + chunk_size, len(tokens))
        chunk_tokens = tokens[start:end]
        chunk_text_str = tokenizer.decode(chunk_tokens).strip()
        if chunk_text_str:
            chunks.append(chunk_text_str)

        if end >= len(tokens):
            break
        start += chunk_size - overlap

    return chunks


# ---------------------------------------------------------------------------
# Embedding generation
# ---------------------------------------------------------------------------
class EmbeddingService:
    """Generates embeddings via Vertex AI and performs semantic search."""

    @staticmethod
    def generate_embedding(text: str) -> List[float]:
        """
        Generate an embedding vector for a single text using Vertex AI text-embedding-004.

        Args:
            text: The text to embed.

        Returns:
            A list of floats representing the embedding vector.

        Raises:
            RuntimeError: If the Vertex AI call fails.
        """
        client = _get_client()
        try:
            result = client.models.embed_content(
                model=settings.embedding_model,
                contents=text,
            )
            # The response structure: result.embeddings is a list of ContentEmbedding
            if result and result.embeddings:
                return list(result.embeddings[0].values)
            raise RuntimeError("Empty embedding response from Vertex AI")
        except Exception as e:
            logger.error("Embedding generation failed: %s", e)
            raise RuntimeError(f"Vertex AI embedding failed: {e}") from e

    @staticmethod
    def generate_embeddings_batch(texts: List[str]) -> List[List[float]]:
        """
        Generate embeddings for multiple texts in a single Vertex AI call.

        Args:
            texts: List of texts to embed (max ~250 per batch).

        Returns:
            List of embedding vectors, one per input text.
        """
        if not texts:
            return []

        client = _get_client()
        try:
            result = client.models.embed_content(
                model=settings.embedding_model,
                contents=texts,
            )
            if result and result.embeddings:
                return [list(emb.values) for emb in result.embeddings]
            raise RuntimeError("Empty batch embedding response from Vertex AI")
        except Exception as e:
            logger.error("Batch embedding generation failed: %s", e)
            raise RuntimeError(f"Vertex AI batch embedding failed: {e}") from e

    @staticmethod
    def embed_document(db: Session, document_id: UUID) -> int:
        """
        Chunk a document's text, generate Vertex AI embeddings, and store in document_chunks.

        Args:
            db: SQLAlchemy session.
            document_id: ID of the OpportunityDocument to embed.

        Returns:
            Number of chunks created.

        Raises:
            ValueError: If the document is not found or has no content.
        """
        doc = db.execute(
            select(OpportunityDocument).where(OpportunityDocument.id == document_id)
        ).scalar_one_or_none()

        if not doc:
            raise ValueError(f"Document {document_id} not found")
        if not doc.content or not doc.content.strip():
            raise ValueError(f"Document {document_id} has no text content")

        # Remove existing chunks for this document (re-embed)
        existing_chunks = db.execute(
            select(DocumentChunk).where(DocumentChunk.document_id == document_id)
        ).scalars().all()
        for chunk in existing_chunks:
            db.delete(chunk)
        db.flush()

        # Chunk the text
        chunks = chunk_text(doc.content, chunk_size=512, overlap=50)
        if not chunks:
            return 0

        # Generate embeddings in batch
        logger.info("Generating embeddings for %d chunks of document %s", len(chunks), document_id)
        embeddings = EmbeddingService.generate_embeddings_batch(chunks)

        # Store chunks with embeddings
        for idx, (text, embedding) in enumerate(zip(chunks, embeddings)):
            chunk = DocumentChunk(
                document_id=document_id,
                chunk_index=idx,
                chunk_text=text,
                embedding=embedding,
                metadata_={
                    "source_document_title": doc.title,
                    "document_type": doc.document_type.value if doc.document_type else None,
                    "language": doc.language,
                },
            )
            db.add(chunk)

        db.commit()
        logger.info("Created %d chunks with embeddings for document %s", len(chunks), document_id)
        return len(chunks)

    @staticmethod
    def embed_all_documents(db: Session) -> dict:
        """
        Generate embeddings for all documents that don't have embedded chunks yet.

        Returns:
            Dict with counts: {"documents_processed": N, "total_chunks_created": N, "errors": [...]}
        """
        # Find documents that have no chunks with embeddings
        docs_with_embeddings = (
            db.execute(
                select(DocumentChunk.document_id)
                .where(DocumentChunk.embedding.isnot(None))
                .distinct()
            )
            .scalars()
            .all()
        )
        embedded_doc_ids = set(docs_with_embeddings)

        all_docs = (
            db.execute(
                select(OpportunityDocument)
                .where(OpportunityDocument.content.isnot(None))
                .where(OpportunityDocument.content != "")
            )
            .scalars()
            .all()
        )

        docs_to_embed = [d for d in all_docs if d.id not in embedded_doc_ids]
        logger.info("Found %d documents to embed out of %d total", len(docs_to_embed), len(all_docs))

        results = {"documents_processed": 0, "total_chunks_created": 0, "errors": []}

        for doc in docs_to_embed:
            try:
                chunk_count = EmbeddingService.embed_document(db, doc.id)
                results["documents_processed"] += 1
                results["total_chunks_created"] += chunk_count
            except Exception as e:
                error_msg = f"Document {doc.id} ({doc.title}): {e}"
                logger.error("Failed to embed document: %s", error_msg)
                results["errors"].append(error_msg)

        return results

    @staticmethod
    def semantic_search(
        db: Session,
        query: str,
        top_k: int = 5,
        opportunity_ids: Optional[List[UUID]] = None,
    ) -> List[DocumentChunk]:
        """
        Find the most semantically similar document chunks to a query.

        Uses pgvector cosine distance for approximate nearest neighbor search.

        Args:
            db: SQLAlchemy session.
            query: The search query text.
            top_k: Number of top results to return.
            opportunity_ids: Optional filter to limit search to specific opportunities.

        Returns:
            List of DocumentChunk objects ordered by similarity (most similar first).
        """
        # Generate query embedding
        query_embedding = EmbeddingService.generate_embedding(query)

        # Build the similarity search query
        stmt = (
            select(DocumentChunk)
            .where(DocumentChunk.embedding.isnot(None))
        )

        # Filter by opportunity IDs if provided
        if opportunity_ids:
            stmt = stmt.join(
                OpportunityDocument,
                DocumentChunk.document_id == OpportunityDocument.id,
            ).where(OpportunityDocument.opportunity_id.in_(opportunity_ids))

        # Order by cosine distance (ascending = most similar first)
        stmt = stmt.order_by(
            DocumentChunk.embedding.cosine_distance(query_embedding)
        ).limit(top_k)

        results = db.execute(stmt).scalars().all()
        return list(results)

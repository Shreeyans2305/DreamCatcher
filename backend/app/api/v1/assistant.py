"""
AI Assistant Endpoints: Conversational Career Guide, RAG Counseling, Skill Extraction,
Chat Session Management, and Embedding Generation.
"""
from typing import Optional
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.schemas.assistant import (
    ChatRequest,
    ChatResponse,
    ChatSessionCreate,
    ChatSessionListItem,
    ChatSessionResponse,
    ChatMessageResponse,
    SkillExtractionRequest,
    SkillExtractionResponse,
    EmbedDocumentResponse,
    EmbedAllResponse,
)
from app.services.ai_service import AIService

router = APIRouter(prefix="/assistant", tags=["AI Assistant"])


# ---------------------------------------------------------------------------
# Chat
# ---------------------------------------------------------------------------
@router.post(
    "/chat",
    response_model=ChatResponse,
    status_code=status.HTTP_200_OK,
    summary="Profile-aware AI career and scholarship counseling chat (Vertex AI)",
)
def chat_with_assistant(
    request: ChatRequest,
    db: Session = Depends(get_db),
):
    """
    Processes a student query with profile-grounded RAG context via Vertex AI.
    Returns tailored advice, official scholarship references, and action suggestions.

    Supports multi-turn conversations when session_id is provided.
    """
    try:
        return AIService.ask_career_guide(
            db=db,
            student_id=request.student_id,
            message=request.message,
            language=request.language or "en",
            session_id=request.session_id,
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Assistant service error: {str(e)}",
        )


# ---------------------------------------------------------------------------
# Skill Extraction
# ---------------------------------------------------------------------------
@router.post(
    "/extract-skills",
    response_model=SkillExtractionResponse,
    status_code=status.HTTP_200_OK,
    summary="Extract NSQF standardized skills and trades from informal learning text (Vertex AI)",
)
def extract_skills(request: SkillExtractionRequest):
    """
    Parses casual hands-on descriptions and maps them to standard vocational trades.
    Uses Vertex AI when available, falls back to rule-based engine.
    """
    return AIService.extract_skills_from_informal_text(request.description)


# ---------------------------------------------------------------------------
# Chat Sessions
# ---------------------------------------------------------------------------
@router.post(
    "/sessions",
    response_model=ChatSessionResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Create a new chat session for a student",
)
def create_session(
    request: ChatSessionCreate,
    db: Session = Depends(get_db),
):
    """Create a new conversation session."""
    from app.models.conversation import ChatSession

    session = ChatSession(
        student_id=request.student_id,
        title=request.title or "New conversation",
    )
    db.add(session)
    db.commit()
    db.refresh(session)

    return ChatSessionResponse(
        id=session.id,
        student_id=session.student_id,
        title=session.title,
        created_at=session.created_at,
        last_active_at=session.last_active_at,
        messages=[],
    )


@router.get(
    "/sessions",
    response_model=list[ChatSessionListItem],
    summary="List chat sessions for a student",
)
def list_sessions(
    student_id: UUID = Query(..., description="Student ID to list sessions for"),
    db: Session = Depends(get_db),
):
    """List all chat sessions for a student, most recent first."""
    sessions = AIService.list_sessions(db, student_id)
    result = []
    for s in sessions:
        result.append(
            ChatSessionListItem(
                id=s.id,
                title=s.title,
                created_at=s.created_at,
                last_active_at=s.last_active_at,
                message_count=len(s.messages) if s.messages else 0,
            )
        )
    return result


@router.get(
    "/sessions/{session_id}",
    response_model=ChatSessionResponse,
    summary="Get a chat session with full message history",
)
def get_session(
    session_id: UUID,
    db: Session = Depends(get_db),
):
    """Retrieve a chat session with all messages."""
    session = AIService.get_session_with_messages(db, session_id)
    if not session:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Chat session not found",
        )

    return ChatSessionResponse(
        id=session.id,
        student_id=session.student_id,
        title=session.title,
        created_at=session.created_at,
        last_active_at=session.last_active_at,
        messages=[
            ChatMessageResponse(
                id=m.id,
                role=m.role.value,
                content=m.content,
                created_at=m.created_at,
                metadata=m.metadata_,
            )
            for m in session.messages
        ],
    )


# ---------------------------------------------------------------------------
# Embedding Management
# ---------------------------------------------------------------------------
@router.post(
    "/embed-document/{document_id}",
    response_model=EmbedDocumentResponse,
    summary="Generate Vertex AI embeddings for a specific document",
)
def embed_document(
    document_id: UUID,
    db: Session = Depends(get_db),
):
    """Chunk a document and generate Vertex AI embeddings for RAG search."""
    from app.services.embedding_service import EmbeddingService

    try:
        chunks_created = EmbeddingService.embed_document(db, document_id)
        return EmbedDocumentResponse(
            document_id=document_id,
            chunks_created=chunks_created,
            message=f"Successfully created {chunks_created} embedding chunks.",
        )
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=str(e))
    except RuntimeError as e:
        raise HTTPException(status_code=status.HTTP_502_BAD_GATEWAY, detail=str(e))


@router.post(
    "/embed-all",
    response_model=EmbedAllResponse,
    summary="Batch-generate Vertex AI embeddings for all un-embedded documents",
)
def embed_all_documents(db: Session = Depends(get_db)):
    """Generate Vertex AI embeddings for all documents that don't have them yet."""
    from app.services.embedding_service import EmbeddingService

    try:
        results = EmbeddingService.embed_all_documents(db)
        return EmbedAllResponse(**results)
    except RuntimeError as e:
        raise HTTPException(status_code=status.HTTP_502_BAD_GATEWAY, detail=str(e))

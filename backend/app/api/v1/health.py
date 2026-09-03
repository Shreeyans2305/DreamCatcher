"""Health check endpoints for Phase 1 verification."""
from fastapi import APIRouter, HTTPException
from sqlalchemy import text

from app.core.database import check_db_connection, SessionLocal

router = APIRouter()


@router.get("/health", summary="Application health check")
def health():
    """Returns OK if the application is running."""
    return {"status": "ok", "service": "dreamcatcher-backend"}


@router.get("/health/db", summary="Database connectivity check")
def health_db():
    """
    Returns OK if PostgreSQL is reachable.
    Also returns the database version and pgvector extension status.
    """
    try:
        with SessionLocal() as db:
            # Check basic connectivity
            result = db.execute(text("SELECT version()")).scalar()

            # Check pgvector extension
            pgvector_result = db.execute(
                text(
                    "SELECT extversion FROM pg_extension WHERE extname = 'vector'"
                )
            ).fetchone()

            pgvector_version = pgvector_result[0] if pgvector_result else None

        return {
            "status": "ok",
            "database": "connected",
            "postgresql_version": result,
            "pgvector_installed": pgvector_version is not None,
            "pgvector_version": pgvector_version,
        }
    except Exception as exc:
        raise HTTPException(status_code=503, detail=f"Database unavailable: {str(exc)}")

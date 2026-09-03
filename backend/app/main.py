"""
DreamCatcher — FastAPI Application Entry Point (Phase 1)

Phase 1 scope: database foundation verification only.
Only health-check endpoints are exposed.
"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import settings
from app.api.v1 import health as health_router

# ---------------------------------------------------------------------------
# Application factory
# ---------------------------------------------------------------------------
app = FastAPI(
    title=settings.app_name,
    version=settings.app_version,
    description=(
        "DreamCatcher — Multilingual AI guidance counselor for students in rural India. "
        "Phase 1: Database Foundation API."
    ),
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/openapi.json",
)

# ---------------------------------------------------------------------------
# CORS (permissive for local development; tighten in production)
# ---------------------------------------------------------------------------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"] if settings.app_debug else [],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ---------------------------------------------------------------------------
# Routers
# ---------------------------------------------------------------------------
app.include_router(health_router.router, prefix="", tags=["Health"])


# ---------------------------------------------------------------------------
# Root
# ---------------------------------------------------------------------------
@app.get("/", tags=["Root"])
def root():
    return {
        "project": settings.app_name,
        "version": settings.app_version,
        "phase": 1,
        "docs": "/docs",
    }

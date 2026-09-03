"""
DreamCatcher — FastAPI Application Entry Point (Phase 2: Complete CRUD API)

Provides REST endpoints for:
- Reference catalogues (languages, locations, skills, interests, institutions, organizations)
- Students (profiles, education, skills, interests, aspirations, eligibility discovery)
- Opportunities (scholarships, courses, entrance exams, internships, rules, eligibility evaluation)
- Careers (career paths, pathways, requirements, skill-based matching)
- System health checks
"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import settings
from app.api.v1 import health as health_router
from app.api.v1 import api_v1_router

# ---------------------------------------------------------------------------
# Application factory
# ---------------------------------------------------------------------------
app = FastAPI(
    title=settings.app_name,
    version=settings.app_version,
    description=(
        "DreamCatcher — Multilingual AI guidance counselor for students in rural India. "
        "Phase 2: Complete CRUD API & Deterministic Rule Engine."
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
# Root health checks (for Docker/Cloud Run)
app.include_router(health_router.router, prefix="", tags=["Health"])

# Main API v1
app.include_router(api_v1_router)


# ---------------------------------------------------------------------------
# Root
# ---------------------------------------------------------------------------
@app.get("/", tags=["Root"])
def root():
    return {
        "project": settings.app_name,
        "version": settings.app_version,
        "phase": 2,
        "docs": "/docs",
        "api_v1": "/api/v1",
    }

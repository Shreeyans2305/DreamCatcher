"""
API v1 router aggregate.
"""
from fastapi import APIRouter

from app.api.v1.health import router as health_router
from app.api.v1.reference import router as reference_router
from app.api.v1.students import router as students_router
from app.api.v1.opportunities import router as opportunities_router
from app.api.v1.careers import router as careers_router

api_v1_router = APIRouter(prefix="/api/v1")

# Health
api_v1_router.include_router(health_router, prefix="", tags=["Health"])

# Catalogues & Reference
api_v1_router.include_router(reference_router, prefix="", tags=["Reference Catalogues"])

# Students
api_v1_router.include_router(students_router, prefix="", tags=["Students"])

# Opportunities
api_v1_router.include_router(opportunities_router, prefix="", tags=["Opportunities"])

# Careers
api_v1_router.include_router(careers_router, prefix="", tags=["Careers"])

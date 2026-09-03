"""
DreamCatcher Models — Import all models so Alembic can detect them.

IMPORTANT: Every model module must be imported here so that SQLAlchemy's
metadata knows about all tables when Alembic runs autogenerate or when
Base.metadata.create_all() is called.
"""

# Localization
from app.models.language import Language
from app.models.translation import Translation
from app.models.location import Location

# Organizations & Institutions
from app.models.organization import Organization
from app.models.institution import Institution

# Student domain
from app.models.student import Student
from app.models.education import StudentEducation, StudentSubject
from app.models.skill import Skill, StudentSkill
from app.models.interest import Interest, StudentInterest
from app.models.aspiration import StudentAspiration
from app.models.student_document import StudentDocument

# Opportunity domain
from app.models.opportunity import Opportunity, OpportunityVersion
from app.models.scholarship import Scholarship
from app.models.course import Course, CourseInstitution
from app.models.exam import EntranceExam
from app.models.internship import Internship

# Career domain
from app.models.career import Career, CareerPathway, CareerSkill, CareerCourse, CareerExam

# Eligibility
from app.models.eligibility import EligibilityRule

# Sources & Verification
from app.models.source import Source, VerificationLog

# RAG / Knowledge
from app.models.document import OpportunityDocument, DocumentChunk

# Chat / Conversation
from app.models.conversation import ChatSession, ChatMessage

__all__ = [
    # Localization
    "Language",
    "Translation",
    "Location",
    # Organizations & Institutions
    "Organization",
    "Institution",
    # Student domain
    "Student",
    "StudentEducation",
    "StudentSubject",
    "Skill",
    "StudentSkill",
    "Interest",
    "StudentInterest",
    "StudentAspiration",
    "StudentDocument",
    # Opportunity domain
    "Opportunity",
    "OpportunityVersion",
    "Scholarship",
    "Course",
    "CourseInstitution",
    "EntranceExam",
    "Internship",
    # Career domain
    "Career",
    "CareerPathway",
    "CareerSkill",
    "CareerCourse",
    "CareerExam",
    # Eligibility
    "EligibilityRule",
    # Sources & Verification
    "Source",
    "VerificationLog",
    # RAG / Knowledge
    "OpportunityDocument",
    "DocumentChunk",
    # Chat / Conversation
    "ChatSession",
    "ChatMessage",
]

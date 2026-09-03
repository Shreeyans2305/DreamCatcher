"""Initial schema — complete DreamCatcher Phase 1 database

Revision ID: 0001
Revises:
Create Date: 2026-09-03

This migration:
1. Enables the pgvector extension.
2. Creates all enum types using raw SQL (idempotent).
3. Creates all tables using those enum types (create_type=False to avoid duplicates).
4. Adds an HNSW index on document_chunks.embedding for fast ANN search.
"""
from typing import Sequence, Union
import os
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql
from alembic import op

# revision identifiers
revision: str = "0001"
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None

# Read vector dimension from env (default 1536)
VECTOR_DIM = int(os.environ.get("VECTOR_DIM", "1536"))


def _enum(name: str, *values: str) -> postgresql.ENUM:
    """Return an ENUM type that does NOT auto-create (we create it manually)."""
    return postgresql.ENUM(*values, name=name, create_type=False)


def upgrade() -> None:
    # ── pgvector + pgcrypto extensions ────────────────────────────────────
    op.execute("CREATE EXTENSION IF NOT EXISTS vector")
    op.execute("CREATE EXTENSION IF NOT EXISTS pgcrypto")

    # ── Create all enum types idempotently ───────────────────────────────
    op.execute("""
        DO $$ BEGIN CREATE TYPE rural_urban_enum AS ENUM ('rural', 'urban', 'semi_urban', 'unknown');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE organization_type_enum AS ENUM (
            'government', 'university', 'ngo', 'company', 'foundation',
            'research_institution', 'school', 'other');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE institution_type_enum AS ENUM (
            'university', 'college', 'school', 'polytechnic', 'iit', 'nit',
            'deemed_university', 'open_university', 'vocational', 'research_institute', 'other');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE government_private_enum AS ENUM (
            'government', 'private', 'aided', 'autonomous', 'deemed');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE gender_enum AS ENUM (
            'male', 'female', 'other', 'prefer_not_to_say');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE education_level_enum AS ENUM (
            'primary', 'upper_primary', 'secondary', 'senior_secondary',
            'diploma', 'vocational', 'certificate', 'bachelor', 'master',
            'doctorate', 'informal', 'self_learning', 'other');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE education_status_enum AS ENUM (
            'completed', 'in_progress', 'dropped_out', 'incomplete');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE data_source_enum AS ENUM (
            'student_reported', 'marksheet', 'institution_verified',
            'ai_inferred', 'volunteer_entered', 'other');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE skill_category_enum AS ENUM (
            'technical', 'soft', 'language', 'digital', 'vocational',
            'artistic', 'scientific', 'other');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE proficiency_level_enum AS ENUM (
            'beginner', 'intermediate', 'advanced', 'expert');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE interest_category_enum AS ENUM (
            'science', 'technology', 'engineering', 'mathematics', 'arts',
            'commerce', 'sports', 'social_work', 'environment', 'healthcare',
            'agriculture', 'media', 'law', 'other');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE opportunity_type_enum AS ENUM (
            'scholarship', 'course', 'entrance_exam', 'internship',
            'higher_education', 'other');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE opportunity_status_enum AS ENUM (
            'active', 'inactive', 'draft', 'expired', 'upcoming');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE verification_status_enum AS ENUM (
            'verified', 'unverified', 'pending', 'outdated');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE award_frequency_enum AS ENUM (
            'one_time', 'annual', 'semester', 'monthly', 'other');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE course_mode_enum AS ENUM (
            'full_time', 'part_time', 'online', 'distance', 'hybrid');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE admission_method_enum AS ENUM (
            'merit', 'entrance_exam', 'interview', 'direct', 'lateral_entry', 'other');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE exam_mode_enum AS ENUM ('online', 'offline', 'hybrid');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE exam_frequency_enum AS ENUM (
            'annual', 'biannual', 'quarterly', 'as_needed');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE career_level_enum AS ENUM ('entry', 'mid', 'senior', 'executive');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE demand_level_enum AS ENUM (
            'very_high', 'high', 'medium', 'low', 'declining');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE importance_level_enum AS ENUM ('required', 'preferred', 'helpful');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE rule_type_enum AS ENUM (
            'AGE', 'INCOME', 'GENDER', 'SOCIAL_CATEGORY', 'STATE', 'DISTRICT',
            'EDUCATION_LEVEL', 'BOARD', 'PERCENTAGE', 'SUBJECT', 'SKILL',
            'RURAL_STATUS', 'INSTITUTION_TYPE', 'NATIONALITY', 'DISABILITY', 'OTHER');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE rule_operator_enum AS ENUM (
            'EQ', 'NEQ', 'LT', 'LTE', 'GT', 'GTE', 'IN', 'NOT_IN', 'EXISTS');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE group_operator_enum AS ENUM ('AND', 'OR');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE source_type_enum AS ENUM (
            'OFFICIAL', 'GOVERNMENT', 'UNIVERSITY', 'PARTNER', 'SECONDARY', 'USER_SUBMITTED');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE document_type_enum AS ENUM (
            'scholarship_guidelines', 'government_pdf', 'admission_brochure',
            'exam_brochure', 'course_description', 'internship_description', 'faq', 'other');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)
    op.execute("""
        DO $$ BEGIN CREATE TYPE student_document_type_enum AS ENUM (
            'marksheet', 'certificate', 'income_certificate', 'caste_certificate',
            'skill_certificate', 'identity_proof', 'photo', 'other');
        EXCEPTION WHEN duplicate_object THEN null; END $$;
    """)

    # ── Tables — dependency order ─────────────────────────────────────────

    # languages
    op.create_table(
        "languages",
        sa.Column("code", sa.String(10), primary_key=True),
        sa.Column("name", sa.String(100), nullable=False),
        sa.Column("native_name", sa.String(100), nullable=True),
        sa.Column("is_active", sa.Boolean, nullable=False, server_default="true"),
        sa.Column("script", sa.String(50), nullable=True),
    )

    # locations
    op.create_table(
        "locations",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("country", sa.String(100), nullable=False, server_default="India"),
        sa.Column("state", sa.String(100), nullable=True),
        sa.Column("district", sa.String(100), nullable=True),
        sa.Column("taluka", sa.String(100), nullable=True),
        sa.Column("village", sa.String(200), nullable=True),
        sa.Column("pincode", sa.String(10), nullable=True),
        sa.Column("rural_urban", _enum("rural_urban_enum", "rural", "urban", "semi_urban", "unknown"), nullable=False, server_default="unknown"),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
    )

    # organizations
    op.create_table(
        "organizations",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("name", sa.String(300), nullable=False),
        sa.Column("type", _enum("organization_type_enum", "government", "university", "ngo", "company", "foundation", "research_institution", "school", "other"), nullable=False),
        sa.Column("description", sa.Text, nullable=True),
        sa.Column("website", sa.String(500), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
    )

    # translations
    op.create_table(
        "translations",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("entity_type", sa.String(100), nullable=False),
        sa.Column("entity_id", postgresql.UUID(as_uuid=True), nullable=False),
        sa.Column("field", sa.String(100), nullable=False),
        sa.Column("language_code", sa.String(10), sa.ForeignKey("languages.code", ondelete="CASCADE"), nullable=False),
        sa.Column("translated_text", sa.Text, nullable=False),
        sa.UniqueConstraint("entity_type", "entity_id", "field", "language_code", name="uq_translation"),
    )

    # institutions
    op.create_table(
        "institutions",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("organization_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("organizations.id", ondelete="SET NULL"), nullable=True),
        sa.Column("name", sa.String(300), nullable=False),
        sa.Column("institution_type", _enum("institution_type_enum", "university", "college", "school", "polytechnic", "iit", "nit", "deemed_university", "open_university", "vocational", "research_institute", "other"), nullable=False),
        sa.Column("location_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("locations.id", ondelete="SET NULL"), nullable=True),
        sa.Column("website", sa.String(500), nullable=True),
        sa.Column("government_private", _enum("government_private_enum", "government", "private", "aided", "autonomous", "deemed"), nullable=True),
        sa.Column("description", sa.Text, nullable=True),
        sa.Column("accreditation", sa.String(200), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
    )

    # students
    op.create_table(
        "students",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("name", sa.String(200), nullable=False),
        sa.Column("date_of_birth", sa.Date, nullable=True),
        sa.Column("gender", _enum("gender_enum", "male", "female", "other", "prefer_not_to_say"), nullable=True),
        sa.Column("phone", sa.String(20), nullable=True),
        sa.Column("email", sa.String(254), nullable=True),
        sa.Column("preferred_language", sa.String(10), sa.ForeignKey("languages.code"), nullable=False, server_default="en"),
        sa.Column("location_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("locations.id", ondelete="SET NULL"), nullable=True),
        sa.Column("profile_completeness", sa.Float, nullable=False, server_default="0.0"),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
    )

    # careers
    op.create_table(
        "careers",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("name", sa.String(200), nullable=False, unique=True),
        sa.Column("description", sa.Text, nullable=True),
        sa.Column("industry", sa.String(200), nullable=True),
        sa.Column("career_level", _enum("career_level_enum", "entry", "mid", "senior", "executive"), nullable=False, server_default="entry"),
        sa.Column("demand_level", _enum("demand_level_enum", "very_high", "high", "medium", "low", "declining"), nullable=False, server_default="medium"),
    )

    # skills
    op.create_table(
        "skills",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("canonical_name", sa.String(200), nullable=False, unique=True),
        sa.Column("category", _enum("skill_category_enum", "technical", "soft", "language", "digital", "vocational", "artistic", "scientific", "other"), nullable=False, server_default="other"),
        sa.Column("description", sa.Text, nullable=True),
    )

    # interests
    op.create_table(
        "interests",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("name", sa.String(200), nullable=False, unique=True),
        sa.Column("category", _enum("interest_category_enum", "science", "technology", "engineering", "mathematics", "arts", "commerce", "sports", "social_work", "environment", "healthcare", "agriculture", "media", "law", "other"), nullable=False, server_default="other"),
        sa.Column("description", sa.Text, nullable=True),
    )

    # opportunities
    op.create_table(
        "opportunities",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("type", _enum("opportunity_type_enum", "scholarship", "course", "entrance_exam", "internship", "higher_education", "other"), nullable=False),
        sa.Column("title", sa.String(500), nullable=False),
        sa.Column("organization_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("organizations.id", ondelete="SET NULL"), nullable=True),
        sa.Column("description", sa.Text, nullable=True),
        sa.Column("status", _enum("opportunity_status_enum", "active", "inactive", "draft", "expired", "upcoming"), nullable=False, server_default="active"),
        sa.Column("official_url", sa.String(1000), nullable=True),
        sa.Column("application_url", sa.String(1000), nullable=True),
        sa.Column("application_start", sa.Date, nullable=True),
        sa.Column("application_deadline", sa.Date, nullable=True),
        sa.Column("location_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("locations.id", ondelete="SET NULL"), nullable=True),
        sa.Column("last_verified", sa.DateTime(timezone=True), nullable=True),
        sa.Column("verification_status", _enum("verification_status_enum", "verified", "unverified", "pending", "outdated"), nullable=False, server_default="unverified"),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
    )
    op.create_index("ix_opportunities_type", "opportunities", ["type"])
    op.create_index("ix_opportunities_status", "opportunities", ["status"])
    op.create_index("ix_opportunities_deadline", "opportunities", ["application_deadline"])

    # scholarships
    op.create_table(
        "scholarships",
        sa.Column("opportunity_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("opportunities.id", ondelete="CASCADE"), primary_key=True),
        sa.Column("amount", sa.Numeric(12, 2), nullable=True),
        sa.Column("currency", sa.String(3), nullable=False, server_default="INR"),
        sa.Column("award_frequency", _enum("award_frequency_enum", "one_time", "annual", "semester", "monthly", "other"), nullable=False, server_default="annual"),
        sa.Column("renewable", sa.Boolean, nullable=False, server_default="false"),
        sa.Column("number_of_awards", sa.Integer, nullable=True),
        sa.Column("application_process", sa.Text, nullable=True),
        sa.Column("required_documents", sa.Text, nullable=True),
    )

    # courses
    op.create_table(
        "courses",
        sa.Column("opportunity_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("opportunities.id", ondelete="CASCADE"), primary_key=True),
        sa.Column("education_level", _enum("education_level_enum", "primary", "upper_primary", "secondary", "senior_secondary", "diploma", "vocational", "certificate", "bachelor", "master", "doctorate", "informal", "self_learning", "other"), nullable=True),
        sa.Column("field", sa.String(200), nullable=True),
        sa.Column("duration", sa.String(100), nullable=True),
        sa.Column("mode", _enum("course_mode_enum", "full_time", "part_time", "online", "distance", "hybrid"), nullable=False, server_default="full_time"),
        sa.Column("description", sa.Text, nullable=True),
    )

    # entrance_exams
    op.create_table(
        "entrance_exams",
        sa.Column("opportunity_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("opportunities.id", ondelete="CASCADE"), primary_key=True),
        sa.Column("conducting_body", sa.String(300), nullable=True),
        sa.Column("exam_mode", _enum("exam_mode_enum", "online", "offline", "hybrid"), nullable=False, server_default="offline"),
        sa.Column("exam_frequency", _enum("exam_frequency_enum", "annual", "biannual", "quarterly", "as_needed"), nullable=False, server_default="annual"),
        sa.Column("registration_start", sa.Date, nullable=True),
        sa.Column("registration_deadline", sa.Date, nullable=True),
        sa.Column("examination_date", sa.Date, nullable=True),
        sa.Column("application_fee", sa.Numeric(10, 2), nullable=True),
        sa.Column("official_exam_url", sa.String(1000), nullable=True),
    )

    # internships
    op.create_table(
        "internships",
        sa.Column("opportunity_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("opportunities.id", ondelete="CASCADE"), primary_key=True),
        sa.Column("organization_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("organizations.id", ondelete="SET NULL"), nullable=True),
        sa.Column("location_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("locations.id", ondelete="SET NULL"), nullable=True),
        sa.Column("remote", sa.Boolean, nullable=False, server_default="false"),
        sa.Column("duration", sa.String(100), nullable=True),
        sa.Column("stipend", sa.Numeric(10, 2), nullable=True),
        sa.Column("start_date", sa.Date, nullable=True),
        sa.Column("end_date", sa.Date, nullable=True),
        sa.Column("application_deadline", sa.Date, nullable=True),
        sa.Column("work_description", sa.Text, nullable=True),
    )

    # career_pathways
    op.create_table(
        "career_pathways",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("career_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("careers.id", ondelete="CASCADE"), nullable=False),
        sa.Column("pathway_name", sa.String(200), nullable=False),
        sa.Column("description", sa.Text, nullable=True),
        sa.Column("steps", postgresql.JSONB, nullable=False, server_default="[]"),
        sa.Column("is_alternative", sa.Boolean, nullable=False, server_default="false"),
    )
    op.create_index("ix_career_pathways_career_id", "career_pathways", ["career_id"])

    # career_skills
    op.create_table(
        "career_skills",
        sa.Column("career_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("careers.id", ondelete="CASCADE"), primary_key=True),
        sa.Column("skill_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("skills.id", ondelete="CASCADE"), primary_key=True),
        sa.Column("importance", _enum("importance_level_enum", "required", "preferred", "helpful"), nullable=False, server_default="preferred"),
    )

    # career_courses
    op.create_table(
        "career_courses",
        sa.Column("career_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("careers.id", ondelete="CASCADE"), primary_key=True),
        sa.Column("course_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("courses.opportunity_id", ondelete="CASCADE"), primary_key=True),
        sa.Column("importance", _enum("importance_level_enum", "required", "preferred", "helpful"), nullable=False, server_default="preferred"),
    )

    # career_exams
    op.create_table(
        "career_exams",
        sa.Column("career_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("careers.id", ondelete="CASCADE"), primary_key=True),
        sa.Column("exam_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("entrance_exams.opportunity_id", ondelete="CASCADE"), primary_key=True),
        sa.Column("importance", _enum("importance_level_enum", "required", "preferred", "helpful"), nullable=False, server_default="preferred"),
    )

    # student_education
    op.create_table(
        "student_education",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("student_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("students.id", ondelete="CASCADE"), nullable=False),
        sa.Column("institution_name", sa.String(300), nullable=True),
        sa.Column("education_level", _enum("education_level_enum", "primary", "upper_primary", "secondary", "senior_secondary", "diploma", "vocational", "certificate", "bachelor", "master", "doctorate", "informal", "self_learning", "other"), nullable=False),
        sa.Column("curriculum", sa.String(100), nullable=True),
        sa.Column("board", sa.String(150), nullable=True),
        sa.Column("field_of_study", sa.String(200), nullable=True),
        sa.Column("start_date", sa.Date, nullable=True),
        sa.Column("end_date", sa.Date, nullable=True),
        sa.Column("status", _enum("education_status_enum", "completed", "in_progress", "dropped_out", "incomplete"), nullable=False, server_default="completed"),
        sa.Column("description", sa.Text, nullable=True),
        sa.Column("source", _enum("data_source_enum", "student_reported", "marksheet", "institution_verified", "ai_inferred", "volunteer_entered", "other"), nullable=False, server_default="student_reported"),
        sa.Column("confidence", sa.Float, nullable=False, server_default="1.0"),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
    )
    op.create_index("ix_student_education_student_id", "student_education", ["student_id"])

    # student_subjects
    op.create_table(
        "student_subjects",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("student_education_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("student_education.id", ondelete="CASCADE"), nullable=False),
        sa.Column("subject", sa.String(200), nullable=False),
        sa.Column("marks", sa.Float, nullable=True),
        sa.Column("maximum_marks", sa.Float, nullable=True),
        sa.Column("percentage", sa.Float, nullable=True),
        sa.Column("grade", sa.String(10), nullable=True),
        sa.Column("source", _enum("data_source_enum", "student_reported", "marksheet", "institution_verified", "ai_inferred", "volunteer_entered", "other"), nullable=False, server_default="student_reported"),
        sa.Column("confidence", sa.Float, nullable=False, server_default="1.0"),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
    )
    op.create_index("ix_student_subjects_education_id", "student_subjects", ["student_education_id"])

    # student_skills
    op.create_table(
        "student_skills",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("student_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("students.id", ondelete="CASCADE"), nullable=False),
        sa.Column("skill_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("skills.id", ondelete="CASCADE"), nullable=False),
        sa.Column("proficiency", _enum("proficiency_level_enum", "beginner", "intermediate", "advanced", "expert"), nullable=True),
        sa.Column("years_experience", sa.Float, nullable=True),
        sa.Column("source", _enum("data_source_enum", "student_reported", "marksheet", "institution_verified", "ai_inferred", "volunteer_entered", "other"), nullable=False, server_default="student_reported"),
        sa.Column("confidence", sa.Float, nullable=False, server_default="1.0"),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
    )
    op.create_index("ix_student_skills_student_id", "student_skills", ["student_id"])

    # student_interests
    op.create_table(
        "student_interests",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("student_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("students.id", ondelete="CASCADE"), nullable=False),
        sa.Column("interest_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("interests.id", ondelete="CASCADE"), nullable=False),
        sa.Column("strength", sa.Float, nullable=False, server_default="0.5"),
        sa.Column("source", _enum("data_source_enum", "student_reported", "marksheet", "institution_verified", "ai_inferred", "volunteer_entered", "other"), nullable=False, server_default="student_reported"),
        sa.Column("confidence", sa.Float, nullable=False, server_default="1.0"),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
    )
    op.create_index("ix_student_interests_student_id", "student_interests", ["student_id"])

    # student_aspirations
    op.create_table(
        "student_aspirations",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("student_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("students.id", ondelete="CASCADE"), nullable=False),
        sa.Column("aspiration_text", sa.Text, nullable=False),
        sa.Column("target_career_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("careers.id", ondelete="SET NULL"), nullable=True),
        sa.Column("priority", sa.Integer, nullable=False, server_default="1"),
        sa.Column("source", _enum("data_source_enum", "student_reported", "marksheet", "institution_verified", "ai_inferred", "volunteer_entered", "other"), nullable=False, server_default="student_reported"),
        sa.Column("confidence", sa.Float, nullable=False, server_default="1.0"),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
    )
    op.create_index("ix_student_aspirations_student_id", "student_aspirations", ["student_id"])

    # student_documents
    op.create_table(
        "student_documents",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("student_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("students.id", ondelete="CASCADE"), nullable=False),
        sa.Column("document_type", _enum("student_document_type_enum", "marksheet", "certificate", "income_certificate", "caste_certificate", "skill_certificate", "identity_proof", "photo", "other"), nullable=False, server_default="other"),
        sa.Column("storage_url", sa.String(1000), nullable=True),
        sa.Column("filename", sa.String(500), nullable=True),
        sa.Column("mime_type", sa.String(100), nullable=True),
        sa.Column("uploaded_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
        sa.Column("verified", sa.Boolean, nullable=False, server_default="false"),
        sa.Column("extracted_text", sa.Text, nullable=True),
        sa.Column("extraction_confidence", sa.Float, nullable=True),
    )
    op.create_index("ix_student_documents_student_id", "student_documents", ["student_id"])

    # eligibility_rules
    op.create_table(
        "eligibility_rules",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("opportunity_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("opportunities.id", ondelete="CASCADE"), nullable=False),
        sa.Column("rule_type", _enum("rule_type_enum", "AGE", "INCOME", "GENDER", "SOCIAL_CATEGORY", "STATE", "DISTRICT", "EDUCATION_LEVEL", "BOARD", "PERCENTAGE", "SUBJECT", "SKILL", "RURAL_STATUS", "INSTITUTION_TYPE", "NATIONALITY", "DISABILITY", "OTHER"), nullable=False),
        sa.Column("operator", _enum("rule_operator_enum", "EQ", "NEQ", "LT", "LTE", "GT", "GTE", "IN", "NOT_IN", "EXISTS"), nullable=False),
        sa.Column("value", sa.String(500), nullable=False),
        sa.Column("unit", sa.String(50), nullable=True),
        sa.Column("required", sa.Boolean, nullable=False, server_default="true"),
        sa.Column("description", sa.Text, nullable=True),
        sa.Column("rule_group_id", sa.String(100), nullable=True),
        sa.Column("group_operator", _enum("group_operator_enum", "AND", "OR"), nullable=False, server_default="AND"),
        sa.Column("sort_order", sa.Integer, nullable=False, server_default="0"),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
        sa.Column("updated_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
    )
    op.create_index("ix_eligibility_rules_opportunity_id", "eligibility_rules", ["opportunity_id"])
    op.create_index("ix_eligibility_rules_rule_type", "eligibility_rules", ["rule_type"])

    # sources
    op.create_table(
        "sources",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("organization_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("organizations.id", ondelete="SET NULL"), nullable=True),
        sa.Column("url", sa.String(1000), nullable=True),
        sa.Column("source_type", _enum("source_type_enum", "OFFICIAL", "GOVERNMENT", "UNIVERSITY", "PARTNER", "SECONDARY", "USER_SUBMITTED"), nullable=False, server_default="SECONDARY"),
        sa.Column("title", sa.String(500), nullable=True),
        sa.Column("retrieved_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("last_checked", sa.DateTime(timezone=True), nullable=True),
        sa.Column("reliability", sa.Float, nullable=False, server_default="0.5"),
        sa.Column("notes", sa.Text, nullable=True),
    )

    # verification_logs
    op.create_table(
        "verification_logs",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("opportunity_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("opportunities.id", ondelete="CASCADE"), nullable=False),
        sa.Column("source_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("sources.id", ondelete="SET NULL"), nullable=True),
        sa.Column("verification_status", _enum("verification_status_enum", "verified", "unverified", "pending", "outdated"), nullable=False),
        sa.Column("verified_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
        sa.Column("verified_by", sa.String(200), nullable=True),
        sa.Column("notes", sa.Text, nullable=True),
    )
    op.create_index("ix_verification_logs_opportunity_id", "verification_logs", ["opportunity_id"])

    # opportunity_versions
    op.create_table(
        "opportunity_versions",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("opportunity_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("opportunities.id", ondelete="CASCADE"), nullable=False),
        sa.Column("version", sa.Integer, nullable=False, server_default="1"),
        sa.Column("valid_from", sa.DateTime(timezone=True), nullable=False),
        sa.Column("valid_until", sa.DateTime(timezone=True), nullable=True),
        sa.Column("data", postgresql.JSONB, nullable=False, server_default="{}"),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
    )
    op.create_index("ix_opportunity_versions_opportunity_id", "opportunity_versions", ["opportunity_id"])

    # course_institutions
    op.create_table(
        "course_institutions",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("course_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("courses.opportunity_id", ondelete="CASCADE"), nullable=False),
        sa.Column("institution_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("institutions.id", ondelete="CASCADE"), nullable=False),
        sa.Column("tuition_fee", sa.Numeric(12, 2), nullable=True),
        sa.Column("duration", sa.String(100), nullable=True),
        sa.Column("admission_method", _enum("admission_method_enum", "merit", "entrance_exam", "interview", "direct", "lateral_entry", "other"), nullable=False, server_default="merit"),
    )
    op.create_index("ix_course_institutions_course_id", "course_institutions", ["course_id"])
    op.create_index("ix_course_institutions_institution_id", "course_institutions", ["institution_id"])

    # opportunity_documents
    op.create_table(
        "opportunity_documents",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("opportunity_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("opportunities.id", ondelete="CASCADE"), nullable=False),
        sa.Column("source_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("sources.id", ondelete="SET NULL"), nullable=True),
        sa.Column("document_type", _enum("document_type_enum", "scholarship_guidelines", "government_pdf", "admission_brochure", "exam_brochure", "course_description", "internship_description", "faq", "other"), nullable=False, server_default="other"),
        sa.Column("title", sa.String(500), nullable=True),
        sa.Column("content", sa.Text, nullable=True),
        sa.Column("source_url", sa.String(1000), nullable=True),
        sa.Column("language", sa.String(10), sa.ForeignKey("languages.code"), nullable=False, server_default="en"),
        sa.Column("last_updated", sa.DateTime(timezone=True), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
    )
    op.create_index("ix_opportunity_documents_opportunity_id", "opportunity_documents", ["opportunity_id"])

    # document_chunks — vector column added via raw SQL after table creation
    op.create_table(
        "document_chunks",
        sa.Column("id", postgresql.UUID(as_uuid=True), primary_key=True, server_default=sa.text("gen_random_uuid()")),
        sa.Column("document_id", postgresql.UUID(as_uuid=True), sa.ForeignKey("opportunity_documents.id", ondelete="CASCADE"), nullable=False),
        sa.Column("chunk_index", sa.Integer, nullable=False),
        sa.Column("chunk_text", sa.Text, nullable=False),
        sa.Column("metadata", postgresql.JSONB, nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("now()")),
    )
    op.create_index("ix_document_chunks_document_id", "document_chunks", ["document_id"])

    # Add pgvector embedding column
    op.execute(f"ALTER TABLE document_chunks ADD COLUMN embedding vector({VECTOR_DIM})")

    # HNSW index for approximate nearest-neighbour cosine search
    op.execute("""
        CREATE INDEX ix_document_chunks_embedding_hnsw
        ON document_chunks
        USING hnsw (embedding vector_cosine_ops)
        WITH (m = 16, ef_construction = 64)
    """)


def downgrade() -> None:
    op.drop_table("document_chunks")
    op.drop_table("opportunity_documents")
    op.drop_table("course_institutions")
    op.drop_table("opportunity_versions")
    op.drop_table("verification_logs")
    op.drop_table("sources")
    op.drop_table("eligibility_rules")
    op.drop_table("student_documents")
    op.drop_table("student_aspirations")
    op.drop_table("student_interests")
    op.drop_table("student_skills")
    op.drop_table("student_subjects")
    op.drop_table("student_education")
    op.drop_table("career_exams")
    op.drop_table("career_courses")
    op.drop_table("career_skills")
    op.drop_table("career_pathways")
    op.drop_table("internships")
    op.drop_table("entrance_exams")
    op.drop_table("courses")
    op.drop_table("scholarships")
    op.drop_table("opportunities")
    op.drop_table("interests")
    op.drop_table("skills")
    op.drop_table("careers")
    op.drop_table("students")
    op.drop_table("institutions")
    op.drop_table("translations")
    op.drop_table("organizations")
    op.drop_table("locations")
    op.drop_table("languages")

    for enum_name in [
        "rural_urban_enum", "organization_type_enum", "institution_type_enum",
        "government_private_enum", "gender_enum", "education_level_enum",
        "education_status_enum", "data_source_enum", "skill_category_enum",
        "proficiency_level_enum", "interest_category_enum", "opportunity_type_enum",
        "opportunity_status_enum", "verification_status_enum", "award_frequency_enum",
        "course_mode_enum", "admission_method_enum", "exam_mode_enum",
        "exam_frequency_enum", "career_level_enum", "demand_level_enum",
        "importance_level_enum", "rule_type_enum", "rule_operator_enum",
        "group_operator_enum", "source_type_enum", "document_type_enum",
        "student_document_type_enum",
    ]:
        op.execute(f"DROP TYPE IF EXISTS {enum_name}")

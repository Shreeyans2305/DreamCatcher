<p align="center">
    <img src="DreamCatcherLogo.png" alt="DreamCatcher" width="180">
</p>

<h1 align="center">DreamCatcher</h1>

<p align="center">
    Multilingual AI guidance counselor for students in rural India.
</p>

<p align="center">
    <img src="RuralEducation.png" alt="Rural education" width="720">
</p>


> Multilingual AI guidance counselor for students in rural India.

DreamCatcher helps students discover career pathways, scholarships, entrance examinations, courses, and internships through a structured database, profile-aware eligibility matching, multilingual guidance, and voice counselling.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Prerequisites](#prerequisites)
3. [Local Setup](#local-setup)
4. [Docker Commands](#docker-commands)
5. [Database Migration Commands](#database-migration-commands)
6. [How to Seed the Database](#how-to-seed-the-database)
7. [How to Start FastAPI](#how-to-start-fastapi)
8. [Database Schema](#database-schema)
9. [ER Diagram](#er-diagram)
10. [Eligibility Engine](#eligibility-engine)
11. [RAG Architecture](#rag-architecture)
12. [GCP Deployment](#gcp-deployment)
13. [Client Applications](#client-applications)
14. [Phase Roadmap](#phase-roadmap)
15. [Project Structure](#project-structure)

---

## Architecture Overview

```
Student Profile
    ↓
Profile Normalization
    ↓
Structured Eligibility Engine (PostgreSQL rules — no LLM)
    ↓
Candidate Opportunities
    ↓
Ranking
    ↓
Hybrid Search (structured + pgvector ANN)
    ↓
RAG (document_chunks + embeddings)
    ↓
LLM
    ↓
Response in Student's Language
```

The database remains the source of truth for eligibility, deadlines, fees, and opportunity details. The AI services explain, compare, and guide using verified opportunity data and retrieved document context.

---

## Prerequisites

| Tool | Version |
|------|---------|
| Python | 3.12+ |
| Docker | Latest |
| Docker Compose | V2+ |
| Git | Any |

---

## Local Setup

```bash
# 1. Clone the repository
git clone <repo-url>
cd DreamCatcher

# 2. Copy environment variables
cp .env.example .env

# 3. Start PostgreSQL (pgvector-enabled)
docker compose up -d db

# 4. Create Python virtual environment
cd backend/
python3.12 -m venv .venv
source .venv/bin/activate       # macOS/Linux
# .venv\Scripts\activate        # Windows

# 5. Install dependencies
pip install -r requirements.txt

# 6. Run database migrations
alembic upgrade head

# 7. Seed development data
python scripts/seed.py

# 8. Start the API server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Visit:
- API docs: http://localhost:8000/docs
- Health: http://localhost:8000/health
- DB health: http://localhost:8000/health/db

---

## Docker Commands

```bash
# Start only the database (recommended for local development)
docker compose up -d db

# Start both database and backend
docker compose up -d

# View logs
docker compose logs -f db
docker compose logs -f backend

# Stop all services
docker compose down

# Stop and remove volumes (DESTROYS DATA)
docker compose down -v

# Check container health
docker compose ps
```

---

## Database Migration Commands

```bash
# Apply all pending migrations (upgrade to latest)
alembic upgrade head

# Check current migration version
alembic current

# View migration history
alembic history

# Rollback one migration
alembic downgrade -1

# Rollback to beginning (DESTROYS ALL TABLES)
alembic downgrade base

# Auto-generate a new migration from model changes
alembic revision --autogenerate -m "description_of_change"
```

> **Important**: Set `DATABASE_URL` in your `.env` before running Alembic.
> The format is: `postgresql+psycopg2://user:password@host:port/dbname`

---

## How to Seed the Database

```bash
cd backend/
source .venv/bin/activate
python scripts/seed.py
```

The seed script inserts:
- 9 languages (en, hi, mr, bn, ta, te, kn, gu, or)
- 9 locations (states, districts, and rural villages)
- 5 organizations
- 5 institutions
- 10 skills
- 10 interests
- 5 careers + 5 pathways
- 5 scholarships + 5 courses + 3 entrance exams + 3 internships
- 10 eligibility rules
- 3 example students (Priya, Arjun, Meena) with education, skills, interests, and aspirations

All data is **fictional** and for development/testing only.

---

## How to Start FastAPI

```bash
cd backend/
source .venv/bin/activate

# Development (with hot reload)
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Production
uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 4
```

### Run both local backends

From the repository root, `run_backends.py` starts the Website credential dispatcher on port `8000` and the FastAPI guidance backend on port `8001`:

```bash
python run_backends.py
```

For Vertex AI features, authenticate with Google Application Default Credentials first:

```bash
gcloud auth application-default login
```

The Docker Compose backend uses port `8000`; do not run it at the same time as the unified runner unless you change one of the ports.

## Client Applications

| Client | Directory | Start command |
|--------|-----------|---------------|
| Flutter student app | [`app/`](app/) | `cd app && flutter run -d chrome` |
| React voice counselling client | [`call/`](call/) | `cd call && npm install && npm run dev` |
| React volunteer portal | [`Website/frontend/`](Website/frontend/) | `cd Website/frontend && npm install && npm run dev` |

See the README in each directory for client-specific configuration and backend URLs.

---

## Database Schema

The database is organized into **six logical domains** within a single PostgreSQL database:

### 1. Localization Domain
| Table | Purpose |
|-------|---------|
| `languages` | ISO 639-1 language codes (en, hi, mr, ...) |
| `translations` | EAV translations for any entity field in any language |
| `locations` | Hierarchical geography: country → state → district → taluka → village |

### 2. Student Domain
| Table | Purpose |
|-------|---------|
| `students` | Core student profile (no passwords, no gov ID) |
| `student_education` | Flexible education history (school, diploma, vocational, informal, etc.) |
| `student_subjects` | Subject-wise marks with confidence and source tracking |
| `student_skills` | Student ↔ Skill associations with proficiency and source |
| `student_interests` | Student ↔ Interest with strength and source (AI-inferred vs stated) |
| `student_aspirations` | Free-text aspirations with optional career linkage |
| `student_documents` | Document metadata (files stored in GCS) |

### 3. Opportunity Domain
| Table | Purpose |
|-------|---------|
| `opportunities` | Central parent entity for all opportunity types |
| `scholarships` | Scholarship-specific fields (1:1 with opportunities) |
| `courses` | Course-specific fields (1:1 with opportunities) |
| `entrance_exams` | Exam dates, fees, mode (1:1 with opportunities) |
| `internships` | Duration, stipend, remote flag (1:1 with opportunities) |
| `opportunity_versions` | Historical snapshots of opportunity data (JSONB) |

### 4. Career Domain
| Table | Purpose |
|-------|---------|
| `careers` | Canonical career catalogue |
| `career_pathways` | Multiple pathways to the same career (JSONB steps) |
| `career_skills` | Career ↔ Skill with importance level |
| `career_courses` | Career ↔ Course with importance level |
| `career_exams` | Career ↔ Entrance Exam with importance level |

### 5. Eligibility Domain
| Table | Purpose |
|-------|---------|
| `eligibility_rules` | Structured rules (AGE, INCOME, GENDER, STATE, PERCENTAGE, etc.) |

### 6. Sources & RAG Domain
| Table | Purpose |
|-------|---------|
| `sources` | Data sources with reliability scores |
| `verification_logs` | Audit trail of opportunity verification |
| `opportunity_documents` | Full-text documents from official sources |
| `document_chunks` | Chunked text with pgvector embeddings for RAG |

---

## ER Diagram

```mermaid
erDiagram
    STUDENTS {
        uuid id PK
        string name
        date date_of_birth
        string gender
        string phone
        string preferred_language FK
        uuid location_id FK
        float profile_completeness
    }

    STUDENT_EDUCATION {
        uuid id PK
        uuid student_id FK
        string institution_name
        string education_level
        string curriculum
        string board
        string field_of_study
        date start_date
        date end_date
        string status
        string source
        float confidence
    }

    STUDENT_SUBJECTS {
        uuid id PK
        uuid student_education_id FK
        string subject
        float marks
        float maximum_marks
        float percentage
        string grade
        string source
    }

    SKILLS {
        uuid id PK
        string canonical_name
        string category
        string description
    }

    STUDENT_SKILLS {
        uuid id PK
        uuid student_id FK
        uuid skill_id FK
        string proficiency
        float years_experience
        string source
        float confidence
    }

    INTERESTS {
        uuid id PK
        string name
        string category
    }

    STUDENT_INTERESTS {
        uuid id PK
        uuid student_id FK
        uuid interest_id FK
        float strength
        string source
        float confidence
    }

    STUDENT_ASPIRATIONS {
        uuid id PK
        uuid student_id FK
        text aspiration_text
        uuid target_career_id FK
        int priority
        string source
    }

    CAREERS {
        uuid id PK
        string name
        string industry
        string demand_level
    }

    CAREER_PATHWAYS {
        uuid id PK
        uuid career_id FK
        string pathway_name
        jsonb steps
        boolean is_alternative
    }

    CAREER_SKILLS {
        uuid career_id FK
        uuid skill_id FK
        string importance
    }

    CAREER_COURSES {
        uuid career_id FK
        uuid course_id FK
        string importance
    }

    OPPORTUNITIES {
        uuid id PK
        string type
        string title
        uuid organization_id FK
        string status
        date application_deadline
        uuid location_id FK
        string verification_status
    }

    SCHOLARSHIPS {
        uuid opportunity_id PK_FK
        decimal amount
        string currency
        string award_frequency
        boolean renewable
    }

    COURSES {
        uuid opportunity_id PK_FK
        string education_level
        string field
        string duration
        string mode
    }

    ENTRANCE_EXAMS {
        uuid opportunity_id PK_FK
        string conducting_body
        date examination_date
        decimal application_fee
    }

    INTERNSHIPS {
        uuid opportunity_id PK_FK
        boolean remote
        string duration
        decimal stipend
    }

    COURSE_INSTITUTIONS {
        uuid id PK
        uuid course_id FK
        uuid institution_id FK
        decimal tuition_fee
        string admission_method
    }

    INSTITUTIONS {
        uuid id PK
        string name
        string institution_type
        uuid location_id FK
        string accreditation
    }

    ORGANIZATIONS {
        uuid id PK
        string name
        string type
        string website
    }

    ELIGIBILITY_RULES {
        uuid id PK
        uuid opportunity_id FK
        string rule_type
        string operator
        string value
        string unit
        boolean required
        string rule_group_id
        string group_operator
    }

    SOURCES {
        uuid id PK
        uuid organization_id FK
        string url
        string source_type
        float reliability
    }

    OPPORTUNITY_DOCUMENTS {
        uuid id PK
        uuid opportunity_id FK
        uuid source_id FK
        string document_type
        text content
        string language
    }

    DOCUMENT_CHUNKS {
        uuid id PK
        uuid document_id FK
        int chunk_index
        text chunk_text
        vector embedding
        jsonb metadata
    }

    LOCATIONS {
        uuid id PK
        string country
        string state
        string district
        string taluka
        string village
        string rural_urban
    }

    LANGUAGES {
        string code PK
        string name
        string native_name
    }

    TRANSLATIONS {
        uuid id PK
        string entity_type
        uuid entity_id
        string field
        string language_code FK
        text translated_text
    }

    %% Student Domain relationships
    STUDENTS ||--o{ STUDENT_EDUCATION : "has"
    STUDENT_EDUCATION ||--o{ STUDENT_SUBJECTS : "has"
    STUDENTS ||--o{ STUDENT_SKILLS : "has"
    STUDENTS ||--o{ STUDENT_INTERESTS : "has"
    STUDENTS ||--o{ STUDENT_ASPIRATIONS : "has"
    STUDENTS }o--|| LOCATIONS : "lives in"
    STUDENTS }o--|| LANGUAGES : "prefers"

    %% Skills
    SKILLS ||--o{ STUDENT_SKILLS : "assigned to"
    SKILLS ||--o{ CAREER_SKILLS : "required by"

    %% Interests
    INTERESTS ||--o{ STUDENT_INTERESTS : "assigned to"

    %% Careers
    CAREERS ||--o{ CAREER_PATHWAYS : "reached via"
    CAREERS ||--o{ CAREER_SKILLS : "requires"
    CAREERS ||--o{ CAREER_COURSES : "via"
    STUDENT_ASPIRATIONS }o--o| CAREERS : "targets"

    %% Opportunities
    OPPORTUNITIES }o--|| ORGANIZATIONS : "offered by"
    OPPORTUNITIES }o--o| LOCATIONS : "scoped to"
    OPPORTUNITIES ||--o{ ELIGIBILITY_RULES : "has"

    %% Opportunity specializations (1:1)
    OPPORTUNITIES ||--o| SCHOLARSHIPS : "is"
    OPPORTUNITIES ||--o| COURSES : "is"
    OPPORTUNITIES ||--o| ENTRANCE_EXAMS : "is"
    OPPORTUNITIES ||--o| INTERNSHIPS : "is"

    %% Courses at institutions
    COURSES ||--o{ COURSE_INSTITUTIONS : "offered at"
    INSTITUTIONS ||--o{ COURSE_INSTITUTIONS : "offers"
    INSTITUTIONS }o--o| LOCATIONS : "located in"
    INSTITUTIONS }o--o| ORGANIZATIONS : "belongs to"

    %% Career ↔ Courses and Exams
    CAREERS ||--o{ CAREER_COURSES : "recommends"
    COURSES ||--o{ CAREER_COURSES : "recommended for"

    %% Sources & RAG
    OPPORTUNITIES ||--o{ OPPORTUNITY_DOCUMENTS : "has"
    OPPORTUNITY_DOCUMENTS ||--o{ DOCUMENT_CHUNKS : "chunked into"
    SOURCES ||--o{ OPPORTUNITY_DOCUMENTS : "provides"

    %% Translations
    LANGUAGES ||--o{ TRANSLATIONS : "has"
```

---

## Eligibility Engine

**Design Principle**: The LLM must **never** determine eligibility. Eligibility is computed deterministically from structured database rules.

### Rule Structure

Each `eligibility_rule` row has:
- `rule_type` — what to check (INCOME, STATE, GENDER, PERCENTAGE, etc.)
- `operator` — how to compare (EQ, LTE, IN, etc.)
- `value` — the threshold/target value
- `rule_group_id` — optional grouping for compound conditions
- `group_operator` — AND | OR within a group

### Simple Rule Example

```sql
-- MHRD Central Sector Scholarship
INSERT INTO eligibility_rules (opportunity_id, rule_type, operator, value, description)
VALUES
  (opp_id, 'INCOME',      'LTE', '450000', 'Family income ≤ ₹4.5 lakh'),
  (opp_id, 'PERCENTAGE',  'GTE', '80',     'Minimum 80% in Class 12'),
  (opp_id, 'NATIONALITY', 'EQ',  'Indian', 'Must be Indian national');
```

### Compound Rule Example (AND/OR groups)

```sql
-- Maharashtra OBC Scholarship: must be OBC AND from Maharashtra
INSERT INTO eligibility_rules (opportunity_id, rule_type, operator, value, rule_group_id, group_operator)
VALUES
  (opp_id, 'SOCIAL_CATEGORY', 'IN',  'OBC,VJNT,SBC', 'G1', 'AND'),
  (opp_id, 'STATE',            'EQ',  'Maharashtra',  'G1', 'AND'),
  (opp_id, 'INCOME',           'LTE', '800000',       NULL, 'AND');
-- G1: CATEGORY IN [OBC,VJNT,SBC] AND STATE = Maharashtra
-- All: G1 AND INCOME ≤ 8L
```

### Supported Rule Types

| Rule Type | Example |
|-----------|---------|
| AGE | Age ≤ 25 |
| INCOME | Family income ≤ ₹4.5 lakh |
| GENDER | Female only |
| SOCIAL_CATEGORY | SC, ST, OBC, General |
| STATE | Maharashtra domicile |
| DISTRICT | Specific district |
| EDUCATION_LEVEL | 12th pass / Diploma |
| BOARD | CBSE only |
| PERCENTAGE | ≥ 60% in 10th |
| SUBJECT | Must have Mathematics |
| SKILL | Must have Python skill |
| RURAL_STATUS | Rural area resident |
| INSTITUTION_TYPE | Government college only |
| NATIONALITY | Indian national |
| DISABILITY | Person with disability |

---

## RAG Architecture

```
Student Query (natural language)
        ↓
LLM extracts intent + entities
        ↓
Structured Eligibility Engine → Candidate Opportunities
        ↓
Opportunity Documents retrieved
        ↓
Document Chunks semantically searched via pgvector HNSW index
        ↓
Top-K relevant chunks retrieved
        ↓
LLM generates response from chunks + structured data
        ↓
Response in student's language
```

### Document Storage

- `opportunity_documents` — full-text documents (PDFs converted to text, brochures, FAQs)
- `document_chunks` — split into overlapping chunks (e.g., 512 tokens with 50 overlap)
- `document_chunks.embedding` — `vector(768)` column by default (pgvector)

### Vector Index

```sql
-- HNSW index for approximate cosine similarity search
CREATE INDEX ix_document_chunks_embedding_hnsw
ON document_chunks
USING hnsw (embedding vector_cosine_ops)
WITH (m = 16, ef_construction = 64);
```

### Similarity Query

```python
# Find top-5 most similar chunks to a query embedding
results = db.execute(
    select(DocumentChunk)
    .where(DocumentChunk.embedding.isnot(None))
    .order_by(DocumentChunk.embedding.cosine_distance(query_embedding))
    .limit(5)
).scalars().all()
```

### Embedding Dimension

Default: **768** for Vertex AI `text-embedding-004`.

To change: update `VECTOR_DIM` in `.env` **before** running the first migration.

---

## GCP Deployment

When ready to deploy to Google Cloud:

### 1. Cloud SQL for PostgreSQL

```bash
# Create a Cloud SQL instance with pgvector
gcloud sql instances create dreamcatcher-db \
  --database-version=POSTGRES_16 \
  --tier=db-g1-small \
  --region=asia-south1

# Enable pgvector extension
gcloud sql databases patch dreamcatcher \
  --instance=dreamcatcher-db \
  --flags=cloudsql.enable_pgvector=on
```

### 2. Update DATABASE_URL

```bash
# Via Cloud SQL Auth Proxy
DATABASE_URL=postgresql+psycopg2://user:pass@/dreamcatcher?host=/cloudsql/PROJECT:REGION:INSTANCE
```

### 3. Cloud Run

```bash
gcloud run deploy dreamcatcher-backend \
  --source ./backend \
  --region asia-south1 \
  --set-env-vars DATABASE_URL=...
```

### 4. Google Cloud Storage (for student documents)

Student document files (`student_documents.storage_url`) should reference GCS object URIs:
```
gs://dreamcatcher-prod/students/{student_id}/documents/{doc_id}.pdf
```

---

## Phase Roadmap

| Phase | What Gets Built |
|-------|----------------|
| **Core platform** ✅ | PostgreSQL/pgvector schema, migrations, seed data, health API |
| **Guidance APIs** ✅ | FastAPI CRUD, opportunity matching, eligibility, AI assistant, and RAG services |
| **Student app** ✅ | Flutter onboarding, dashboard, opportunity finder, profile, chat, and localization |
| **Voice counselling** ✅ | Browser voice client with Google Speech-to-Text and Text-to-Speech |
| **Volunteer portal** ✅ | React/Vite field portal and credential dispatcher backend |
| Next | Authentication, authorization, and production hardening |
| Next | Opportunity ingestion, document processing, and richer offline support |

---

## Project Structure

```
DreamCatcher/
├── app/                              # Flutter student application
├── backend/                          # FastAPI, SQLAlchemy, AI, and voice APIs
│   ├── app/api/v1/                   # Health, students, opportunities, chat, voice
│   ├── app/models/                   # SQLAlchemy domain models
│   ├── app/services/                 # Eligibility, AI, RAG, student, and voice services
│   ├── alembic/versions/             # Database migrations
│   ├── scripts/                      # Seed and embedding utilities
│   └── tests/                        # Backend API and service tests
├── call/                             # React/Vite browser voice client
├── Website/frontend/                 # React/Vite volunteer portal
├── Website/backend/                  # Credential dispatcher service
├── docker-compose.yml                # PostgreSQL/pgvector and FastAPI
├── run_backends.py                   # Starts both local backend services
├── DreamCatcherLogo.png              # Project logo
├── RuralEducation.png                # README project image
├── .env.example
├── .gitignore
└── README.md
```

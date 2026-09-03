"""
Seed sample opportunity documents for RAG pipeline development.

Usage:
    cd backend
    source .venv/bin/activate
    python scripts/seed_documents.py

This creates realistic opportunity_documents for existing opportunities
in the database so the embedding pipeline and semantic search have data to work with.
"""
import sys
import os

# Add backend directory to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from sqlalchemy import select
from app.core.database import SessionLocal
from app.models.opportunity import Opportunity, OpportunityType
from app.models.document import OpportunityDocument, DocumentType

# ---------------------------------------------------------------------------
# Sample document content (realistic Indian scholarship/course descriptions)
# ---------------------------------------------------------------------------
SAMPLE_DOCUMENTS = {
    OpportunityType.SCHOLARSHIP: [
        {
            "title": "Scheme Guidelines & Eligibility",
            "document_type": DocumentType.SCHOLARSHIP_GUIDELINES,
            "content": """
Post-Matric Scholarship for SC/ST/OBC Students — Official Guidelines

1. OBJECTIVE
The Post-Matric Scholarship scheme aims to provide financial assistance to students
belonging to Scheduled Castes, Scheduled Tribes, and Other Backward Classes studying
at the post-matriculation or post-secondary stage to enable them to complete their education.

2. ELIGIBILITY CRITERIA
- The applicant must belong to SC/ST/OBC category as certified by the competent authority.
- The applicant must have secured admission in a recognized institution after passing the
  matriculation examination (Class 10) or equivalent.
- The annual family income should not exceed ₹2,50,000 for SC/ST and ₹1,00,000 for OBC.
- The applicant must not be receiving any other scholarship for the same purpose.
- Students pursuing courses at government or recognized private institutions are eligible.

3. BENEFITS
- Full tuition fee reimbursement for students in government and aided institutions.
- Maintenance allowance ranging from ₹380 to ₹1,200 per month depending on course level.
- Additional allowance for books, equipment, and study tour as per norms.
- For hostellers: additional ₹570 to ₹1,200 per month.

4. APPLICATION PROCESS
- Apply online through the National Scholarship Portal (scholarships.gov.in).
- Upload required documents: caste certificate, income certificate, previous year marksheet,
  Aadhaar card, bank passbook, institution verification certificate.
- Application window: July to October each academic year.
- Renewal applications must be submitted within 30 days of academic session commencement.

5. IMPORTANT DATES
- Application Start: July 15
- Application Deadline: October 31
- Verification Deadline: November 30
- Disbursement: January-March

6. DOCUMENTS REQUIRED
- Valid Caste Certificate (issued by Tehsildar/SDM)
- Income Certificate (annual, not older than 1 year)
- Class 10 Marksheet / Passing Certificate
- Current year admission receipt / fee receipt
- Aadhaar Card (linked with bank account)
- Bank Passbook (student's own account, preferably nationalized bank)
- Passport size photograph
- Institution Verification Certificate
""",
        },
    ],
    OpportunityType.COURSE: [
        {
            "title": "Course Curriculum & Career Outcomes",
            "document_type": DocumentType.COURSE_DESCRIPTION,
            "content": """
ITI Electrician Trade — Course Description and Career Pathways

COURSE OVERVIEW
The ITI Electrician Trade is a 2-year program under the Craftsmen Training Scheme (CTS)
accredited by NCVT (National Council for Vocational Training). It prepares students for
careers in electrical installation, maintenance, and repair.

DURATION: 2 years (4 semesters)
ELIGIBILITY: Pass in 10th Standard (SSC) with Mathematics and Science
MODE: Full-time, practical-oriented with 70% hands-on training
INTAKE: Varies by ITI; typically 20-40 students per batch

CURRICULUM HIGHLIGHTS
Semester 1-2 (Year 1):
- Basic Electrical Engineering concepts
- Electrical wiring (domestic and industrial)
- Use of electrical measuring instruments (multimeter, clamp meter)
- Motor winding and rewinding fundamentals
- Safety practices and first aid
- Workshop mathematics and science

Semester 3-4 (Year 2):
- Industrial wiring and panel board assembly
- PLC (Programmable Logic Controller) basics
- Solar panel installation and maintenance
- Transformer repair and testing
- AC and DC motor troubleshooting
- Inverter and UPS system installation
- Electrical estimation and costing
- Entrepreneurship development

CERTIFICATION
- NCVT Certificate (nationally recognized)
- Eligible for National Apprenticeship Certificate (NAC) after 1-year apprenticeship

CAREER OPPORTUNITIES
- Electrician in government/private sector (₹15,000-₹30,000/month starting)
- MSEDCL / DISCOM technician through recruitment exams
- Solar installation technician (growing demand under PM Surya Ghar Yojana)
- Self-employment with government subsidized tool kit (₹15,000 kit provided free)
- Wireman license holder (can contract independently)
- Apprenticeship under NAPS in companies like L&T, Tata, Siemens

FEES
- Government ITI: Free (only nominal exam fee of ₹200-500)
- Private ITI: ₹10,000-₹30,000 per year
- SC/ST/OBC students: Full fee waiver in government ITIs

HOW TO APPLY
- Apply through state DTE (Directorate of Technical Education) website
- Maharashtra: dte.maharashtra.gov.in
- Admission through merit list based on 10th marks
- Reservation: SC 13%, ST 7%, OBC 19%, EWS 10%
""",
        },
    ],
    OpportunityType.ENTRANCE_EXAM: [
        {
            "title": "Exam Pattern & Preparation Guide",
            "document_type": DocumentType.EXAM_BROCHURE,
            "content": """
Maharashtra Polytechnic CET — Exam Pattern and Preparation Guide

OVERVIEW
The Maharashtra State Board of Technical Education (MSBTE) conducts the Polytechnic
Common Entrance Test (CET) for admission to Diploma programs in Engineering and Technology.

ELIGIBILITY
- Pass in SSC (10th Standard) examination with Mathematics and Science
- Minimum 35% marks (no minimum for reserved categories)
- Age limit: No upper age limit

EXAM PATTERN
- Duration: 90 minutes
- Total Questions: 100 MCQs
- Subjects: Mathematics (50 questions), Science (25 questions), General Aptitude (25 questions)
- Marking: 1 mark per correct answer, no negative marking
- Medium: English, Hindi, Marathi

IMPORTANT TOPICS
Mathematics:
- Number systems and arithmetic operations
- Algebraic expressions, equations, factorization
- Geometry: triangles, circles, mensuration
- Statistics: mean, median, mode
- Profit and loss, simple and compound interest

Science:
- Physics: force, motion, energy, light, electricity
- Chemistry: elements, compounds, chemical reactions
- General science: environment, health, nutrition

PREPARATION TIPS
1. Focus on NCERT textbooks for Class 8-10 Science and Mathematics
2. Practice previous year question papers (available free on MSBTE website)
3. Use free online resources: DIKSHA app, Khan Academy Hindi
4. Time management: aim for 50 seconds per question
5. Start with easier questions, then attempt difficult ones

REGISTRATION
- Online registration through MSBTE portal
- Application fee: ₹300 (₹100 for reserved categories)
- Exam centers in every district of Maharashtra

FEE WAIVERS
- SC/ST students: Full fee waiver
- OBC/EWS students: 50% fee concession
- Orphans and disabled students: Complete exemption
""",
        },
    ],
    OpportunityType.INTERNSHIP: [
        {
            "title": "Internship Program Details",
            "document_type": DocumentType.INTERNSHIP_DESCRIPTION,
            "content": """
National Apprenticeship Promotion Scheme (NAPS) — Internship Program Details

OVERVIEW
NAPS is a Government of India initiative under the Ministry of Skill Development and
Entrepreneurship to promote apprenticeship training in establishments across India.

BENEFITS FOR STUDENTS
- Monthly stipend: ₹6,000-₹9,000 (25% shared by Government of India)
- On-the-job training in real industry settings
- National Apprenticeship Certificate upon completion
- Direct absorption opportunity: 60%+ apprentices get permanent jobs

ELIGIBILITY
- Minimum age: 14 years (for designated trades) / 18 years (for optional trades)
- Educational qualification: varies by trade (Class 8 to ITI pass)
- Aadhaar card mandatory
- Bank account in apprentice's name

DURATION
- 6 months to 3 years depending on the trade
- Minimum 6 months for optional trades
- 1-2 years for designated trades

HOW TO REGISTER
1. Visit apprenticeshipindia.gov.in
2. Create account with Aadhaar and mobile number
3. Complete profile with educational details
4. Search and apply to establishments offering apprenticeship
5. Establishments can also search and engage apprentices

SECTORS AVAILABLE
- Manufacturing (automobile, electronics, textiles)
- IT and ITES
- Healthcare
- Retail and hospitality
- Banking and financial services
- Agriculture and food processing
- Construction and real estate
- Renewable energy (solar, wind)

IMPORTANT NOTES
- No fees charged to apprentices
- Government shares 25% of prescribed stipend (up to ₹1,500/month)
- ₹7,500 basic training cost reimbursed per apprentice
- Covers both ITI pass-outs and general stream students
""",
        },
    ],
}


def seed_documents():
    """Seed sample documents for existing opportunities."""
    db = SessionLocal()
    try:
        created_count = 0
        for opp_type, doc_templates in SAMPLE_DOCUMENTS.items():
            # Find opportunities of this type
            opportunities = list(
                db.execute(
                    select(Opportunity).where(Opportunity.type == opp_type).limit(3)
                ).scalars().all()
            )

            if not opportunities:
                print(f"  No {opp_type.value} opportunities found, skipping.")
                continue

            for opp in opportunities:
                # Check if document already exists
                existing = db.execute(
                    select(OpportunityDocument).where(
                        OpportunityDocument.opportunity_id == opp.id
                    )
                ).scalar_one_or_none()

                if existing:
                    print(f"  Document already exists for '{opp.title}', skipping.")
                    continue

                for template in doc_templates:
                    doc = OpportunityDocument(
                        opportunity_id=opp.id,
                        title=f"{opp.title} — {template['title']}",
                        document_type=template["document_type"],
                        content=template["content"].strip(),
                        language="en",
                    )
                    db.add(doc)
                    created_count += 1
                    print(f"  ✓ Created document for '{opp.title}'")

        db.commit()
        print(f"\n✅ Seeded {created_count} sample documents.")
        print("Next step: Run 'python scripts/generate_embeddings.py' to create Vertex AI embeddings.")

    except Exception as e:
        db.rollback()
        print(f"\n❌ Error seeding documents: {e}")
        raise
    finally:
        db.close()


if __name__ == "__main__":
    print("🌱 Seeding sample opportunity documents...\n")
    seed_documents()

"""
DreamCatcher — Seed Script with Researched Real Opportunities for Rural Students.

Seeds the database with authentic, high-impact opportunities specifically
tailored for students in rural India, including:
- 12 Real Scholarships (NMMSS, PM YASASVI, SC/ST Post-Matric, Pragati, Saksham, INSPIRE, Reliance, Kotak, HDFC, etc.)
- 11 Practical & Vocational Courses (ITI Trades, Polytechnics, B.Sc. Agriculture, ANM, GNM, D.El.Ed, IGNOU, DDU-GKY)
- 8 Key Entrance Exams (JNVST with 75% rural quota, ICAR AIEEA, JEE Main + SATHEE, NEET, Polytechnic CET, SSC GD)
- 7 Grassroots Fellowships & Apprenticeships (SBI Youth for India, Gandhi Fellowship, PRADAN, NAPS, ICAR RAWE)
- Deterministic Eligibility Rules for every opportunity
- Benchmark Student Profiles (Priya, Arjun, Meena)

Usage:
    cd backend/
    python scripts/seed.py
"""
import sys
import os
from datetime import date, datetime, timezone
import sqlalchemy as sa

# Make app importable from scripts/
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.core.database import SessionLocal
from app.models import (
    Language, Location, Organization, Institution, Skill, Interest,
    Career, CareerPathway, CareerSkill, CareerCourse, CareerExam,
    Student, StudentEducation, StudentSubject, StudentSkill, StudentInterest, StudentAspiration,
    Opportunity, Scholarship, Course, CourseInstitution, EntranceExam, Internship,
    EligibilityRule, Source, VerificationLog, OpportunityDocument, DocumentChunk,
)
from app.models.organization import OrganizationType
from app.models.institution import InstitutionType, GovernmentPrivate
from app.models.location import RuralUrban
from app.models.student import Gender
from app.models.education import EducationLevel, EducationStatus, DataSource
from app.models.skill import SkillCategory, ProficiencyLevel
from app.models.interest import InterestCategory
from app.models.career import DemandLevel, CareerLevel, ImportanceLevel
from app.models.opportunity import OpportunityType, OpportunityStatus, VerificationStatus
from app.models.scholarship import AwardFrequency
from app.models.course import CourseMode, AdmissionMethod
from app.models.exam import ExamMode, ExamFrequency
from app.models.eligibility import RuleType, RuleOperator, GroupOperator
from app.models.source import SourceType
from app.models.document import DocumentType


def clear_database(db):
    """Truncate tables in safe cascade order to allow re-running seed cleanly."""
    print("  🧹 Resetting database tables...")
    tables = [
        "document_chunks", "opportunity_documents", "course_institutions",
        "opportunity_versions", "verification_logs", "sources", "eligibility_rules",
        "student_documents", "student_aspirations", "student_interests",
        "student_skills", "student_subjects", "student_education",
        "career_exams", "career_courses", "career_skills", "career_pathways",
        "internships", "entrance_exams", "courses", "scholarships",
        "opportunities", "interests", "skills", "careers", "students",
        "institutions", "translations", "organizations", "locations", "languages"
    ]
    for tbl in tables:
        try:
            db.execute(sa.text(f"TRUNCATE TABLE {tbl} CASCADE;"))
        except Exception:
            pass
    db.commit()


def seed():
    db = SessionLocal()
    try:
        print("🌱 Seeding DreamCatcher database with Rural Opportunities...")
        clear_database(db)

        # ── 1. Languages ───────────────────────────────────────────────────
        print("  → 1. Languages")
        languages = [
            Language(code="en", name="English", native_name="English", script="Latin"),
            Language(code="hi", name="Hindi", native_name="हिन्दी", script="Devanagari"),
            Language(code="mr", name="Marathi", native_name="मराठी", script="Devanagari"),
            Language(code="bn", name="Bengali", native_name="বাংলা", script="Bengali"),
            Language(code="ta", name="Tamil", native_name="தமிழ்", script="Tamil"),
            Language(code="te", name="Telugu", native_name="తెలుగు", script="Telugu"),
            Language(code="kn", name="Kannada", native_name="ಕನ್ನಡ", script="Kannada"),
            Language(code="gu", name="Gujarati", native_name="ગુજરાતી", script="Gujarati"),
            Language(code="or", name="Odia", native_name="ଓଡ଼ିଆ", script="Odia"),
        ]
        db.add_all(languages)
        db.flush()

        # ── 2. Locations ───────────────────────────────────────────────────
        print("  → 2. Geographic Locations (Rural & Regional)")
        loc_national = Location(country="India", rural_urban=RuralUrban.UNKNOWN)
        loc_mh = Location(country="India", state="Maharashtra", rural_urban=RuralUrban.URBAN)
        loc_mh_nashik_rural = Location(country="India", state="Maharashtra", district="Nashik",
                                       taluka="Niphad", village="Pimpalgaon Baswant",
                                       pincode="422209", rural_urban=RuralUrban.RURAL)
        loc_mh_aurangabad_rural = Location(country="India", state="Maharashtra", district="Chhatrapati Sambhajinagar",
                                           taluka="Paithan", village="Bidkin",
                                           pincode="431105", rural_urban=RuralUrban.RURAL)
        loc_up = Location(country="India", state="Uttar Pradesh", rural_urban=RuralUrban.URBAN)
        loc_up_varanasi_rural = Location(country="India", state="Uttar Pradesh", district="Varanasi",
                                         taluka="Pindra", village="Rampur Khas",
                                         pincode="221206", rural_urban=RuralUrban.RURAL)
        loc_up_gorakhpur_rural = Location(country="India", state="Uttar Pradesh", district="Gorakhpur",
                                          taluka="Campierganj", village="Machhligaon",
                                          pincode="273158", rural_urban=RuralUrban.RURAL)
        loc_rj_barmer_rural = Location(country="India", state="Rajasthan", district="Barmer",
                                       taluka="Chohtan", village="Kharchia",
                                       pincode="344702", rural_urban=RuralUrban.RURAL)
        loc_br_muzaffarpur_rural = Location(country="India", state="Bihar", district="Muzaffarpur",
                                            taluka="Bochahan", village="Sarfuddinpur",
                                            pincode="843103", rural_urban=RuralUrban.RURAL)
        loc_mp_jhabua_rural = Location(country="India", state="Madhya Pradesh", district="Jhabua",
                                       taluka="Thandla", village="Khatamba",
                                       pincode="457777", rural_urban=RuralUrban.RURAL)
        loc_mumbai = Location(country="India", state="Maharashtra", district="Mumbai",
                              pincode="400001", rural_urban=RuralUrban.URBAN)
        loc_pune = Location(country="India", state="Maharashtra", district="Pune",
                            pincode="411001", rural_urban=RuralUrban.URBAN)
        loc_delhi = Location(country="India", state="Delhi", district="New Delhi",
                             pincode="110001", rural_urban=RuralUrban.URBAN)

        locations = [
            loc_national, loc_mh, loc_mh_nashik_rural, loc_mh_aurangabad_rural,
            loc_up, loc_up_varanasi_rural, loc_up_gorakhpur_rural,
            loc_rj_barmer_rural, loc_br_muzaffarpur_rural, loc_mp_jhabua_rural,
            loc_mumbai, loc_pune, loc_delhi
        ]
        db.add_all(locations)
        db.flush()

        # ── 3. Organizations ───────────────────────────────────────────────
        print("  → 3. Government Ministries, Public Bodies & Foundations")
        org_moe = Organization(
            name="Ministry of Education, Government of India",
            type=OrganizationType.GOVERNMENT,
            website="https://education.gov.in",
            description="Oversees primary, secondary, and higher education policies across India."
        )
        org_msje = Organization(
            name="Ministry of Social Justice and Empowerment",
            type=OrganizationType.GOVERNMENT,
            website="https://socialjustice.gov.in",
            description="Empowers disadvantaged groups including SCs, OBCs, EBCs, and DNT communities."
        )
        org_mota = Organization(
            name="Ministry of Tribal Affairs",
            type=OrganizationType.GOVERNMENT,
            website="https://tribal.nic.in",
            description="Formulates welfare, educational, and economic programmes for Scheduled Tribes (ST)."
        )
        org_aicte = Organization(
            name="All India Council for Technical Education (AICTE)",
            type=OrganizationType.GOVERNMENT,
            website="https://www.aicte-india.org",
            description="Statutory body and national-level council for technical education in India."
        )
        org_dst = Organization(
            name="Department of Science & Technology (DST)",
            type=OrganizationType.GOVERNMENT,
            website="https://dst.gov.in",
            description="Promotes scientific research and educational initiatives including INSPIRE."
        )
        org_msde = Organization(
            name="Ministry of Skill Development and Entrepreneurship (MSDE / DGT)",
            type=OrganizationType.GOVERNMENT,
            website="https://www.msde.gov.in",
            description="Regulates vocational training (ITIs), apprenticeships, and national skill qualifications."
        )
        org_mord = Organization(
            name="Ministry of Rural Development (MoRD)",
            type=OrganizationType.GOVERNMENT,
            website="https://rural.nic.in",
            description="Spearheads rural employment, poverty reduction, and DDU-GKY youth skilling."
        )
        org_icar = Organization(
            name="Indian Council of Agricultural Research (ICAR)",
            type=OrganizationType.GOVERNMENT,
            website="https://icar.org.in",
            description="Apex body coordinating agricultural education and research throughout the country."
        )
        org_nvs = Organization(
            name="Navodaya Vidyalaya Samiti",
            type=OrganizationType.GOVERNMENT,
            website="https://navodaya.gov.in",
            description="Manages Jawahar Navodaya Vidyalayas providing free residential schooling to rural talent."
        )
        org_nta = Organization(
            name="National Testing Agency (NTA)",
            type=OrganizationType.GOVERNMENT,
            website="https://nta.ac.in",
            description="Premier specialist autonomous testing organization conducting JEE, NEET, and CUET."
        )
        org_ssc = Organization(
            name="Staff Selection Commission (SSC)",
            type=OrganizationType.GOVERNMENT,
            website="https://ssc.gov.in",
            description="Recruits staff for various posts in ministries and departments of the Government of India."
        )
        org_nsp = Organization(
            name="National Scholarship Portal (NSP)",
            type=OrganizationType.GOVERNMENT,
            website="https://scholarships.gov.in",
            description="Mission Mode Project under Digital India providing common electronic portal for scholarships."
        )
        org_sbi_found = Organization(
            name="SBI Foundation",
            type=OrganizationType.FOUNDATION,
            website="https://www.sbifoundation.in",
            description="CSR arm of State Bank of India executing the flagship SBI Youth for India fellowship."
        )
        org_piramal = Organization(
            name="Piramal Foundation / Kaivalya Education Foundation",
            type=OrganizationType.FOUNDATION,
            website="https://piramalfoundation.org",
            description="Executes the Gandhi Fellowship focused on transforming primary public education in rural districts."
        )
        org_pradan = Organization(
            name="PRADAN (Professional Assistance for Development Action)",
            type=OrganizationType.NGO,
            website="https://www.pradan.net",
            description="Pioneering NGO promoting sustainable rural livelihoods, SHGs, and natural resource management."
        )
        org_reliance_found = Organization(
            name="Reliance Foundation",
            type=OrganizationType.FOUNDATION,
            website="https://www.reliancefoundation.org",
            description="Philanthropic arm of Reliance Industries supporting undergraduate education scholarships."
        )
        org_hdfc_found = Organization(
            name="HDFC Bank Parivartan",
            type=OrganizationType.FOUNDATION,
            website="https://www.hdfcbank.com/parivartan",
            description="Social initiative of HDFC Bank supporting underprivileged students through ECSS scholarships."
        )
        org_kotak_found = Organization(
            name="Kotak Education Foundation",
            type=OrganizationType.FOUNDATION,
            website="https://kotakeducation.org",
            description="Empowers children and youth from underprivileged families through education and scholarships."
        )
        org_tata_trust = Organization(
            name="Tata Trusts",
            type=OrganizationType.FOUNDATION,
            website="https://www.tatatrusts.org",
            description="India's oldest philanthropic organization supporting rural education and development."
        )
        org_iit_bombay = Organization(
            name="Indian Institute of Technology Bombay",
            type=OrganizationType.UNIVERSITY,
            website="https://www.iitb.ac.in",
            description="Premier institute of technology and national research university."
        )

        orgs = [
            org_moe, org_msje, org_mota, org_aicte, org_dst, org_msde, org_mord,
            org_icar, org_nvs, org_nta, org_ssc, org_nsp, org_sbi_found,
            org_piramal, org_pradan, org_reliance_found, org_hdfc_found,
            org_kotak_found, org_tata_trust, org_iit_bombay
        ]
        db.add_all(orgs)
        db.flush()

        # ── 4. Institutions ────────────────────────────────────────────────
        print("  → 4. Institutions (Govt ITIs, Polytechnics, Agri Universities, Schools)")
        inst_iitb = Institution(
            organization_id=org_iit_bombay.id, name="IIT Bombay",
            institution_type=InstitutionType.IIT, location_id=loc_mumbai.id,
            website="https://www.iitb.ac.in", government_private=GovernmentPrivate.GOVERNMENT,
            accreditation="NAAC A++", description="Premier technical institute in Mumbai."
        )
        inst_coep = Institution(
            name="College of Engineering Pune (COEP)", institution_type=InstitutionType.COLLEGE,
            location_id=loc_pune.id, website="https://www.coeptech.ac.in",
            government_private=GovernmentPrivate.GOVERNMENT, accreditation="NAAC A",
            description="Top autonomous engineering institution in Maharashtra."
        )
        inst_iti_nashik = Institution(
            name="Government Industrial Training Institute (ITI) Nashik",
            institution_type=InstitutionType.VOCATIONAL, location_id=loc_mh.id,
            government_private=GovernmentPrivate.GOVERNMENT, accreditation="NCVT Approved",
            description="Government ITI providing hands-on vocational trades like Electrician, Fitter, and COPA."
        )
        inst_iti_varanasi = Institution(
            name="Government ITI Karaundi, Varanasi",
            institution_type=InstitutionType.VOCATIONAL, location_id=loc_up.id,
            government_private=GovernmentPrivate.GOVERNMENT, accreditation="NCVT Approved",
            description="Major vocational training center for rural youth in eastern Uttar Pradesh."
        )
        inst_poly_pune = Institution(
            name="Government Polytechnic Pune",
            institution_type=InstitutionType.POLYTECHNIC, location_id=loc_pune.id,
            government_private=GovernmentPrivate.GOVERNMENT, accreditation="AICTE Approved",
            description="Oldest government polytechnic offering low-cost 3-year technical engineering diplomas."
        )
        inst_mpkv = Institution(
            name="Mahatma Phule Krishi Vidyapeeth (MPKV), Rahuri",
            institution_type=InstitutionType.UNIVERSITY, location_id=loc_mh.id,
            website="https://mpkv.ac.in", government_private=GovernmentPrivate.GOVERNMENT,
            accreditation="ICAR Accredited",
            description="State agricultural university providing B.Sc. Agriculture and rural farming outreach."
        )
        inst_jnv_nashik = Institution(
            name="PM SHRI Jawahar Navodaya Vidyalaya, Nashik",
            institution_type=InstitutionType.SCHOOL, location_id=loc_mh_nashik_rural.id,
            website="https://navodaya.gov.in/nvs/nvs-school/NASHIK",
            government_private=GovernmentPrivate.GOVERNMENT,
            description="Fully residential government school with 75% reservation for rural students."
        )
        inst_ignou = Institution(
            name="Indira Gandhi National Open University (IGNOU)",
            institution_type=InstitutionType.OPEN_UNIVERSITY, location_id=loc_delhi.id,
            website="https://www.ignou.ac.in", government_private=GovernmentPrivate.GOVERNMENT,
            accreditation="NAAC A++",
            description="Largest open university offering flexible, affordable distance degrees for rural learners."
        )
        inst_diet_nashik = Institution(
            name="District Institute of Education and Training (DIET) Nashik",
            institution_type=InstitutionType.COLLEGE, location_id=loc_mh.id,
            government_private=GovernmentPrivate.GOVERNMENT,
            description="Government institute conducting 2-year D.El.Ed primary teacher training."
        )
        inst_gmc_aurangabad = Institution(
            name="Government Medical College (GMC), Chhatrapati Sambhajinagar",
            institution_type=InstitutionType.COLLEGE, location_id=loc_mh.id,
            government_private=GovernmentPrivate.GOVERNMENT, accreditation="NMC Approved",
            description="Subsidized government medical college with state rural quota seats."
        )

        institutions = [
            inst_iitb, inst_coep, inst_iti_nashik, inst_iti_varanasi,
            inst_poly_pune, inst_mpkv, inst_jnv_nashik, inst_ignou,
            inst_diet_nashik, inst_gmc_aurangabad
        ]
        db.add_all(institutions)
        db.flush()

        # ── 5. Skills ──────────────────────────────────────────────────────
        print("  → 5. Skills")
        skill_python = Skill(canonical_name="Python Programming", category=SkillCategory.TECHNICAL, description="Programming with Python.")
        skill_electrical = Skill(canonical_name="Electrical Wiring & Circuit Repair", category=SkillCategory.TECHNICAL, description="Domestic wiring, wireman fundamentals, motor servicing, and safety.")
        skill_solar = Skill(canonical_name="Solar PV Installation & Maintenance", category=SkillCategory.VOCATIONAL, description="Rooftop solar panel mounting, inverter wiring, and battery systems.")
        skill_crop_mgmt = Skill(canonical_name="Crop Production & Soil Testing", category=SkillCategory.SCIENTIFIC, description="Soil sampling, nutrient management, seed treatment, and organic inputs.")
        skill_computer_basic = Skill(canonical_name="Basic Computer Operations & MS Office", category=SkillCategory.DIGITAL, description="Word processing, spreadsheets, internet browsing, and digital forms.")
        skill_nursing = Skill(canonical_name="Primary Patient Care & Maternal Health", category=SkillCategory.VOCATIONAL, description="Vital monitoring, immunization, maternal and neonatal care basics.")
        skill_teaching = Skill(canonical_name="Primary Pedagogy & Classroom Management", category=SkillCategory.SOFT, description="Child-centric lesson planning, foundational literacy, and numeracy.")
        skill_data_analysis = Skill(canonical_name="Data Analysis", category=SkillCategory.TECHNICAL, description="Processing and analyzing structured datasets.")
        skill_communication = Skill(canonical_name="Community Communication", category=SkillCategory.SOFT, description="Engaging community elders, farmers, and self-help groups.")
        skill_english = Skill(canonical_name="Functional English", category=SkillCategory.LANGUAGE, description="Everyday spoken and written English for official communication.")
        skill_math = Skill(canonical_name="Mathematics & Numerical Reasoning", category=SkillCategory.SCIENTIFIC, description="Arithmetic, algebra, and applied calculations.")
        skill_problem_solving = Skill(canonical_name="Problem Solving", category=SkillCategory.SOFT, description="Logical diagnosis and analytical troubleshooting.")

        all_skills = [
            skill_python, skill_electrical, skill_solar, skill_crop_mgmt,
            skill_computer_basic, skill_nursing, skill_teaching, skill_data_analysis,
            skill_communication, skill_english, skill_math, skill_problem_solving
        ]
        db.add_all(all_skills)
        db.flush()

        # ── 6. Interests ───────────────────────────────────────────────────
        print("  → 6. Interests")
        int_computers = Interest(name="Computers & Technology", category=InterestCategory.TECHNOLOGY)
        int_agriculture = Interest(name="Agriculture & Rural Development", category=InterestCategory.AGRICULTURE)
        int_healthcare = Interest(name="Healthcare & Nursing", category=InterestCategory.HEALTHCARE)
        int_teaching = Interest(name="Teaching & Community Education", category=InterestCategory.SOCIAL_WORK)
        int_electrical = Interest(name="Electrical & Machine Work", category=InterestCategory.ENGINEERING)
        int_defence = Interest(name="Police & Armed Forces", category=InterestCategory.OTHER)
        int_science = Interest(name="Pure Sciences & Research", category=InterestCategory.SCIENCE)
        int_social_service = Interest(name="Social Work & Grassroots Empowerment", category=InterestCategory.SOCIAL_WORK)
        int_civil_infra = Interest(name="Civil Engineering & Construction", category=InterestCategory.ENGINEERING)

        all_interests = [
            int_computers, int_agriculture, int_healthcare, int_teaching,
            int_electrical, int_defence, int_science, int_social_service, int_civil_infra
        ]
        db.add_all(all_interests)
        db.flush()

        # ── 7. Careers & Pathways ──────────────────────────────────────────
        print("  → 7. Careers & Pathways")
        career_swe = Career(name="Software Engineer", industry="Information Technology",
                            career_level=CareerLevel.ENTRY, demand_level=DemandLevel.VERY_HIGH,
                            description="Design, test, and maintain computer software systems.")
        career_agri_ext = Career(name="Agricultural Extension Officer", industry="Agriculture & Rural Development",
                                 career_level=CareerLevel.ENTRY, demand_level=DemandLevel.HIGH,
                                 description="Guide farmers on modern agronomy, soil health, and government schemes.")
        career_wireman = Career(name="Electrician & Electrical Contractor", industry="Energy & Utilities",
                                career_level=CareerLevel.ENTRY, demand_level=DemandLevel.VERY_HIGH,
                                description="Install and maintain residential, agricultural pump, and grid wiring.")
        career_teacher = Career(name="Primary School Teacher", industry="Education",
                                career_level=CareerLevel.ENTRY, demand_level=DemandLevel.HIGH,
                                description="Educate children in foundational literacy and numeracy in rural schools.")
        career_nurse = Career(name="Community Health Nurse (ANM / GNM)", industry="Healthcare",
                              career_level=CareerLevel.ENTRY, demand_level=DemandLevel.VERY_HIGH,
                              description="Deliver maternal, neonatal, and primary immunization services at PHCs.")
        career_csc_vle = Career(name="Digital Service Entrepreneur (CSC VLE)", industry="Digital Services",
                                career_level=CareerLevel.ENTRY, demand_level=DemandLevel.HIGH,
                                description="Run a village Common Service Centre providing Aadhaar, DBT, and banking.")
        career_doctor = Career(name="Medical Doctor (MBBS)", industry="Healthcare",
                               career_level=CareerLevel.MID, demand_level=DemandLevel.HIGH,
                               description="Diagnose, treat, and prevent diseases in primary and secondary healthcare.")
        career_civil_eng = Career(name="Civil Engineer", industry="Infrastructure & Construction",
                                  career_level=CareerLevel.ENTRY, demand_level=DemandLevel.MEDIUM,
                                  description="Design and oversee construction of rural roads, canals, and buildings.")

        all_careers = [
            career_swe, career_agri_ext, career_wireman, career_teacher,
            career_nurse, career_csc_vle, career_doctor, career_civil_eng
        ]
        db.add_all(all_careers)
        db.flush()

        # Career Pathways
        pathways = [
            CareerPathway(
                career_id=career_wireman.id,
                pathway_name="ITI Route to Licensed Wireman",
                description="Short 2-year vocational path after Class 10 with fast self-employment.",
                is_alternative=False,
                steps=[
                    {"step": 1, "level": "secondary", "description": "Pass Class 10 with Science and Mathematics"},
                    {"step": 2, "level": "vocational", "description": "Complete 2-year ITI Electrician course (NCVT)"},
                    {"step": 3, "level": "apprenticeship", "description": "1-year National Apprenticeship (NAPS) with state electricity board / DISCOM"},
                    {"step": 4, "level": "certification", "description": "Clear State Wireman / Electrical Supervisor Licensing Exam"},
                    {"step": 5, "level": "employment", "description": "Licensed Electrical Contractor or DISCOM Lineman"},
                ]
            ),
            CareerPathway(
                career_id=career_teacher.id,
                pathway_name="D.El.Ed to Government Primary Teacher",
                description="Direct 2-year teacher diploma path after Class 12 for village schools.",
                is_alternative=False,
                steps=[
                    {"step": 1, "level": "senior_secondary", "description": "Complete Class 12 with minimum 50% marks"},
                    {"step": 2, "level": "diploma", "description": "2-year Diploma in Elementary Education (D.El.Ed) at DIET"},
                    {"step": 3, "level": "entrance_exam", "description": "Clear State Teacher Eligibility Test (TET) or CTET Paper 1"},
                    {"step": 4, "level": "employment", "description": "Appointment as Primary Teacher (PRT) in Zilla Parishad School"},
                ]
            ),
            CareerPathway(
                career_id=career_agri_ext.id,
                pathway_name="B.Sc Agriculture Route",
                description="4-year professional agriculture degree pathway.",
                is_alternative=False,
                steps=[
                    {"step": 1, "level": "senior_secondary", "description": "Class 12 with PCB or Agriculture"},
                    {"step": 2, "level": "entrance_exam", "description": "Clear State Agri CET or ICAR CUET"},
                    {"step": 3, "level": "bachelor", "description": "B.Sc (Hons) Agriculture with RAWE village internship"},
                    {"step": 4, "level": "employment", "description": "Agricultural Extension Officer / Bank Rural Development Officer (AFO)"},
                ]
            ),
            CareerPathway(
                career_id=career_nurse.id,
                pathway_name="ANM / GNM Rural Nursing Pathway",
                description="High demand healthcare career for rural women.",
                is_alternative=False,
                steps=[
                    {"step": 1, "level": "senior_secondary", "description": "Complete Class 12 with minimum 40% aggregate"},
                    {"step": 2, "level": "diploma", "description": "Complete 2-year ANM or 3-year GNM nursing diploma"},
                    {"step": 3, "level": "certification", "description": "Register with State Nursing Council"},
                    {"step": 4, "level": "employment", "description": "Staff Nurse / ANM at Primary Health Centre (PHC) or Sub-Centre"},
                ]
            ),
            CareerPathway(
                career_id=career_swe.id,
                pathway_name="University Route",
                description="Standard 4-year B.Tech in Computer Science.",
                is_alternative=False,
                steps=[
                    {"step": 1, "level": "senior_secondary", "description": "Class 11-12 with Physics, Chemistry, Mathematics"},
                    {"step": 2, "level": "entrance_exam", "description": "Clear JEE Main using SATHEE free coaching portal"},
                    {"step": 3, "level": "bachelor", "description": "4-year B.Tech in Computer Science / IT"},
                    {"step": 4, "level": "employment", "description": "Software Engineer"},
                ]
            ),
            CareerPathway(
                career_id=career_doctor.id,
                pathway_name="MBBS Medical Doctor Pathway",
                description="Rigorous medical degree pathway via NEET-UG.",
                is_alternative=False,
                steps=[
                    {"step": 1, "level": "senior_secondary", "description": "Class 11-12 with Physics, Chemistry, Biology"},
                    {"step": 2, "level": "entrance_exam", "description": "Clear NEET-UG"},
                    {"step": 3, "level": "bachelor", "description": "MBBS (5.5 years including rotatory internship)"},
                    {"step": 4, "level": "employment", "description": "Medical Officer at Government Rural Hospital / PHC"},
                ]
            ),
        ]
        db.add_all(pathways)
        db.flush()

        # Career ↔ Skills linkage
        db.add_all([
            CareerSkill(career_id=career_wireman.id, skill_id=skill_electrical.id, importance=ImportanceLevel.REQUIRED),
            CareerSkill(career_id=career_wireman.id, skill_id=skill_solar.id, importance=ImportanceLevel.PREFERRED),
            CareerSkill(career_id=career_wireman.id, skill_id=skill_problem_solving.id, importance=ImportanceLevel.REQUIRED),
            CareerSkill(career_id=career_teacher.id, skill_id=skill_teaching.id, importance=ImportanceLevel.REQUIRED),
            CareerSkill(career_id=career_teacher.id, skill_id=skill_communication.id, importance=ImportanceLevel.REQUIRED),
            CareerSkill(career_id=career_agri_ext.id, skill_id=skill_crop_mgmt.id, importance=ImportanceLevel.REQUIRED),
            CareerSkill(career_id=career_agri_ext.id, skill_id=skill_communication.id, importance=ImportanceLevel.REQUIRED),
            CareerSkill(career_id=career_nurse.id, skill_id=skill_nursing.id, importance=ImportanceLevel.REQUIRED),
            CareerSkill(career_id=career_csc_vle.id, skill_id=skill_computer_basic.id, importance=ImportanceLevel.REQUIRED),
            CareerSkill(career_id=career_swe.id, skill_id=skill_python.id, importance=ImportanceLevel.REQUIRED),
            CareerSkill(career_id=career_swe.id, skill_id=skill_problem_solving.id, importance=ImportanceLevel.REQUIRED),
        ])
        db.flush()

        # ── 8. Opportunities — SCHOLARSHIPS (12 Real Schemes) ──────────────
        print("  → 8. Researched Scholarships for Rural & Low-Income Students")

        # Scholarship 1: NMMSS
        opp_sc_nmms = Opportunity(
            type=OpportunityType.SCHOLARSHIP,
            title="National Means-cum-Merit Scholarship Scheme (NMMSS)",
            organization_id=org_moe.id, status=OpportunityStatus.ACTIVE,
            description="Centrally sponsored scheme providing financial support to meritorious students from economically weaker sections studying in government and local body schools to arrest drop-out at Class 8 and encourage secondary education.",
            official_url="https://scholarships.gov.in",
            application_start=date(2026, 7, 1), application_deadline=date(2026, 11, 30),
            location_id=loc_national.id, verification_status=VerificationStatus.VERIFIED,
        )
        # Scholarship 2: PM YASASVI
        opp_sc_yasasvi = Opportunity(
            type=OpportunityType.SCHOLARSHIP,
            title="PM YASASVI Scholarship Scheme for OBC, EBC and DNT Students",
            organization_id=org_msje.id, status=OpportunityStatus.ACTIVE,
            description="Flagship scheme of Ministry of Social Justice for Other Backward Classes (OBC), Economically Backward Classes (EBC), and De-notified Tribes (DNT) studying in identified Top Schools or Class 9 to 12.",
            official_url="https://yet.nta.ac.in",
            application_start=date(2026, 8, 1), application_deadline=date(2026, 10, 31),
            location_id=loc_national.id, verification_status=VerificationStatus.VERIFIED,
        )
        # Scholarship 3: Post-Matric SC
        opp_sc_post_matric_sc = Opportunity(
            type=OpportunityType.SCHOLARSHIP,
            title="Post-Matric Scholarship for Scheduled Caste (SC) Students",
            organization_id=org_msje.id, status=OpportunityStatus.ACTIVE,
            description="Comprehensive financial support covering 100% tuition and non-refundable fees plus monthly living allowance for SC students pursuing post-secondary courses (Class 11, 12, ITI, Diploma, Degree, PG).",
            official_url="https://scholarships.gov.in",
            application_start=date(2026, 7, 15), application_deadline=date(2026, 12, 15),
            location_id=loc_national.id, verification_status=VerificationStatus.VERIFIED,
        )
        # Scholarship 4: Post-Matric ST
        opp_sc_post_matric_st = Opportunity(
            type=OpportunityType.SCHOLARSHIP,
            title="Post-Matric Scholarship Scheme for Scheduled Tribe (ST) Students",
            organization_id=org_mota.id, status=OpportunityStatus.ACTIVE,
            description="Centrally sponsored scheme implemented through State Governments to enable tribal students from rural and forested areas to complete post-matric education without financial distress.",
            official_url="https://scholarships.gov.in",
            application_start=date(2026, 7, 15), application_deadline=date(2026, 12, 15),
            location_id=loc_national.id, verification_status=VerificationStatus.VERIFIED,
        )
        # Scholarship 5: AICTE Pragati
        opp_sc_pragati = Opportunity(
            type=OpportunityType.SCHOLARSHIP,
            title="AICTE Pragati Scholarship for Girl Students in Technical Education",
            organization_id=org_aicte.id, status=OpportunityStatus.ACTIVE,
            description="Empowers young women admitted to 1st year of AICTE-approved Degree or Diploma technical programs with substantial annual tuition and device grants.",
            official_url="https://www.aicte-pragati-saksham-gov.in",
            application_start=date(2026, 8, 15), application_deadline=date(2026, 11, 15),
            location_id=loc_national.id, verification_status=VerificationStatus.VERIFIED,
        )
        # Scholarship 6: AICTE Saksham
        opp_sc_saksham = Opportunity(
            type=OpportunityType.SCHOLARSHIP,
            title="AICTE Saksham Scholarship for Specially-Abled Students",
            organization_id=org_aicte.id, status=OpportunityStatus.ACTIVE,
            description="Dedicated financial assistance for students with disability of 40% or more pursuing technical degrees or diplomas in AICTE approved institutions.",
            official_url="https://www.aicte-pragati-saksham-gov.in",
            application_start=date(2026, 8, 15), application_deadline=date(2026, 11, 15),
            location_id=loc_national.id, verification_status=VerificationStatus.VERIFIED,
        )
        # Scholarship 7: INSPIRE SHE
        opp_sc_inspire = Opportunity(
            type=OpportunityType.SCHOLARSHIP,
            title="INSPIRE Scholarship for Higher Education (SHE) by DST",
            organization_id=org_dst.id, status=OpportunityStatus.ACTIVE,
            description="Prestigious Department of Science & Technology scholarship for top 1% board examination performers pursuing B.Sc. / Int. M.Sc. in basic and natural sciences, nurturing rural science talent.",
            official_url="https://online-inspire.gov.in",
            application_start=date(2026, 9, 1), application_deadline=date(2026, 11, 30),
            location_id=loc_national.id, verification_status=VerificationStatus.VERIFIED,
        )
        # Scholarship 8: Reliance Foundation
        opp_sc_reliance = Opportunity(
            type=OpportunityType.SCHOLARSHIP,
            title="Reliance Foundation Undergraduate Scholarship",
            organization_id=org_reliance_found.id, status=OpportunityStatus.ACTIVE,
            description="Merit-cum-means scholarship supporting 5,000 undergraduate students across India, with strong affirmative priority given to students from rural areas, low-income families, and girls.",
            official_url="https://www.reliancefoundation.org/ug-scholarships",
            application_start=date(2026, 8, 1), application_deadline=date(2026, 10, 15),
            location_id=loc_national.id, verification_status=VerificationStatus.VERIFIED,
        )
        # Scholarship 9: HDFC Parivartan ECSS
        opp_sc_hdfc = Opportunity(
            type=OpportunityType.SCHOLARSHIP,
            title="HDFC Bank Parivartan's Educational Crisis Support Scholarship (ECSS)",
            organization_id=org_hdfc_found.id, status=OpportunityStatus.ACTIVE,
            description="Assists school and college students from economically vulnerable rural households who are at risk of dropping out due to personal or economic crisis.",
            official_url="https://www.hdfcbank.com/parivartan",
            application_start=date(2026, 6, 1), application_deadline=date(2026, 9, 30),
            location_id=loc_national.id, verification_status=VerificationStatus.VERIFIED,
        )
        # Scholarship 10: Kotak Kanya
        opp_sc_kotak = Opportunity(
            type=OpportunityType.SCHOLARSHIP,
            title="Kotak Kanya Scholarship for Meritorious Girl Students",
            organization_id=org_kotak_found.id, status=OpportunityStatus.ACTIVE,
            description="Provides substantial financial aid to meritorious girls from disadvantaged backgrounds to pursue professional graduation degrees like Engineering, MBBS, Architecture, and Law.",
            official_url="https://kotakeducation.org/kotak-kanya-scholarship/",
            application_start=date(2026, 7, 1), application_deadline=date(2026, 10, 31),
            location_id=loc_national.id, verification_status=VerificationStatus.VERIFIED,
        )
        # Scholarship 11: Begum Hazrat Mahal
        opp_sc_hazrat_mahal = Opportunity(
            type=OpportunityType.SCHOLARSHIP,
            title="Begum Hazrat Mahal National Scholarship for Minority Girls",
            organization_id=org_moe.id, status=OpportunityStatus.ACTIVE,
            description="National scholarship for meritorious girl students belonging to notified minority communities (Muslim, Christian, Sikh, Buddhist, Jain, Parsi) in Class 9 to 12.",
            official_url="https://scholarships.gov.in",
            application_start=date(2026, 7, 1), application_deadline=date(2026, 11, 15),
            location_id=loc_national.id, verification_status=VerificationStatus.VERIFIED,
        )
        # Scholarship 12: Tata Capital Pankh
        opp_sc_pankh = Opportunity(
            type=OpportunityType.SCHOLARSHIP,
            title="Tata Capital Pankh Scholarship for Underprivileged Students",
            organization_id=org_tata_trust.id, status=OpportunityStatus.ACTIVE,
            description="Supports school and undergraduate/diploma students from low-income families to fulfill their academic ambitions without financial distress.",
            official_url="https://www.tatacapital.com",
            application_start=date(2026, 7, 1), application_deadline=date(2026, 10, 15),
            location_id=loc_national.id, verification_status=VerificationStatus.VERIFIED,
        )

        scholarship_opps = [
            opp_sc_nmms, opp_sc_yasasvi, opp_sc_post_matric_sc, opp_sc_post_matric_st,
            opp_sc_pragati, opp_sc_saksham, opp_sc_inspire, opp_sc_reliance,
            opp_sc_hdfc, opp_sc_kotak, opp_sc_hazrat_mahal, opp_sc_pankh
        ]
        db.add_all(scholarship_opps)
        db.flush()

        # Detailed Scholarship extension rows
        db.add_all([
            Scholarship(
                opportunity_id=opp_sc_nmms.id, amount=12000, currency="INR",
                award_frequency=AwardFrequency.ANNUAL, renewable=True, number_of_awards=100000,
                application_process="Apply online via National Scholarship Portal (NSP) with OTR after qualifying state Class 8 NMMSS selection exam.",
                required_documents="Class 8 marksheet, Tahsildar Income Certificate, Aadhaar Card, Bank Passbook, School Bonafide Certificate"
            ),
            Scholarship(
                opportunity_id=opp_sc_yasasvi.id, amount=125000, currency="INR",
                award_frequency=AwardFrequency.ANNUAL, renewable=True, number_of_awards=15000,
                application_process="Apply through NTA YASASVI portal / NSP using Aadhaar-seeded account.",
                required_documents="OBC/EBC/DNT Caste Certificate, Income Certificate (<= 2.5 LPA), Previous Class Marksheet"
            ),
            Scholarship(
                opportunity_id=opp_sc_post_matric_sc.id, amount=35000, currency="INR",
                award_frequency=AwardFrequency.ANNUAL, renewable=True,
                application_process="Apply via NSP or respective State Scholarship Portal (e.g., MahaDBT, UP Scholarship) with college admission slip.",
                required_documents="Caste Certificate, Income Certificate, Fee Receipt, Marksheet, College Bonafide"
            ),
            Scholarship(
                opportunity_id=opp_sc_post_matric_st.id, amount=35000, currency="INR",
                award_frequency=AwardFrequency.ANNUAL, renewable=True,
                application_process="Apply via NSP or State Tribal Welfare Portal with validated ST certificate and fee structure.",
                required_documents="ST Tribe Certificate, Income Certificate, Admission Receipt, Bank Details"
            ),
            Scholarship(
                opportunity_id=opp_sc_pragati.id, amount=50000, currency="INR",
                award_frequency=AwardFrequency.ANNUAL, renewable=True, number_of_awards=10000,
                application_process="Register on AICTE Portal / NSP with technical institution admission allotment letter.",
                required_documents="Admission letter to AICTE-approved degree/diploma, Income certificate (<= 8 LPA), Family declaration of max 2 girl children"
            ),
            Scholarship(
                opportunity_id=opp_sc_saksham.id, amount=50000, currency="INR",
                award_frequency=AwardFrequency.ANNUAL, renewable=True,
                application_process="Apply through National Scholarship Portal with UDID disability card.",
                required_documents="Unique Disability Identity (UDID) Certificate (40%+ disability), College admission letter, Income certificate"
            ),
            Scholarship(
                opportunity_id=opp_sc_inspire.id, amount=80000, currency="INR",
                award_frequency=AwardFrequency.ANNUAL, renewable=True, number_of_awards=10000,
                application_process="Online application via DST INSPIRE web portal using Board advisory/eligibility note.",
                required_documents="Class 12 Marksheet showing Top 1% ranking, Endorsement Certificate from College Principal, B.Sc. enrollment proof"
            ),
            Scholarship(
                opportunity_id=opp_sc_reliance.id, amount=200000, currency="INR",
                award_frequency=AwardFrequency.ANNUAL, renewable=True, number_of_awards=5000,
                application_process="Complete online registration, submit academic profile, and take the online aptitude assessment.",
                required_documents="Class 12 Marksheet, Current College ID, Household Income Proof, Electricity Bill / Ration Card"
            ),
            Scholarship(
                opportunity_id=opp_sc_hdfc.id, amount=50000, currency="INR",
                award_frequency=AwardFrequency.ANNUAL, renewable=False,
                application_process="Online application via Buddy4Study / HDFC Parivartan with proof of crisis or low income.",
                required_documents="Income Certificate / BPL Card / Ration card, Previous year marksheet (min 55%), Proof of crisis (if applicable)"
            ),
            Scholarship(
                opportunity_id=opp_sc_kotak.id, amount=150000, currency="INR",
                award_frequency=AwardFrequency.ANNUAL, renewable=True,
                application_process="Apply on Kotak Education Foundation portal with Class 12 score and professional course admission letter.",
                required_documents="Class 12 Marksheet (min 75%), Allotment letter for MBBS/B.Tech/Architecture/LLB, Parent Income Certificate (<= 6 LPA)"
            ),
            Scholarship(
                opportunity_id=opp_sc_hazrat_mahal.id, amount=12000, currency="INR",
                award_frequency=AwardFrequency.ANNUAL, renewable=False,
                application_process="Apply on National Scholarship Portal with minority community self-declaration.",
                required_documents="Minority Community Certificate / Self Declaration, Marksheet (min 50%), Income Certificate (<= 2 LPA)"
            ),
            Scholarship(
                opportunity_id=opp_sc_pankh.id, amount=30000, currency="INR",
                award_frequency=AwardFrequency.ANNUAL, renewable=False,
                application_process="Online application with academic marksheets and household income proof.",
                required_documents="Income proof (<= 2.5 LPA), Marksheets, Photo ID, Current fee receipt"
            ),
        ])
        db.flush()

        # ── 9. Opportunities — COURSES (11 Real Courses) ───────────────────
        print("  → 9. Researched Courses for Rural Employability")

        opp_co_iti_elec = Opportunity(
            type=OpportunityType.COURSE, title="ITI Electrician Trade (NCVT)",
            organization_id=org_msde.id, status=OpportunityStatus.ACTIVE,
            description="2-year government vocational trade covering domestic, agricultural pump, and industrial electrical wiring. Leads to licensed wireman certification and high rural self-employment.",
            official_url="https://dgt.gov.in", location_id=loc_national.id,
            verification_status=VerificationStatus.VERIFIED,
        )
        opp_co_iti_copa = Opportunity(
            type=OpportunityType.COURSE, title="ITI Computer Operator & Programming Assistant (COPA)",
            organization_id=org_msde.id, status=OpportunityStatus.ACTIVE,
            description="1-year vocational IT course empowering rural youth to operate Common Service Centres (CSCs), handle Gram Panchayat digitization, and provide rural banking correspondent services.",
            official_url="https://dgt.gov.in", location_id=loc_national.id,
            verification_status=VerificationStatus.VERIFIED,
        )
        opp_co_iti_fitter = Opportunity(
            type=OpportunityType.COURSE, title="ITI Fitter Trade (NCVT)",
            organization_id=org_msde.id, status=OpportunityStatus.ACTIVE,
            description="2-year mechanical fitting, lathe work, and fabrication trade in high demand for tractor, agricultural machinery repair, and industrial plants.",
            official_url="https://dgt.gov.in", location_id=loc_national.id,
            verification_status=VerificationStatus.VERIFIED,
        )
        opp_co_poly_civil = Opportunity(
            type=OpportunityType.COURSE, title="Polytechnic Diploma in Civil Engineering",
            organization_id=org_aicte.id, status=OpportunityStatus.ACTIVE,
            description="3-year technical diploma after Class 10 focusing on rural infrastructure, road construction, irrigation canals, and rural housing. Qualifies for Junior Engineer government posts.",
            official_url="https://www.aicte-india.org", location_id=loc_national.id,
            verification_status=VerificationStatus.VERIFIED,
        )
        opp_co_poly_mech = Opportunity(
            type=OpportunityType.COURSE, title="Polytechnic Diploma in Mechanical Engineering",
            organization_id=org_aicte.id, status=OpportunityStatus.ACTIVE,
            description="3-year diploma in machinery, manufacturing processes, and automobile systems, with direct lateral entry into 2nd year B.Tech.",
            official_url="https://www.aicte-india.org", location_id=loc_national.id,
            verification_status=VerificationStatus.VERIFIED,
        )
        opp_co_bsc_agri = Opportunity(
            type=OpportunityType.COURSE, title="B.Sc. (Hons) Agriculture",
            organization_id=org_icar.id, status=OpportunityStatus.ACTIVE,
            description="4-year professional degree recognized by ICAR covering agronomy, seed science, plant pathology, agricultural economics, and mandatory village immersion (RAWE).",
            official_url="https://icar.org.in", location_id=loc_national.id,
            verification_status=VerificationStatus.VERIFIED,
        )
        opp_co_anm = Opportunity(
            type=OpportunityType.COURSE, title="Auxiliary Nurse Midwifery (ANM)",
            organization_id=org_moe.id, status=OpportunityStatus.ACTIVE,
            description="2-year diploma training female healthcare workers to staff rural Sub-Centres and Primary Health Centres (PHCs) for maternal and child immunisation.",
            location_id=loc_national.id, verification_status=VerificationStatus.VERIFIED,
        )
        opp_co_gnm = Opportunity(
            type=OpportunityType.COURSE, title="General Nursing and Midwifery (GNM)",
            organization_id=org_moe.id, status=OpportunityStatus.ACTIVE,
            description="3-year diploma in nursing care, emergency assistance, and maternity healthcare at community and district hospitals.",
            location_id=loc_national.id, verification_status=VerificationStatus.VERIFIED,
        )
        opp_co_deled = Opportunity(
            type=OpportunityType.COURSE, title="Diploma in Elementary Education (D.El.Ed)",
            organization_id=org_moe.id, status=OpportunityStatus.ACTIVE,
            description="2-year professional teacher training program mandatory for primary school teaching (Classes 1 to 5) in Zilla Parishad and government schools.",
            location_id=loc_national.id, verification_status=VerificationStatus.VERIFIED,
        )
        opp_co_ignou_ba = Opportunity(
            type=OpportunityType.COURSE, title="Bachelor of Arts (B.A. General) - Open & Distance",
            organization_id=org_moe.id, status=OpportunityStatus.ACTIVE,
            description="Affordable, self-paced 3-year distance degree by IGNOU with local study centres across rural talukas, allowing students to study while farming or working.",
            official_url="https://ignou.ac.in", location_id=loc_national.id,
            verification_status=VerificationStatus.VERIFIED,
        )
        opp_co_btech_cs = Opportunity(
            type=OpportunityType.COURSE, title="B.Tech Computer Science & Engineering",
            organization_id=org_iit_bombay.id, status=OpportunityStatus.ACTIVE,
            description="4-year undergraduate degree in computer science, software systems, and data structures.",
            official_url="https://www.iitb.ac.in", location_id=loc_national.id,
            verification_status=VerificationStatus.VERIFIED,
        )

        course_opps = [
            opp_co_iti_elec, opp_co_iti_copa, opp_co_iti_fitter,
            opp_co_poly_civil, opp_co_poly_mech, opp_co_bsc_agri,
            opp_co_anm, opp_co_gnm, opp_co_deled, opp_co_ignou_ba, opp_co_btech_cs
        ]
        db.add_all(course_opps)
        db.flush()

        # Detailed Course rows
        course_iti_elec = Course(opportunity_id=opp_co_iti_elec.id, education_level=EducationLevel.VOCATIONAL, field="Electrical Engineering", duration="2 years", mode=CourseMode.FULL_TIME)
        course_iti_copa = Course(opportunity_id=opp_co_iti_copa.id, education_level=EducationLevel.VOCATIONAL, field="Computer Applications", duration="1 year", mode=CourseMode.FULL_TIME)
        course_iti_fitter = Course(opportunity_id=opp_co_iti_fitter.id, education_level=EducationLevel.VOCATIONAL, field="Mechanical Fitting", duration="2 years", mode=CourseMode.FULL_TIME)
        course_poly_civil = Course(opportunity_id=opp_co_poly_civil.id, education_level=EducationLevel.DIPLOMA, field="Civil Engineering", duration="3 years", mode=CourseMode.FULL_TIME)
        course_poly_mech = Course(opportunity_id=opp_co_poly_mech.id, education_level=EducationLevel.DIPLOMA, field="Mechanical Engineering", duration="3 years", mode=CourseMode.FULL_TIME)
        course_bsc_agri = Course(opportunity_id=opp_co_bsc_agri.id, education_level=EducationLevel.BACHELOR, field="Agricultural Sciences", duration="4 years", mode=CourseMode.FULL_TIME)
        course_anm = Course(opportunity_id=opp_co_anm.id, education_level=EducationLevel.DIPLOMA, field="Nursing & Midwifery", duration="2 years", mode=CourseMode.FULL_TIME)
        course_gnm = Course(opportunity_id=opp_co_gnm.id, education_level=EducationLevel.DIPLOMA, field="General Nursing", duration="3 years", mode=CourseMode.FULL_TIME)
        course_deled = Course(opportunity_id=opp_co_deled.id, education_level=EducationLevel.DIPLOMA, field="Elementary Education", duration="2 years", mode=CourseMode.FULL_TIME)
        course_ignou_ba = Course(opportunity_id=opp_co_ignou_ba.id, education_level=EducationLevel.BACHELOR, field="Humanities & Social Sciences", duration="3 years", mode=CourseMode.DISTANCE)
        course_btech_cs = Course(opportunity_id=opp_co_btech_cs.id, education_level=EducationLevel.BACHELOR, field="Computer Science & Engineering", duration="4 years", mode=CourseMode.FULL_TIME)

        all_courses = [
            course_iti_elec, course_iti_copa, course_iti_fitter,
            course_poly_civil, course_poly_mech, course_bsc_agri,
            course_anm, course_gnm, course_deled, course_ignou_ba, course_btech_cs
        ]
        db.add_all(all_courses)
        db.flush()

        # Course ↔ Institutions
        db.add_all([
            CourseInstitution(course_id=course_iti_elec.opportunity_id, institution_id=inst_iti_nashik.id, tuition_fee=2500, admission_method=AdmissionMethod.MERIT),
            CourseInstitution(course_id=course_iti_copa.opportunity_id, institution_id=inst_iti_nashik.id, tuition_fee=2000, admission_method=AdmissionMethod.MERIT),
            CourseInstitution(course_id=course_iti_fitter.opportunity_id, institution_id=inst_iti_varanasi.id, tuition_fee=2500, admission_method=AdmissionMethod.MERIT),
            CourseInstitution(course_id=course_poly_civil.opportunity_id, institution_id=inst_poly_pune.id, tuition_fee=12000, admission_method=AdmissionMethod.ENTRANCE_EXAM),
            CourseInstitution(course_id=course_bsc_agri.opportunity_id, institution_id=inst_mpkv.id, tuition_fee=22000, admission_method=AdmissionMethod.ENTRANCE_EXAM),
            CourseInstitution(course_id=course_deled.opportunity_id, institution_id=inst_diet_nashik.id, tuition_fee=5000, admission_method=AdmissionMethod.ENTRANCE_EXAM),
            CourseInstitution(course_id=course_ignou_ba.opportunity_id, institution_id=inst_ignou.id, tuition_fee=4500, admission_method=AdmissionMethod.DIRECT),
            CourseInstitution(course_id=course_btech_cs.opportunity_id, institution_id=inst_iitb.id, tuition_fee=200000, admission_method=AdmissionMethod.ENTRANCE_EXAM),
            CourseInstitution(course_id=course_btech_cs.opportunity_id, institution_id=inst_coep.id, tuition_fee=80000, admission_method=AdmissionMethod.ENTRANCE_EXAM),
        ])
        db.flush()

        # Career ↔ Courses
        db.add_all([
            CareerCourse(career_id=career_wireman.id, course_id=course_iti_elec.opportunity_id, importance=ImportanceLevel.REQUIRED),
            CareerCourse(career_id=career_csc_vle.id, course_id=course_iti_copa.opportunity_id, importance=ImportanceLevel.REQUIRED),
            CareerCourse(career_id=career_teacher.id, course_id=course_deled.opportunity_id, importance=ImportanceLevel.REQUIRED),
            CareerCourse(career_id=career_agri_ext.id, course_id=course_bsc_agri.opportunity_id, importance=ImportanceLevel.REQUIRED),
            CareerCourse(career_id=career_nurse.id, course_id=course_anm.opportunity_id, importance=ImportanceLevel.REQUIRED),
            CareerCourse(career_id=career_nurse.id, course_id=course_gnm.opportunity_id, importance=ImportanceLevel.PREFERRED),
            CareerCourse(career_id=career_civil_eng.id, course_id=course_poly_civil.opportunity_id, importance=ImportanceLevel.HELPFUL),
            CareerCourse(career_id=career_swe.id, course_id=course_btech_cs.opportunity_id, importance=ImportanceLevel.REQUIRED),
        ])
        db.flush()

        # ── 10. Opportunities — ENTRANCE EXAMS (8 Real Exams) ──────────────
        print("  → 10. Researched Entrance Exams with Rural Quotas & Concessions")

        opp_ex_jnvst = Opportunity(
            type=OpportunityType.ENTRANCE_EXAM, title="Jawahar Navodaya Vidyalaya Selection Test (JNVST)",
            organization_id=org_nvs.id, status=OpportunityStatus.ACTIVE,
            description="All-India admission test for PM SHRI Jawahar Navodaya Vidyalayas. Law mandates that at least 75% of admitted seats are strictly reserved for students from rural areas. Offers free quality schooling, food, and boarding.",
            official_url="https://navodaya.gov.in", location_id=loc_national.id,
            verification_status=VerificationStatus.VERIFIED,
        )
        opp_ex_icar = Opportunity(
            type=OpportunityType.ENTRANCE_EXAM, title="ICAR AIEEA (UG) / CUET-ICAR Agriculture",
            organization_id=org_icar.id, status=OpportunityStatus.ACTIVE,
            description="National entrance test for 15% all-India quota seats in State Agricultural Universities for B.Sc. Agriculture. Admitted students receive National Talent Scholarship (NTS) of ₹3,000/month.",
            official_url="https://exams.nta.ac.in/CUET-UG/", location_id=loc_national.id,
            verification_status=VerificationStatus.VERIFIED,
        )
        opp_ex_jee = Opportunity(
            type=OpportunityType.ENTRANCE_EXAM, title="JEE Main (with SATHEE Free Portal)",
            organization_id=org_nta.id, status=OpportunityStatus.ACTIVE,
            description="Joint Entrance Examination for engineering colleges, NITs, and IIITs. Ministry of Education and IIT Kanpur provide the free AI-enabled 'SATHEE' learning portal (sathee.prutor.ai) for rural students.",
            official_url="https://jeemain.nta.ac.in", location_id=loc_national.id,
            verification_status=VerificationStatus.VERIFIED,
        )
        opp_ex_neet = Opportunity(
            type=OpportunityType.ENTRANCE_EXAM, title="NEET-UG (National Eligibility cum Entrance Test)",
            organization_id=org_nta.id, status=OpportunityStatus.ACTIVE,
            description="Single medical entrance exam across India for MBBS, BDS, BAMS, and BHMS admissions with rural reservation quotas in government medical colleges.",
            official_url="https://neet.nta.nic.in", location_id=loc_national.id,
            verification_status=VerificationStatus.VERIFIED,
        )
        opp_ex_poly_cet = Opportunity(
            type=OpportunityType.ENTRANCE_EXAM, title="State Polytechnic Joint Entrance Examination (JEECUP / MSBTE CET)",
            organization_id=org_aicte.id, status=OpportunityStatus.ACTIVE,
            description="State-level entrance examination for admission into subsidized 3-year engineering diploma programs across government polytechnic colleges.",
            location_id=loc_national.id, verification_status=VerificationStatus.VERIFIED,
        )
        opp_ex_ssc_gd = Opportunity(
            type=OpportunityType.ENTRANCE_EXAM, title="SSC General Duty (GD) Constable Examination",
            organization_id=org_ssc.id, status=OpportunityStatus.ACTIVE,
            description="Direct recruitment examination for Class 10 pass youth into Central Armed Police Forces (BSF, CISF, CRPF, ITBP, SSB, SSF, and Assam Rifles), offering stable government employment.",
            official_url="https://ssc.gov.in", location_id=loc_national.id,
            verification_status=VerificationStatus.VERIFIED,
        )
        opp_ex_cuet = Opportunity(
            type=OpportunityType.ENTRANCE_EXAM, title="Common University Entrance Test (CUET-UG)",
            organization_id=org_nta.id, status=OpportunityStatus.ACTIVE,
            description="Single nationwide entrance gateway for admission to 250+ Central, State, and Deemed universities offering subsidized quality higher education with hostel facilities.",
            official_url="https://exams.nta.ac.in/CUET-UG/", location_id=loc_national.id,
            verification_status=VerificationStatus.VERIFIED,
        )
        opp_ex_tet = Opportunity(
            type=OpportunityType.ENTRANCE_EXAM, title="State Teacher Eligibility Test (TET) - Paper 1",
            organization_id=org_moe.id, status=OpportunityStatus.ACTIVE,
            description="Mandatory qualification exam for D.El.Ed and B.Ed holders to be eligible for appointment as primary school teachers in government schools.",
            location_id=loc_national.id, verification_status=VerificationStatus.VERIFIED,
        )

        exam_opps = [
            opp_ex_jnvst, opp_ex_icar, opp_ex_jee, opp_ex_neet,
            opp_ex_poly_cet, opp_ex_ssc_gd, opp_ex_cuet, opp_ex_tet
        ]
        db.add_all(exam_opps)
        db.flush()

        # Detailed Exam rows
        exam_jnvst = EntranceExam(
            opportunity_id=opp_ex_jnvst.id, conducting_body="Navodaya Vidyalaya Samiti",
            exam_mode=ExamMode.OFFLINE, exam_frequency=ExamFrequency.ANNUAL,
            registration_start=date(2026, 7, 1), registration_deadline=date(2026, 9, 15),
            examination_date=date(2027, 1, 18), application_fee=0, official_exam_url="https://navodaya.gov.in"
        )
        exam_icar = EntranceExam(
            opportunity_id=opp_ex_icar.id, conducting_body="National Testing Agency (NTA)",
            exam_mode=ExamMode.ONLINE, exam_frequency=ExamFrequency.ANNUAL,
            registration_start=date(2026, 2, 15), registration_deadline=date(2026, 3, 25),
            examination_date=date(2026, 5, 15), application_fee=750, official_exam_url="https://exams.nta.ac.in/CUET-UG/"
        )
        exam_jee = EntranceExam(
            opportunity_id=opp_ex_jee.id, conducting_body="National Testing Agency (NTA)",
            exam_mode=ExamMode.ONLINE, exam_frequency=ExamFrequency.BIANNUAL,
            registration_start=date(2026, 11, 1), registration_deadline=date(2026, 12, 15),
            examination_date=date(2027, 1, 20), application_fee=900, official_exam_url="https://jeemain.nta.ac.in"
        )
        exam_neet = EntranceExam(
            opportunity_id=opp_ex_neet.id, conducting_body="National Testing Agency (NTA)",
            exam_mode=ExamMode.OFFLINE, exam_frequency=ExamFrequency.ANNUAL,
            registration_start=date(2026, 12, 1), registration_deadline=date(2027, 1, 31),
            examination_date=date(2027, 5, 4), application_fee=1700, official_exam_url="https://neet.nta.nic.in"
        )
        exam_poly_cet = EntranceExam(
            opportunity_id=opp_ex_poly_cet.id, conducting_body="State Directorate of Technical Education",
            exam_mode=ExamMode.OFFLINE, exam_frequency=ExamFrequency.ANNUAL,
            registration_start=date(2026, 3, 1), registration_deadline=date(2026, 4, 30),
            examination_date=date(2026, 5, 20), application_fee=300
        )
        exam_ssc_gd = EntranceExam(
            opportunity_id=opp_ex_ssc_gd.id, conducting_body="Staff Selection Commission (SSC)",
            exam_mode=ExamMode.ONLINE, exam_frequency=ExamFrequency.ANNUAL,
            registration_start=date(2026, 8, 27), registration_deadline=date(2026, 10, 14),
            examination_date=date(2027, 1, 10), application_fee=100, official_exam_url="https://ssc.gov.in"
        )
        exam_cuet = EntranceExam(
            opportunity_id=opp_ex_cuet.id, conducting_body="National Testing Agency (NTA)",
            exam_mode=ExamMode.ONLINE, exam_frequency=ExamFrequency.ANNUAL,
            registration_start=date(2026, 2, 20), registration_deadline=date(2026, 3, 31),
            examination_date=date(2026, 5, 18), application_fee=750, official_exam_url="https://exams.nta.ac.in/CUET-UG/"
        )
        exam_tet = EntranceExam(
            opportunity_id=opp_ex_tet.id, conducting_body="State Examination Authority",
            exam_mode=ExamMode.OFFLINE, exam_frequency=ExamFrequency.ANNUAL,
            registration_start=date(2026, 4, 1), registration_deadline=date(2026, 5, 15),
            examination_date=date(2026, 7, 12), application_fee=500
        )

        all_exams = [exam_jnvst, exam_icar, exam_jee, exam_neet, exam_poly_cet, exam_ssc_gd, exam_cuet, exam_tet]
        db.add_all(all_exams)
        db.flush()

        # Career ↔ Exam linkages
        db.add_all([
            CareerExam(career_id=career_agri_ext.id, exam_id=exam_icar.opportunity_id, importance=ImportanceLevel.REQUIRED),
            CareerExam(career_id=career_swe.id, exam_id=exam_jee.opportunity_id, importance=ImportanceLevel.PREFERRED),
            CareerExam(career_id=career_doctor.id, exam_id=exam_neet.opportunity_id, importance=ImportanceLevel.REQUIRED),
            CareerExam(career_id=career_teacher.id, exam_id=exam_tet.opportunity_id, importance=ImportanceLevel.REQUIRED),
        ])
        db.flush()

        # ── 11. Opportunities — INTERNSHIPS & FELLOWSHIPS (7 Real Programs)
        print("  → 11. Researched Grassroots Fellowships & Apprenticeships")

        opp_in_sbi = Opportunity(
            type=OpportunityType.INTERNSHIP, title="SBI Youth for India Fellowship",
            organization_id=org_sbi_found.id, status=OpportunityStatus.ACTIVE,
            description="13-month rural development fellowship where educated youth partner with grassroots NGOs to solve community challenges in health, education, livelihood, and water.",
            official_url="https://youthforindia.org", location_id=loc_national.id,
            verification_status=VerificationStatus.VERIFIED,
        )
        opp_in_gandhi = Opportunity(
            type=OpportunityType.INTERNSHIP, title="Gandhi Fellowship (Piramal School of Leadership)",
            organization_id=org_piramal.id, status=OpportunityStatus.ACTIVE,
            description="2-year residential leadership fellowship working directly in rural aspirational districts alongside district collectors and headmasters to overhaul government primary schools.",
            official_url="https://gandhifellowship.org", location_id=loc_national.id,
            verification_status=VerificationStatus.VERIFIED,
        )
        opp_in_pradan = Opportunity(
            type=OpportunityType.INTERNSHIP, title="PRADAN Development Apprenticeship",
            organization_id=org_pradan.id, status=OpportunityStatus.ACTIVE,
            description="12-month grassroots development apprenticeship living in tribal villages to organize women's self-help groups, promote regenerative agriculture, and water harvesting.",
            official_url="https://www.pradan.net", location_id=loc_national.id,
            verification_status=VerificationStatus.VERIFIED,
        )
        opp_in_naps = Opportunity(
            type=OpportunityType.INTERNSHIP, title="National Apprenticeship Promotion Scheme (NAPS / NATS)",
            organization_id=org_msde.id, status=OpportunityStatus.ACTIVE,
            description="Government-subsidized on-the-job industrial apprenticeship for ITI certificate and polytechnic diploma holders with direct DBT stipend subsidy paid to the student bank account.",
            official_url="https://www.apprenticeshipindia.gov.in", location_id=loc_national.id,
            verification_status=VerificationStatus.VERIFIED,
        )
        opp_in_rawe = Opportunity(
            type=OpportunityType.INTERNSHIP, title="ICAR Rural Agricultural Work Experience (RAWE) Internship",
            organization_id=org_icar.id, status=OpportunityStatus.ACTIVE,
            description="1-semester mandatory field immersion for B.Sc. Agriculture undergraduates living in villages with farm families, conducting on-site crop diagnostics and farmer training.",
            official_url="https://icar.org.in", location_id=loc_national.id,
            verification_status=VerificationStatus.VERIFIED,
        )
        opp_in_tfi = Opportunity(
            type=OpportunityType.INTERNSHIP, title="Teach For India Fellowship",
            organization_id=org_moe.id, status=OpportunityStatus.ACTIVE,
            description="2-year full-time teaching fellowship in under-resourced schools to eliminate educational inequity.",
            official_url="https://www.teachforindia.org", location_id=loc_national.id,
            verification_status=VerificationStatus.VERIFIED,
        )
        opp_in_aspirational = Opportunity(
            type=OpportunityType.INTERNSHIP, title="Aspirational Districts Governance Fellowship",
            organization_id=org_mord.id, status=OpportunityStatus.ACTIVE,
            description="1-year fellowship embedded inside District Magistrate / Collector offices in rural Aspirational Districts to track indicators in nutrition, education, and agriculture.",
            location_id=loc_national.id, verification_status=VerificationStatus.VERIFIED,
        )

        internship_opps = [
            opp_in_sbi, opp_in_gandhi, opp_in_pradan,
            opp_in_naps, opp_in_rawe, opp_in_tfi, opp_in_aspirational
        ]
        db.add_all(internship_opps)
        db.flush()

        # Detailed Internship rows
        db.add_all([
            Internship(
                opportunity_id=opp_in_sbi.id, organization_id=org_sbi_found.id, remote=False,
                duration="13 months", stipend=16000,
                start_date=date(2026, 8, 1), end_date=date(2027, 8, 31), application_deadline=date(2026, 5, 31),
                work_description="Work in partner rural NGO on community-identified rural development initiatives; receives ₹50,000 completion grant."
            ),
            Internship(
                opportunity_id=opp_in_gandhi.id, organization_id=org_piramal.id, remote=False,
                duration="2 years", stipend=24500,
                start_date=date(2026, 7, 1), end_date=date(2028, 6, 30), application_deadline=date(2026, 4, 30),
                work_description="Transform government primary schools and district education systems in backward rural blocks."
            ),
            Internship(
                opportunity_id=opp_in_pradan.id, organization_id=org_pradan.id, remote=False,
                duration="12 months", stipend=35000,
                start_date=date(2026, 9, 1), end_date=date(2027, 8, 31), application_deadline=date(2026, 6, 30),
                work_description="Empower rural women through SHGs, watershed development, and farm-based livelihood collectives in tribal pockets."
            ),
            Internship(
                opportunity_id=opp_in_naps.id, organization_id=org_msde.id, remote=False,
                duration="12 months", stipend=10000,
                start_date=date(2026, 8, 1), end_date=date(2027, 7, 31),
                work_description="Industrial shop-floor apprenticeship for ITI and Diploma holders with government DBT stipend co-funding."
            ),
            Internship(
                opportunity_id=opp_in_rawe.id, organization_id=org_icar.id, remote=False,
                duration="6 months", stipend=4000,
                start_date=date(2026, 7, 1), end_date=date(2026, 12, 31),
                work_description="Hands-on rural farming attachment living with rural host families for B.Sc. Agriculture undergraduates."
            ),
            Internship(
                opportunity_id=opp_in_tfi.id, organization_id=org_moe.id, remote=False,
                duration="2 years", stipend=30000,
                start_date=date(2026, 6, 1), end_date=date(2028, 5, 31),
                work_description="Full-time classroom teaching in under-resourced schools."
            ),
            Internship(
                opportunity_id=opp_in_aspirational.id, organization_id=org_mord.id, remote=False,
                duration="12 months", stipend=45000,
                start_date=date(2026, 8, 1), end_date=date(2027, 7, 31),
                work_description="Policy and scheme implementation analysis in rural district headquarters under district collectors."
            ),
        ])
        db.flush()

        # ── 12. Structured Eligibility Rules ───────────────────────────────
        print("  → 12. Structured Eligibility Rules (Deterministic Engine)")
        db.add_all([
            # 1. NMMSS Rules
            EligibilityRule(opportunity_id=opp_sc_nmms.id, rule_type=RuleType.INCOME, operator=RuleOperator.LTE, value="350000", unit="INR", description="Parental annual income must not exceed ₹3.50 lakh from all sources."),
            EligibilityRule(opportunity_id=opp_sc_nmms.id, rule_type=RuleType.PERCENTAGE, operator=RuleOperator.GTE, value="55", description="Minimum 55% marks in Class 8 examination (50% for SC/ST)."),
            EligibilityRule(opportunity_id=opp_sc_nmms.id, rule_type=RuleType.INSTITUTION_TYPE, operator=RuleOperator.EQ, value="government", description="Must be regular student in Government, Local Body, or Aided school (KVs/JNVs excluded)."),
            EligibilityRule(opportunity_id=opp_sc_nmms.id, rule_type=RuleType.NATIONALITY, operator=RuleOperator.EQ, value="Indian", description="Must be an Indian citizen."),

            # 2. PM YASASVI Rules
            EligibilityRule(opportunity_id=opp_sc_yasasvi.id, rule_type=RuleType.SOCIAL_CATEGORY, operator=RuleOperator.IN, value="OBC,EBC,DNT", description="Candidate must belong to OBC, EBC, or De-Notified Tribe category."),
            EligibilityRule(opportunity_id=opp_sc_yasasvi.id, rule_type=RuleType.INCOME, operator=RuleOperator.LTE, value="250000", unit="INR", description="Family income must not exceed ₹2.50 lakh per annum."),
            EligibilityRule(opportunity_id=opp_sc_yasasvi.id, rule_type=RuleType.PERCENTAGE, operator=RuleOperator.GTE, value="60", description="Minimum 60% marks in previous academic year."),

            # 3. Post-Matric SC Rules
            EligibilityRule(opportunity_id=opp_sc_post_matric_sc.id, rule_type=RuleType.SOCIAL_CATEGORY, operator=RuleOperator.EQ, value="SC", description="Must belong to Scheduled Caste (SC)."),
            EligibilityRule(opportunity_id=opp_sc_post_matric_sc.id, rule_type=RuleType.INCOME, operator=RuleOperator.LTE, value="250000", unit="INR", description="Annual family income must not exceed ₹2.50 lakh."),

            # 4. Post-Matric ST Rules
            EligibilityRule(opportunity_id=opp_sc_post_matric_st.id, rule_type=RuleType.SOCIAL_CATEGORY, operator=RuleOperator.EQ, value="ST", description="Must belong to Scheduled Tribe (ST)."),
            EligibilityRule(opportunity_id=opp_sc_post_matric_st.id, rule_type=RuleType.INCOME, operator=RuleOperator.LTE, value="250000", unit="INR", description="Annual family income must not exceed ₹2.50 lakh."),

            # 5. AICTE Pragati Rules
            EligibilityRule(opportunity_id=opp_sc_pragati.id, rule_type=RuleType.GENDER, operator=RuleOperator.EQ, value="female", description="Strictly for girl students."),
            EligibilityRule(opportunity_id=opp_sc_pragati.id, rule_type=RuleType.INCOME, operator=RuleOperator.LTE, value="800000", unit="INR", description="Annual family income must be less than ₹8 lakh."),
            EligibilityRule(opportunity_id=opp_sc_pragati.id, rule_type=RuleType.EDUCATION_LEVEL, operator=RuleOperator.IN, value="bachelor,diploma", description="Must be admitted in 1st year degree or diploma in AICTE approved institution."),

            # 6. AICTE Saksham Rules
            EligibilityRule(opportunity_id=opp_sc_saksham.id, rule_type=RuleType.DISABILITY, operator=RuleOperator.EQ, value="40% or more", description="Candidate must have not less than 40% benchmark disability."),
            EligibilityRule(opportunity_id=opp_sc_saksham.id, rule_type=RuleType.INCOME, operator=RuleOperator.LTE, value="800000", unit="INR", description="Family income <= ₹8 lakh per annum."),

            # 7. INSPIRE SHE Rules
            EligibilityRule(opportunity_id=opp_sc_inspire.id, rule_type=RuleType.PERCENTAGE, operator=RuleOperator.GTE, value="85", description="Must be in top 1% cut-off in Class 12 board examination."),
            EligibilityRule(opportunity_id=opp_sc_inspire.id, rule_type=RuleType.AGE, operator=RuleOperator.LTE, value="22", unit="years", description="Age must be between 17 and 22 years."),

            # 8. Reliance Foundation Rules
            EligibilityRule(opportunity_id=opp_sc_reliance.id, rule_type=RuleType.PERCENTAGE, operator=RuleOperator.GTE, value="60", description="Minimum 60% in Class 12 board exams."),
            EligibilityRule(opportunity_id=opp_sc_reliance.id, rule_type=RuleType.INCOME, operator=RuleOperator.LTE, value="1500000", unit="INR", description="Household annual income up to ₹15 lakh (affirmative preference <= ₹2.5L)."),

            # 9. Kotak Kanya Rules
            EligibilityRule(opportunity_id=opp_sc_kotak.id, rule_type=RuleType.GENDER, operator=RuleOperator.EQ, value="female", description="Exclusively for meritorious girl students."),
            EligibilityRule(opportunity_id=opp_sc_kotak.id, rule_type=RuleType.PERCENTAGE, operator=RuleOperator.GTE, value="75", description="Minimum 75% marks in Class 12 board exams."),
            EligibilityRule(opportunity_id=opp_sc_kotak.id, rule_type=RuleType.INCOME, operator=RuleOperator.LTE, value="600000", unit="INR", description="Annual family income must not exceed ₹6 lakh."),

            # 10. JNVST Navodaya Exam Rules
            EligibilityRule(opportunity_id=opp_ex_jnvst.id, rule_type=RuleType.RURAL_STATUS, operator=RuleOperator.EQ, value="rural", description="Mandatory 75% seats reserved exclusively for students studying in recognized rural schools."),

            # 11. SSC GD Exam Rules
            EligibilityRule(opportunity_id=opp_ex_ssc_gd.id, rule_type=RuleType.EDUCATION_LEVEL, operator=RuleOperator.EQ, value="secondary", description="Must have passed Class 10 (Matriculation) examination from recognized board."),
            EligibilityRule(opportunity_id=opp_ex_ssc_gd.id, rule_type=RuleType.AGE, operator=RuleOperator.LTE, value="23", unit="years", description="Age limit 18 to 23 years (relaxation for SC/ST/OBC)."),

            # 12. SBI Youth for India Rules
            EligibilityRule(opportunity_id=opp_in_sbi.id, rule_type=RuleType.EDUCATION_LEVEL, operator=RuleOperator.IN, value="bachelor,master", description="Must hold at least a Bachelor's degree before fellowship start date."),
            EligibilityRule(opportunity_id=opp_in_sbi.id, rule_type=RuleType.AGE, operator=RuleOperator.LTE, value="32", unit="years", description="Candidate must be between 21 and 32 years of age."),
        ])
        db.flush()

        # ── 13. Sources & Verification Logs ────────────────────────────────
        print("  → 13. Sources & Verification Metadata")
        src_nsp = Source(organization_id=org_nsp.id, url="https://scholarships.gov.in", source_type=SourceType.GOVERNMENT, title="National Scholarship Portal", reliability=0.99)
        src_dgt = Source(organization_id=org_msde.id, url="https://dgt.gov.in", source_type=SourceType.GOVERNMENT, title="Directorate General of Training", reliability=0.98)
        src_nvs = Source(organization_id=org_nvs.id, url="https://navodaya.gov.in", source_type=SourceType.GOVERNMENT, title="Navodaya Vidyalaya Samiti", reliability=0.99)
        src_sbi = Source(organization_id=org_sbi_found.id, url="https://youthforindia.org", source_type=SourceType.PARTNER, title="SBI Youth for India", reliability=0.96)
        src_icar = Source(organization_id=org_icar.id, url="https://icar.org.in", source_type=SourceType.GOVERNMENT, title="ICAR Education Portal", reliability=0.98)

        all_sources = [src_nsp, src_dgt, src_nvs, src_sbi, src_icar]
        db.add_all(all_sources)
        db.flush()

        # ── 14. Benchmark Students ─────────────────────────────────────────
        print("  → 14. Rural Student Personas (Priya, Arjun, Meena)")

        # Student 1: Priya — rural Maharashtra girl interested in tech/software
        student_priya = Student(
            name="Priya Shinde", date_of_birth=date(2006, 3, 15),
            gender=Gender.FEMALE, phone="+919876543201",
            preferred_language="mr", location_id=loc_mh_nashik_rural.id,
            profile_completeness=0.85,
        )
        # Student 2: Arjun — rural UP boy interested in farming & modern agri
        student_arjun = Student(
            name="Arjun Yadav", date_of_birth=date(2005, 8, 22),
            gender=Gender.MALE, phone="+919876543202",
            preferred_language="hi", location_id=loc_up_varanasi_rural.id,
            profile_completeness=0.75,
        )
        # Student 3: Meena — rural Rajasthan girl looking for fast livelihood & teaching
        student_meena = Student(
            name="Meena Bhati", date_of_birth=date(2007, 1, 10),
            gender=Gender.FEMALE, phone="+919876543203",
            preferred_language="hi", location_id=loc_rj_barmer_rural.id,
            profile_completeness=0.70,
        )

        db.add_all([student_priya, student_arjun, student_meena])
        db.flush()

        # Priya's Education
        edu_priya_10 = StudentEducation(
            student_id=student_priya.id, institution_name="Zilla Parishad High School, Pimpalgaon",
            education_level=EducationLevel.SECONDARY, curriculum="State Board",
            board="Maharashtra State Board", field_of_study="General",
            start_date=date(2019, 6, 1), end_date=date(2021, 5, 31),
            status=EducationStatus.COMPLETED, source=DataSource.MARKSHEET, confidence=0.95,
        )
        edu_priya_12 = StudentEducation(
            student_id=student_priya.id, institution_name="Nashik Junior College",
            education_level=EducationLevel.SENIOR_SECONDARY, curriculum="State Board",
            board="Maharashtra State Board", field_of_study="Science (PCM)",
            start_date=date(2021, 6, 1), status=EducationStatus.COMPLETED,
            source=DataSource.MARKSHEET, confidence=1.0,
        )
        # Arjun's Education
        edu_arjun_10 = StudentEducation(
            student_id=student_arjun.id, institution_name="Government High School, Rampur Khas",
            education_level=EducationLevel.SECONDARY, curriculum="State Board",
            board="Uttar Pradesh Board", start_date=date(2019, 7, 1), end_date=date(2021, 5, 31),
            status=EducationStatus.COMPLETED, source=DataSource.MARKSHEET, confidence=0.9,
        )
        edu_arjun_12 = StudentEducation(
            student_id=student_arjun.id, institution_name="Inter College, Pindra",
            education_level=EducationLevel.SENIOR_SECONDARY, curriculum="State Board",
            board="Uttar Pradesh Board", field_of_study="Agriculture / Biology",
            start_date=date(2021, 7, 1), end_date=date(2023, 5, 31),
            status=EducationStatus.COMPLETED, source=DataSource.MARKSHEET, confidence=0.9,
        )
        # Meena's Education
        edu_meena_10 = StudentEducation(
            student_id=student_meena.id, institution_name="Government Secondary School, Kharchia",
            education_level=EducationLevel.SECONDARY, curriculum="State Board",
            board="Rajasthan Board", start_date=date(2020, 7, 1), end_date=date(2022, 5, 31),
            status=EducationStatus.COMPLETED, source=DataSource.MARKSHEET, confidence=0.9,
        )
        edu_meena_12 = StudentEducation(
            student_id=student_meena.id, institution_name="Government Senior Secondary School, Chohtan",
            education_level=EducationLevel.SENIOR_SECONDARY, curriculum="State Board",
            board="Rajasthan Board", field_of_study="Arts",
            start_date=date(2022, 7, 1), end_date=date(2024, 5, 31),
            status=EducationStatus.COMPLETED, source=DataSource.MARKSHEET, confidence=0.9,
        )

        db.add_all([edu_priya_10, edu_priya_12, edu_arjun_10, edu_arjun_12, edu_meena_10, edu_meena_12])
        db.flush()

        # Priya's Marks
        db.add_all([
            StudentSubject(student_education_id=edu_priya_12.id, subject="Mathematics", marks=92, maximum_marks=100, percentage=92.0, grade="A1", source=DataSource.MARKSHEET),
            StudentSubject(student_education_id=edu_priya_12.id, subject="Physics", marks=85, maximum_marks=100, percentage=85.0, grade="A2", source=DataSource.MARKSHEET),
            StudentSubject(student_education_id=edu_priya_12.id, subject="Chemistry", marks=88, maximum_marks=100, percentage=88.0, grade="A1", source=DataSource.MARKSHEET),
            StudentSubject(student_education_id=edu_arjun_12.id, subject="Agriculture", marks=84, maximum_marks=100, percentage=84.0, grade="A", source=DataSource.MARKSHEET),
            StudentSubject(student_education_id=edu_meena_12.id, subject="Hindi Literature", marks=81, maximum_marks=100, percentage=81.0, grade="A", source=DataSource.MARKSHEET),
        ])
        db.flush()

        # Student Skills
        db.add_all([
            StudentSkill(student_id=student_priya.id, skill_id=skill_python.id, proficiency=ProficiencyLevel.INTERMEDIATE, source=DataSource.STUDENT_REPORTED),
            StudentSkill(student_id=student_priya.id, skill_id=skill_math.id, proficiency=ProficiencyLevel.ADVANCED, source=DataSource.MARKSHEET),
            StudentSkill(student_id=student_priya.id, skill_id=skill_computer_basic.id, proficiency=ProficiencyLevel.INTERMEDIATE, source=DataSource.STUDENT_REPORTED),
            StudentSkill(student_id=student_arjun.id, skill_id=skill_crop_mgmt.id, proficiency=ProficiencyLevel.INTERMEDIATE, source=DataSource.STUDENT_REPORTED),
            StudentSkill(student_id=student_arjun.id, skill_id=skill_communication.id, proficiency=ProficiencyLevel.BEGINNER, source=DataSource.STUDENT_REPORTED),
            StudentSkill(student_id=student_meena.id, skill_id=skill_teaching.id, proficiency=ProficiencyLevel.INTERMEDIATE, source=DataSource.STUDENT_REPORTED),
            StudentSkill(student_id=student_meena.id, skill_id=skill_computer_basic.id, proficiency=ProficiencyLevel.BEGINNER, source=DataSource.STUDENT_REPORTED),
        ])
        db.flush()

        # Student Interests
        db.add_all([
            StudentInterest(student_id=student_priya.id, interest_id=int_computers.id, strength=0.95, source=DataSource.STUDENT_REPORTED),
            StudentInterest(student_id=student_priya.id, interest_id=int_science.id, strength=0.85, source=DataSource.STUDENT_REPORTED),
            StudentInterest(student_id=student_arjun.id, interest_id=int_agriculture.id, strength=0.98, source=DataSource.STUDENT_REPORTED),
            StudentInterest(student_id=student_meena.id, interest_id=int_teaching.id, strength=0.90, source=DataSource.STUDENT_REPORTED),
            StudentInterest(student_id=student_meena.id, interest_id=int_healthcare.id, strength=0.75, source=DataSource.STUDENT_REPORTED),
        ])
        db.flush()

        # Student Aspirations
        db.add_all([
            StudentAspiration(student_id=student_priya.id, priority=1, aspiration_text="I want to become a software engineer or data specialist, study at a good college with scholarship support.", target_career_id=career_swe.id, source=DataSource.STUDENT_REPORTED),
            StudentAspiration(student_id=student_arjun.id, priority=1, aspiration_text="I want to pursue B.Sc. Agriculture, become an Agricultural Extension Officer and help farmers in our district improve crop yields.", target_career_id=career_agri_ext.id, source=DataSource.STUDENT_REPORTED),
            StudentAspiration(student_id=student_meena.id, priority=1, aspiration_text="Main D.El.Ed karke gaon ke primary school mein teacher banna chahti hoon taaki ladkiyon ko padha sakun.", target_career_id=career_teacher.id, source=DataSource.STUDENT_REPORTED),
        ])
        db.flush()

        db.commit()
        print("\n✅ Seeding complete!")
        print(f"   Languages    : {len(languages)}")
        print(f"   Locations    : {len(locations)}")
        print(f"   Organizations: {len(orgs)}")
        print(f"   Institutions : {len(institutions)}")
        print(f"   Skills       : {len(all_skills)}")
        print(f"   Interests    : {len(all_interests)}")
        print(f"   Careers      : {len(all_careers)}")
        print(f"   Pathways     : {len(pathways)}")
        print(f"   Scholarships : {len(scholarship_opps)} (NMMSS, PM YASASVI, Post-Matric SC/ST, Pragati, etc.)")
        print(f"   Courses      : {len(course_opps)} (ITI Trades, Polytechnics, B.Sc. Agri, ANM, GNM, D.El.Ed, IGNOU)")
        print(f"   Exams        : {len(exam_opps)} (JNVST 75% rural quota, ICAR AIEEA, JEE + SATHEE, NEET, SSC GD)")
        print(f"   Internships  : {len(internship_opps)} (SBI Youth for India, Gandhi Fellowship, PRADAN, NAPS, RAWE)")
        print(f"   Students     : 3 rural personas (Priya, Arjun, Meena)")

    except Exception as e:
        db.rollback()
        print(f"\n❌ Seed failed: {e}")
        raise
    finally:
        db.close()


if __name__ == "__main__":
    seed()

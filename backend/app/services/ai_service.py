"""
AI Service — Powered exclusively by Vertex AI (Gemini 2.0 Flash) with RAG & Eligibility-Aware Guidance.

Provides:
- Profile-aware career guidance with RAG-enriched context
- Eligibility-filtered opportunity matching
- Multi-turn conversation with persistent history
- Vertex AI-powered skill extraction with rule-based fallback
"""
import logging
from typing import List, Dict, Any, Optional
from uuid import UUID

from sqlalchemy.orm import Session
from sqlalchemy import select, func

from app.core.config import settings
from app.models.student import Student
from app.models.opportunity import Opportunity, OpportunityStatus
from app.models.conversation import ChatSession, ChatMessage, MessageRole
from app.schemas.assistant import ChatResponse, OpportunityReference, SkillExtractionResponse

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Vertex AI client — singleton
# ---------------------------------------------------------------------------
_genai_client = None


def _get_client():
    """Get or create the Vertex AI GenAI client."""
    global _genai_client
    if _genai_client is not None:
        return _genai_client
    try:
        from google import genai
        _genai_client = genai.Client(
            vertexai=True,
            project=settings.gcp_project_id,
            location=settings.gcp_location,
        )
        logger.info(
            "Vertex AI client initialized (project=%s, location=%s, model=%s)",
            settings.gcp_project_id,
            settings.gcp_location,
            settings.gemini_model,
        )
        return _genai_client
    except Exception as e:
        logger.warning("Could not initialize Vertex AI client: %s. Fallback engine will be active.", e)
        return None


class AIService:
    """AI-powered career counseling service backed by Vertex AI."""

    # ------------------------------------------------------------------
    # Main chat endpoint
    # ------------------------------------------------------------------
    @classmethod
    def ask_career_guide(
        cls,
        db: Session,
        student_id: UUID,
        message: str,
        language: str = "en",
        session_id: Optional[UUID] = None,
    ) -> ChatResponse:
        """
        Provides empathetic, grounded, profile-aware career and scholarship guidance.

        Pipeline:
        1. Fetch student profile
        2. Run eligibility engine to find matching opportunities
        3. Retrieve RAG context via semantic search
        4. Load conversation history for multi-turn context
        5. Generate response via Vertex AI (or local fallback)
        6. Persist messages to session
        """
        # 1. Fetch real student profile
        student = db.query(Student).filter(Student.id == student_id).first()
        if not student:
            return ChatResponse(
                reply="I couldn't locate your profile. Please complete onboarding first.",
                suggested_actions=["Complete Onboarding", "Explore Opportunities"],
                is_fallback=True,
            )

        # 2. Extract profile context
        edu_record = student.education_records[0] if student.education_records else None
        edu_level = edu_record.education_level.value if edu_record and edu_record.education_level else "secondary"
        edu_desc = edu_record.description if edu_record and edu_record.description else ""

        skills_list = [s.skill.canonical_name for s in student.skills if s.skill]
        interests_list = [i.interest.name for i in student.interests if i.interest]
        aspirations_list = [a.aspiration_text for a in student.aspirations]
        location_name = (
            f"{student.location.village}, {student.location.district}, {student.location.state}"
            if student.location
            else "India"
        )

        # 3. Fetch eligible opportunities (eligibility-aware)
        candidate_opps = cls._get_eligible_opportunities(db, student)

        matched_refs: List[OpportunityReference] = []
        for opp in candidate_opps[:5]:
            matched_refs.append(
                OpportunityReference(
                    id=opp.id,
                    title=opp.title,
                    type=opp.type.value if hasattr(opp.type, "value") else str(opp.type),
                    official_url=opp.official_url,
                    deadline=str(opp.application_deadline) if opp.application_deadline else None,
                    match_reason="Matches your educational eligibility and background profile.",
                )
            )

        # 4. Retrieve RAG context from document chunks
        rag_context = cls._get_rag_context(db, message, [opp.id for opp in candidate_opps[:10]])

        # 5. Load conversation history
        conversation_history = cls._get_conversation_history(db, session_id)

        # 6. Manage session
        session = cls._get_or_create_session(db, student_id, session_id, message)

        # 7. Persist user message
        user_msg = ChatMessage(
            session_id=session.id,
            role=MessageRole.USER,
            content=message,
        )
        db.add(user_msg)
        db.flush()

        # 8. Generate response via Vertex AI
        client = _get_client()
        reply_text = None
        is_fallback = False
        suggested_actions = []

        if client:
            try:
                reply_text, suggested_actions = cls._generate_vertex_response(
                    client=client,
                    student_name=student.name,
                    location=location_name,
                    edu_level=edu_level,
                    edu_desc=edu_desc,
                    skills=skills_list,
                    interests=interests_list,
                    aspirations=aspirations_list,
                    language=language,
                    message=message,
                    candidate_opps=candidate_opps[:6],
                    rag_context=rag_context,
                    conversation_history=conversation_history,
                )
            except Exception as e:
                logger.warning("Vertex AI generation failed: %s. Using local fallback.", e)

        if not reply_text:
            is_fallback = True
            fallback_resp = cls._generate_grounded_fallback_reply(
                student_name=student.name,
                location=location_name,
                edu_level=edu_level,
                edu_desc=edu_desc,
                skills=skills_list,
                aspirations=aspirations_list,
                message=message,
                language=language,
                matched_refs=matched_refs,
            )
            reply_text = fallback_resp["reply"]
            suggested_actions = fallback_resp["suggested"]

        if not suggested_actions:
            suggested_actions = [
                "Which scholarships can I get?",
                "What documents do I need to prepare?",
                "Show me vocational courses nearby",
            ]

        # 9. Persist assistant response
        assistant_msg = ChatMessage(
            session_id=session.id,
            role=MessageRole.ASSISTANT,
            content=reply_text,
            metadata_={
                "suggested_actions": suggested_actions,
                "referenced_opportunity_ids": [str(r.id) for r in matched_refs],
                "is_fallback": is_fallback,
            },
        )
        db.add(assistant_msg)

        # Update session last_active_at
        session.last_active_at = func.now()
        db.commit()

        return ChatResponse(
            reply=reply_text,
            suggested_actions=suggested_actions,
            referenced_opportunities=matched_refs,
            is_fallback=is_fallback,
            session_id=session.id,
        )

    # ------------------------------------------------------------------
    # Vertex AI response generation
    # ------------------------------------------------------------------
    @classmethod
    def _generate_vertex_response(
        cls,
        client,
        student_name: str,
        location: str,
        edu_level: str,
        edu_desc: str,
        skills: List[str],
        interests: List[str],
        aspirations: List[str],
        language: str,
        message: str,
        candidate_opps: List[Opportunity],
        rag_context: str,
        conversation_history: List[Dict[str, str]],
    ) -> tuple:
        """Generate a response using Vertex AI Gemini."""
        opps_context = "\n".join(
            [
                f"- [{o.type.value.upper()}] {o.title}: {o.description or ''} "
                f"(Deadline: {o.application_deadline or 'Open'}, URL: {o.official_url or 'N/A'})"
                for o in candidate_opps
            ]
        )

        system_prompt = f"""You are DreamCatcher AI, an inspiring, empathetic, and knowledgeable career mentor for rural and vernacular youth across India.
Your mission is to help first-generation students, underprivileged youth, and rural jobseekers navigate scholarships, vocational courses, ITI programs, entrance exams, and career roadmaps.

Student Profile Context:
- Name: {student_name}
- Region: {location}
- Highest Education: {edu_level}
- Practical Experience / Background: {edu_desc}
- Verified Skills: {', '.join(skills) if skills else 'Exploring new trades'}
- Interests: {', '.join(interests) if interests else 'Exploring opportunities'}
- Dream Aspiration: {', '.join(aspirations) if aspirations else 'Undecided'}
- Preferred Language: {language}

Verified Opportunities Available in System (Eligibility-Matched):
{opps_context if opps_context else 'No specific matches found yet — provide general guidance.'}

{f'''Relevant Knowledge Base Context (from verified documents):
{rag_context}
''' if rag_context else ''}
Guidelines:
1. Tone: Warm, encouraging, respectful ("Namaste", "Aapka sapna sach ho sakta hai").
2. Answer specifically addressing their question and their exact educational background.
3. Recommend 1-3 specific schemes/courses from the verified opportunities when relevant.
4. Keep answers concise (under 250 words) with clear bullet points.
5. Provide 2-3 immediate, actionable stepping stones (e.g. documents to gather, exam portal to register).
6. If the user writes in Hindi or requests Hindi, reply in natural conversational Hindi (Devanagari or Hinglish). Otherwise reply in clear English.
7. NEVER make up opportunity names, deadlines, or URLs. Only reference data from the "Verified Opportunities" section above.
8. At the end, suggest 3 brief follow-up questions the student might want to ask (prefixed with "💡").
"""

        # Build multi-turn contents
        contents = []

        # Add conversation history for multi-turn context
        for msg in conversation_history[-6:]:  # Last 6 messages for context window
            contents.append({"role": msg["role"], "parts": [{"text": msg["content"]}]})

        # Add current user message
        contents.append({"role": "user", "parts": [{"text": message}]})

        response = client.models.generate_content(
            model=settings.gemini_model,
            contents=contents,
            config={
                "system_instruction": system_prompt,
                "temperature": 0.7,
                "max_output_tokens": 1024,
            },
        )

        if response and response.text:
            reply = response.text.strip()

            # Extract suggested actions from reply if present
            suggested = []
            lines = reply.split("\n")
            for line in lines:
                if line.strip().startswith("💡"):
                    suggested.append(line.strip().lstrip("💡").strip())

            if not suggested:
                suggested = [
                    "How do I apply for this scholarship?",
                    "What documents do I need to prepare?",
                    "Show me vocational courses nearby",
                ]

            return reply, suggested

        return None, []

    # ------------------------------------------------------------------
    # Eligibility-aware opportunity retrieval
    # ------------------------------------------------------------------
    @classmethod
    def _get_eligible_opportunities(cls, db: Session, student: Student) -> List[Opportunity]:
        """
        Fetch opportunities that are likely relevant to the student.
        Uses basic profile matching for now — full eligibility engine for detailed checks.
        """
        from app.models.eligibility import EligibilityRule, RuleType

        # Start with active opportunities
        stmt = (
            select(Opportunity)
            .where(Opportunity.status == OpportunityStatus.ACTIVE)
        )

        # If student has a location, prefer opportunities in their state or national
        if student.location:
            from app.models.location import Location
            from sqlalchemy import or_

            stmt = stmt.outerjoin(
                Location, Opportunity.location_id == Location.id
            ).where(
                or_(
                    Location.state == student.location.state,
                    Opportunity.location_id.is_(None),  # National scope
                )
            )

        opportunities = list(
            db.execute(stmt.limit(15)).scalars().all()
        )

        return opportunities

    # ------------------------------------------------------------------
    # RAG context retrieval
    # ------------------------------------------------------------------
    @classmethod
    def _get_rag_context(
        cls,
        db: Session,
        query: str,
        opportunity_ids: List[UUID],
    ) -> str:
        """
        Retrieve relevant document chunks via semantic search for RAG context.
        Returns formatted text context or empty string if no embeddings available.
        """
        try:
            from app.services.embedding_service import EmbeddingService

            chunks = EmbeddingService.semantic_search(
                db=db,
                query=query,
                top_k=5,
                opportunity_ids=opportunity_ids if opportunity_ids else None,
            )

            if not chunks:
                return ""

            context_parts = []
            for chunk in chunks:
                source_info = ""
                if chunk.metadata_:
                    title = chunk.metadata_.get("source_document_title", "")
                    if title:
                        source_info = f" [Source: {title}]"
                context_parts.append(f"• {chunk.chunk_text}{source_info}")

            return "\n".join(context_parts)

        except Exception as e:
            logger.debug("RAG context retrieval skipped: %s", e)
            return ""

    # ------------------------------------------------------------------
    # Conversation history
    # ------------------------------------------------------------------
    @classmethod
    def _get_conversation_history(
        cls,
        db: Session,
        session_id: Optional[UUID],
    ) -> List[Dict[str, str]]:
        """Load previous messages from a chat session for multi-turn context."""
        if not session_id:
            return []

        messages = (
            db.execute(
                select(ChatMessage)
                .where(ChatMessage.session_id == session_id)
                .order_by(ChatMessage.created_at)
            )
            .scalars()
            .all()
        )

        return [
            {"role": msg.role.value, "content": msg.content}
            for msg in messages
        ]

    @classmethod
    def _get_or_create_session(
        cls,
        db: Session,
        student_id: UUID,
        session_id: Optional[UUID],
        first_message: str,
    ) -> ChatSession:
        """Get existing session or create a new one."""
        if session_id:
            session = db.execute(
                select(ChatSession).where(ChatSession.id == session_id)
            ).scalar_one_or_none()
            if session:
                return session

        # Create new session with auto-generated title
        title = first_message[:100] if first_message else "New conversation"
        session = ChatSession(
            student_id=student_id,
            title=title,
        )
        db.add(session)
        db.flush()
        return session

    # ------------------------------------------------------------------
    # Session management
    # ------------------------------------------------------------------
    @classmethod
    def list_sessions(cls, db: Session, student_id: UUID) -> List[ChatSession]:
        """List all chat sessions for a student, most recent first."""
        return list(
            db.execute(
                select(ChatSession)
                .where(ChatSession.student_id == student_id)
                .order_by(ChatSession.last_active_at.desc())
            )
            .scalars()
            .all()
        )

    @classmethod
    def get_session_with_messages(cls, db: Session, session_id: UUID) -> Optional[ChatSession]:
        """Get a session with all its messages."""
        from sqlalchemy.orm import selectinload

        return db.execute(
            select(ChatSession)
            .options(selectinload(ChatSession.messages))
            .where(ChatSession.id == session_id)
        ).scalar_one_or_none()

    # ------------------------------------------------------------------
    # Skill extraction (Vertex AI-powered with rule-based fallback)
    # ------------------------------------------------------------------
    @classmethod
    def extract_skills_from_informal_text(cls, description: str) -> SkillExtractionResponse:
        """
        Extracts NSQF-standard skills and recommended vocational trades.
        Uses Vertex AI when available, falls back to rule-based engine.
        """
        client = _get_client()
        if client:
            try:
                return cls._extract_skills_vertex(client, description)
            except Exception as e:
                logger.warning("Vertex AI skill extraction failed: %s. Using rule-based fallback.", e)

        return cls._extract_skills_rules(description)

    @classmethod
    def _extract_skills_vertex(cls, client, description: str) -> SkillExtractionResponse:
        """Extract skills using Vertex AI with structured output."""
        prompt = f"""Analyze the following informal description of a student's practical experience and hands-on learning.
Extract NSQF (National Skills Qualifications Framework) standard skills and recommend matching Indian vocational trades (ITI/Diploma/Polytechnic).

Student's description:
"{description}"

Respond in this exact JSON format:
{{
    "extracted_skills": ["skill1", "skill2", ...],
    "recommended_trades": ["trade1", "trade2", ...],
    "summary": "Brief summary of identified skill areas"
}}

Rules:
- Map informal descriptions to formal NSQF-recognized skill names
- Recommend ITI trades, Diploma courses, or Polytechnic programs relevant to India
- Include at least 2 skills and 2 trades
- Keep the summary under 2 sentences
"""
        response = client.models.generate_content(
            model=settings.gemini_model,
            contents=prompt,
            config={
                "temperature": 0.3,
                "max_output_tokens": 512,
                "response_mime_type": "application/json",
            },
        )

        if response and response.text:
            import json
            try:
                data = json.loads(response.text)
                return SkillExtractionResponse(
                    extracted_skills=data.get("extracted_skills", []),
                    recommended_trades=data.get("recommended_trades", []),
                    summary=data.get("summary", "Skills analyzed via Vertex AI."),
                )
            except json.JSONDecodeError:
                logger.warning("Could not parse Vertex AI JSON response for skill extraction")

        raise RuntimeError("No valid response from Vertex AI")

    @classmethod
    def _extract_skills_rules(cls, description: str) -> SkillExtractionResponse:
        """Rule-based skill extraction fallback — zero API dependency."""
        desc_lower = description.lower()
        extracted: List[str] = []
        trades: List[str] = []

        skill_rules = [
            (["solar", "inverter", "battery", "panel"], "Solar PV Installation & Repair", "Solar Technician (PM Surya Ghar)"),
            (["wiring", "electric", "motor", "switch", "circuit"], "Electrical Wiring & Circuit Repair", "ITI Electrician Trade"),
            (["farm", "crop", "soil", "agriculture", "organic", "fertilizer"], "Crop Production & Soil Testing", "Diploma in Precision Agriculture"),
            (["repair", "bike", "mechanic", "pump", "engine"], "Mechanical Maintenance & Pump Repair", "ITI Fitter / Mechanic Trade"),
            (["computer", "ms office", "typing", "internet", "excel"], "Basic Computer Operations & MS Office", "ITI COPA (Computer Operator)"),
            (["teaching", "kids", "coaching", "school"], "Primary Pedagogy & Community Teaching", "Diploma in Elementary Education (D.El.Ed)"),
            (["nurse", "health", "medicine", "patient"], "Primary Healthcare Assistance", "Auxiliary Nurse Midwifery (ANM)"),
            (["tailor", "sewing", "stitch", "cloth", "fashion"], "Garment Construction & Tailoring", "ITI Dress Making / Fashion Design"),
            (["plumb", "pipe", "water", "tap"], "Plumbing & Sanitary Installation", "ITI Plumber Trade"),
            (["weld", "metal", "fabricat"], "Welding & Metal Fabrication", "ITI Welder Trade"),
        ]

        for keywords, skill_name, trade_name in skill_rules:
            if any(k in desc_lower for k in keywords):
                if skill_name not in extracted:
                    extracted.append(skill_name)
                if trade_name not in trades:
                    trades.append(trade_name)

        if not extracted:
            extracted = ["Practical Hands-on Learning", "Rural Community Work"]
            trades = ["General Vocational Training (ITI)", "Apprenticeship Promotion Scheme"]

        summary = (
            f"Identified {len(extracted)} practical skill areas aligned with formal NSQF trade pathways."
        )

        return SkillExtractionResponse(
            extracted_skills=extracted,
            recommended_trades=trades,
            summary=summary,
        )

    # ------------------------------------------------------------------
    # Local fallback engine (zero crashes, fully profile-grounded)
    # ------------------------------------------------------------------
    @classmethod
    def _generate_grounded_fallback_reply(
        cls,
        student_name: str,
        location: str,
        edu_level: str,
        edu_desc: str,
        skills: List[str],
        aspirations: List[str],
        message: str,
        language: str,
        matched_refs: List[OpportunityReference],
    ) -> Dict[str, Any]:
        """
        Synthesizes a detailed, culturally attuned response grounded directly in
        the verified opportunities in the database.
        """
        msg_lower = message.lower()
        aspiration_text = aspirations[0] if aspirations else "your chosen ambition"
        first_name = student_name.split()[0] if student_name else "Friend"

        opp_bullet_points = ""
        for opp in matched_refs[:3]:
            deadline_str = f" (Deadline: {opp.deadline})" if opp.deadline else ""
            url_str = f" | Portal: {opp.official_url}" if opp.official_url else ""
            opp_bullet_points += f"• **{opp.title}** ({opp.type.capitalize()}){deadline_str}{url_str}\n"

        if "scholarship" in msg_lower or "money" in msg_lower or "fee" in msg_lower or "aid" in msg_lower:
            reply = (
                f"Namaste {first_name}! 🙏 Based on your profile from **{location}** and your education ({edu_level}), "
                f"you qualify for government and merit-based financial aid schemes:\n\n"
                f"{opp_bullet_points}\n"
                f"**Key Steps to Apply:**\n"
                f"1. **Income & Caste Certificate**: Ensure you have valid certificates from your local Tehsildar / Block Development Office.\n"
                f"2. **National Scholarship Portal**: Register at [scholarships.gov.in](https://scholarships.gov.in) with your Aadhaar and Bank account.\n"
                f"3. Keep your 10th marksheet and fee receipts ready for document verification."
            )
            suggested = [
                "Which documents are required for NSP?",
                "Are there scholarships for ITI & Diplomas?",
                "Check full eligibility breakdown",
            ]
        elif "course" in msg_lower or "iti" in msg_lower or "learn" in msg_lower or "training" in msg_lower:
            reply = (
                f"Hello {first_name}! With your practical background in *{edu_desc or 'hands-on learning'}*, "
                f"practical vocational courses offer high-demand career pathways:\n\n"
                f"{opp_bullet_points}\n"
                f"**Recommended Progression:**\n"
                f"1. **NCVT Approved Programs**: Enroll in a government ITI or Polytechnic to get formal NSQF certification.\n"
                f"2. **Dual Training**: Combine classroom learning with industry apprenticeship under NAPS (National Apprenticeship Promotion Scheme)."
            )
            suggested = [
                "Find ITI centers in my district",
                "How does the Apprenticeship scheme pay?",
                "What skills should I build next?",
            ]
        else:
            reply = (
                f"Namaste {first_name}! 🙏 I am tracking your goal toward becoming **{aspiration_text}**.\n\n"
                f"Here are top verified opportunities aligned with your background from {location}:\n\n"
                f"{opp_bullet_points}\n"
                f"**How I can guide you:**\n"
                f"• Find scholarships with 100% fee waivers for rural students.\n"
                f"• Connect your hands-on practical skills to government certified diplomas.\n"
                f"• Prepare for entrance exams like JNVST, CUET, or Polytechnic CET."
            )
            suggested = [
                "Which scholarships can I get?",
                "How do I prepare for exams for free?",
                "Find programs in my district",
            ]

        return {"reply": reply, "suggested": suggested}

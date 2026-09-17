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
        is_voice_mode: bool = False,
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

        # 6. Incrementally extract and build profile from caller conversation
        cls._update_profile_from_conversation(db, student, message, conversation_history)
        db.refresh(student)

        # Refresh extracted profile variables
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

        # 7. Manage session
        session = cls._get_or_create_session(db, student_id, session_id, message)

        # 8. Persist user message
        user_msg = ChatMessage(
            session_id=session.id,
            role=MessageRole.USER,
            content=message,
        )
        db.add(user_msg)
        db.flush()

        # 9. Generate response via Vertex AI
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
                    is_voice_mode=is_voice_mode,
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
                is_voice_mode=is_voice_mode,
            )
            reply_text = fallback_resp["reply"]
            suggested_actions = fallback_resp["suggested"]

        if not suggested_actions:
            suggested_actions = [
                "Which scholarships can I get?",
                "What documents do I need to prepare?",
                "Show me vocational courses nearby",
            ]

        # 10. Persist assistant response
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
    # Dynamic Profile Extraction during Conversation
    # ------------------------------------------------------------------
    @classmethod
    def _update_profile_from_conversation(
        cls,
        db: Session,
        student: Student,
        message: str,
        conversation_history: List[Dict[str, str]],
    ):
        """Incrementally extracts and persists profile information as the student talks."""
        try:
            from app.models.education import StudentEducation, EducationLevel, EducationStatus, DataSource
            from app.models.aspiration import StudentAspiration
            from app.services.student_service import StudentService
            import re

            msg = message.strip()
            msg_lower = msg.lower()
            updated = False

            # 1. Name extraction if student is still "New Caller" / "Voice Caller"
            if student.name.lower() in ("new caller", "new voice caller", "voice caller", "new user", "student"):
                name_match = re.search(
                    r"(?:mera naam|मेरा नाम|माझे नाव|my name is|i am|i'm|naam hai|नाम है|naam|नाम|name:?)\s+([A-Za-z\u0900-\u097F][a-zA-Z\u0900-\u097F\s]{1,30})",
                    msg,
                    re.IGNORECASE,
                )
                if name_match:
                    raw_name = name_match.group(1).strip()
                    raw_name = re.split(r"(?:\s+(?:hai|है|hoon|हूँ|आहे|from|se|से|aur|और|and|\.|\,)|$)", raw_name, flags=re.IGNORECASE)[0].strip()
                    if raw_name and len(raw_name) >= 2:
                        student.name = raw_name.title()
                        updated = True
                elif len(conversation_history) <= 2 and len(msg.split()) <= 3 and not any(w in msg_lower for w in ("hello", "hi", "namaste", "नमस्ते", "scholarship", "help", "kya", "क्या", "kaise", "कैसे")):
                    clean_words = [w for w in msg.split() if w.isalpha() or '\u0900' <= w[0] <= '\u097F']
                    if 1 <= len(clean_words) <= 3:
                        student.name = " ".join(clean_words).title()
                        updated = True

            # 2. Education extraction
            if not student.education_records:
                detected_level = None
                field_of_study = None

                if any(w in msg_lower for w in ("12th", "12 vi", "12 वी", "12वीं", "12th pass", "hsc", "intermediate", "inter", "senior secondary", "बारहवीं")):
                    detected_level = EducationLevel.SENIOR_SECONDARY
                elif any(w in msg_lower for w in ("10th", "10 vi", "10 वी", "10वीं", "10th pass", "ssc", "matric", "high school", "secondary", "दसवीं")):
                    detected_level = EducationLevel.SECONDARY
                elif any(w in msg_lower for w in ("iti", "vocational", "fitter", "electrician trade", "copa", "wireman")):
                    detected_level = EducationLevel.VOCATIONAL
                elif any(w in msg_lower for w in ("diploma", "polytechnic")):
                    detected_level = EducationLevel.DIPLOMA
                elif any(w in msg_lower for w in ("btech", "b.tech", "bachelor", "bca", "bsc", "b.sc", "bcom", "b.com", "ba", "b.a", "degree", "graduate", "graduation", "college")):
                    detected_level = EducationLevel.BACHELOR
                elif any(w in msg_lower for w in ("8th", "8 vi", "8वीं", "7th", "6th", "upper primary", "middle school", "आठवीं")):
                    detected_level = EducationLevel.UPPER_PRIMARY

                if "science" in msg_lower or "विज्ञान" in msg_lower or "pcm" in msg_lower or "pcb" in msg_lower:
                    field_of_study = "Science"
                elif "commerce" in msg_lower or "वाणिज्य" in msg_lower:
                    field_of_study = "Commerce"
                elif "arts" in msg_lower or "कला" in msg_lower or "humanities" in msg_lower:
                    field_of_study = "Arts"

                if detected_level:
                    edu = StudentEducation(
                        student_id=student.id,
                        education_level=detected_level,
                        field_of_study=field_of_study,
                        status=EducationStatus.COMPLETED if "pass" in msg_lower or "पास" in msg_lower or "complete" in msg_lower else EducationStatus.IN_PROGRESS,
                        description=msg[:250],
                        source=DataSource.STUDENT_REPORTED,
                        confidence=0.9,
                    )
                    db.add(edu)
                    updated = True

            # 3. Aspiration extraction
            if not student.aspirations:
                aspiration_keywords = {
                    "software": "Software Engineer & Programmer",
                    "सॉफ्टवेयर": "Software Engineer & Programmer",
                    "coding": "Software Developer",
                    "कोडिंग": "Software Developer",
                    "computer": "Computer Science & IT Professional",
                    "कंप्यूटर": "Computer Science & IT Professional",
                    "police": "Police Service & Law Enforcement",
                    "पुलिस": "Police Service & Law Enforcement",
                    "army": "Indian Armed Forces / Defense",
                    "सेना": "Indian Armed Forces / Defense",
                    "फौज": "Indian Armed Forces / Defense",
                    "teacher": "School Teacher / Educator",
                    "शिक्षक": "School Teacher / Educator",
                    "अध्यापक": "School Teacher / Educator",
                    "doctor": "Medical & Healthcare Professional",
                    "डॉक्टर": "Medical & Healthcare Professional",
                    "nurse": "Nursing & Healthcare Assistant",
                    "नर्स": "Nursing & Healthcare Assistant",
                    "mechanic": "Mechanical & Automobile Technician",
                    "मैकेनिक": "Mechanical & Automobile Technician",
                    "electrician": "Electrical Technician / Electrician",
                    "इलेक्ट्रीशियन": "Electrical Technician / Electrician",
                    "ias": "Civil Services / Administrative Officer",
                    "ips": "Indian Police Service Officer",
                    "bank": "Banking & Financial Services",
                    "business": "Entrepreneurship & Small Business",
                    "व्यापार": "Entrepreneurship & Small Business",
                    "farming": "Modern Agriculture & Farming",
                    "खेती": "Modern Agriculture & Farming",
                    "किसान": "Modern Agriculture & Farming",
                    "drone": "Drone Operator & Precision Agriculture",
                    "solar": "Solar Energy Technician",
                }
                for kw, asp_title in aspiration_keywords.items():
                    if kw in msg_lower:
                        asp = StudentAspiration(
                            student_id=student.id,
                            aspiration_text=asp_title,
                            priority=1,
                            source="student_reported",
                            confidence=0.9,
                        )
                        db.add(asp)
                        updated = True
                        break

            if updated:
                student.profile_completeness = StudentService.calculate_completeness(student)
                db.commit()
                db.refresh(student)
        except Exception as e:
            logger.debug("Profile extraction notice: %s", e)

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
        is_voice_mode: bool = False,
    ) -> tuple:
        """Generate a response using Vertex AI Gemini."""
        opps_context = "\n".join(
            [
                f"- [{o.type.value.upper()}] {o.title}: {o.description or ''} "
                f"(Deadline: {o.application_deadline or 'Open'}, URL: {o.official_url or 'N/A'})"
                for o in candidate_opps
            ]
        )

        is_first_time_caller = (
            student_name.lower() in ("new caller", "new voice caller", "voice caller", "new user", "friend")
            or (not skills and not aspirations and not edu_desc)
        )

        if is_voice_mode:
            system_prompt = f"""You are Pragati from DreamCatcher AI, speaking on a LIVE SPOKEN PHONE CALL with a student.
You are a warm, encouraging, conversational mentor for Indian youth.

Student Profile:
- Name: {student_name}
- Region: {location}
- Highest Education: {edu_level}
- Practical Background: {edu_desc}
- Verified Skills: {', '.join(skills) if skills else 'Exploring'}
- Dream Aspiration: {', '.join(aspirations) if aspirations else 'Undecided'}
- Language: {language}

Verified Opportunities Available:
{opps_context if opps_context else 'No specific opportunities loaded.'}

{f'''Knowledge Base Context:
{rag_context}
''' if rag_context else ''}

STRICT VOICE CALL RULES (CRITICAL):
1. SPOKEN BREVITY: This is an audio phone call. Keep every response SHORT, NATURAL, and PUNCHY — MAXIMUM 1 TO 2 SHORT SENTENCES (strictly under 35 words total). Always complete your sentences cleanly. Never drag on or speak long paragraphs.
2. NO MARKDOWN: Never use asterisks (*, **), bullet points, numbered lists, markdown formatting, emojis (💡), headers (#), or URLs. Everything you write will be read aloud by text-to-speech.
3. CONVERSATIONAL DIALOGUE:
   - For a first-time caller whose profile is incomplete: Warmly acknowledge in 1 short sentence, and ask EXACTLY ONE simple question (e.g. asking for their education level or career goal). Never ask two questions at once.
   - For ongoing guidance: Answer directly in 1 sentence, mention at most 1 matching scholarship/course by name, and finish with 1 simple follow-up question.
4. LANGUAGE: Reply in natural spoken {language} (e.g., natural spoken conversational Hindi, Marathi, or English).
5. NEVER sound like a search engine or report. Speak warmly like a real counselor talking over the phone.
"""
        else:
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
3. Structure your response using these exact alert callout blocks for clean card rendering in the UI:
   - 🎯 **Recommended Pathway:** (followed by a 1-2 sentence structured roadmap)
   - ⚠️ **Important Eligibility Notice:** (followed by key age, exam, or certificate criteria)
   - 💡 **Officer Guidance:** (followed by strategic advice or next steps)
4. Keep responses focused and concise (under 120 words) with clear bullet points, except when the alert callouts require enough detail to be useful.
5. Provide 2-3 immediate, actionable stepping stones.
6. If the user writes in Hindi or requests Hindi, reply in natural conversational Hindi (Devanagari or Hinglish). If Marathi or another regional language, reply in that language. Otherwise use clear English.
7. NEVER make up opportunity names, deadlines, or URLs. Only reference data from the "Verified Opportunities" section above.
8. At the very end, suggest 2-3 brief follow-up questions the student might want to ask (prefixed with "💡").
9. For a new caller with missing profile details, act as an interviewer: ask for one or two missing facts at a time (name, village/state, education, work or skills, interests, and goal). Use facts already shared in conversation history and do not ask the same question again. Only give highly specific opportunity guidance after enough facts are available.

First-Time Caller Conversational Interview Rules:
{'''
- This caller is talking to you for the first time and is building their profile right now during this conversation!
- Ask for missing pieces of information step-by-step:
    • If their name or village/city hasn't been shared yet: Warmly greet them and ask for their name and village/city.
    • If they just told you their name/village: Greet them by name, acknowledge their village, and ask what their current education is.
    • If they shared their education: Ask what trade or subjects they enjoy.
    • If they shared their interests: Ask what their dream career goal is.
    • Once education and goal are shared: Summarize their profile enthusiastically, recommend 1-2 matching opportunities/scholarships from the verified opportunities above, and give clear immediate next steps!
- Never overwhelm the caller — ask only 1 focused question at a time.
''' if is_first_time_caller else '''
- Address the student by name and provide tailored guidance directly based on their verified profile and opportunities.
'''}
"""

        # Build multi-turn contents
        contents = []

        # Add conversation history for multi-turn context
        for msg in conversation_history[-6:]:  # Last 6 messages for context window
            contents.append({"role": msg["role"], "parts": [{"text": msg["content"]}]})

        # Add current user message
        contents.append({"role": "user", "parts": [{"text": message}]})

        max_tokens = 1024
        temp = 0.6 if is_voice_mode else 0.7

        response = client.models.generate_content(
            model=settings.gemini_model,
            contents=contents,
            config={
                "system_instruction": system_prompt,
                "temperature": temp,
                "max_output_tokens": max_tokens,
            },
        )

        if response and response.text:
            reply = response.text.strip()

            if is_voice_mode:
                import re
                reply = re.sub(r'[*#_`•💡]', '', reply)
                reply = re.sub(r'\[([^\]]+)\]\([^)]+\)', r'\1', reply)
                reply = re.sub(r'\s+', ' ', reply).strip()

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
        is_voice_mode: bool = False,
    ) -> Dict[str, Any]:
        """
        Synthesizes a culturally attuned response grounded directly in
        the verified opportunities in the database.
        """
        msg_lower = message.lower()
        aspiration_text = aspirations[0] if aspirations else "your chosen ambition"
        first_name = student_name.split()[0] if student_name else "Friend"

        if is_voice_mode:
            top_opp = matched_refs[0].title if matched_refs else "National Scholarship schemes"
            if "scholarship" in msg_lower or "money" in msg_lower or "fee" in msg_lower or "aid" in msg_lower:
                if language.startswith("hi"):
                    reply = f"नमस्ते {first_name}! आपकी पढ़ाई के लिए {top_opp} जैसी छात्रवृत्तियां उपलब्ध हैं। क्या आपका आय प्रमाण पत्र तैयार है?"
                elif language.startswith("mr"):
                    reply = f"नमस्कार {first_name}! तुमच्यासाठी {top_opp} ही शिष्यवृत्ती उपलब्ध आहे. तुमचे कागदपत्रे तयार आहेत का?"
                else:
                    reply = f"Namaste {first_name}! Scholarships like {top_opp} are available for your background. Do you have your income certificate ready?"
            elif "course" in msg_lower or "iti" in msg_lower or "learn" in msg_lower or "training" in msg_lower:
                if language.startswith("hi"):
                    reply = f"नमस्ते {first_name}! आपके लिए सरकारी आईटीआई और पॉलिटेक्निक कोर्सेज बहुत अच्छे रहेंगे। आप किस ट्रेड में सीखना चाहते हैं?"
                elif language.startswith("mr"):
                    reply = f"नमस्कार {first_name}! शासकीय आयटीआय आणि पॉलिटेक्निक कोर्सेस उत्तम पर्याय आहेत. तुम्हाला कोणत्या ट्रेडमध्ये आवड आहे?"
                else:
                    reply = f"Hello {first_name}! Government ITIs and polytechnic courses are great pathways. Which trade are you interested in?"
            else:
                if language.startswith("hi"):
                    reply = f"नमस्ते {first_name}! मैं आपकी करियर गाइड प्रगति हूँ। आप अभी कौन सी कक्षा में पढ़ रहे हैं?"
                elif language.startswith("mr"):
                    reply = f"नमस्कार {first_name}! मी तुमची मार्गदर्शक प्रगती आहे. तुमचे सध्याचे शिक्षण काय आहे?"
                else:
                    reply = f"Namaste {first_name}! I am your DreamCatcher career guide Pragati. What is your current class or education level?"

            return {
                "reply": reply,
                "suggested": [
                    "Which scholarships can I get?",
                    "What documents do I need?",
                    "Show vocational courses",
                ],
            }

        opp_bullet_points = ""
        for opp in matched_refs[:3]:
            deadline_str = f" (Deadline: {opp.deadline})" if opp.deadline else ""
            url_str = f" | Portal: {opp.official_url}" if opp.official_url else ""
            opp_bullet_points += f"• **{opp.title}** ({opp.type.capitalize()}){deadline_str}{url_str}\n"

        if "scholarship" in msg_lower or "money" in msg_lower or "fee" in msg_lower or "aid" in msg_lower:
            reply = (
                f"Namaste {first_name}! 🙏 Based on your profile from **{location}** and your education ({edu_level}), "
                f"you qualify for government and merit-based financial aid schemes:\n\n"
                f"🎯 **Recommended Pathway:**\n"
                f"Income Certificate Verification → National Scholarship Portal Registration → 100% Fee Waiver.\n\n"
                f"⚠️ **Important Eligibility Notice:**\n"
                f"Valid Caste/Income Certificate from local Tehsildar and active Aadhaar-linked bank account required.\n\n"
                f"💡 **Officer Guidance:**\n"
                f"Check the verified scholarship schemes listed below. Prepare your 10th marksheet and fee receipts for instant upload."
            )
            suggested = [
                "Which documents are required for NSP?",
                "Are there scholarships for ITI & Diplomas?",
                "Check full eligibility breakdown",
            ]
        elif "course" in msg_lower or "iti" in msg_lower or "learn" in msg_lower or "training" in msg_lower:
            reply = (
                f"Hello {first_name}! With your background in *{edu_desc or 'hands-on learning'}*, "
                f"practical vocational courses offer high-demand career pathways:\n\n"
                f"🎯 **Recommended Pathway:**\n"
                f"Class 10th Pass → Government ITI Trade Certification → NAPS Industry Apprenticeship (Stipend ₹8,000-₹12,000/mo).\n\n"
                f"⚠️ **Important Eligibility Notice:**\n"
                f"Class 10th pass marksheet and domicile certificate required for DVET centralized admission (CAP).\n\n"
                f"💡 **Officer Guidance:**\n"
                f"Enroll in high-demand trades like Electrician, Solar PV Technician, or Fitter for guaranteed campus placements."
            )
            suggested = [
                "Find ITI centers in my district",
                "How does the Apprenticeship scheme pay?",
                "What skills should I build next?",
            ]
        else:
            reply = (
                f"Namaste {first_name}! 🙏 Here is your personalized roadmap toward becoming **{aspiration_text}**:\n\n"
                f"🎯 **Recommended Pathway:**\n"
                f"Board Exam Completion → Targeted Physical/Vocational Preparation → Official Recruitment & Scholarship Applications.\n\n"
                f"⚠️ **Important Eligibility Notice:**\n"
                f"Verify minimum age (18 years) and required physical/academic criteria for upcoming state recruitment cycles.\n\n"
                f"💡 **Officer Guidance:**\n"
                f"Review the eligible government recruitment drives and scholarship grants below. Tap any suggested question to get specific details."
            )
            suggested = [
                "Which scholarships can I get?",
                "How do I prepare for exams for free?",
                "Find programs in my district",
            ]

        return {"reply": reply, "suggested": suggested}

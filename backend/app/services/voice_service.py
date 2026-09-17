import base64
import logging
from typing import Optional
from uuid import UUID

from sqlalchemy.orm import Session

from app.services.ai_service import AIService
from app.schemas.voice import VoiceQueryResponse
from app.models.student import Student

logger = logging.getLogger(__name__)


class VoiceService:
    """Google Speech adapter around the existing persistent AI conversation flow."""

    @staticmethod
    def transcribe(audio_data: str, language: str, sample_rate: int) -> tuple[str, Optional[float]]:
        # 1. Try Google Cloud Speech-to-Text API
        try:
            from google.cloud import speech
            client = speech.SpeechClient()
            audio = speech.RecognitionAudio(content=base64.b64decode(audio_data))
            config = speech.RecognitionConfig(
                encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
                sample_rate_hertz=sample_rate,
                language_code=f"{language}-IN" if len(language) == 2 else language,
                enable_automatic_punctuation=True,
            )
            response = client.recognize(config=config, audio=audio)
            alternatives = [result.alternatives[0] for result in response.results if result.alternatives]
            if alternatives:
                return " ".join(item.transcript.strip() for item in alternatives).strip(), alternatives[0].confidence
        except Exception as e:
            logger.warning("Google Cloud Speech STT failed, trying Vertex AI Gemini multimodal STT: %s", e)

        # 2. Fallback to Vertex AI Gemini 2.0 Multimodal STT
        try:
            from app.services.ai_service import _get_client
            from app.core.config import settings
            from google.genai import types

            client = _get_client()
            if client is not None:
                audio_bytes = base64.b64decode(audio_data)
                audio_part = types.Part.from_bytes(
                    data=audio_bytes,
                    mime_type="audio/wav",
                )
                prompt = (
                    f"Listen to this audio recording carefully and transcribe what the person said in {language}. "
                    "Return only the exact transcribed speech text with no extra commentary, explanations, or quotes."
                )
                res = client.models.generate_content(
                    model=settings.gemini_model,
                    contents=[audio_part, prompt],
                )
                if res and res.text:
                    cleaned = res.text.strip().strip('"').strip("'")
                    return cleaned, 0.95
        except Exception as gemini_err:
            logger.warning("Gemini multimodal transcription failed: %s", gemini_err)

        return "", None

    @staticmethod
    def synthesize(text: str, language: str) -> tuple[str, str]:
        try:
            import re
            # Clean markdown artifacts for fluid spoken audio
            clean_text = re.sub(r'\[([^\]]+)\]\([^)]+\)', r'\1', text)
            clean_text = re.sub(r'[*#_`•💡]', '', clean_text)
            clean_text = re.sub(r'\s+', ' ', clean_text).strip()
            if not clean_text:
                clean_text = text

            from google.cloud import texttospeech
            client = texttospeech.TextToSpeechClient()
            response = client.synthesize_speech(
                input=texttospeech.SynthesisInput(text=clean_text),
                voice=texttospeech.VoiceSelectionParams(language_code=f"{language}-IN" if len(language) == 2 else language),
                audio_config=texttospeech.AudioConfig(audio_encoding=texttospeech.AudioEncoding.MP3),
            )
            return base64.b64encode(response.audio_content).decode("ascii"), "MP3"
        except Exception as tts_err:
            logger.warning("TTS synthesis failed, client will use browser voice: %s", tts_err)
            raise

    @classmethod
    def query(cls, db: Session, *, audio_data: str, language: str, conversation_id: Optional[UUID], student_id: Optional[UUID], sample_rate: int) -> VoiceQueryResponse:
        transcript, confidence = cls.transcribe(audio_data, language, sample_rate)
        if not transcript:
            raise ValueError("Speech could not be understood. Please try again.")
        if not student_id:
            student = Student(name="New voice caller", preferred_language=language)
            student.profile_completeness = 0.1
            db.add(student)
            db.flush()
            student_id = student.id
        response = AIService.ask_career_guide(
            db,
            student_id,
            transcript,
            language,
            conversation_id,
            is_voice_mode=True,
        )
        audio_response = None
        audio_format = "MP3"
        try:
            audio_response, audio_format = cls.synthesize(response.reply, language)
        except Exception:
            logger.exception("TTS synthesis failed; returning text response")
        return VoiceQueryResponse(
            user_transcript=transcript,
            ai_response=response.reply,
            audio_response=audio_response,
            audio_format=audio_format,
            conversation_id=response.session_id,
            student_id=student_id,
            stt_confidence=confidence,
            referenced_opportunities=response.referenced_opportunities,
        )
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
        return " ".join(item.transcript.strip() for item in alternatives).strip(), (alternatives[0].confidence if alternatives else None)

    @staticmethod
    def synthesize(text: str, language: str) -> tuple[str, str]:
        from google.cloud import texttospeech

        client = texttospeech.TextToSpeechClient()
        response = client.synthesize_speech(
            input=texttospeech.SynthesisInput(text=text),
            voice=texttospeech.VoiceSelectionParams(language_code=f"{language}-IN" if len(language) == 2 else language),
            audio_config=texttospeech.AudioConfig(audio_encoding=texttospeech.AudioEncoding.MP3),
        )
        return base64.b64encode(response.audio_content).decode("ascii"), "MP3"

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
        response = AIService.ask_career_guide(db, student_id, transcript, language, conversation_id)
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
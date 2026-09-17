from typing import Optional
from uuid import UUID

from pydantic import BaseModel, Field

from app.schemas.assistant import OpportunityReference


class VoiceQueryRequest(BaseModel):
    audio_data: str = Field(..., min_length=1)
    language: str = Field("hi", max_length=10)
    conversation_id: Optional[UUID] = None
    student_id: Optional[UUID] = Field(None, description="Existing profile; omitted for a new caller")
    audio_encoding: str = "LINEAR16"
    sample_rate: int = Field(16000, ge=8000, le=48000)


class VoiceQueryResponse(BaseModel):
    user_transcript: str
    ai_response: str
    audio_response: Optional[str] = None
    audio_format: str = "MP3"
    conversation_id: UUID
    student_id: UUID
    stt_confidence: Optional[float] = None
    referenced_opportunities: list[OpportunityReference] = Field(default_factory=list)

class VoiceSynthesisRequest(BaseModel):
    text: str = Field(..., min_length=1)
    language: str = Field("hi", max_length=10)

class VoiceSynthesisResponse(BaseModel):
    audio_response: str
    audio_format: str = "MP3"
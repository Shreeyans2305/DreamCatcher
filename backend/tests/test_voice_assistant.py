"""
Tests for Voice and Assistant Chat endpoints (with voice mode brevity).
"""
import pytest
from fastapi.testclient import TestClient
from uuid import uuid4


def test_chat_voice_mode_fallback(client: TestClient):
    """Verify that chat endpoint supports is_voice_mode."""
    # 1. Create a student first
    res = client.post(
        "/api/v1/students",
        json={"name": "Pooja Sharma", "preferred_language": "hi"},
    )
    assert res.status_code == 201
    student_id = res.json()["id"]

    # 2. Query chat with is_voice_mode=True
    chat_res = client.post(
        "/api/v1/assistant/chat",
        json={
            "student_id": student_id,
            "message": "Mujhe 12th ke baad scholarship chahiye",
            "language": "hi",
            "is_voice_mode": True,
        },
    )
    assert chat_res.status_code == 200
    data = chat_res.json()
    assert "reply" in data
    assert len(data["reply"]) > 0
    # Voice mode replies should not have markdown bullet characters or excessive length
    assert "•" not in data["reply"]
    assert "https://" not in data["reply"]

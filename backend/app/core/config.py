"""
DreamCatcher — Application Configuration
Loads settings from environment variables / .env file.
"""
import os
from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )

    # Application
    app_env: str = "development"
    app_debug: bool = True
    app_host: str = "0.0.0.0"
    app_port: int = 8000
    app_name: str = "DreamCatcher"
    app_version: str = "0.2.0"

    # Database
    database_url: str = (
        "postgresql+psycopg2://dreamcatcher:dreamcatcher_dev_password@localhost:5432/dreamcatcher"
    )

    # pgvector — embedding dimension
    # 768  = Vertex AI text-embedding-004 (default)
    # 1536 = OpenAI ada-002 compatible
    # 384  = all-MiniLM-L6-v2
    vector_dim: int = 768

    # Vertex AI & Generative Models
    use_vertex_ai: bool = True
    gcp_project_id: str = "dreamcatcher-507515"
    gcp_location: str = "us-central1"
    gemini_model: str = "gemini-2.5-flash"
    embedding_model: str = "text-embedding-004"


@lru_cache()
def get_settings() -> Settings:
    """Return cached application settings."""
    return Settings()


settings = get_settings()

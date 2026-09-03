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
    app_version: str = "0.1.0"

    # Database
    database_url: str = (
        "postgresql+psycopg2://dreamcatcher:dreamcatcher_dev_password@localhost:5432/dreamcatcher"
    )

    # pgvector — embedding dimension
    # 1536 = OpenAI ada-002 compatible (default)
    # 768  = BERT / sentence-transformers (768-dim)
    # 384  = all-MiniLM-L6-v2
    vector_dim: int = 1536


@lru_cache()
def get_settings() -> Settings:
    """Return cached application settings."""
    return Settings()


settings = get_settings()

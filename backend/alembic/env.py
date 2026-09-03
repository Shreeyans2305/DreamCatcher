"""
Alembic environment — reads DATABASE_URL from environment variables,
imports all SQLAlchemy models, and runs migrations.
"""
import os
import sys
from logging.config import fileConfig

from alembic import context
from sqlalchemy import engine_from_config, pool
from dotenv import load_dotenv

# ── Make the backend/ directory importable ──────────────────────────────────
# When alembic is run from backend/, we need app.* to be on sys.path.
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Load .env so DATABASE_URL is available
load_dotenv()

# ── Import models so Alembic autogenerate can see all tables ──────────────
import app.models  # noqa: F401 — side-effect import registers all ORM models

from app.core.database import Base
from app.core.config import settings

# ── Alembic Config ───────────────────────────────────────────────────────
config = context.config

# Override sqlalchemy.url from environment variable
config.set_main_option("sqlalchemy.url", settings.database_url)

# Set up Python logging from alembic.ini
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

# The MetaData object for autogenerate
target_metadata = Base.metadata


# ── Offline mode ──────────────────────────────────────────────────────────
def run_migrations_offline() -> None:
    """Run migrations without a live database connection."""
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
        compare_type=True,
    )
    with context.begin_transaction():
        context.run_migrations()


# ── Online mode ───────────────────────────────────────────────────────────
def run_migrations_online() -> None:
    """Run migrations with a live database connection."""
    connectable = engine_from_config(
        config.get_section(config.config_ini_section, {}),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )
    with connectable.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            compare_type=True,
        )
        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()

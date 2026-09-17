"""Add avatar_url column to students table.

Revision ID: 0003_add_student_avatar_url
Revises: 0002_chat_history
Create Date: 2026-09-04
"""
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = "0003_add_student_avatar_url"
down_revision = "0002_chat_history"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column("students", sa.Column("avatar_url", sa.Text(), nullable=True))


def downgrade() -> None:
    op.drop_column("students", "avatar_url")

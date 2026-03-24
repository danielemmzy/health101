"""initial schema with users doctors consultations chat_messages

Revision ID: 7daa0d26415b
Revises: 5fd3275a9c76
Create Date: 2026-03-03 10:05:24.766335

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '7daa0d26415b'
down_revision: Union[str, Sequence[str], None] = '5fd3275a9c76'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    pass


def downgrade() -> None:
    """Downgrade schema."""
    pass

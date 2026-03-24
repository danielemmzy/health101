"""add pharmacies and products tables

Revision ID: 8063f69fc51a
Revises: 7daa0d26415b
Create Date: 2026-03-13 16:03:01.408886

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '8063f69fc51a'
down_revision: Union[str, Sequence[str], None] = '7daa0d26415b'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    pass


def downgrade() -> None:
    """Downgrade schema."""
    pass

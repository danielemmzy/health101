"""description of change

Revision ID: 37340b13e418
Revises: 20e40be35beb
Create Date: 2026-03-27 12:31:45.725027

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '37340b13e418'
down_revision: Union[str, Sequence[str], None] = '20e40be35beb'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    pass


def downgrade() -> None:
    """Downgrade schema."""
    pass

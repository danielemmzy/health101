"""Add stock_quantity and slug to Product

Revision ID: 4d7c2cc4b335
Revises: 37340b13e418
Create Date: 2026-03-31 18:16:11.604689

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '4d7c2cc4b335'
down_revision: Union[str, Sequence[str], None] = '37340b13e418'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    pass


def downgrade() -> None:
    """Downgrade schema."""
    pass

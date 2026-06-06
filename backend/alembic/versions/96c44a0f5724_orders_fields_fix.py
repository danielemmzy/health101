"""orders fields fix"""

from alembic import op
import sqlalchemy as sa


revision = "96c44a0f5724"
down_revision = "6f697e3f3d73"
branch_labels = None
depends_on = None


def upgrade():

    # -----------------------------
    # ADD NEW COLUMNS
    # -----------------------------
    op.add_column(
        "orders",
        sa.Column("tracking_number", sa.String(100), nullable=True)
    )

    op.add_column(
        "orders",
        sa.Column("payment_method", sa.String(50), nullable=True)
    )

    op.add_column(
        "orders",
        sa.Column(
            "payment_status",
            sa.String(50),
            nullable=False,
            server_default="PENDING"
        )
    )

    # -----------------------------
    # FIX NULL ISSUES SAFELY
    # -----------------------------
    op.execute("""
        UPDATE orders
        SET payment_status = 'PENDING'
        WHERE payment_status IS NULL;
    """)

    # -----------------------------
    # INDEX
    # -----------------------------
    op.create_index(
        "ix_orders_tracking_number",
        "orders",
        ["tracking_number"]
    )


def downgrade():

    op.drop_index("ix_orders_tracking_number", table_name="orders")

    op.drop_column("orders", "payment_status")
    op.drop_column("orders", "payment_method")
    op.drop_column("orders", "tracking_number")

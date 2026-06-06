"""users role enum fix"""

from alembic import op
import sqlalchemy as sa


# Alembic identifiers
revision = "5c62f5b58065"
down_revision = "4d7c2cc4b335"
branch_labels = None
depends_on = None


def upgrade():

    # -----------------------------
    # 1. DROP DEFAULT (IMPORTANT)
    # -----------------------------
    op.execute("""
        ALTER TABLE users
        ALTER COLUMN role DROP DEFAULT;
    """)

    # -----------------------------
    # 2. NORMALIZE EXISTING DATA
    # -----------------------------
    op.execute("""
        UPDATE users
        SET role = UPPER(role);
    """)

    # -----------------------------
    # 3. CONVERT TO ENUM SAFELY
    # -----------------------------
    op.alter_column(
        "users",
        "role",
        existing_type=sa.VARCHAR(length=20),
        type_=sa.Enum(
            "PATIENT",
            "DOCTOR",
            "PHARMACY",
            "ADMIN",
            name="userrole"
        ),
        existing_nullable=False,
        postgresql_using="role::text::userrole"
    )

    # -----------------------------
    # 4. SET NEW VALID DEFAULT
    # -----------------------------
    op.execute("""
        ALTER TABLE users
        ALTER COLUMN role SET DEFAULT 'PATIENT';
    """)


def downgrade():

    # remove default first
    op.execute("""
        ALTER TABLE users
        ALTER COLUMN role DROP DEFAULT;
    """)

    # revert ENUM → VARCHAR
    op.alter_column(
        "users",
        "role",
        type_=sa.VARCHAR(length=20),
        postgresql_using="role::text"
    )

    # restore old default
    op.execute("""
        ALTER TABLE users
        ALTER COLUMN role SET DEFAULT 'patient';
    """)

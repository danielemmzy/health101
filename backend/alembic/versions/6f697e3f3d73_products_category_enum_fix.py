"""products category enum fix"""

from alembic import op
import sqlalchemy as sa


revision = "6f697e3f3d73"
down_revision = "5c62f5b58065"
branch_labels = None
depends_on = None


def upgrade():

    # -----------------------------
    # 1. NORMALIZE CATEGORY DATA
    # -----------------------------
    op.execute("""
        UPDATE products
        SET category = UPPER(category);
    """)

    # -----------------------------
    # 2. ADD NEW COLUMNS SAFELY
    # -----------------------------
    op.add_column("products", sa.Column("image_urls", sa.JSON(), nullable=True))
    op.add_column("products", sa.Column("thumbnail_url", sa.String(length=500), nullable=True))

    op.add_column(
        "products",
        sa.Column(
            "is_featured",
            sa.Boolean(),
            nullable=False,
            server_default=sa.text("false")
        )
    )

    # -----------------------------
    # 3. ENUM CONVERSION (SAFE)
    # -----------------------------
    op.alter_column(
        "products",
        "category",
        existing_type=sa.VARCHAR(),
        type_=sa.Enum(
            "PAIN_RELIEF",
            "VITAMINS_SUPPLEMENTS",
            "COLD_FLU",
            "DIGESTIVE",
            "SKIN_CARE",
            "BABY_KIDS",
            "MEDICAL_DEVICES",
            "OTHER",
            name="productcategory"
        ),
        postgresql_using="category::text::productcategory"
    )

    # -----------------------------
    # 4. SET DEFAULT FOR NEW FIELD INDEXES (optional but safe)
    # -----------------------------
    op.create_index(
        "ix_products_is_featured",
        "products",
        ["is_featured"]
    )


def downgrade():

    op.drop_index("ix_products_is_featured", table_name="products")

    op.drop_column("products", "is_featured")
    op.drop_column("products", "thumbnail_url")
    op.drop_column("products", "image_urls")

    op.alter_column(
        "products",
        "category",
        type_=sa.VARCHAR(),
        postgresql_using="category::text"
    )

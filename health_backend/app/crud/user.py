from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, update
from app.models.user import User, UserRole
from app.utils.security import hash_password, verify_password
from sqlalchemy.exc import IntegrityError

async def create_user(db: AsyncSession, email: str, password: str, full_name: str | None = None, role: UserRole = UserRole.PATIENT, location: dict | None = None):
    try:
        hashed_pw = hash_password(password)
        user = User(email=email, hashed_password=hashed_pw, full_name=full_name, role=role, location=location)
        db.add(user)
        await db.commit()
        await db.refresh(user)
        return user
    except IntegrityError:
        await db.rollback()
        return None  # email duplicate

async def get_user_by_email(db: AsyncSession, email: str):
    stmt = select(User).where(User.email == email)
    result = await db.execute(stmt)
    return result.scalar_one_or_none()

async def authenticate_user(db: AsyncSession, email: str, password: str):
    user = await get_user_by_email(db, email)
    if not user or not verify_password(password, user.hashed_password):
        return None
    return user

async def update_user(db: AsyncSession, user_id: int, full_name: str | None = None, password: str | None = None):
    values = {}
    if full_name is not None:
        values["full_name"] = full_name
    if password:
        values["hashed_password"] = hash_password(password)
    if not values:
        return None
    stmt = update(User).where(User.id == user_id).values(values).returning(User)
    result = await db.execute(stmt)
    await db.commit()
    return result.scalar_one_or_none()

async def deactivate_user(db: AsyncSession, user_id: int):
    stmt = update(User).where(User.id == user_id).values(is_active=False).returning(User)
    result = await db.execute(stmt)
    await db.commit()
    return result.scalar_one_or_none()
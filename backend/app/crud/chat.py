
from app.models.chat_message import ChatMessage
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.models.chat_message import ChatMessage
from app.models.user import User

async def save_chat_message(db: AsyncSession, consultation_id: int, sender_id: int, content: str):
    message = ChatMessage(
        consultation_id=consultation_id,
        sender_id=sender_id,
        content=content
    )
    db.add(message)
    await db.commit()
    await db.refresh(message)
    return message

async def create_chat_message(
    db: AsyncSession,
    consultation_id: int,
    sender_id: int,
    content: str
):
    # Create message
    message = ChatMessage(
        consultation_id=consultation_id,
        sender_id=sender_id,
        content=content
    )
    db.add(message)
    await db.commit()
    await db.refresh(message)

    # Enrich with sender info (this fixes the validation error)
    stmt = select(User).where(User.id == sender_id)
    result = await db.execute(stmt)
    user = result.scalar_one_or_none()

    # Return enriched object
    return {
        "id": message.id,
        "consultation_id": message.consultation_id,
        "sender_id": message.sender_id,
        "sender_name": user.full_name if user else "Unknown",
        "sender_role": user.role if user else "PATIENT",
        "content": message.content,
        "created_at": message.created_at,
        "is_read": message.is_read
    }
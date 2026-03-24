from sqlalchemy.ext.asyncio import AsyncSession
from app.models.chat_message import ChatMessage

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
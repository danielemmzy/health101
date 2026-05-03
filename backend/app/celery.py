from celery import Celery
from app.settings import settings
from app.utils.email import send_verification_email

celery_app = Celery(
    "health101",
    broker=settings.CELERY_BROKER_URL,
    backend=settings.CELERY_RESULT_BACKEND
)

@celery_app.task
def send_verification_email_task(email: str, code: str):
    import asyncio
    print("📨 Celery task started")
    asyncio.run(send_verification_email(email, code))
    print("📨 Email sending finished")
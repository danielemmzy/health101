from celery import Celery
from app.settings import settings
from twilio.rest import Client  # for SMS (optional)

app = Celery('health101', broker=settings.CELERY_BROKER_URL, backend=settings.CELERY_RESULT_BACKEND)

@app.task
def send_notification(user_id: int, message: str):
    # Stub for SMS/email
    client = Client("TWILIO_SID", "TWILIO_TOKEN")
    client.messages.create(body=message, from_="your_twilio_number", to="user_phone")
    print("Notification sent:", message)
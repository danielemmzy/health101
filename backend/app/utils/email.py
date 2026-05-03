from email.message import EmailMessage
import aiosmtplib
from app.settings import settings
import logging

logger = logging.getLogger(__name__)

async def send_verification_email(email: str, code: str) -> bool:
    try:
        message = EmailMessage()
        message["From"] = settings.EMAIL_HOST_USER
        message["To"] = email
        message["Subject"] = "Your Health101 Verification Code"

        message.set_content(f"""
Hello,

Your verification code is: {code}

This code will expire in 5 minutes.

If you didn't request this, ignore this email.

Health101 Team
""")
    

        await aiosmtplib.send(
    message,
    hostname="smtp.titan.email",
    port=587,
    start_tls=True,
    username=settings.EMAIL_HOST_USER,
    password = settings.EMAIL_HOST_PASSWORD.get_secret_value(),
)
        
        return True

    except Exception as e:
        print("❌ EMAIL ERROR:", str(e))
        return False
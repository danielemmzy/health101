from fastapi import FastAPI, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import text
from app.database import engine, Base, get_db
from app.models.user import User
from app.routers.auth import router as auth_router
from slowapi import Limiter
from slowapi.middleware import SlowAPIMiddleware
from slowapi.util import get_remote_address
from app.celery import app as celery_app
from app.routers.consultation import router as consultation_router
from app.routers.doctor import router as doctor_router

app = FastAPI()
app = FastAPI(debug=True)  # ← add debug=True

# Rate limiting global (for scale)
limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter
app.add_middleware(SlowAPIMiddleware)

app.include_router(auth_router)
app.include_router(consultation_router)
app.include_router(doctor_router)

#@app.on_event("startup")
#async def startup_event():
    #async with engine.begin() as conn:
        #await conn.run_sync(Base.metadata.create_all)

@app.get("/health")
async def health_check(db: AsyncSession = Depends(get_db)):
    await db.execute(text("SELECT 1"))
    return {"status": "healthy", "database": "connected"}
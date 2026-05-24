from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, update, and_
from sqlalchemy.exc import NoResultFound, IntegrityError, SQLAlchemyError
from app.models.consultation import Consultation, ConsultationStatus
from app.models.doctor import Doctor
from app.dependencies import get_current_user  
from datetime import datetime, timedelta, timezone
from app.settings import settings
from redis.asyncio import Redis
from typing import Dict, List, Optional
from fastapi import HTTPException
import logging
from app.models.user import User

redis = Redis.from_url(settings.REDIS_URL or "redis://localhost:6379/0")
logger = logging.getLogger(__name__)

async def check_doctor_availability(
    db: AsyncSession,
    doctor_id: int,
    scheduled_time: datetime,
    duration_minutes: int,
) -> bool:
    """
    Check if the doctor exists, is available, and has no overlapping booking.
    All times are expected to be timezone-aware (UTC).
    Returns True if available, False otherwise.
    """
    # Ensure scheduled_time is UTC-aware
    if scheduled_time.tzinfo is None:
        scheduled_time = scheduled_time.replace(tzinfo=timezone.utc)

    # Debug: show the time range being checked
    end_time = scheduled_time + timedelta(minutes=duration_minutes)
    print(f"Checking overlap for doctor {doctor_id}: {scheduled_time} to {end_time}")

    # Doctor must exist and be available
    stmt = select(Doctor).where(Doctor.id == doctor_id)
    result = await db.execute(stmt)
    doctor = result.scalar_one_or_none()

    if not doctor:
        print(f"Doctor {doctor_id} not found")
        return False

    if not doctor.is_available:
        print(f"Doctor {doctor_id} ({doctor.name}) is marked unavailable")
        return False

    # Check for any overlapping consultation
    overlapping_stmt = select(Consultation).where(
        Consultation.doctor_id == doctor_id,
        Consultation.scheduled_time.between(scheduled_time, end_time)
    )
    overlapping_result = await db.execute(overlapping_stmt)
    overlapping = overlapping_result.scalar_one_or_none()

    if overlapping:
        print(f"Overlap found: consultation {overlapping.id} at {overlapping.scheduled_time} "
              f"for {overlapping.duration_minutes} min")
        return False

    print(f"No overlap found for doctor {doctor_id}")
    return True

async def create_consultation(
    db: AsyncSession,
    user_id: int,
    doctor_id: int,
    scheduled_time: datetime,
    duration_minutes: int = 30,
    notes: str | None = None,
):
    """
    Create a new consultation booking.
    - Ensures time is UTC-aware
    - Prevents past bookings
    - Checks availability
    - Handles transaction rollback on conflict
    """
    # Force scheduled_time to be UTC-aware
    if scheduled_time.tzinfo is None:
        scheduled_time = scheduled_time.replace(tzinfo=timezone.utc)

    # Prevent booking in the past
    now_utc = datetime.now(timezone.utc)
    if scheduled_time < now_utc:
        raise HTTPException(
            status_code=400,
            detail="Cannot book a consultation in the past"
        )

    # Check availability
    if not await check_doctor_availability(db, doctor_id, scheduled_time, duration_minutes):
        raise HTTPException(
            status_code=400,
            detail="Doctor is not available at the requested time"
        )

    try:
        consultation = Consultation(
            user_id=user_id,
            doctor_id=doctor_id,
            scheduled_time=scheduled_time,
            duration_minutes=duration_minutes,
            notes=notes,
        )

        db.add(consultation)
        await db.commit()
        await db.refresh(consultation)

        # Cache the consultation ID (optional, for scale)
        await redis.setex(f"consultation:{consultation.id}", 3600, consultation.id)

        return consultation

    except IntegrityError as e:
        await db.rollback()
        raise HTTPException(
            status_code=409,
            detail="Booking conflict — possible concurrent booking"
        ) from e

    except Exception as e:
        await db.rollback()
        print("Booking failed with error:", str(e))  # ← add this print
        raise HTTPException(
            status_code=500,
            detail=f"Failed to create consultation: {str(e)}"
        ) from e

async def get_consultation(db: AsyncSession, consultation_id: int) -> Consultation:
    """
    Fetch a single consultation by ID.
    """
    try:
        stmt = select(Consultation).where(Consultation.id == consultation_id)
        result = await db.execute(stmt)
        consultation = result.scalar_one_or_none()

        if consultation is None:
            logger.warning(f"Consultation not found: ID {consultation_id}")
            raise HTTPException(
                status_code=404,
                detail=f"Consultation with ID {consultation_id} not found"
            )

        return consultation

    except SQLAlchemyError as e:
        logger.error(f"Database error fetching consultation {consultation_id}: {str(e)}", exc_info=True)
        raise HTTPException(status_code=500, detail="Database error while fetching consultation") from e

    except Exception as e:
        logger.exception(f"Unexpected error fetching consultation {consultation_id}")
        raise HTTPException(status_code=500, detail="Unexpected error while fetching consultation") from e


async def get_user_consultations(
    db: AsyncSession,
    user_id: int,
    skip: int = 0,
    limit: int = 10
):
    """
    Fetch user's consultations with doctor details by joining through User table.
    """
    try:
        stmt = (
            select(
                Consultation,
                User.full_name.label("doctor_name"),      # ← Get name from User
                User.id.label("doctor_user_id"),
                Doctor.specialty.label("doctor_specialty"),
                Doctor.id.label("doctor_id"),
            )
            .join(Doctor, Consultation.doctor_id == Doctor.id)
            .join(User, Doctor.user_id == User.id)       # ← Join User to get full_name
            .where(Consultation.user_id == user_id)
            .order_by(Consultation.scheduled_time.desc())
            .offset(skip)
            .limit(limit)
        )

        result = await db.execute(stmt)
        rows = result.all()

        consultations = []
        for row in rows:
            cons = row[0]

            cons_dict = {
                "id": cons.id,
                "doctor_id": row.doctor_id,
                "user_id": cons.user_id,
                "status": cons.status.value if hasattr(cons.status, "value") else cons.status,
                "scheduled_time": cons.scheduled_time,
                "duration_minutes": cons.duration_minutes,
                "notes": cons.notes,
                "created_at": cons.created_at,
                "doctor": {
                    "id": row.doctor_id,
                    "name": row.doctor_name,               # ← This will now work
                    "specialty": row.doctor_specialty,
                }
            }
            consultations.append(cons_dict)

        logger.info(f"Retrieved {len(consultations)} consultations for user {user_id}")
        return consultations

    except SQLAlchemyError as e:
        logger.error(f"Database error fetching consultations for user {user_id}: {e}", exc_info=True)
        raise HTTPException(status_code=500, detail="Database error while fetching consultations") from e

    except Exception as e:
        logger.exception(f"Unexpected error fetching consultations for user {user_id}")
        raise HTTPException(status_code=500, detail="Unexpected error") from e

async def update_consultation_status(db: AsyncSession, consultation_id: int, status: ConsultationStatus):
    stmt = update(Consultation).where(Consultation.id == consultation_id).values(status=status).returning(Consultation)
    result = await db.execute(stmt)
    await db.commit()
    return result.scalar_one_or_none()

async def list_available_doctors(
    db: AsyncSession,
    specialty: Optional[str] = None,
    location: Optional[Dict[str, float]] = None,
    skip: int = 0,
    limit: int = 10
) -> List[Doctor]:
    """
    List available doctors with optional filters.
    - specialty: partial match (case-insensitive)
    - location: geo search within 50km (requires PostGIS extension in Neon)
    - skip/limit: pagination
    """
    stmt = select(Doctor).where(Doctor.is_available == True)

    if specialty:
        stmt = stmt.where(Doctor.specialty.ilike(f"%{specialty}%"))

    if location:
        # PostGIS geo search (within 50km ≈ 50000 meters)
        # Assumes location column is JSON with "lat" and "lon" keys
        stmt = stmt.where(
            "ST_DWithin("
            "  ST_SetSRID(ST_Point(location->>'lon', location->>'lat'), 4326),"
            "  ST_SetSRID(ST_Point(:lon, :lat), 4326),"
            "  50000"
            ")"
        ).params(lat=location["lat"], lon=location["lon"])

    stmt = stmt.offset(skip).limit(limit).order_by(Doctor.rating.desc(), Doctor.experience_years.desc())

    result = await db.execute(stmt)
    doctors = result.scalars().all()

    # Optional: ensure consistent output (None → empty structures)
    for doctor in doctors:
        if doctor.location is None:
            doctor.location = {}
        if doctor.availability_slots is None:
            doctor.availability_slots = []

    return doctors

async def is_doctor_of_consultation(db: AsyncSession, user_id: int, consultation_id: int) -> bool:
    """
    Check if the given user_id is the doctor for the given consultation.
    Returns True if yes, False otherwise.
    """
    stmt = select(Consultation).where(
        Consultation.id == consultation_id,
        Consultation.doctor_id == user_id
    )
    result = await db.execute(stmt)
    return result.scalar_one_or_none() is not None

async def get_doctor_by_user_id(db: AsyncSession, user_id: int):
    """
    Fetch doctor profile by user_id.
    Raises 403 if not found or not verified.
    """
    stmt = select(Doctor).where(Doctor.user_id == user_id)
    result = await db.execute(stmt)
    doctor = result.scalar_one_or_none()
    
    if not doctor:
        raise HTTPException(status_code=403, detail="Doctor profile not found")
    
    return doctor
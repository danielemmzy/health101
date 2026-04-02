from sqlalchemy import select, update
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import NoResultFound
from app.models.consultation import Consultation, ConsultationStatus
from app.models.doctor import Doctor
from fastapi import HTTPException
from datetime import datetime, timezone

# ====================== DOCTOR-SPECIFIC CRUD ======================

async def get_doctor_consultations(
    db: AsyncSession, 
    doctor_id: int, 
    skip: int = 0, 
    limit: int = 20
):
    """Doctor sees all their consultations (pending + confirmed + past)"""
    stmt = (
        select(Consultation)
        .where(Consultation.doctor_id == doctor_id)
        .order_by(Consultation.scheduled_time.desc())
        .offset(skip)
        .limit(limit)
    )
    result = await db.execute(stmt)
    return result.scalars().all()


async def accept_consultation(
    db: AsyncSession, 
    consultation_id: int, 
    doctor_id: int
):
    """Doctor accepts a pending consultation"""
    stmt = (
        update(Consultation)
        .where(
            Consultation.id == consultation_id,
            Consultation.doctor_id == doctor_id,
            Consultation.status == ConsultationStatus.PENDING
        )
        .values(status=ConsultationStatus.CONFIRMED, updated_at=datetime.now(timezone.utc))
        .returning(Consultation)
    )
    result = await db.execute(stmt)
    await db.commit()
    return result.scalar_one_or_none()


async def reject_consultation(
    db: AsyncSession, 
    consultation_id: int, 
    doctor_id: int, 
    reason: str | None = None
):
    """Doctor rejects a pending consultation"""
    stmt = (
        update(Consultation)
        .where(
            Consultation.id == consultation_id,
            Consultation.doctor_id == doctor_id,
            Consultation.status == ConsultationStatus.PENDING
        )
        .values(
            status=ConsultationStatus.CANCELLED,
            notes=(reason or "Rejected by doctor"),
            updated_at=datetime.now(timezone.utc)
        )
        .returning(Consultation)
    )
    result = await db.execute(stmt)
    await db.commit()
    return result.scalar_one_or_none()


# Keep your existing functions (create_consultation, update_consultation_status, etc.)
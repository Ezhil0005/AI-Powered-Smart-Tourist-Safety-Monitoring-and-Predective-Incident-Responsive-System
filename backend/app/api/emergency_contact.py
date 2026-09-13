from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.security import get_current_user
from app.db.session import get_db
from app.models.emergency_contact import EmergencyContact
from app.models.tourist import Tourist
from app.models.user import User
from app.schemas.emergency_contact import (
    EmergencyContactCreate,
    EmergencyContactResponse,
    EmergencyContactUpdate,
)


router = APIRouter(
    prefix="/emergency-contacts",
    tags=["Emergency Contacts"],
)


def get_current_tourist(current_user: User, db: Session):
    tourist = (
        db.query(Tourist)
        .filter(Tourist.user_id == current_user.id)
        .first()
    )

    if not tourist:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Tourist profile not found",
        )

    return tourist


@router.post(
    "/",
    response_model=EmergencyContactResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_contact(
    data: EmergencyContactCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(current_user, db)

    contact = EmergencyContact(
        tourist_id=tourist.id,
        name=data.name,
        relationship_type=data.relationship_type,
        phone=data.phone,
        email=str(data.email) if data.email else None,
    )

    db.add(contact)
    db.commit()
    db.refresh(contact)

    return contact


@router.get("/", response_model=list[EmergencyContactResponse])
def list_contacts(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(current_user, db)

    return (
        db.query(EmergencyContact)
        .filter(EmergencyContact.tourist_id == tourist.id)
        .order_by(EmergencyContact.created_at.desc())
        .all()
    )


@router.put(
    "/{contact_id}",
    response_model=EmergencyContactResponse,
)
def update_contact(
    contact_id: int,
    data: EmergencyContactUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(current_user, db)

    contact = (
        db.query(EmergencyContact)
        .filter(
            EmergencyContact.id == contact_id,
            EmergencyContact.tourist_id == tourist.id,
        )
        .first()
    )

    if not contact:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Emergency contact not found",
        )

    if data.name is not None:
        contact.name = data.name

    if data.relationship_type is not None:
        contact.relationship_type = data.relationship_type

    if data.phone is not None:
        contact.phone = data.phone

    if data.email is not None:
        contact.email = str(data.email)

    db.commit()
    db.refresh(contact)

    return contact


@router.delete(
    "/{contact_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
def delete_contact(
    contact_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(current_user, db)

    contact = (
        db.query(EmergencyContact)
        .filter(
            EmergencyContact.id == contact_id,
            EmergencyContact.tourist_id == tourist.id,
        )
        .first()
    )

    if not contact:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Emergency contact not found",
        )

    db.delete(contact)
    db.commit()

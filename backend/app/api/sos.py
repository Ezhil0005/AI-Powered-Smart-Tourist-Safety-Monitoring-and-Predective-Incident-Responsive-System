from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.security import get_current_user
from app.db.session import get_db
from app.models.alert import Alert
from app.models.emergency_contact import EmergencyContact
from app.models.notification import Notification
from app.models.tourist import Tourist
from app.models.tourist_location import TouristLocation
from app.models.user import User
from app.schemas.sos import SOSResponse


router = APIRouter(
    prefix="/sos",
    tags=["SOS & Emergency"],
)


def get_current_tourist(
    current_user: User,
    db: Session,
):
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
    "/trigger",
    response_model=SOSResponse,
    status_code=status.HTTP_201_CREATED,
)
def trigger_sos(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(current_user, db)

    # Enable emergency mode
    tourist.emergency_mode = True

    # Get latest known GPS position
    latest_location = (
        db.query(TouristLocation)
        .filter(TouristLocation.tourist_id == tourist.id)
        .order_by(TouristLocation.recorded_at.desc())
        .first()
    )

    if latest_location:
        location_text = (
            f" Last known location: "
            f"{latest_location.latitude}, "
            f"{latest_location.longitude}."
        )
    else:
        location_text = " Last known GPS location is unavailable."

    # Create critical SOS alert
    alert = Alert(
        tourist_id=tourist.id,
        geofence_id=None,
        alert_type="sos",
        severity="critical",
        message=(
            f"SOS triggered by tourist {current_user.name}."
            f"{location_text}"
        ),
        status="active",
    )

    db.add(alert)
    db.flush()

    # Create in-app notification
    notification = Notification(
        user_id=current_user.id,
        tourist_id=tourist.id,
        notification_type="sos",
        title="Emergency SOS Activated",
        message=(
            "Your SOS request has been activated. "
            "Emergency contacts can now be notified."
            f"{location_text}"
        ),
        status="unread",
    )

    db.add(notification)

    # Load emergency contacts
    contacts = (
        db.query(EmergencyContact)
        .filter(EmergencyContact.tourist_id == tourist.id)
        .all()
    )

    db.commit()
    db.refresh(alert)
    db.refresh(notification)
    db.refresh(tourist)

    contact_data = [
        {
            "id": contact.id,
            "name": contact.name,
            "relationship_type": contact.relationship_type,
            "phone": contact.phone,
            "email": contact.email,
        }
        for contact in contacts
    ]

    return {
        "success": True,
        "alert_id": alert.id,
        "notification_id": notification.id,
        "emergency_mode": tourist.emergency_mode,
        "emergency_contacts": contact_data,
        "message": "Emergency SOS activated successfully",
    }


@router.post("/cancel")
def cancel_sos(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(current_user, db)

    tourist.emergency_mode = False

    active_sos_alerts = (
        db.query(Alert)
        .filter(
            Alert.tourist_id == tourist.id,
            Alert.alert_type == "sos",
            Alert.status == "active",
        )
        .all()
    )

    for alert in active_sos_alerts:
        alert.status = "resolved"

    notification = Notification(
        user_id=current_user.id,
        tourist_id=tourist.id,
        notification_type="sos_cancelled",
        title="Emergency SOS Cancelled",
        message="Your emergency SOS mode has been cancelled.",
        status="unread",
    )

    db.add(notification)
    db.commit()

    return {
        "success": True,
        "emergency_mode": False,
        "message": "SOS cancelled successfully",
    }


@router.get("/status")
def sos_status(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(current_user, db)

    return {
        "tourist_id": tourist.id,
        "emergency_mode": tourist.emergency_mode,
    }

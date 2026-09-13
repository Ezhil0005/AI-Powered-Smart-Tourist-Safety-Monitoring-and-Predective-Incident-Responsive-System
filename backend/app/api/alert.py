
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.security import get_current_user
from app.db.session import get_db
from app.models.alert import Alert
from app.models.tourist import Tourist
from app.models.user import User

router = APIRouter(
    prefix="/alerts",
    tags=["Alerts"],
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


@router.get("/")
def get_alerts(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(current_user, db)

    return (
        db.query(Alert)
        .filter(Alert.tourist_id == tourist.id)
        .order_by(Alert.created_at.desc())
        .all()
    )


@router.get("/{alert_id}")
def get_alert(
    alert_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(current_user, db)

    alert = (
        db.query(Alert)
        .filter(
            Alert.id == alert_id,
            Alert.tourist_id == tourist.id,
        )
        .first()
    )

    if not alert:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Alert not found",
        )

    return alert


@router.patch("/{alert_id}/acknowledge")
def acknowledge_alert(
    alert_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(current_user, db)

    alert = (
        db.query(Alert)
        .filter(
            Alert.id == alert_id,
            Alert.tourist_id == tourist.id,
        )
        .first()
    )

    if not alert:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Alert not found",
        )

    alert.status = "acknowledged"
    db.commit()
    db.refresh(alert)

    return alert

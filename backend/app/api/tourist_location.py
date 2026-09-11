from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.security import get_current_user
from app.db.session import get_db
from app.models.tourist import Tourist
from app.models.user import User
from app.schemas.tourist_location import (
    LocationCreate,
    LocationHistoryResponse,
    LocationResponse,
)
from app.services.tourist_location_service import (
    create_location,
    get_latest_location,
    get_trip_for_tourist,
    get_trip_locations,
)

router = APIRouter(
    prefix="/locations",
    tags=["GPS & Location"],
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
    "/",
    response_model=LocationResponse,
    status_code=status.HTTP_201_CREATED,
)
def update_location(
    data: LocationCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(
        current_user=current_user,
        db=db,
    )

    trip = get_trip_for_tourist(
        db=db,
        trip_id=data.trip_id,
        tourist_id=tourist.id,
    )

    if not trip:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Trip not found",
        )

    if trip.status not in {"active", "paused"}:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="GPS updates are allowed only for active or paused trips",
        )

    return create_location(
        db=db,
        tourist_id=tourist.id,
        trip_id=data.trip_id,
        latitude=data.latitude,
        longitude=data.longitude,
        accuracy=data.accuracy,
        speed=data.speed,
        heading=data.heading,
    )


@router.get(
    "/latest",
    response_model=LocationResponse,
)
def latest_location(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(
        current_user=current_user,
        db=db,
    )

    location = get_latest_location(
        db=db,
        tourist_id=tourist.id,
    )

    if not location:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No GPS location found",
        )

    return location


@router.get(
    "/trip/{trip_id}",
    response_model=LocationHistoryResponse,
)
def trip_location_history(
    trip_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(
        current_user=current_user,
        db=db,
    )

    trip = get_trip_for_tourist(
        db=db,
        trip_id=trip_id,
        tourist_id=tourist.id,
    )

    if not trip:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Trip not found",
        )

    locations = get_trip_locations(
        db=db,
        tourist_id=tourist.id,
        trip_id=trip_id,
    )

    return {
        "locations": locations,
        "total": len(locations),
    }

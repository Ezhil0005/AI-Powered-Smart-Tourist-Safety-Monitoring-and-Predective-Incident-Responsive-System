from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.security import get_current_user
from app.db.session import get_db
from app.models.tourist import Tourist
from app.models.user import User
from app.schemas.trip import TripCreate, TripResponse, TripUpdate
from app.services.trip_service import (
    create_trip,
    delete_trip,
    get_trip,
    get_trips,
    update_trip,
    update_trip_status,
)

router = APIRouter(
    prefix="/trips",
    tags=["Trips"],
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
    response_model=TripResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_new_trip(
    data: TripCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(current_user, db)

    if data.end_date < data.start_date:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="End date cannot be before start date",
        )

    return create_trip(
        db=db,
        tourist_id=tourist.id,
        destination=data.destination,
        start_date=data.start_date,
        end_date=data.end_date,
    )


@router.get(
    "/",
    response_model=list[TripResponse],
)
def list_my_trips(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(current_user, db)

    return get_trips(
        db=db,
        tourist_id=tourist.id,
    )


@router.get(
    "/{trip_id}",
    response_model=TripResponse,
)
def get_my_trip(
    trip_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(current_user, db)

    trip = get_trip(
        db=db,
        trip_id=trip_id,
        tourist_id=tourist.id,
    )

    if not trip:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Trip not found",
        )

    return trip


@router.put(
    "/{trip_id}",
    response_model=TripResponse,
)
def update_my_trip(
    trip_id: int,
    data: TripUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(current_user, db)

    trip = get_trip(
        db=db,
        trip_id=trip_id,
        tourist_id=tourist.id,
    )

    if not trip:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Trip not found",
        )

    start_date = (
        data.start_date
        if data.start_date is not None
        else trip.start_date
    )

    end_date = (
        data.end_date
        if data.end_date is not None
        else trip.end_date
    )

    if end_date < start_date:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="End date cannot be before start date",
        )

    return update_trip(
        db=db,
        trip=trip,
        destination=data.destination,
        start_date=data.start_date,
        end_date=data.end_date,
        status=data.status,
    )


@router.delete(
    "/{trip_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
def delete_my_trip(
    trip_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(current_user, db)

    trip = get_trip(
        db=db,
        trip_id=trip_id,
        tourist_id=tourist.id,
    )

    if not trip:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Trip not found",
        )

    delete_trip(
        db=db,
        trip=trip,
    )


@router.patch(
    "/{trip_id}/start",
    response_model=TripResponse,
)
def start_trip(
    trip_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(current_user, db)

    trip = get_trip(
        db=db,
        trip_id=trip_id,
        tourist_id=tourist.id,
    )

    if not trip:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Trip not found",
        )

    if trip.status != "planned":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Only planned trips can be started",
        )

    return update_trip_status(db, trip, "active")


@router.patch(
    "/{trip_id}/pause",
    response_model=TripResponse,
)
def pause_trip(
    trip_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(current_user, db)

    trip = get_trip(
        db=db,
        trip_id=trip_id,
        tourist_id=tourist.id,
    )

    if not trip:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Trip not found",
        )

    if trip.status != "active":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Only active trips can be paused",
        )

    return update_trip_status(db, trip, "paused")


@router.patch(
    "/{trip_id}/resume",
    response_model=TripResponse,
)
def resume_trip(
    trip_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(current_user, db)

    trip = get_trip(
        db=db,
        trip_id=trip_id,
        tourist_id=tourist.id,
    )

    if not trip:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Trip not found",
        )

    if trip.status != "paused":
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Only paused trips can be resumed",
        )

    return update_trip_status(db, trip, "active")


@router.patch(
    "/{trip_id}/end",
    response_model=TripResponse,
)
def end_trip(
    trip_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    tourist = get_current_tourist(current_user, db)

    trip = get_trip(
        db=db,
        trip_id=trip_id,
        tourist_id=tourist.id,
    )

    if not trip:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Trip not found",
        )

    if trip.status not in ("active", "paused"):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Only active or paused trips can be ended",
        )

    return update_trip_status(db, trip, "completed")

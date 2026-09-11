from sqlalchemy.orm import Session

from app.models.tourist_location import TouristLocation
from app.models.trip import Trip


def create_location(
    db: Session,
    tourist_id: int,
    trip_id: int,
    latitude: float,
    longitude: float,
    accuracy: float | None = None,
    speed: float | None = None,
    heading: float | None = None,
):
    location = TouristLocation(
        tourist_id=tourist_id,
        trip_id=trip_id,
        latitude=latitude,
        longitude=longitude,
        accuracy=accuracy,
        speed=speed,
        heading=heading,
    )

    db.add(location)
    db.commit()
    db.refresh(location)

    return location


def get_latest_location(
    db: Session,
    tourist_id: int,
):
    return (
        db.query(TouristLocation)
        .filter(TouristLocation.tourist_id == tourist_id)
        .order_by(TouristLocation.recorded_at.desc())
        .first()
    )


def get_trip_locations(
    db: Session,
    tourist_id: int,
    trip_id: int,
):
    return (
        db.query(TouristLocation)
        .filter(
            TouristLocation.tourist_id == tourist_id,
            TouristLocation.trip_id == trip_id,
        )
        .order_by(TouristLocation.recorded_at.asc())
        .all()
    )


def get_trip_for_tourist(
    db: Session,
    trip_id: int,
    tourist_id: int,
):
    return (
        db.query(Trip)
        .filter(
            Trip.id == trip_id,
            Trip.tourist_id == tourist_id,
        )
        .first()
    )

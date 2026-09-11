from sqlalchemy.orm import Session

from app.models.trip import Trip


def create_trip(
    db: Session,
    tourist_id: int,
    destination: str,
    start_date,
    end_date,
):
    trip = Trip(
        tourist_id=tourist_id,
        destination=destination.strip(),
        start_date=start_date,
        end_date=end_date,
        status="planned",
    )

    db.add(trip)
    db.commit()
    db.refresh(trip)

    return trip


def get_trip(
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


def get_trips(
    db: Session,
    tourist_id: int,
):
    return (
        db.query(Trip)
        .filter(Trip.tourist_id == tourist_id)
        .order_by(Trip.start_date.desc())
        .all()
    )


def update_trip(
    db: Session,
    trip: Trip,
    destination=None,
    start_date=None,
    end_date=None,
    status=None,
):
    if destination is not None:
        trip.destination = destination.strip()

    if start_date is not None:
        trip.start_date = start_date

    if end_date is not None:
        trip.end_date = end_date

    if status is not None:
        trip.status = status

    db.commit()
    db.refresh(trip)

    return trip


def delete_trip(
    db: Session,
    trip: Trip,
):
    db.delete(trip)
    db.commit()


def update_trip_status(
    db: Session,
    trip: Trip,
    status: str,
):
    trip.status = status

    db.commit()
    db.refresh(trip)

    return trip

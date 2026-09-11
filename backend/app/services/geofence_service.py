import math

from sqlalchemy.orm import Session

from app.models.geofence_zone import GeofenceZone


EARTH_RADIUS_METERS = 6_371_000


def calculate_distance_meters(
    latitude1: float,
    longitude1: float,
    latitude2: float,
    longitude2: float,
):
    lat1 = math.radians(latitude1)
    lat2 = math.radians(latitude2)

    delta_lat = math.radians(latitude2 - latitude1)
    delta_lon = math.radians(longitude2 - longitude1)

    a = (
        math.sin(delta_lat / 2) ** 2
        + math.cos(lat1)
        * math.cos(lat2)
        * math.sin(delta_lon / 2) ** 2
    )

    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))

    return EARTH_RADIUS_METERS * c


def create_geofence(
    db: Session,
    name: str,
    description: str | None,
    latitude: float,
    longitude: float,
    radius: float,
    zone_type: str,
):
    geofence = GeofenceZone(
        name=name.strip(),
        description=description,
        latitude=latitude,
        longitude=longitude,
        radius=radius,
        zone_type=zone_type.strip().lower(),
        is_active=True,
    )

    db.add(geofence)
    db.commit()
    db.refresh(geofence)

    return geofence


def get_geofences(db: Session):
    return (
        db.query(GeofenceZone)
        .filter(GeofenceZone.is_active == True)
        .order_by(GeofenceZone.id.asc())
        .all()
    )


def get_geofence(
    db: Session,
    geofence_id: int,
):
    return (
        db.query(GeofenceZone)
        .filter(GeofenceZone.id == geofence_id)
        .first()
    )


def update_geofence(
    db: Session,
    geofence: GeofenceZone,
    name=None,
    description=None,
    latitude=None,
    longitude=None,
    radius=None,
    zone_type=None,
    is_active=None,
):
    if name is not None:
        geofence.name = name.strip()

    if description is not None:
        geofence.description = description

    if latitude is not None:
        geofence.latitude = latitude

    if longitude is not None:
        geofence.longitude = longitude

    if radius is not None:
        geofence.radius = radius

    if zone_type is not None:
        geofence.zone_type = zone_type.strip().lower()

    if is_active is not None:
        geofence.is_active = is_active

    db.commit()
    db.refresh(geofence)

    return geofence


def delete_geofence(
    db: Session,
    geofence: GeofenceZone,
):
    db.delete(geofence)
    db.commit()


def check_geofences(
    db: Session,
    latitude: float,
    longitude: float,
):
    zones = get_geofences(db)

    results = []

    for zone in zones:
        distance = calculate_distance_meters(
            latitude,
            longitude,
            zone.latitude,
            zone.longitude,
        )

        if distance <= zone.radius:
            results.append(
                {
                    "geofence_id": zone.id,
                    "name": zone.name,
                    "zone_type": zone.zone_type,
                    "distance_meters": round(distance, 2),
                    "radius_meters": zone.radius,
                    "inside": True,
                }
            )

    return results

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.core.dependencies import require_admin
from app.core.security import get_current_user
from app.db.session import get_db
from app.models.user import User
from app.schemas.geofence import (
    GeofenceCheckRequest,
    GeofenceCheckResponse,
    GeofenceCreate,
    GeofenceResponse,
    GeofenceUpdate,
)
from app.services.geofence_service import (
    check_geofences,
    create_geofence,
    delete_geofence,
    get_geofence,
    get_geofences,
    update_geofence,
)

router = APIRouter(
    prefix="/geofences",
    tags=["Geofencing"],
)


@router.post(
    "/",
    response_model=GeofenceResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_new_geofence(
    data: GeofenceCreate,
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    return create_geofence(
        db=db,
        name=data.name,
        description=data.description,
        latitude=data.latitude,
        longitude=data.longitude,
        radius=data.radius,
        zone_type=data.zone_type,
    )


@router.get(
    "/",
    response_model=list[GeofenceResponse],
)
def list_active_geofences(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return get_geofences(db)


@router.get(
    "/{geofence_id}",
    response_model=GeofenceResponse,
)
def get_single_geofence(
    geofence_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    geofence = get_geofence(db, geofence_id)

    if not geofence:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Geofence not found",
        )

    return geofence


@router.put(
    "/{geofence_id}",
    response_model=GeofenceResponse,
)
def update_existing_geofence(
    geofence_id: int,
    data: GeofenceUpdate,
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    geofence = get_geofence(db, geofence_id)

    if not geofence:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Geofence not found",
        )

    return update_geofence(
        db=db,
        geofence=geofence,
        name=data.name,
        description=data.description,
        latitude=data.latitude,
        longitude=data.longitude,
        radius=data.radius,
        zone_type=data.zone_type,
        is_active=data.is_active,
    )


@router.delete(
    "/{geofence_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
def delete_existing_geofence(
    geofence_id: int,
    current_user: User = Depends(require_admin),
    db: Session = Depends(get_db),
):
    geofence = get_geofence(db, geofence_id)

    if not geofence:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Geofence not found",
        )

    delete_geofence(db, geofence)


@router.post(
    "/check",
    response_model=GeofenceCheckResponse,
)
def check_location_against_geofences(
    data: GeofenceCheckRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    matched_zones = check_geofences(
        db=db,
        latitude=data.latitude,
        longitude=data.longitude,
    )

    return {
        "latitude": data.latitude,
        "longitude": data.longitude,
        "matched_zones": matched_zones,
    }

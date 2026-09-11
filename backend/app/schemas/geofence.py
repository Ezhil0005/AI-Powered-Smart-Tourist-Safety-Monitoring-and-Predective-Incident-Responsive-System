from datetime import datetime

from pydantic import BaseModel, Field


class GeofenceCreate(BaseModel):
    name: str = Field(..., min_length=2, max_length=150)
    description: str | None = None
    latitude: float = Field(..., ge=-90, le=90)
    longitude: float = Field(..., ge=-180, le=180)
    radius: float = Field(..., gt=0, le=100000)
    zone_type: str = Field(..., min_length=2, max_length=30)


class GeofenceUpdate(BaseModel):
    name: str | None = Field(default=None, min_length=2, max_length=150)
    description: str | None = None
    latitude: float | None = Field(default=None, ge=-90, le=90)
    longitude: float | None = Field(default=None, ge=-180, le=180)
    radius: float | None = Field(default=None, gt=0, le=100000)
    zone_type: str | None = Field(default=None, min_length=2, max_length=30)
    is_active: bool | None = None


class GeofenceResponse(BaseModel):
    id: int
    name: str
    description: str | None
    latitude: float
    longitude: float
    radius: float
    zone_type: str
    is_active: bool
    created_at: datetime

    class Config:
        from_attributes = True


class GeofenceCheckRequest(BaseModel):
    latitude: float = Field(..., ge=-90, le=90)
    longitude: float = Field(..., ge=-180, le=180)


class GeofenceCheckResult(BaseModel):
    geofence_id: int
    name: str
    zone_type: str
    distance_meters: float
    radius_meters: float
    inside: bool


class GeofenceCheckResponse(BaseModel):
    latitude: float
    longitude: float
    matched_zones: list[GeofenceCheckResult]

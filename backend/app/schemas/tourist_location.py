from datetime import datetime

from pydantic import BaseModel, Field


class LocationCreate(BaseModel):
    trip_id: int
    latitude: float = Field(..., ge=-90, le=90)
    longitude: float = Field(..., ge=-180, le=180)
    accuracy: float | None = Field(default=None, ge=0)
    speed: float | None = Field(default=None, ge=0)
    heading: float | None = Field(default=None, ge=0, le=360)


class LocationResponse(BaseModel):
    id: int
    tourist_id: int
    trip_id: int
    latitude: float
    longitude: float
    accuracy: float | None
    speed: float | None
    heading: float | None
    recorded_at: datetime
    created_at: datetime

    class Config:
        from_attributes = True


class LocationHistoryResponse(BaseModel):
    locations: list[LocationResponse]
    total: int

from datetime import date, datetime

from pydantic import BaseModel, ConfigDict, Field


class TripCreate(BaseModel):
    destination: str = Field(..., min_length=2, max_length=255)
    start_date: date
    end_date: date


class TripUpdate(BaseModel):
    destination: str | None = Field(default=None, min_length=2, max_length=255)
    start_date: date | None = None
    end_date: date | None = None
    status: str | None = Field(default=None, max_length=30)


class TripResponse(BaseModel):
    id: int
    tourist_id: int
    destination: str
    start_date: date
    end_date: date
    status: str
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)

from datetime import datetime
from pydantic import BaseModel, ConfigDict, EmailStr, Field


class EmergencyContactCreate(BaseModel):
    name: str = Field(..., min_length=2, max_length=100)
    relationship_type: str | None = Field(default=None, max_length=50)
    phone: str = Field(..., min_length=5, max_length=20)
    email: EmailStr | None = None


class EmergencyContactUpdate(BaseModel):
    name: str | None = Field(default=None, min_length=2, max_length=100)
    relationship_type: str | None = Field(default=None, max_length=50)
    phone: str | None = Field(default=None, min_length=5, max_length=20)
    email: EmailStr | None = None


class EmergencyContactResponse(BaseModel):
    id: int
    tourist_id: int
    name: str
    relationship_type: str | None
    phone: str
    email: str | None
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)

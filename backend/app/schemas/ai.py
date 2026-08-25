from pydantic import BaseModel, Field


class GPSPoint(BaseModel):
    latitude: float = Field(..., ge=-90, le=90)
    longitude: float = Field(..., ge=-180, le=180)
    speed: float = Field(..., ge=0)


class AIAnalysisRequest(BaseModel):
    tourist_id: int = Field(..., gt=0)
    previous: GPSPoint
    current: GPSPoint


class AIAnalysisResponse(BaseModel):
    tourist_id: int
    risk_level: str
    safety_score: int
    route_deviation: bool
    anomaly: bool
    deviation_score: float
    alert_generated: bool
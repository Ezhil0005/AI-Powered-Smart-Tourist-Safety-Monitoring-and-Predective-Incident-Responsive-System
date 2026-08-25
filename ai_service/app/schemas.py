from pydantic import BaseModel, Field


class GPSPoint(BaseModel):
    latitude: float = Field(..., ge=-90, le=90)
    longitude: float = Field(..., ge=-180, le=180)
    speed: float = Field(..., ge=0)


class RiskPredictionRequest(BaseModel):
    previous: GPSPoint
    current: GPSPoint


class RiskPredictionResponse(BaseModel):
    risk_level: str
    safety_score: int
    route_deviation: bool
    anomaly: bool


class RouteDeviationResponse(BaseModel):
    route_deviation: bool
    deviation_score: float
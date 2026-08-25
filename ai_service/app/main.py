from fastapi import FastAPI, HTTPException

from app.predictor import predict, predict_route_deviation
from app.schemas import (
    RiskPredictionRequest,
    RiskPredictionResponse,
    RouteDeviationResponse,
)


app = FastAPI(
    title="Tourist Safety AI Service",
    description="AI microservice for tourist risk and route anomaly detection",
    version="1.0.0",
)


@app.get("/health")
def health_check():
    return {
        "status": "ok",
        "service": "tourist-safety-ai-service",
    }


@app.get("/")
def root():
    return {
        "message": "Tourist Safety AI Service is running",
    }


@app.post(
    "/predict-risk",
    response_model=RiskPredictionResponse,
)
def predict_risk(request: RiskPredictionRequest):
    try:
        return predict(
            request.previous,
            request.current,
        )
    except Exception as exc:
        raise HTTPException(
            status_code=500,
            detail=f"Risk prediction failed: {exc}",
        )


@app.post(
    "/predict-route-deviation",
    response_model=RouteDeviationResponse,
)
def predict_route(request: RiskPredictionRequest):
    try:
        return predict_route_deviation(
            request.previous,
            request.current,
        )
    except Exception as exc:
        raise HTTPException(
            status_code=500,
            detail=f"Route deviation prediction failed: {exc}",
        )
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.models.alert import Alert
from app.models.anomaly_score import AnomalyScore
from app.models.safety_score import SafetyScore
from app.models.tourist import Tourist
from app.schemas.ai import AIAnalysisRequest, AIAnalysisResponse
from app.services.ai_service import (
    AIServiceError,
    predict_risk,
    predict_route_deviation,
)


router = APIRouter(
    prefix="/ai",
    tags=["AI"],
)


@router.post(
    "/analyze-location",
    response_model=AIAnalysisResponse,
)
async def analyze_location(
    request: AIAnalysisRequest,
    db: Session = Depends(get_db),
):
    # Validate tourist before calling AI or writing anything to the database.
    tourist = (
        db.query(Tourist)
        .filter(Tourist.id == request.tourist_id)
        .first()
    )

    if tourist is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Tourist {request.tourist_id} not found",
        )

    # Call AI microservice.
    try:
        risk_result = await predict_risk(
            request.previous.model_dump(),
            request.current.model_dump(),
        )

        deviation_result = await predict_route_deviation(
            request.previous.model_dump(),
            request.current.model_dump(),
        )

    except AIServiceError as exc:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail=str(exc),
        ) from exc

    # Store anomaly score.
    anomaly_record = AnomalyScore(
        tourist_id=request.tourist_id,
        score=float(deviation_result["deviation_score"]),
        model_version="isolation-forest-v1",
    )

    # Store safety score.
    safety_record = SafetyScore(
        tourist_id=request.tourist_id,
        score=float(risk_result["safety_score"]),
    )

    db.add(anomaly_record)
    db.add(safety_record)

    alert_generated = False

    # Prevent duplicate active AI-risk alerts.
    if risk_result["risk_level"] == "High":
        existing_alert = (
            db.query(Alert)
            .filter(
                Alert.tourist_id == request.tourist_id,
                Alert.alert_type == "AI_RISK",
                Alert.status == "active",
            )
            .first()
        )

        if existing_alert is None:
            alert = Alert(
                tourist_id=request.tourist_id,
                geofence_id=None,
                alert_type="AI_RISK",
                severity="HIGH",
                message=(
                    "High-risk tourist behavior detected by AI. "
                    "Route deviation identified."
                ),
                status="active",
            )

            db.add(alert)
            alert_generated = True

    try:
        db.commit()
    except Exception:
        db.rollback()
        raise

    return AIAnalysisResponse(
        tourist_id=request.tourist_id,
        risk_level=risk_result["risk_level"],
        safety_score=risk_result["safety_score"],
        route_deviation=deviation_result["route_deviation"],
        anomaly=risk_result["anomaly"],
        deviation_score=deviation_result["deviation_score"],
        alert_generated=alert_generated,
    )
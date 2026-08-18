from fastapi import FastAPI

# Import all models so SQLAlchemy registers every relationship
import app.models.user
import app.models.tourist
import app.models.emergency_contact
import app.models.trip
import app.models.tourist_location
import app.models.geofence_zone
import app.models.alert
import app.models.incident
import app.models.anomaly_score
import app.models.safety_score
import app.models.notification

# Import API routers
from app.api.auth import router as auth_router
from app.api.tourist import router as tourist_router
from app.api.trip import router as trip_router
from app.api.alert import router as alert_router
from app.api.health import router as health_router


app = FastAPI(
    title="Tourist Safety API",
    version="0.1.0",
    description="Backend foundation for the Tourist Safety System.",
)

# Register API routers
app.include_router(auth_router)
app.include_router(tourist_router)
app.include_router(trip_router)
app.include_router(alert_router)
app.include_router(health_router)
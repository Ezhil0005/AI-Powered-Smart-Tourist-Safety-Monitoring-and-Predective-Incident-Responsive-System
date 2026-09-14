from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

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
from app.api.ai import router as ai_router
from app.api.tourist_location import router as tourist_location_router
from app.api.geofence import router as geofence_router
from app.api.sos import router as sos_router
from app.api.emergency_contact import router as emergency_contact_router
from app.api.notification import router as notification_router


app = FastAPI(
    title="Tourist Safety API",
    version="1.0.0",
    description="AI-Powered Smart Tourist Safety Monitoring API",
)


# Development CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Register API routers
app.include_router(auth_router)
app.include_router(tourist_router)
app.include_router(trip_router)
app.include_router(alert_router)
app.include_router(health_router)
app.include_router(ai_router)
app.include_router(tourist_location_router)
app.include_router(geofence_router)
app.include_router(sos_router)
app.include_router(emergency_contact_router)
app.include_router(notification_router)

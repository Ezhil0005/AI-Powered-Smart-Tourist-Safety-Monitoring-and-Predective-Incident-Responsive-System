from sqlalchemy import Boolean, Column, DateTime, Double, Integer, String, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.db.base import Base


class GeofenceZone(Base):
    __tablename__ = "geofence_zones"

    id = Column(Integer, primary_key=True, index=True)

    name = Column(String(150), nullable=False)
    description = Column(Text)

    latitude = Column(Double, nullable=False)
    longitude = Column(Double, nullable=False)
    radius = Column(Double, nullable=False)

    zone_type = Column(String(30), nullable=False)
    is_active = Column(Boolean, nullable=False, default=True)

    created_at = Column(DateTime, nullable=False, server_default=func.now())

    alerts = relationship(
        "Alert",
        back_populates="geofence",
    )
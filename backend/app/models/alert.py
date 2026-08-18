from sqlalchemy import Column, DateTime, ForeignKey, Integer, String, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.db.base import Base


class Alert(Base):
    __tablename__ = "alerts"

    id = Column(Integer, primary_key=True, index=True)

    tourist_id = Column(
        Integer,
        ForeignKey("tourists.id", ondelete="CASCADE"),
        nullable=True,
    )

    geofence_id = Column(
        Integer,
        ForeignKey("geofence_zones.id", ondelete="SET NULL"),
        nullable=True,
    )

    alert_type = Column(String(50), nullable=False)
    severity = Column(String(20), nullable=False)
    message = Column(Text, nullable=False)
    status = Column(String(20), nullable=False, default="active")

    created_at = Column(DateTime, nullable=False, server_default=func.now())

    tourist = relationship(
        "Tourist",
        back_populates="alerts",
    )

    geofence = relationship(
        "GeofenceZone",
        back_populates="alerts",
    )
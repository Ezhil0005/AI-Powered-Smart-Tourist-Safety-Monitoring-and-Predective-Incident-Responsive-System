from sqlalchemy import Column, DateTime, ForeignKey, Integer, String, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.db.base import Base


class Incident(Base):
    __tablename__ = "incidents"

    id = Column(Integer, primary_key=True, index=True)

    tourist_id = Column(
        Integer,
        ForeignKey("tourists.id", ondelete="SET NULL"),
        nullable=True,
    )

    alert_id = Column(
        Integer,
        ForeignKey("alerts.id", ondelete="SET NULL"),
        nullable=True,
    )

    incident_type = Column(String(50), nullable=False)
    severity = Column(String(20), nullable=False)
    description = Column(Text)
    status = Column(String(20), nullable=False, default="open")

    created_at = Column(DateTime, nullable=False, server_default=func.now())

    tourist = relationship("Tourist", back_populates="incidents")
from sqlalchemy import Boolean, Column, Date, DateTime, ForeignKey, Integer, String
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.db.base import Base


class Tourist(Base):
    __tablename__ = "tourists"

    id = Column(Integer, primary_key=True, index=True)

    user_id = Column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE"),
        unique=True,
        nullable=False,
    )

    passport_number = Column(String(50), unique=True)
    nationality = Column(String(100))
    date_of_birth = Column(Date)
    phone = Column(String(20))
    emergency_mode = Column(Boolean, nullable=False, default=False)

    created_at = Column(DateTime, nullable=False, server_default=func.now())
    updated_at = Column(
        DateTime,
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )

    user = relationship("User", back_populates="tourist")

    emergency_contacts = relationship(
        "EmergencyContact",
        back_populates="tourist",
        cascade="all, delete-orphan",
    )

    trips = relationship(
        "Trip",
        back_populates="tourist",
        cascade="all, delete-orphan",
    )

    locations = relationship(
        "TouristLocation",
        back_populates="tourist",
        cascade="all, delete-orphan",
    )

    alerts = relationship(
        "Alert",
        back_populates="tourist",
        cascade="all, delete-orphan",
    )

    incidents = relationship(
        "Incident",
        back_populates="tourist",
        cascade="all, delete-orphan",
    )

    anomaly_scores = relationship(
        "AnomalyScore",
        back_populates="tourist",
        cascade="all, delete-orphan",
    )

    safety_scores = relationship(
        "SafetyScore",
        back_populates="tourist",
        cascade="all, delete-orphan",
    )
    notifications = relationship(
        "Notification",
        back_populates="tourist",
        cascade="all, delete-orphan",
    )
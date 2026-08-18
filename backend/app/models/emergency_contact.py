from sqlalchemy import Column, DateTime, ForeignKey, Integer, String
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.db.base import Base


class EmergencyContact(Base):
    __tablename__ = "emergency_contacts"

    id = Column(Integer, primary_key=True, index=True)

    tourist_id = Column(
        Integer,
        ForeignKey("tourists.id", ondelete="CASCADE"),
        nullable=False,
    )

    name = Column(String(100), nullable=False)
    relationship_type = Column(String(50))
    phone = Column(String(20), nullable=False)
    email = Column(String(255))

    created_at = Column(DateTime, nullable=False, server_default=func.now())

    tourist = relationship("Tourist", back_populates="emergency_contacts")
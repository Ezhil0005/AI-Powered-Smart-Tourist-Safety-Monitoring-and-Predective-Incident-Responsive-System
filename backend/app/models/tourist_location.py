from sqlalchemy import Column, DateTime, Double, ForeignKey, Integer, BigInteger
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.db.base import Base


class TouristLocation(Base):
    __tablename__ = "tourist_locations"

    id = Column(BigInteger, primary_key=True, index=True)

    tourist_id = Column(
        Integer,
        ForeignKey("tourists.id", ondelete="CASCADE"),
        nullable=False,
    )

    latitude = Column(Double, nullable=False)
    longitude = Column(Double, nullable=False)
    accuracy = Column(Double)

    recorded_at = Column(DateTime, nullable=False, server_default=func.now())
    created_at = Column(DateTime, nullable=False, server_default=func.now())

    tourist = relationship("Tourist", back_populates="locations")
from sqlalchemy import Column, DateTime, ForeignKey, Integer, Float
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.db.base import Base


class SafetyScore(Base):
    __tablename__ = "safety_scores"

    id = Column(Integer, primary_key=True, index=True)

    tourist_id = Column(
        Integer,
        ForeignKey("tourists.id", ondelete="CASCADE"),
        nullable=False,
    )

    score = Column(Float, nullable=False)

    created_at = Column(DateTime, nullable=False, server_default=func.now())

    tourist = relationship("Tourist", back_populates="safety_scores")
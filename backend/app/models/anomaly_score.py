
from sqlalchemy import Column, DateTime, ForeignKey, Integer, Float, String
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.db.base import Base


class AnomalyScore(Base):
    __tablename__ = "anomaly_scores"

    id = Column(Integer, primary_key=True, index=True)

    tourist_id = Column(
        Integer,
        ForeignKey("tourists.id", ondelete="CASCADE"),
        nullable=False,
    )

    score = Column(Float, nullable=False)
    model_version = Column(String(50), nullable=True)

    created_at = Column(DateTime, nullable=False, server_default=func.now())

    tourist = relationship("Tourist", back_populates="anomaly_scores")
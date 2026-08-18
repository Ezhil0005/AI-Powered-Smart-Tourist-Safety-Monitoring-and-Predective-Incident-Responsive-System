from sqlalchemy import Column, DateTime, ForeignKey, Integer, String, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.db.base import Base


class Notification(Base):
    __tablename__ = "notifications"

    id = Column(Integer, primary_key=True, index=True)

    user_id = Column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )

    tourist_id = Column(
        Integer,
        ForeignKey("tourists.id", ondelete="CASCADE"),
        nullable=True,
    )

    notification_type = Column(String(50), nullable=False)
    title = Column(String(255), nullable=False)
    message = Column(Text, nullable=False)
    status = Column(String(20), nullable=False, default="unread")

    created_at = Column(DateTime, nullable=False, server_default=func.now())

    user = relationship("User", back_populates="notifications")
    tourist = relationship("Tourist", back_populates="notifications")
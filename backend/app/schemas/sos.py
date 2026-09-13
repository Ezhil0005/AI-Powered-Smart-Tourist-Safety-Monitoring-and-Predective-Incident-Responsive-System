from pydantic import BaseModel


class SOSResponse(BaseModel):
    success: bool
    alert_id: int
    notification_id: int
    emergency_mode: bool
    emergency_contacts: list[dict]
    message: str

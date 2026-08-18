from fastapi import APIRouter

router = APIRouter(
    prefix="/alerts",
    tags=["Alerts"],
)


@router.get("/")
def get_alerts():
    return {
        "message": "Alert API is ready",
        "status": "success",
    }
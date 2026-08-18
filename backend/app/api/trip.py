from fastapi import APIRouter

router = APIRouter(
    prefix="/trips",
    tags=["Trips"],
)


@router.get("/")
def get_trips():
    return {
        "message": "Trip API is ready",
        "status": "success",
    }
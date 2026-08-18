from fastapi import APIRouter

router = APIRouter(
    prefix="/tourists",
    tags=["Tourists"],
)


@router.get("/")
def get_tourists():
    return {
        "message": "Tourist API is ready",
        "status": "success",
    }
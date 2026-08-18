from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.schemas.user import UserCreate, UserLogin, UserResponse
from app.services.auth_service import (
    authenticate_user,
    create_user,
    get_user_by_email,
)
from app.core.security import create_access_token, get_current_user
from app.models.user import User

router = APIRouter(
    prefix="/auth",
    tags=["Authentication"],
)


@router.post(
    "/register",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED,
)
def register(
    user_data: UserCreate,
    db: Session = Depends(get_db),
):
    existing_user = get_user_by_email(db, user_data.email)

    if existing_user:
        raise HTTPException(
            status_code=400,
            detail="Email already registered",
        )

    user = create_user(
        db=db,
        name=user_data.name,
        email=user_data.email,
        password=user_data.password,
        role=user_data.role,
    )

    return user


@router.post("/login")
def login(
    user_data: UserLogin,
    db: Session = Depends(get_db),
):
    user = authenticate_user(
        db=db,
        email=user_data.email,
        password=user_data.password,
    )

    if not user:
        raise HTTPException(
            status_code=401,
            detail="Invalid email or password",
        )

    token = create_access_token(
        {
            "sub": str(user.id),
            "role": user.role,
        }
    )

    return {
        "access_token": token,
        "token_type": "bearer",
    }
@router.get("/me", response_model=UserResponse)
def get_me(
    current_user: User = Depends(get_current_user),
):
    return current_user
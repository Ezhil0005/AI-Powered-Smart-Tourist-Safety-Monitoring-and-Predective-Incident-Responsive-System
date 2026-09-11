from fastapi import Depends, HTTPException, status

from app.core.security import get_current_user
from app.models.user import User


def require_roles(*allowed_roles: str):
    def role_checker(
        current_user: User = Depends(get_current_user),
    ):
        if not current_user.is_active:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="User account is inactive",
            )

        if current_user.role not in allowed_roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions",
            )

        return current_user

    return role_checker


def require_tourist(
    current_user: User = Depends(get_current_user),
):
    if current_user.role != "tourist":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Tourist role required",
        )

    return current_user


def require_police(
    current_user: User = Depends(get_current_user),
):
    if current_user.role != "police":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Police role required",
        )

    return current_user


def require_admin(
    current_user: User = Depends(get_current_user),
):
    if current_user.role != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Admin role required",
        )

    return current_user


def require_police_or_admin(
    current_user: User = Depends(get_current_user),
):
    if current_user.role not in {"police", "admin"}:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Police or admin role required",
        )

    return current_user
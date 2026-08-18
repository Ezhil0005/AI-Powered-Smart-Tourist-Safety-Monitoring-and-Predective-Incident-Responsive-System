from sqlalchemy.orm import Session

from app.models.user import User
from app.core.security import hash_password, verify_password


def get_user_by_email(db: Session, email: str):
    return db.query(User).filter(User.email == email).first()


def create_user(
    db: Session,
    name: str,
    email: str,
    password: str,
    role: str = "tourist",
):
    hashed_password = hash_password(password)

    user = User(
        name=name,
        email=email,
        password_hash=hashed_password,
        role=role,
        is_active=True,
    )

    db.add(user)
    db.commit()
    db.refresh(user)

    return user


def authenticate_user(
    db: Session,
    email: str,
    password: str,
):
    user = get_user_by_email(db, email)

    if not user:
        return None

    if not verify_password(password, user.password_hash):
        return None

    return user
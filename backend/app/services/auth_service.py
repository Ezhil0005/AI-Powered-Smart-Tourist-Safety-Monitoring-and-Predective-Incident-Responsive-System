import hashlib
import secrets
from datetime import datetime, timedelta, timezone

from sqlalchemy.orm import Session

from app.core.security import hash_password, verify_password
from app.models.password_reset_token import PasswordResetToken
from app.models.user import User
def get_user_by_email(db: Session, email: str):
    return db.query(User).filter(User.email == email.lower()).first()


def get_user_by_id(db: Session, user_id: int):
    return db.query(User).filter(User.id == user_id).first()


def create_user(
    db: Session,
    name: str,
    email: str,
    password: str,
    role: str = "tourist",
):
    user = User(
        name=name.strip(),
        email=email.lower(),
        password_hash=hash_password(password),
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

    if not user.is_active:
        return None

    if not verify_password(password, user.password_hash):
        return None

    return user


def update_user_profile(
    db: Session,
    user: User,
    name: str | None = None,
):
    if name is not None:
        user.name = name.strip()

    db.commit()
    db.refresh(user)

    return user


def change_password(
    db: Session,
    user: User,
    current_password: str,
    new_password: str,
):
    if not verify_password(current_password, user.password_hash):
        return False

    user.password_hash = hash_password(new_password)

    db.commit()
    db.refresh(user)

    return True

def create_password_reset_token(db: Session, user: User):
    raw_token = secrets.token_urlsafe(32)

    token_hash = hashlib.sha256(
        raw_token.encode()
    ).hexdigest()

    expires_at = datetime.now(timezone.utc) + timedelta(minutes=15)

    reset_token = PasswordResetToken(
        user_id=user.id,
        token_hash=token_hash,
        expires_at=expires_at,
        used=False,
    )

    db.add(reset_token)
    db.commit()
    db.refresh(reset_token)

    return raw_token

def reset_password_with_token(
    db: Session,
    token: str,
    new_password: str,
):
    token_hash = hashlib.sha256(
        token.encode()
    ).hexdigest()

    reset_token = (
        db.query(PasswordResetToken)
        .filter(
            PasswordResetToken.token_hash == token_hash,
            PasswordResetToken.used == False,
        )
        .first()
    )

    if not reset_token:
        return False

    now = datetime.now(timezone.utc)

    if reset_token.expires_at <= now:
        return False

    user = db.query(User).filter(
        User.id == reset_token.user_id
    ).first()

    if not user or not user.is_active:
        return False

    user.password_hash = hash_password(new_password)

    reset_token.used = True

    db.commit()

    return True
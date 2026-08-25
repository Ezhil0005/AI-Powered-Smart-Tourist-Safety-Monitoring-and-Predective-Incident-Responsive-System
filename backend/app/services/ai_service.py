import os

import httpx


AI_SERVICE_URL = os.getenv(
    "AI_SERVICE_URL",
    "http://127.0.0.1:8001",
)


class AIServiceError(Exception):
    pass


async def predict_risk(previous: dict, current: dict) -> dict:
    payload = {
        "previous": previous,
        "current": current,
    }

    try:
        async with httpx.AsyncClient(timeout=10.0) as client:
            response = await client.post(
                f"{AI_SERVICE_URL}/predict-risk",
                json=payload,
            )

        response.raise_for_status()
        return response.json()

    except httpx.HTTPError as exc:
        raise AIServiceError(
            f"AI risk prediction failed: {exc}"
        ) from exc


async def predict_route_deviation(
    previous: dict,
    current: dict,
) -> dict:
    payload = {
        "previous": previous,
        "current": current,
    }

    try:
        async with httpx.AsyncClient(timeout=10.0) as client:
            response = await client.post(
                f"{AI_SERVICE_URL}/predict-route-deviation",
                json=payload,
            )

        response.raise_for_status()
        return response.json()

    except httpx.HTTPError as exc:
        raise AIServiceError(
            f"AI route-deviation prediction failed: {exc}"
        ) from exc
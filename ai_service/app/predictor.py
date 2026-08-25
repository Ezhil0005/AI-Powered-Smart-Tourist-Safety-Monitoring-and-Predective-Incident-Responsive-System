import math
import os
import pickle


MODEL_FILE = os.path.join(
    os.path.dirname(os.path.dirname(__file__)),
    "model",
    "isolation_forest.pkl",
)


def calculate_distance(lat1, lon1, lat2, lon2):
    earth_radius = 6371000

    lat1_rad = math.radians(lat1)
    lat2_rad = math.radians(lat2)

    delta_lat = math.radians(lat2 - lat1)
    delta_lon = math.radians(lon2 - lon1)

    a = (
        math.sin(delta_lat / 2) ** 2
        + math.cos(lat1_rad)
        * math.cos(lat2_rad)
        * math.sin(delta_lon / 2) ** 2
    )

    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))

    return earth_radius * c


def load_model():
    if not os.path.exists(MODEL_FILE):
        raise FileNotFoundError(
            f"Trained model not found: {MODEL_FILE}"
        )

    with open(MODEL_FILE, "rb") as file:
        return pickle.load(file)


model = load_model()


def extract_features(previous, current):
    distance = calculate_distance(
        previous.latitude,
        previous.longitude,
        current.latitude,
        current.longitude,
    )

    speed = current.speed

    return [[distance, speed, 0.0]]


def predict(previous, current):
    features = extract_features(previous, current)

    prediction = model.predict(features)[0]
    anomaly_score = model.decision_function(features)[0]

    anomaly = prediction == -1

    if anomaly:
        risk_level = "High"
        safety_score = 30
        route_deviation = True
    elif anomaly_score < 0.1:
        risk_level = "Medium"
        safety_score = 65
        route_deviation = True
    else:
        risk_level = "Low"
        safety_score = 90
        route_deviation = False

    return {
        "risk_level": risk_level,
        "safety_score": safety_score,
        "route_deviation": route_deviation,
        "anomaly": anomaly,
    }


def predict_route_deviation(previous, current):
    features = extract_features(previous, current)

    prediction = model.predict(features)[0]
    score = model.decision_function(features)[0]

    return {
        "route_deviation": prediction == -1,
        "deviation_score": round(float(-score), 4),
    }
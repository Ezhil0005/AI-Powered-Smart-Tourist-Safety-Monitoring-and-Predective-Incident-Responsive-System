import csv
import os
import pickle

from sklearn.ensemble import IsolationForest

from app.features import extract_movement_features


INPUT_FILE = "dataset/gps_trajectories.csv"
MODEL_FILE = "model/isolation_forest.pkl"


def load_data():
    """
    Load GPS data and generate the same movement features
    used during prediction.
    """

    rows = []

    with open(INPUT_FILE, "r", encoding="utf-8") as file:
        reader = csv.DictReader(file)

        previous_point = {}

        for row in reader:

            tourist_id = row["tourist_id"]

            latitude = float(row["latitude"])
            longitude = float(row["longitude"])
            speed = float(row["speed"])

            previous = previous_point.get(tourist_id)

            if previous is None:
                features, bearing = extract_movement_features(
                    latitude,
                    longitude,
                    latitude,
                    longitude,
                    speed,
                )
            else:
                features, bearing = extract_movement_features(
                    previous["latitude"],
                    previous["longitude"],
                    latitude,
                    longitude,
                    speed,
                    previous["bearing"],
                )

            previous_point[tourist_id] = {
                "latitude": latitude,
                "longitude": longitude,
                "bearing": bearing,
            }

            rows.append(features)

    return rows


def train_model(features):
    model = IsolationForest(
        n_estimators=100,
        contamination=0.10,
        random_state=42,
    )

    model.fit(features)

    return model


def main():
    print("Loading GPS dataset...")

    features = load_data()

    print(f"Total records: {len(features)}")

    print("Training Isolation Forest...")

    model = train_model(features)

    os.makedirs("model", exist_ok=True)

    with open(MODEL_FILE, "wb") as file:
        pickle.dump(model, file)

    print("Model training completed.")
    print(f"Model saved to: {MODEL_FILE}")


if __name__ == "__main__":
    main()
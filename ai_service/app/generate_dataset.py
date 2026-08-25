import csv
import math
import random
from datetime import datetime, timedelta


OUTPUT_FILE = "dataset/gps_trajectories.csv"

random.seed(42)


def generate_route(
    tourist_id,
    start_lat,
    start_lon,
    points=50,
    abnormal=False,
):
    rows = []

    current_lat = start_lat
    current_lon = start_lon
    current_time = datetime(2026, 1, 1, 9, 0, 0)

    for i in range(points):

        if abnormal and 25 <= i <= 35:
            # Simulate sudden route deviation
            lat_step = random.uniform(0.002, 0.005)
            lon_step = random.uniform(0.002, 0.005)
            speed = random.uniform(8, 15)
        else:
            # Normal tourist movement
            lat_step = random.uniform(0.0001, 0.0004)
            lon_step = random.uniform(0.0001, 0.0004)
            speed = random.uniform(1, 5)

        current_lat += lat_step
        current_lon += lon_step

        rows.append(
            {
                "tourist_id": tourist_id,
                "timestamp": current_time.isoformat(),
                "latitude": round(current_lat, 6),
                "longitude": round(current_lon, 6),
                "speed": round(speed, 2),
                "is_abnormal": int(abnormal),
            }
        )

        current_time += timedelta(minutes=1)

    return rows


all_rows = []

# Normal tourist routes
for tourist_id in range(1, 6):
    all_rows.extend(
        generate_route(
            tourist_id=tourist_id,
            start_lat=11.0168,
            start_lon=76.9558,
            abnormal=False,
        )
    )

# Abnormal tourist routes
for tourist_id in range(6, 11):
    all_rows.extend(
        generate_route(
            tourist_id=tourist_id,
            start_lat=11.0168,
            start_lon=76.9558,
            abnormal=True,
        )
    )


with open(OUTPUT_FILE, "w", newline="", encoding="utf-8") as file:
    writer = csv.DictWriter(
        file,
        fieldnames=[
            "tourist_id",
            "timestamp",
            "latitude",
            "longitude",
            "speed",
            "is_abnormal",
        ],
    )

    writer.writeheader()
    writer.writerows(all_rows)


print(f"Dataset created: {OUTPUT_FILE}")
print(f"Total records: {len(all_rows)}")
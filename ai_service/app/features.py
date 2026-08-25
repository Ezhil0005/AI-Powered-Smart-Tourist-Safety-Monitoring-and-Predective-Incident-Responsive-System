import math


def calculate_distance(lat1, lon1, lat2, lon2):
    """
    Calculate distance between two GPS coordinates in meters.
    Uses the Haversine formula.
    """
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


def calculate_bearing(lat1, lon1, lat2, lon2):
    """
    Calculate movement bearing in degrees.
    """
    lat1_rad = math.radians(lat1)
    lat2_rad = math.radians(lat2)

    delta_lon = math.radians(lon2 - lon1)

    x = math.sin(delta_lon) * math.cos(lat2_rad)

    y = (
        math.cos(lat1_rad) * math.sin(lat2_rad)
        - math.sin(lat1_rad)
        * math.cos(lat2_rad)
        * math.cos(delta_lon)
    )

    bearing = math.degrees(math.atan2(x, y))

    return (bearing + 360) % 360


def calculate_direction_change(previous_bearing, current_bearing):
    """
    Return the smallest angular difference.
    """
    difference = abs(current_bearing - previous_bearing)

    if difference > 180:
        difference = 360 - difference

    return difference


def extract_movement_features(
    previous_latitude,
    previous_longitude,
    current_latitude,
    current_longitude,
    speed,
    previous_bearing=None,
):
    """
    Generate the exact three features used by the model.

    Returns:
        [distance, speed, direction_change]
    """

    distance = calculate_distance(
        previous_latitude,
        previous_longitude,
        current_latitude,
        current_longitude,
    )

    current_bearing = calculate_bearing(
        previous_latitude,
        previous_longitude,
        current_latitude,
        current_longitude,
    )

    if previous_bearing is None:
        direction_change = 0.0
    else:
        direction_change = calculate_direction_change(
            previous_bearing,
            current_bearing,
        )

    return (
        [distance, speed, direction_change],
        current_bearing,
    )
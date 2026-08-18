
CREATE TABLE geofence_zones (
	id SERIAL NOT NULL,
	name VARCHAR(150) NOT NULL,
	description TEXT,
	latitude DOUBLE PRECISION NOT NULL,
	longitude DOUBLE PRECISION NOT NULL,
	radius DOUBLE PRECISION NOT NULL,
	zone_type VARCHAR(30) NOT NULL,
	is_active BOOLEAN NOT NULL,
	created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
	PRIMARY KEY (id)
)

;


CREATE TABLE users (
	id SERIAL NOT NULL,
	name VARCHAR(100) NOT NULL,
	email VARCHAR(255) NOT NULL,
	password_hash VARCHAR(255) NOT NULL,
	role VARCHAR(30) NOT NULL,
	is_active BOOLEAN NOT NULL,
	created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
	updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
	PRIMARY KEY (id)
)

;


CREATE TABLE tourists (
	id SERIAL NOT NULL,
	user_id INTEGER NOT NULL,
	passport_number VARCHAR(50),
	nationality VARCHAR(100),
	date_of_birth DATE,
	phone VARCHAR(20),
	emergency_mode BOOLEAN NOT NULL,
	created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
	updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
	PRIMARY KEY (id),
	UNIQUE (user_id),
	FOREIGN KEY(user_id) REFERENCES users (id) ON DELETE CASCADE,
	UNIQUE (passport_number)
)

;


CREATE TABLE alerts (
        id SERIAL NOT NULL,
        tourist_id INTEGER,
        geofence_id INTEGER,
        alert_type VARCHAR(50) NOT NULL,
        severity VARCHAR(20) NOT NULL,
        message TEXT NOT NULL,
        status VARCHAR(20) NOT NULL,
        created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
        PRIMARY KEY (id),
        FOREIGN KEY(tourist_id) REFERENCES tourists (id) ON DELETE CASCADE,
        FOREIGN KEY(geofence_id) REFERENCES geofence_zones (id) ON DELETE SET NULL
);

CREATE TABLE anomaly_scores (
	id SERIAL NOT NULL,
	tourist_id INTEGER NOT NULL,
	score FLOAT NOT NULL,
	model_version VARCHAR(50),
	created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY(tourist_id) REFERENCES tourists (id) ON DELETE CASCADE
)

;


CREATE TABLE emergency_contacts (
	id SERIAL NOT NULL,
	tourist_id INTEGER NOT NULL,
	name VARCHAR(100) NOT NULL,
	relationship_type VARCHAR(50),
	phone VARCHAR(20) NOT NULL,
	email VARCHAR(255),
	created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY(tourist_id) REFERENCES tourists (id) ON DELETE CASCADE
)

;


CREATE TABLE notifications (
	id SERIAL NOT NULL,
	user_id INTEGER NOT NULL,
	tourist_id INTEGER,
	notification_type VARCHAR(50) NOT NULL,
	title VARCHAR(255) NOT NULL,
	message TEXT NOT NULL,
	status VARCHAR(20) NOT NULL,
	created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY(user_id) REFERENCES users (id) ON DELETE CASCADE,
	FOREIGN KEY(tourist_id) REFERENCES tourists (id) ON DELETE CASCADE
)

;


CREATE TABLE safety_scores (
	id SERIAL NOT NULL,
	tourist_id INTEGER NOT NULL,
	score FLOAT NOT NULL,
	created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY(tourist_id) REFERENCES tourists (id) ON DELETE CASCADE
)

;


CREATE TABLE tourist_locations (
	id BIGSERIAL NOT NULL,
	tourist_id INTEGER NOT NULL,
	latitude DOUBLE PRECISION NOT NULL,
	longitude DOUBLE PRECISION NOT NULL,
	accuracy DOUBLE PRECISION,
	recorded_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
	created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY(tourist_id) REFERENCES tourists (id) ON DELETE CASCADE
)

;


CREATE TABLE trips (
	id SERIAL NOT NULL,
	tourist_id INTEGER NOT NULL,
	destination VARCHAR(255) NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	status VARCHAR(30) NOT NULL,
	created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
	updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY(tourist_id) REFERENCES tourists (id) ON DELETE CASCADE
)

;


CREATE TABLE incidents (
	id SERIAL NOT NULL,
	tourist_id INTEGER,
	alert_id INTEGER,
	incident_type VARCHAR(50) NOT NULL,
	severity VARCHAR(20) NOT NULL,
	description TEXT,
	status VARCHAR(20) NOT NULL,
	created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY(tourist_id) REFERENCES tourists (id) ON DELETE SET NULL,
	FOREIGN KEY(alert_id) REFERENCES alerts (id) ON DELETE SET NULL
)

;
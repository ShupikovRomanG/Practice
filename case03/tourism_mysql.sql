-- MySQL 8.0.16+
CREATE DATABASE IF NOT EXISTS tourism CHARACTER SET utf8mb4;
USE tourism;

CREATE TABLE destinations (
    destination_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    country VARCHAR(80) NOT NULL,
    city VARCHAR(80) NOT NULL,
    UNIQUE (country, city)
) ENGINE=InnoDB;

CREATE TABLE tours (
    tour_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    destination_id INT UNSIGNED NOT NULL,
    title VARCHAR(120) NOT NULL,
    duration_days SMALLINT UNSIGNED NOT NULL CHECK (duration_days > 0),
    base_price DECIMAL(12,2) NOT NULL CHECK (base_price >= 0),
    CONSTRAINT fk_tours_destination FOREIGN KEY (destination_id)
        REFERENCES destinations (destination_id)
) ENGINE=InnoDB;

CREATE TABLE services (
    service_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(120) NOT NULL UNIQUE,
    price DECIMAL(12,2) NOT NULL CHECK (price >= 0)
) ENGINE=InnoDB;

CREATE TABLE customers (
    customer_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(160) NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE bookings (
    booking_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    tour_id INT UNSIGNED NOT NULL,
    customer_id INT UNSIGNED NOT NULL,
    service_id INT UNSIGNED NULL,
    booked_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    departure_date DATE NOT NULL,
    travelers SMALLINT UNSIGNED NOT NULL CHECK (travelers > 0),
    status VARCHAR(16) NOT NULL DEFAULT 'new'
        CHECK (status IN ('new', 'confirmed', 'cancelled')),
    total_price DECIMAL(12,2) NOT NULL CHECK (total_price >= 0),
    CONSTRAINT fk_bookings_tour FOREIGN KEY (tour_id) REFERENCES tours (tour_id),
    CONSTRAINT fk_bookings_customer FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id),
    CONSTRAINT fk_bookings_service FOREIGN KEY (service_id)
        REFERENCES services (service_id)
) ENGINE=InnoDB;

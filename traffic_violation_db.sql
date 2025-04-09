CREATE DATABASE traffic_violation_system;
USE traffic_violation_system;

-- Table 1: owners
CREATE TABLE owners (
    owner_id INT AUTO_INCREMENT PRIMARY KEY,
    owner_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    contact_number VARCHAR(15)
);
select * from owners;
-- Table 2: vehicles
CREATE TABLE vehicles (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    plate_number VARCHAR(15) NOT NULL UNIQUE,
    vehicle_type VARCHAR(50) NOT NULL,
    model VARCHAR(100),
    owner_id INT,
    FOREIGN KEY (owner_id) REFERENCES owners(owner_id) ON DELETE SET NULL
);
select * from vehicles;
-- Table 3: license
CREATE TABLE license (
    license_id INT AUTO_INCREMENT PRIMARY KEY,
    license_number VARCHAR(20) NOT NULL UNIQUE,
    owner_id INT,
    issue_date DATE,
    expiry_date DATE,
    FOREIGN KEY (owner_id) REFERENCES owners(owner_id) ON DELETE CASCADE
);

-- Table 4: officers
CREATE TABLE officers (
    officer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    badge_number VARCHAR(20) NOT NULL UNIQUE,
    station_id INT
);

-- Table 5: stations
CREATE TABLE stations (
    station_id INT AUTO_INCREMENT PRIMARY KEY,
    station_name VARCHAR(100),
    location VARCHAR(255)
);

-- Update officer with FK now
ALTER TABLE officers ADD CONSTRAINT fk_station FOREIGN KEY (station_id) REFERENCES stations(station_id);

-- Table 6: violation_types
CREATE TABLE violation_types (
    violation_type_id INT AUTO_INCREMENT PRIMARY KEY,
    violation_name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Table 7: location
CREATE TABLE location (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    area_name VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100)
);

-- Table 8: violations
CREATE TABLE violations (
    violation_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT,
    officer_id INT,
    violation_type_id INT,
    location_id INT,
    violation_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE CASCADE,
    FOREIGN KEY (officer_id) REFERENCES officers(officer_id) ON DELETE SET NULL,
    FOREIGN KEY (violation_type_id) REFERENCES violation_types(violation_type_id),
    FOREIGN KEY (location_id) REFERENCES location(location_id)
);

-- Table 9: payments
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    violation_id INT,
    amount_paid DECIMAL(10,2),
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_mode VARCHAR(50),
    FOREIGN KEY (violation_id) REFERENCES violations(violation_id)
);

-- Table 10: users (for admin login)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role ENUM('admin','officer') DEFAULT 'admin'
);

-- INSERT queries (sample data inserts for demonstration)
INSERT INTO owners (owner_name, address, contact_number) VALUES ('Ram Singhal', 'Indore, MP', '9876543210');
INSERT INTO stations (station_name, location) VALUES ('Indore Central', 'Indore');
INSERT INTO officers (name, badge_number, station_id) VALUES ('Officer Arjun', 'B123', 1);
INSERT INTO vehicles (plate_number, vehicle_type, model, owner_id) VALUES ('MP09AB1234', 'Car', 'Honda City', 1);
INSERT INTO license (license_number, owner_id, issue_date, expiry_date) VALUES ('LIC12345678', 1, '2021-01-01', '2031-01-01');
INSERT INTO violation_types (violation_name, description) VALUES ('Overspeeding', 'Driving over speed limit');
INSERT INTO location (area_name, city, state) VALUES ('Rajwada', 'Indore', 'MP');
INSERT INTO violations (vehicle_id, officer_id, violation_type_id, location_id, violation_date) VALUES (1, 1, 1, 1, NOW());
INSERT INTO payments (violation_id, amount_paid, payment_mode) VALUES (1, 500.00, 'Cash');
INSERT INTO users (username, password, role) VALUES ('admin', 'admin123', 'admin');

-- SELECT queries
SELECT * FROM owners;
SELECT * FROM vehicles;
SELECT * FROM officers WHERE station_id = 1;
SELECT v.vehicle_id, o.owner_name FROM vehicles v JOIN owners o ON v.owner_id = o.owner_id;
SELECT * FROM violations WHERE violation_date BETWEEN '2024-01-01' AND '2024-12-31';

-- JOIN queries
SELECT v.violation_id, o.name AS officer, vt.violation_name, l.area_name
FROM violations v
JOIN officers o ON v.officer_id = o.officer_id
JOIN violation_types vt ON v.violation_type_id = vt.violation_type_id
JOIN location l ON v.location_id = l.location_id;

SELECT v.plate_number, p.amount_paid
FROM vehicles v
JOIN violations vl ON v.vehicle_id = vl.vehicle_id
JOIN payments p ON vl.violation_id = p.violation_id;

-- AGGREGATE queries
SELECT COUNT(*) AS total_violations FROM violations;
SELECT vehicle_id, COUNT(*) AS violation_count FROM violations GROUP BY vehicle_id;
SELECT officer_id, COUNT(*) AS handled_violations FROM violations GROUP BY officer_id;

-- UPDATE queries
UPDATE owners SET contact_number = '9999999999' WHERE owner_id = 1;
UPDATE payments SET payment_mode = 'Online' WHERE payment_id = 1;

-- DELETE queries
DELETE FROM license WHERE license_id = 1;
DELETE FROM payments WHERE amount_paid < 100;

-- SUBQUERIES
SELECT owner_name FROM owners WHERE owner_id = (
    SELECT owner_id FROM vehicles WHERE plate_number = 'MP09AB1234'
);

-- NESTED QUERIES
SELECT * FROM violations WHERE officer_id IN (
    SELECT officer_id FROM officers WHERE station_id = 1
);

-- BETWEEN, LIKE, IN
SELECT * FROM location WHERE city LIKE '%Indore%';
SELECT * FROM violations WHERE violation_date BETWEEN '2024-04-01' AND '2024-04-07';
SELECT * FROM vehicles WHERE vehicle_type IN ('Car', 'Truck');

-- DISTINCT, ORDER BY, LIMIT
SELECT DISTINCT vehicle_type FROM vehicles;
SELECT * FROM payments ORDER BY amount_paid DESC LIMIT 5;

-- EXISTS
SELECT owner_name FROM owners WHERE EXISTS (
    SELECT * FROM vehicles WHERE owners.owner_id = vehicles.owner_id
);

-- GROUP BY with HAVING
SELECT officer_id, COUNT(*) AS count FROM violations GROUP BY officer_id HAVING COUNT(*) > 0;

-- MULTI-TABLE INSERT
INSERT INTO owners (owner_name, address, contact_number) VALUES ('John Doe', 'Mumbai', '1234567890');
INSERT INTO vehicles (plate_number, vehicle_type, model, owner_id) VALUES ('MH12XY9876', 'Bike', 'Yamaha', 2);

-- JOIN
SELECT p.payment_id, o.owner_name, v.plate_number, p.amount_paid
FROM payments p
JOIN violations vl ON p.violation_id = vl.violation_id
JOIN vehicles v ON vl.vehicle_id = v.vehicle_id
JOIN owners o ON v.owner_id = o.owner_id;

ALTER TABLE violations ADD COLUMN status VARCHAR(20) DEFAULT 'Unpaid';


DESCRIBE violations;
ALTER TABLE violations DROP FOREIGN KEY violations_ibfk_1;
-- Repeat for other foreign keys if any (officer_id, location_id, etc.)

INSERT INTO owners (owner_id, owner_name, address, contact_number)
VALUES (3, 'Rajiv Sharma', 'Indore, MP', '9876543210');

select * from owners;

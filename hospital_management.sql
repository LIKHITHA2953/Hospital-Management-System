-- HOSPITAL MANAGEMENT SYSTEM
-- Database: hospitaldb
-- Platform: MySQL
-- Run this script once in a fresh MySQL environment.
-- The script creates the database, tables, sample data, queries,
-- views, stored procedures, and reports requested in the project brief.

CREATE DATABASE IF NOT EXISTS hospitaldb;
USE hospitaldb;

-- =========================================================
-- 1. TABLE CREATION
-- =========================================================

CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(10),
    phone VARCHAR(15),
    address VARCHAR(255),
    registration_date DATE
);

CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100),
    specialization VARCHAR(100),
    phone VARCHAR(15),
    joining_date DATE
);

CREATE TABLE Rooms (
    room_id INT PRIMARY KEY,
    room_type VARCHAR(50),
    availability_status VARCHAR(20)
);

CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

CREATE TABLE Admissions (
    admission_id INT PRIMARY KEY,
    patient_id INT,
    room_id INT,
    admission_date DATE,
    discharge_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id)
);

CREATE TABLE Bills (
    bill_id INT PRIMARY KEY,
    patient_id INT,
    total_amount DECIMAL(10,2),
    payment_status VARCHAR(20),
    bill_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- =========================================================
-- 2. SAMPLE DATA
-- Insert parent-table records before dependent-table records.
-- =========================================================

INSERT INTO Patients VALUES
(1, 'Rahul', 55, 'Male', '9876543210', 'Hyderabad', '2026-01-10'),
(2, 'Priya', 28, 'Female', '9876543211', 'Vijayawada', '2026-02-15'),
(3, 'Arjun', 45, 'Male', '9876543212', 'Guntur', '2026-03-05'),
(4, 'Sneha', 35, 'Female', '9876543213', 'Hyderabad', '2026-04-12'),
(5, 'Kiran', 62, 'Male', '9876543214', 'Warangal', '2026-05-20'),
(6, 'Anjali', 25, 'Female', '9876543215', 'Guntur', '2026-06-18'),
(7, 'Vikram', 50, 'Male', '9876543216', 'Vijayawada', '2026-07-22'),
(8, 'Divya', 40, 'Female', '9876543217', 'Hyderabad', '2026-08-11');

INSERT INTO Doctors VALUES
(101, 'Dr. Sharma', 'Cardiology', '9123456780', '2020-01-15'),
(102, 'Dr. Reddy', 'Neurology', '9123456781', '2021-03-10'),
(103, 'Dr. Mehta', 'Orthopedics', '9123456782', '2019-06-20'),
(104, 'Dr. Priya', 'Cardiology', '9123456783', '2022-02-12');

INSERT INTO Rooms VALUES
(201, 'General', 'Available'),
(202, 'Private', 'Occupied'),
(203, 'ICU', 'Available'),
(204, 'General', 'Occupied'),
(205, 'Private', 'Available');

INSERT INTO Appointments VALUES
(1001, 1, 101, '2026-11-26', 'Scheduled'),
(1002, 2, 102, '2026-11-20', 'Completed'),
(1003, 3, 103, '2026-11-21', 'Completed'),
(1004, 4, 101, '2026-11-26', 'Scheduled'),
(1005, 5, 104, '2026-11-22', 'Completed'),
(1006, 6, 102, '2026-11-23', 'Cancelled'),
(1007, 1, 101, '2026-11-24', 'Completed'),
(1008, 7, 103, '2026-11-26', 'Scheduled'),
(1009, 8, 104, '2026-11-25', 'Completed'),
(1010, 2, 101, '2026-11-26', 'Scheduled');

INSERT INTO Admissions VALUES
(501, 1, 202, '2026-11-10', '2026-11-15'),
(502, 2, 204, '2026-11-12', '2026-11-18'),
(503, 3, 203, '2026-11-19', NULL),
(504, 5, 201, '2026-11-20', NULL),
(505, 4, 205, '2026-11-21', '2026-11-24');

INSERT INTO Bills VALUES
(701, 1, 15000.00, 'Paid', '2026-11-15'),
(702, 2, 8000.00, 'Paid', '2026-11-18'),
(703, 3, 12000.00, 'Pending', '2026-11-20'),
(704, 4, 6000.00, 'Paid', '2026-11-24'),
(705, 5, 20000.00, 'Pending', '2026-11-22'),
(706, 6, 5000.00, 'Paid', '2026-11-23'),
(707, 7, 9000.00, 'Pending', '2026-11-25'),
(708, 8, 11000.00, 'Paid', '2026-11-25');

-- Check initial record counts (8, 4, 5, 10, 5, 8).
SELECT COUNT(*) AS total_patients FROM Patients;
SELECT COUNT(*) AS total_doctors FROM Doctors;
SELECT COUNT(*) AS total_rooms FROM Rooms;
SELECT COUNT(*) AS total_appointments FROM Appointments;
SELECT COUNT(*) AS total_admissions FROM Admissions;
SELECT COUNT(*) AS total_bills FROM Bills;

-- =========================================================
-- 3. BASIC QUERIES
-- =========================================================

-- 3.1 Patients above age 50
SELECT * FROM Patients WHERE age > 50;

-- 3.2 Doctors with Cardiology specialization
SELECT * FROM Doctors WHERE specialization = 'Cardiology';

-- 3.3 Appointments scheduled for today
SELECT *
FROM Appointments
WHERE appointment_date = CURDATE()
  AND status = 'Scheduled';

-- 3.4 Available rooms
SELECT * FROM Rooms WHERE availability_status = 'Available';

-- Additional practice: patients ordered by age, highest first
SELECT * FROM Patients ORDER BY age DESC;

-- =========================================================
-- 4. JOINS
-- =========================================================

-- 4.1 Patient name with their doctor
SELECT p.name AS patient_name, d.name AS doctor_name
FROM Appointments a
INNER JOIN Patients p ON a.patient_id = p.patient_id
INNER JOIN Doctors d ON a.doctor_id = d.doctor_id;

-- 4.2 Appointment details with patient information
SELECT a.appointment_id, p.name AS patient_name, p.age,
       a.appointment_date, a.status
FROM Appointments a
INNER JOIN Patients p ON a.patient_id = p.patient_id;

-- 4.3 Admission details with room type
SELECT a.admission_id, p.name AS patient_name, r.room_type,
       a.admission_date, a.discharge_date
FROM Admissions a
INNER JOIN Patients p ON a.patient_id = p.patient_id
INNER JOIN Rooms r ON a.room_id = r.room_id;

-- 4.4 Bills with patient name
SELECT b.bill_id, p.name AS patient_name, b.total_amount,
       b.payment_status, b.bill_date
FROM Bills b
INNER JOIN Patients p ON b.patient_id = p.patient_id;

-- 4.5 Doctors with their patients
SELECT DISTINCT d.name AS doctor_name, p.name AS patient_name,
       d.specialization
FROM Appointments a
INNER JOIN Doctors d ON a.doctor_id = d.doctor_id
INNER JOIN Patients p ON a.patient_id = p.patient_id;

-- =========================================================
-- 5. AGGREGATE FUNCTIONS
-- =========================================================

SELECT COUNT(*) AS total_patients FROM Patients;
SELECT AVG(age) AS average_patient_age FROM Patients;
SELECT SUM(total_amount) AS total_billed_revenue FROM Bills;
SELECT COUNT(*) AS total_appointments FROM Appointments;
SELECT MAX(total_amount) AS highest_bill FROM Bills;

-- Additional practice
SELECT MIN(total_amount) AS lowest_bill FROM Bills;
SELECT SUM(total_amount) AS collected_amount
FROM Bills
WHERE payment_status = 'Paid';

-- =========================================================
-- 6. SUBQUERIES
-- =========================================================

-- 6.1 Patients who never booked appointments
SELECT *
FROM Patients
WHERE patient_id NOT IN (SELECT patient_id FROM Appointments);

-- 6.2 Doctors who have no patients
SELECT *
FROM Doctors
WHERE doctor_id NOT IN (SELECT doctor_id FROM Appointments);

-- 6.3 Patients with bills greater than the average bill
SELECT *
FROM Patients
WHERE patient_id IN (
    SELECT patient_id
    FROM Bills
    WHERE total_amount > (SELECT AVG(total_amount) FROM Bills)
);

-- 6.4 Patients admitted more than once
SELECT *
FROM Patients
WHERE patient_id IN (
    SELECT patient_id
    FROM Admissions
    GROUP BY patient_id
    HAVING COUNT(admission_id) > 1
);

-- 6.5 Doctors with appointment counts above the average per doctor
SELECT d.doctor_id, d.name AS doctor_name,
       COUNT(a.appointment_id) AS total_appointments
FROM Doctors d
INNER JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.name
HAVING COUNT(a.appointment_id) > (
    SELECT AVG(appointment_count)
    FROM (
        SELECT COUNT(appointment_id) AS appointment_count
        FROM Appointments
        GROUP BY doctor_id
    ) AS doctor_counts
);

-- =========================================================
-- 7. UPDATES AND DELETES
-- These statements intentionally modify the sample data.
-- =========================================================

-- 7.1 Update patient phone number
UPDATE Patients
SET phone = '9999999999'
WHERE patient_id = 1;

-- 7.2 Change doctor specialization
UPDATE Doctors
SET specialization = 'Sports Medicine'
WHERE doctor_id = 103;

-- 7.3 Update room availability
UPDATE Rooms
SET availability_status = 'Occupied'
WHERE room_id = 201;

-- 7.4 Delete cancelled appointments
DELETE FROM Appointments
WHERE status = 'Cancelled';

-- 7.5 Delete patients with no appointment, admission, or bill records
DELETE FROM Patients
WHERE NOT EXISTS (
    SELECT 1 FROM Appointments
    WHERE Appointments.patient_id = Patients.patient_id
)
AND NOT EXISTS (
    SELECT 1 FROM Admissions
    WHERE Admissions.patient_id = Patients.patient_id
)
AND NOT EXISTS (
    SELECT 1 FROM Bills
    WHERE Bills.patient_id = Patients.patient_id
);

-- =========================================================
-- 8. VIEWS
-- =========================================================

CREATE VIEW patient_appointments AS
SELECT p.patient_id, p.name AS patient_name,
       a.appointment_id, a.appointment_date, a.status
FROM Patients p
INNER JOIN Appointments a ON p.patient_id = a.patient_id;

CREATE VIEW doctor_details AS
SELECT doctor_id, name, specialization, phone, joining_date
FROM Doctors;

CREATE VIEW admission_details AS
SELECT a.admission_id, p.name AS patient_name, r.room_id,
       r.room_type, a.admission_date, a.discharge_date
FROM Admissions a
INNER JOIN Patients p ON a.patient_id = p.patient_id
INNER JOIN Rooms r ON a.room_id = r.room_id;

CREATE VIEW patient_billing AS
SELECT p.patient_id, p.name AS patient_name,
       SUM(b.total_amount) AS total_bill
FROM Patients p
INNER JOIN Bills b ON p.patient_id = b.patient_id
GROUP BY p.patient_id, p.name;

CREATE VIEW most_visited_doctors AS
SELECT d.doctor_id, d.name AS doctor_name, d.specialization,
       COUNT(a.appointment_id) AS total_appointments
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.name, d.specialization;

-- View checks
SELECT * FROM patient_appointments;
SELECT * FROM doctor_details;
SELECT * FROM admission_details;
SELECT * FROM patient_billing;
SELECT * FROM most_visited_doctors ORDER BY total_appointments DESC;
SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- =========================================================
-- 9. STORED PROCEDURES
-- =========================================================

DELIMITER //

CREATE PROCEDURE InsertPatient(
    IN p_name VARCHAR(100),
    IN p_age INT,
    IN p_gender VARCHAR(10),
    IN p_phone VARCHAR(15),
    IN p_address VARCHAR(255),
    IN p_registration_date DATE
)
BEGIN
    INSERT INTO Patients
        (patient_id, name, age, gender, phone, address, registration_date)
    VALUES (
        (SELECT COALESCE(MAX(patient_id), 0) + 1
         FROM (SELECT patient_id FROM Patients) AS current_patients),
        p_name, p_age, p_gender, p_phone, p_address, p_registration_date
    );
END //

CREATE PROCEDURE UpdateRoomStatus(
    IN p_room_id INT,
    IN p_status VARCHAR(20)
)
BEGIN
    UPDATE Rooms
    SET availability_status = p_status
    WHERE room_id = p_room_id;
END //

CREATE PROCEDURE GetPatientAppointments(
    IN p_patient_id INT
)
BEGIN
    SELECT a.appointment_id, p.name AS patient_name,
           a.appointment_date, a.status
    FROM Appointments a
    INNER JOIN Patients p ON a.patient_id = p.patient_id
    WHERE a.patient_id = p_patient_id;
END //

CREATE PROCEDURE CalculateTotalRevenue()
BEGIN
    SELECT SUM(total_amount) AS total_revenue
    FROM Bills;
END //

CREATE PROCEDURE GetDoctorsBySpecialization(
    IN p_specialization VARCHAR(100)
)
BEGIN
    SELECT *
    FROM Doctors
    WHERE specialization = p_specialization;
END //

DELIMITER ;

-- Procedure tests
-- Uncomment the InsertPatient CALL only if you want to add the test patient.
-- CALL InsertPatient('Manoj', 32, 'Male', '9876501234',
--                    'Hyderabad', '2026-11-26');
CALL UpdateRoomStatus(201, 'Available');
CALL GetPatientAppointments(1);
CALL CalculateTotalRevenue();
CALL GetDoctorsBySpecialization('Cardiology');

SHOW PROCEDURE STATUS WHERE Db = 'hospitaldb';

-- =========================================================
-- 10. REPORTS / ANALYSIS
-- =========================================================

-- 10.1 Top 5 doctors with most appointments
SELECT d.doctor_id, d.name AS doctor_name, d.specialization,
       COUNT(a.appointment_id) AS total_appointments
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.name, d.specialization
ORDER BY total_appointments DESC
LIMIT 5;

-- 10.2 Most frequent patients
SELECT p.patient_id, p.name AS patient_name,
       COUNT(a.appointment_id) AS total_visits
FROM Patients p
INNER JOIN Appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.name
ORDER BY total_visits DESC;

-- 10.3 Monthly appointment report
SELECT DATE_FORMAT(appointment_date, '%Y-%m') AS appointment_month,
       COUNT(*) AS total_appointments
FROM Appointments
GROUP BY DATE_FORMAT(appointment_date, '%Y-%m')
ORDER BY appointment_month;

-- 10.4 Approximate doctor-associated billing (see README limitation)
SELECT d.doctor_id, d.name AS doctor_name,
       SUM(b.total_amount) AS associated_revenue
FROM Doctors d
INNER JOIN Appointments a ON d.doctor_id = a.doctor_id
INNER JOIN Bills b ON a.patient_id = b.patient_id
GROUP BY d.doctor_id, d.name
ORDER BY associated_revenue DESC
LIMIT 1;

-- 10.5 Patient billing analysis
SELECT p.patient_id, p.name AS patient_name,
       COUNT(b.bill_id) AS total_bills,
       COALESCE(SUM(b.total_amount), 0) AS total_amount,
       COALESCE(SUM(CASE WHEN b.payment_status = 'Paid'
                         THEN b.total_amount ELSE 0 END), 0) AS paid_amount,
       COALESCE(SUM(CASE WHEN b.payment_status = 'Pending'
                         THEN b.total_amount ELSE 0 END), 0) AS pending_amount
FROM Patients p
LEFT JOIN Bills b ON p.patient_id = b.patient_id
GROUP BY p.patient_id, p.name
ORDER BY total_amount DESC;

-- 10.6 Most demanded specialization
SELECT d.specialization,
       COUNT(a.appointment_id) AS total_appointments
FROM Doctors d
INNER JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.specialization
ORDER BY total_appointments DESC
LIMIT 1;

-- End of Hospital Management System project.

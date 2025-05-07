-- ================================
-- Clinic Booking System Database
-- ================================

-- Drop existing tables and views to avoid conflicts
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS Patients;
DROP TABLE IF EXISTS Doctors;
DROP TABLE IF EXISTS Specializations;
DROP TABLE IF EXISTS Users;
DROP VIEW IF EXISTS DoctorSchedule;

-- ========================
-- Table: Specializations
-- ========================
CREATE TABLE Specializations (
    specialization_id INT PRIMARY KEY AUTO_INCREMENT,
    specialization_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

-- ========================
-- Table: Doctors
-- ========================
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    specialization_id INT,
    contact_number VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    date_joined TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Active', 'On Leave', 'Retired') DEFAULT 'Active',
    FOREIGN KEY (specialization_id) REFERENCES Specializations(specialization_id)
);

-- ========================
-- Table: Patients
-- ========================
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    contact_number VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    address TEXT,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================
-- Table: Appointments
-- ========================
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    reason TEXT,
    status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);

-- ========================
-- Table: Users (For admin/staff login)
-- ========================
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'Receptionist', 'Doctor') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================
-- Sample Insert Data
-- ========================

-- Insert Specializations
INSERT INTO Specializations (specialization_name, description)
VALUES 
    ('Cardiology', 'Heart and vascular system'),
    ('Pediatrics', 'Care for children'),
    ('Dermatology', 'Skin related issues'),
    ('Neurology', 'Nervous system diseases');

-- Insert Doctors
INSERT INTO Doctors (full_name, specialization_id, contact_number, email)
VALUES 
    ('Dr. Jane Smith', 1, '1234567890', 'jane.smith@clinic.com'),
    ('Dr. Alex Mokoena', 2, '0987654321', 'alex.mokoena@clinic.com');

-- Insert Patients
INSERT INTO Patients (full_name, date_of_birth, gender, contact_number, email, address)
VALUES 
    ('John Doe', '1990-05-10', 'Male', '0821234567', 'john.doe@gmail.com', '123 Main Road'),
    ('Sarah Mhlongo', '1985-12-15', 'Female', '0837654321', 'sarah.mhlongo@gmail.com', '456 Elm Street');

-- Insert Appointments
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, reason)
VALUES 
    (1, 1, '2025-05-10 10:30:00', 'Routine Check-up'),
    (2, 2, '2025-05-11 09:00:00', 'Pediatric Consultation');

-- ========================
-- Sample UPDATE Statement
-- ========================
UPDATE Patients
SET contact_number = '0829999999'
WHERE patient_id = 1;

-- ========================
-- Sample DELETE Statement
-- ========================
DELETE FROM Appointments
WHERE appointment_id = 2;

-- ========================
-- Creating an Index on Appointments (for faster search by patient_id and doctor_id)
-- ========================
CREATE INDEX idx_patient_id ON Appointments(patient_id);
CREATE INDEX idx_doctor_id ON Appointments(doctor_id);

-- ========================
-- View: Doctor Schedule (Available Appointments)
-- ========================
DROP VIEW IF EXISTS DoctorSchedule;

CREATE VIEW DoctorSchedule AS
SELECT d.full_name AS doctor_name, p.full_name AS patient_name, a.appointment_date, a.reason
FROM Appointments a
JOIN Doctors d ON a.doctor_id = d.doctor_id
JOIN Patients p ON a.patient_id = p.patient_id
WHERE a.status = 'Scheduled';

-- ========================
-- Stored Procedure: Add Appointment
-- ========================
CREATE PROCEDURE AddAppointment(IN patientId INT, IN doctorId INT, IN appDate DATETIME, IN appReason TEXT)
BEGIN
    INSERT INTO Appointments (patient_id, doctor_id, appointment_date, reason)
    VALUES (patientId, doctorId, appDate, appReason);
END;

-- ========================
-- Trigger: Auto Confirm Appointment
-- ========================
CREATE TRIGGER AutoConfirmAppointment
AFTER INSERT ON Appointments
FOR EACH ROW
BEGIN
    UPDATE Appointments
    SET status = 'Scheduled'
    WHERE appointment_id = NEW.appointment_id;
END;

-- ========================
-- End of Script
-- ========================

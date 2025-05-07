# Clinic Booking System Database

This project provides a MySQL database schema for a clinic booking system, including tables, sample data, views, procedures, and triggers.

## Features

- **Tables**:  
  - `Specializations`: Medical specializations (e.g., Cardiology, Pediatrics).
  - `Doctors`: Doctor details, linked to specializations.
  - `Patients`: Patient information.
  - `Appointments`: Appointment records, linking patients and doctors.
  - `Users`: Admin, receptionist, and doctor login accounts.

- **Sample Data**:  
  Inserts for specializations, doctors, patients, and appointments.

- **Indexes**:  
  Indexes on `Appointments` for `patient_id` and `doctor_id` to speed up queries.

- **View**:  
  `DoctorSchedule` shows scheduled appointments with doctor and patient names.

- **Stored Procedure**:  
  `AddAppointment` for adding new appointments.

- **Trigger**:  
  `AutoConfirmAppointment` ensures new appointments are set to 'Scheduled'.

## Usage

1. Run the SQL script (`answers.sql`) in your MySQL environment.
2. The script will drop existing tables/views, create the schema, insert sample data, and set up logic.
3. Use the provided procedure and view for managing and viewing appointments.

## Requirements

- MySQL Server

---

**Note:** The script drops existing tables and views with the same names. Back up your data before running.
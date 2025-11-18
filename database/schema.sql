-- Hospital Management System Database Schema
-- PostgreSQL Database

-- Drop tables if they exist (in reverse order of dependencies)
DROP TABLE IF EXISTS medical_records CASCADE;
DROP TABLE IF EXISTS appointments CASCADE;
DROP TABLE IF EXISTS doctors CASCADE;
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Create users table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(20) NOT NULL CHECK (role IN ('patient', 'doctor', 'admin')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create departments table
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create doctors table
CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    department_id INT REFERENCES departments(department_id) ON DELETE SET NULL,
    availability VARCHAR(100),
    consultation_fee DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create appointments table
CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    doctor_id INT REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    reason TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'completed', 'cancelled')),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create medical_records table
CREATE TABLE medical_records (
    record_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    doctor_id INT REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    appointment_id INT REFERENCES appointments(appointment_id) ON DELETE SET NULL,
    diagnosis TEXT,
    treatment TEXT,
    prescription TEXT,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_doctors_department ON doctors(department_id);
CREATE INDEX idx_appointments_patient ON appointments(patient_id);
CREATE INDEX idx_appointments_doctor ON appointments(doctor_id);
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_appointments_status ON appointments(status);
CREATE INDEX idx_medical_records_patient ON medical_records(patient_id);
CREATE INDEX idx_medical_records_doctor ON medical_records(doctor_id);

-- Insert sample data

-- Insert departments
INSERT INTO departments (department_name, description) VALUES
('Cardiology', 'Heart and cardiovascular system specialists'),
('Neurology', 'Brain and nervous system specialists'),
('Pediatrics', 'Child healthcare specialists'),
('Orthopedics', 'Bone and muscle specialists'),
('Dermatology', 'Skin care specialists'),
('General Medicine', 'General health practitioners');

-- Insert users (password: 'password123' - should be hashed in production)
INSERT INTO users (username, password, full_name, email, phone, role) VALUES
('admin', 'password123', 'Admin User', 'admin@hospital.com', '1234567890', 'admin'),
('dr.smith', 'password123', 'Dr. John Smith', 'john.smith@hospital.com', '1234567891', 'doctor'),
('dr.johnson', 'password123', 'Dr. Sarah Johnson', 'sarah.johnson@hospital.com', '1234567892', 'doctor'),
('dr.williams', 'password123', 'Dr. Michael Williams', 'michael.williams@hospital.com', '1234567893', 'doctor'),
('dr.brown', 'password123', 'Dr. Emily Brown', 'emily.brown@hospital.com', '1234567894', 'doctor'),
('patient1', 'password123', 'Alice Cooper', 'alice.cooper@email.com', '1234567895', 'patient'),
('patient2', 'password123', 'Bob Wilson', 'bob.wilson@email.com', '1234567896', 'patient'),
('patient3', 'password123', 'Charlie Davis', 'charlie.davis@email.com', '1234567897', 'patient');

-- Insert doctors
INSERT INTO doctors (user_id, name, specialization, department_id, availability, consultation_fee) VALUES
(2, 'Dr. John Smith', 'Cardiologist', 1, 'Mon-Fri 9AM-5PM', 150.00),
(3, 'Dr. Sarah Johnson', 'Neurologist', 2, 'Mon-Sat 10AM-6PM', 175.00),
(4, 'Dr. Michael Williams', 'Pediatrician', 3, 'Mon-Fri 8AM-4PM', 125.00),
(5, 'Dr. Emily Brown', 'Orthopedic Surgeon', 4, 'Tue-Sat 9AM-5PM', 200.00);

-- Insert sample appointments
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, reason, status) VALUES
(6, 1, CURRENT_DATE + INTERVAL '1 day', '10:00:00', 'Regular checkup', 'pending'),
(7, 2, CURRENT_DATE + INTERVAL '2 days', '14:00:00', 'Headache consultation', 'approved'),
(8, 3, CURRENT_DATE + INTERVAL '3 days', '11:00:00', 'Child vaccination', 'pending');

-- Insert sample medical records
INSERT INTO medical_records (patient_id, doctor_id, diagnosis, treatment, prescription, date) VALUES
(6, 1, 'Hypertension', 'Lifestyle changes and medication', 'Amlodipine 5mg once daily', CURRENT_DATE - INTERVAL '30 days'),
(7, 2, 'Migraine', 'Pain management and stress reduction', 'Sumatriptan as needed', CURRENT_DATE - INTERVAL '15 days');

-- Grant permissions (adjust as needed for your setup)
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO hospital_user;
-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO hospital_user;

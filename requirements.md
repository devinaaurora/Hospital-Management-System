🏥 Hospital Management System — JSP CRUD Project Specification
🏷️ 1. Project Overview

Project Title: Hospital Management System (HMS)
Description:
A hospital management platform designed to streamline patient registration, doctor scheduling, appointment management, and administrative operations.
Patients can book appointments and view their medical records, while doctors can manage schedules and update patient diagnoses. Administrators control user roles, doctor data, and hospital resources.

💡 2. Core Features (CRUD Operations)
Role	Feature	CRUD Action	Description
Patient	View doctor list & availability	Read	Patients can see doctors, departments, and their schedules
Patient	Book appointment	Create	Patients can request an appointment with a doctor
Patient	View appointment status	Read	Patients can monitor confirmed, pending, or cancelled appointments
Patient	Edit appointment	Update	Patients can modify appointments before approval
Patient	Cancel appointment	Delete	Patients can cancel their appointment requests
Doctor	View assigned appointments	Read	Doctors can see patient appointments for the day/week
Doctor	Update appointment status	Update	Doctors can approve, decline, or mark appointments as completed
Doctor	Update patient diagnosis/notes	Update	Doctors can add/update medical notes for a patient
Admin	Add doctor	Create	Admins can add new doctors to the system
Admin	Edit doctor info & schedule	Update	Admins can update doctor profiles and availability
Admin	Manage departments	Create/Update/Delete	Admins can add, update, or remove hospital departments
Admin	View all appointments	Read	Admins can monitor all hospital appointment activity
🧰 3. Technical Requirements

Database: PostgreSQL

Application Server: Apache Tomcat

Language/Framework: JSP + Servlets (Jakarta EE)

JSP Pages:

index.jsp

login.jsp

patient_dashboard.jsp

doctor_dashboard.jsp

admin_dashboard.jsp

doctor_list.jsp

appointment_form.jsp

appointment_list.jsp

admin_doctor_list.jsp

etc.

Servlets:

LoginServlet

DoctorServlet

AppointmentServlet

PatientServlet

AdminServlet

Database Connection: JDBC pool or helper DBUtil class

📊 Example Database Schema
Table: users

user_id (serial, PK)

username (varchar)

password (varchar)

role (varchar) — 'patient', 'doctor', or 'admin'

Table: doctors

doctor_id (serial, PK)

name (varchar)

department_id (int, FK → departments.department_id)

availability (varchar) — e.g., 'Mon-Fri', 'Weekends', etc.

Table: departments

department_id (serial, PK)

department_name (varchar)

Table: appointments

appointment_id (serial, PK)

patient_id (int, FK → users.user_id)

doctor_id (int, FK → doctors.doctor_id)

appointment_date (date)

appointment_time (time)

reason (text)

status (varchar) — 'pending', 'approved', 'rejected', 'completed'

Table: medical_records

record_id (serial, PK)

patient_id (int, FK → users.user_id)

doctor_id (int, FK → doctors.doctor_id)

diagnosis (text)

treatment (text)

date (date)

🎨 4. Design & UI Preferences

Design Style: Clean, professional, healthcare-themed

CSS Framework: TailwindCSS

Theme: White background, medical blue accents, soft gray highlights

UI Guidelines:

Sidebar/top navbar for each user role

Cards for doctor listings and patient summaries

Tables for appointments and patient records

Responsive desktop/mobile layout

Use icons (Lucide, Heroicons) for readability

👤 5. User Roles
Patient

Log in to patient dashboard

View doctors & schedules

Create/edit/cancel appointments

Check appointment status

View medical history

Doctor

Log in to doctor dashboard

View assigned appointments

Approve/reject consultations

Add/update patient diagnosis and notes

Admin

Log in to admin panel

Manage doctors

Manage department data

View all appointments

Oversee hospital operations

🚀 6. Deployment Goal

Primary environment: Local development using Tomcat (localhost)

Target deployment: Online server (Render, school server, CPanel Tomcat hosting, etc.)

Database configuration: context.xml or config.properties for flexibility

🪄 7. Output Requested

You want the following generated:

✅ Complete project file structure (JSP + Servlets + config)
✅ SQL database schema (PostgreSQL)
✅ Sample JSP pages (form pages, dashboards, lists)
✅ Complete Java Servlet backend (CRUD + authentication + session handling)
✅ TailwindCSS-based UI components
✅ Deployment & testing instructions (local + online)

🎯 8. Extra Notes

Prioritize performance & stability

Use reusable components for tables, cards, and forms

All CRUD features must be fully testable before deployment
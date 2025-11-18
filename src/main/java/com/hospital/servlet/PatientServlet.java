package com.hospital.servlet;

import com.hospital.dao.AppointmentDAO;
import com.hospital.dao.DoctorDAO;
import com.hospital.dao.MedicalRecordDAO;
import com.hospital.model.Appointment;
import com.hospital.model.Doctor;
import com.hospital.model.MedicalRecord;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

/**
 * Servlet for handling patient operations
 */
@WebServlet("/patient/*")
public class PatientServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;
    private DoctorDAO doctorDAO;
    private MedicalRecordDAO medicalRecordDAO;
    
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        doctorDAO = new DoctorDAO();
        medicalRecordDAO = new MedicalRecordDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || 
            !"patient".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || "/dashboard".equals(pathInfo)) {
            showDashboard(request, response);
        } else if ("/appointments".equals(pathInfo)) {
            showAppointments(request, response);
        } else if ("/book-appointment".equals(pathInfo)) {
            showBookAppointmentForm(request, response);
        } else if ("/doctors".equals(pathInfo)) {
            showDoctors(request, response);
        } else if ("/medical-records".equals(pathInfo)) {
            showMedicalRecords(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || 
            !"patient".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if ("/cancel-appointment".equals(pathInfo)) {
            cancelAppointment(request, response);
        } else {
            String action = request.getParameter("action");
            
            if ("book".equals(action)) {
                bookAppointment(request, response);
            } else if ("cancel".equals(action)) {
                cancelAppointment(request, response);
            } else if ("update".equals(action)) {
                updateAppointment(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        }
    }
    
    private void showDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int userId = (Integer) request.getSession().getAttribute("userId");
        List<Appointment> appointments = appointmentDAO.getAppointmentsByPatient(userId);
        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("/patient_dashboard.jsp").forward(request, response);
    }
    
    private void showAppointments(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int userId = (Integer) request.getSession().getAttribute("userId");
        List<Appointment> appointments = appointmentDAO.getAppointmentsByPatient(userId);
        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("/patient_appointments.jsp").forward(request, response);
    }
    
    private void showBookAppointmentForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("/appointment_form.jsp").forward(request, response);
    }
    
    private void showDoctors(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        request.setAttribute("doctors", doctors);
        request.getRequestDispatcher("/doctor_list.jsp").forward(request, response);
    }
    
    private void showMedicalRecords(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int userId = (Integer) request.getSession().getAttribute("userId");
        List<MedicalRecord> records = medicalRecordDAO.getMedicalRecordsByPatient(userId);
        request.setAttribute("medicalRecords", records);
        request.getRequestDispatcher("/patient_medical_records.jsp").forward(request, response);
    }
    
    private void bookAppointment(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int userId = (Integer) request.getSession().getAttribute("userId");
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            String dateStr = request.getParameter("appointmentDate");
            String timeStr = request.getParameter("appointmentTime");
            String reason = request.getParameter("reason");
            
            Appointment appointment = new Appointment();
            appointment.setPatientId(userId);
            appointment.setDoctorId(doctorId);
            appointment.setAppointmentDate(Date.valueOf(dateStr));
            appointment.setAppointmentTime(Time.valueOf(timeStr + ":00"));
            appointment.setReason(reason);
            appointment.setStatus("pending");
            
            boolean success = appointmentDAO.createAppointment(appointment);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/patient/appointments?success=booked");
            } else {
                response.sendRedirect(request.getContextPath() + "/patient/book-appointment?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/patient/book-appointment?error=invalid");
        }
    }
    
    private void cancelAppointment(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            boolean success = appointmentDAO.updateAppointmentStatus(appointmentId, "cancelled", "Cancelled by patient");
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/patient/appointments?success=cancelled");
            } else {
                response.sendRedirect(request.getContextPath() + "/patient/appointments?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/patient/appointments?error=invalid");
        }
    }
    
    private void updateAppointment(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String dateStr = request.getParameter("appointmentDate");
            String timeStr = request.getParameter("appointmentTime");
            String reason = request.getParameter("reason");
            
            Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);
            if (appointment != null && "pending".equals(appointment.getStatus())) {
                appointment.setAppointmentDate(Date.valueOf(dateStr));
                appointment.setAppointmentTime(Time.valueOf(timeStr + ":00"));
                appointment.setReason(reason);
                
                boolean success = appointmentDAO.updateAppointment(appointment);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/patient/appointments?success=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/patient/appointments?error=failed");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/patient/appointments?error=cannot_update");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/patient/appointments?error=invalid");
        }
    }
}

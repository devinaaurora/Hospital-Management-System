package com.hospital.servlet;

import com.hospital.dao.AppointmentDAO;
import com.hospital.dao.MedicalRecordDAO;
import com.hospital.model.Appointment;
import com.hospital.model.MedicalRecord;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

/**
 * Servlet for handling doctor operations
 */
@WebServlet("/doctor/*")
public class DoctorServlet extends HttpServlet {
    private AppointmentDAO appointmentDAO;
    private MedicalRecordDAO medicalRecordDAO;
    
    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAO();
        medicalRecordDAO = new MedicalRecordDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || 
            !"doctor".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || "/dashboard".equals(pathInfo)) {
            showDashboard(request, response);
        } else if ("/appointments".equals(pathInfo)) {
            showAppointments(request, response);
        } else if ("/patients".equals(pathInfo)) {
            showPatients(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || 
            !"doctor".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");
        
        if ("approve".equals(action)) {
            approveAppointment(request, response);
        } else if ("reject".equals(action)) {
            rejectAppointment(request, response);
        } else if ("complete".equals(action)) {
            completeAppointment(request, response);
        } else if ("addRecord".equals(action)) {
            addMedicalRecord(request, response, pathInfo);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    private void showDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Integer doctorId = (Integer) request.getSession().getAttribute("doctorId");
        if (doctorId != null) {
            List<Appointment> appointments = appointmentDAO.getAppointmentsByDoctor(doctorId);
            request.setAttribute("appointments", appointments);
        }
        request.getRequestDispatcher("/doctor_dashboard.jsp").forward(request, response);
    }
    
    private void showAppointments(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Integer doctorId = (Integer) request.getSession().getAttribute("doctorId");
        if (doctorId != null) {
            List<Appointment> appointments = appointmentDAO.getAppointmentsByDoctor(doctorId);
            request.setAttribute("appointments", appointments);
        }
        request.getRequestDispatcher("/doctor_appointments.jsp").forward(request, response);
    }
    
    private void showPatients(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Integer doctorId = (Integer) request.getSession().getAttribute("doctorId");
        if (doctorId != null) {
            List<MedicalRecord> records = medicalRecordDAO.getMedicalRecordsByDoctor(doctorId);
            request.setAttribute("medicalRecords", records);
        }
        request.getRequestDispatcher("/doctor_patients.jsp").forward(request, response);
    }
    
    private void approveAppointment(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String notes = request.getParameter("notes");
            
            boolean success = appointmentDAO.updateAppointmentStatus(appointmentId, "approved", notes);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/doctor/appointments?success=approved");
            } else {
                response.sendRedirect(request.getContextPath() + "/doctor/appointments?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctor/appointments?error=invalid");
        }
    }
    
    private void rejectAppointment(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String notes = request.getParameter("notes");
            
            boolean success = appointmentDAO.updateAppointmentStatus(appointmentId, "rejected", notes);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/doctor/appointments?success=rejected");
            } else {
                response.sendRedirect(request.getContextPath() + "/doctor/appointments?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctor/appointments?error=invalid");
        }
    }
    
    private void completeAppointment(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String notes = request.getParameter("notes");
            
            boolean success = appointmentDAO.updateAppointmentStatus(appointmentId, "completed", notes);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/doctor/appointments?success=completed");
            } else {
                response.sendRedirect(request.getContextPath() + "/doctor/appointments?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctor/appointments?error=invalid");
        }
    }
    
    private void addMedicalRecord(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws IOException {
        try {
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            Integer doctorId = (Integer) request.getSession().getAttribute("doctorId");
            String appointmentIdStr = request.getParameter("appointmentId");
            String diagnosis = request.getParameter("diagnosis");
            String treatment = request.getParameter("treatment");
            String prescription = request.getParameter("prescription");
            
            MedicalRecord record = new MedicalRecord();
            record.setPatientId(patientId);
            record.setDoctorId(doctorId);
            if (appointmentIdStr != null && !appointmentIdStr.isEmpty()) {
                record.setAppointmentId(Integer.parseInt(appointmentIdStr));
                // Mark appointment as completed
                appointmentDAO.updateAppointmentStatus(Integer.parseInt(appointmentIdStr), "completed", "Diagnosis added");
            }
            record.setDiagnosis(diagnosis);
            record.setTreatment(treatment);
            record.setPrescription(prescription);
            record.setDate(new Date(System.currentTimeMillis()));
            
            boolean success = medicalRecordDAO.createMedicalRecord(record);
            
            String redirectPath = "/patients".equals(pathInfo) ? "/doctor/patients" : "/doctor/appointments";
            
            if (success) {
                response.sendRedirect(request.getContextPath() + redirectPath + "?success=record_added");
            } else {
                response.sendRedirect(request.getContextPath() + redirectPath + "?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctor/appointments?error=invalid");
        }
    }
}

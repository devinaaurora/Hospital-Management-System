package com.hospital.dao;

import com.hospital.model.Appointment;
import com.hospital.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Appointment operations
 */
public class AppointmentDAO {
    
    /**
     * Get all appointments with patient and doctor names
     */
    public List<Appointment> getAllAppointments() {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.*, u.full_name as patient_name, d.name as doctor_name " +
                    "FROM appointments a " +
                    "JOIN users u ON a.patient_id = u.user_id " +
                    "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                    "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                appointments.add(extractAppointmentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return appointments;
    }
    
    /**
     * Get appointment by ID
     */
    public Appointment getAppointmentById(int appointmentId) {
        String sql = "SELECT a.*, u.full_name as patient_name, d.name as doctor_name " +
                    "FROM appointments a " +
                    "JOIN users u ON a.patient_id = u.user_id " +
                    "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                    "WHERE a.appointment_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, appointmentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractAppointmentFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get appointments by patient ID
     */
    public List<Appointment> getAppointmentsByPatient(int patientId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.*, u.full_name as patient_name, d.name as doctor_name " +
                    "FROM appointments a " +
                    "JOIN users u ON a.patient_id = u.user_id " +
                    "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                    "WHERE a.patient_id = ? " +
                    "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, patientId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                appointments.add(extractAppointmentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return appointments;
    }
    
    /**
     * Get appointments by doctor ID
     */
    public List<Appointment> getAppointmentsByDoctor(int doctorId) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.*, u.full_name as patient_name, d.name as doctor_name " +
                    "FROM appointments a " +
                    "JOIN users u ON a.patient_id = u.user_id " +
                    "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                    "WHERE a.doctor_id = ? " +
                    "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, doctorId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                appointments.add(extractAppointmentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return appointments;
    }
    
    /**
     * Get appointments by status
     */
    public List<Appointment> getAppointmentsByStatus(String status) {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.*, u.full_name as patient_name, d.name as doctor_name " +
                    "FROM appointments a " +
                    "JOIN users u ON a.patient_id = u.user_id " +
                    "JOIN doctors d ON a.doctor_id = d.doctor_id " +
                    "WHERE a.status = ? " +
                    "ORDER BY a.appointment_date DESC, a.appointment_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                appointments.add(extractAppointmentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return appointments;
    }
    
    /**
     * Create new appointment
     */
    public boolean createAppointment(Appointment appointment) {
        String sql = "INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, reason, status) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, appointment.getPatientId());
            pstmt.setInt(2, appointment.getDoctorId());
            pstmt.setDate(3, appointment.getAppointmentDate());
            pstmt.setTime(4, appointment.getAppointmentTime());
            pstmt.setString(5, appointment.getReason());
            pstmt.setString(6, appointment.getStatus());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update appointment
     */
    public boolean updateAppointment(Appointment appointment) {
        String sql = "UPDATE appointments SET appointment_date = ?, appointment_time = ?, " +
                    "reason = ?, status = ?, notes = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE appointment_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setDate(1, appointment.getAppointmentDate());
            pstmt.setTime(2, appointment.getAppointmentTime());
            pstmt.setString(3, appointment.getReason());
            pstmt.setString(4, appointment.getStatus());
            pstmt.setString(5, appointment.getNotes());
            pstmt.setInt(6, appointment.getAppointmentId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update appointment status
     */
    public boolean updateAppointmentStatus(int appointmentId, String status, String notes) {
        String sql = "UPDATE appointments SET status = ?, notes = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE appointment_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setString(2, notes);
            pstmt.setInt(3, appointmentId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete appointment
     */
    public boolean deleteAppointment(int appointmentId) {
        String sql = "DELETE FROM appointments WHERE appointment_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, appointmentId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Extract Appointment object from ResultSet
     */
    private Appointment extractAppointmentFromResultSet(ResultSet rs) throws SQLException {
        Appointment appointment = new Appointment();
        appointment.setAppointmentId(rs.getInt("appointment_id"));
        appointment.setPatientId(rs.getInt("patient_id"));
        appointment.setPatientName(rs.getString("patient_name"));
        appointment.setDoctorId(rs.getInt("doctor_id"));
        appointment.setDoctorName(rs.getString("doctor_name"));
        appointment.setAppointmentDate(rs.getDate("appointment_date"));
        appointment.setAppointmentTime(rs.getTime("appointment_time"));
        appointment.setReason(rs.getString("reason"));
        appointment.setStatus(rs.getString("status"));
        appointment.setNotes(rs.getString("notes"));
        appointment.setCreatedAt(rs.getTimestamp("created_at"));
        appointment.setUpdatedAt(rs.getTimestamp("updated_at"));
        return appointment;
    }
}

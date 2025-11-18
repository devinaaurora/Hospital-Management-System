package com.hospital.dao;

import com.hospital.model.Doctor;
import com.hospital.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Doctor operations
 */
public class DoctorDAO {
    
    /**
     * Get all doctors with department names
     */
    public List<Doctor> getAllDoctors() {
        List<Doctor> doctors = new ArrayList<>();
        String sql = "SELECT d.*, dep.department_name FROM doctors d " +
                    "LEFT JOIN departments dep ON d.department_id = dep.department_id " +
                    "ORDER BY d.name";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                doctors.add(extractDoctorFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return doctors;
    }
    
    /**
     * Get doctor by ID
     */
    public Doctor getDoctorById(int doctorId) {
        String sql = "SELECT d.*, dep.department_name FROM doctors d " +
                    "LEFT JOIN departments dep ON d.department_id = dep.department_id " +
                    "WHERE d.doctor_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, doctorId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractDoctorFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get doctor by user ID
     */
    public Doctor getDoctorByUserId(int userId) {
        String sql = "SELECT d.*, dep.department_name FROM doctors d " +
                    "LEFT JOIN departments dep ON d.department_id = dep.department_id " +
                    "WHERE d.user_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractDoctorFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get doctors by department
     */
    public List<Doctor> getDoctorsByDepartment(int departmentId) {
        List<Doctor> doctors = new ArrayList<>();
        String sql = "SELECT d.*, dep.department_name FROM doctors d " +
                    "LEFT JOIN departments dep ON d.department_id = dep.department_id " +
                    "WHERE d.department_id = ? ORDER BY d.name";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, departmentId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                doctors.add(extractDoctorFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return doctors;
    }
    
    /**
     * Create new doctor
     */
    public boolean createDoctor(Doctor doctor) {
        String sql = "INSERT INTO doctors (user_id, name, specialization, department_id, availability, consultation_fee) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, doctor.getUserId());
            pstmt.setString(2, doctor.getName());
            pstmt.setString(3, doctor.getSpecialization());
            pstmt.setInt(4, doctor.getDepartmentId());
            pstmt.setString(5, doctor.getAvailability());
            pstmt.setBigDecimal(6, doctor.getConsultationFee());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update doctor
     */
    public boolean updateDoctor(Doctor doctor) {
        String sql = "UPDATE doctors SET name = ?, specialization = ?, department_id = ?, " +
                    "availability = ?, consultation_fee = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE doctor_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, doctor.getName());
            pstmt.setString(2, doctor.getSpecialization());
            pstmt.setInt(3, doctor.getDepartmentId());
            pstmt.setString(4, doctor.getAvailability());
            pstmt.setBigDecimal(5, doctor.getConsultationFee());
            pstmt.setInt(6, doctor.getDoctorId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete doctor
     */
    public boolean deleteDoctor(int doctorId) {
        String sql = "DELETE FROM doctors WHERE doctor_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, doctorId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Extract Doctor object from ResultSet
     */
    private Doctor extractDoctorFromResultSet(ResultSet rs) throws SQLException {
        Doctor doctor = new Doctor();
        doctor.setDoctorId(rs.getInt("doctor_id"));
        doctor.setUserId(rs.getInt("user_id"));
        doctor.setName(rs.getString("name"));
        doctor.setSpecialization(rs.getString("specialization"));
        doctor.setDepartmentId(rs.getInt("department_id"));
        doctor.setDepartmentName(rs.getString("department_name"));
        doctor.setAvailability(rs.getString("availability"));
        doctor.setConsultationFee(rs.getBigDecimal("consultation_fee"));
        doctor.setCreatedAt(rs.getTimestamp("created_at"));
        doctor.setUpdatedAt(rs.getTimestamp("updated_at"));
        return doctor;
    }
}

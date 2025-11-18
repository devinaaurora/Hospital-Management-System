package com.hospital.dao;

import com.hospital.model.MedicalRecord;
import com.hospital.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Medical Record operations
 */
public class MedicalRecordDAO {
    
    /**
     * Get all medical records
     */
    public List<MedicalRecord> getAllMedicalRecords() {
        List<MedicalRecord> records = new ArrayList<>();
        String sql = "SELECT mr.*, u.full_name as patient_name, d.name as doctor_name " +
                    "FROM medical_records mr " +
                    "JOIN users u ON mr.patient_id = u.user_id " +
                    "JOIN doctors d ON mr.doctor_id = d.doctor_id " +
                    "ORDER BY mr.date DESC";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                records.add(extractMedicalRecordFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return records;
    }
    
    /**
     * Get medical record by ID
     */
    public MedicalRecord getMedicalRecordById(int recordId) {
        String sql = "SELECT mr.*, u.full_name as patient_name, d.name as doctor_name " +
                    "FROM medical_records mr " +
                    "JOIN users u ON mr.patient_id = u.user_id " +
                    "JOIN doctors d ON mr.doctor_id = d.doctor_id " +
                    "WHERE mr.record_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, recordId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractMedicalRecordFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get medical records by patient ID
     */
    public List<MedicalRecord> getMedicalRecordsByPatient(int patientId) {
        List<MedicalRecord> records = new ArrayList<>();
        String sql = "SELECT mr.*, u.full_name as patient_name, d.name as doctor_name " +
                    "FROM medical_records mr " +
                    "JOIN users u ON mr.patient_id = u.user_id " +
                    "JOIN doctors d ON mr.doctor_id = d.doctor_id " +
                    "WHERE mr.patient_id = ? " +
                    "ORDER BY mr.date DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, patientId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                records.add(extractMedicalRecordFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return records;
    }
    
    /**
     * Get medical records by doctor ID
     */
    public List<MedicalRecord> getMedicalRecordsByDoctor(int doctorId) {
        List<MedicalRecord> records = new ArrayList<>();
        String sql = "SELECT mr.*, u.full_name as patient_name, d.name as doctor_name " +
                    "FROM medical_records mr " +
                    "JOIN users u ON mr.patient_id = u.user_id " +
                    "JOIN doctors d ON mr.doctor_id = d.doctor_id " +
                    "WHERE mr.doctor_id = ? " +
                    "ORDER BY mr.date DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, doctorId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                records.add(extractMedicalRecordFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return records;
    }
    
    /**
     * Create new medical record
     */
    public boolean createMedicalRecord(MedicalRecord record) {
        String sql = "INSERT INTO medical_records (patient_id, doctor_id, appointment_id, diagnosis, treatment, prescription, date) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, record.getPatientId());
            pstmt.setInt(2, record.getDoctorId());
            if (record.getAppointmentId() > 0) {
                pstmt.setInt(3, record.getAppointmentId());
            } else {
                pstmt.setNull(3, Types.INTEGER);
            }
            pstmt.setString(4, record.getDiagnosis());
            pstmt.setString(5, record.getTreatment());
            pstmt.setString(6, record.getPrescription());
            pstmt.setDate(7, record.getDate());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update medical record
     */
    public boolean updateMedicalRecord(MedicalRecord record) {
        String sql = "UPDATE medical_records SET diagnosis = ?, treatment = ?, prescription = ?, " +
                    "date = ?, updated_at = CURRENT_TIMESTAMP WHERE record_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, record.getDiagnosis());
            pstmt.setString(2, record.getTreatment());
            pstmt.setString(3, record.getPrescription());
            pstmt.setDate(4, record.getDate());
            pstmt.setInt(5, record.getRecordId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete medical record
     */
    public boolean deleteMedicalRecord(int recordId) {
        String sql = "DELETE FROM medical_records WHERE record_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, recordId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Extract MedicalRecord object from ResultSet
     */
    private MedicalRecord extractMedicalRecordFromResultSet(ResultSet rs) throws SQLException {
        MedicalRecord record = new MedicalRecord();
        record.setRecordId(rs.getInt("record_id"));
        record.setPatientId(rs.getInt("patient_id"));
        record.setPatientName(rs.getString("patient_name"));
        record.setDoctorId(rs.getInt("doctor_id"));
        record.setDoctorName(rs.getString("doctor_name"));
        record.setAppointmentId(rs.getInt("appointment_id"));
        record.setDiagnosis(rs.getString("diagnosis"));
        record.setTreatment(rs.getString("treatment"));
        record.setPrescription(rs.getString("prescription"));
        record.setDate(rs.getDate("date"));
        record.setCreatedAt(rs.getTimestamp("created_at"));
        record.setUpdatedAt(rs.getTimestamp("updated_at"));
        return record;
    }
}

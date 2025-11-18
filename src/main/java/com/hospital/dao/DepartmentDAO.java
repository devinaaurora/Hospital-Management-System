package com.hospital.dao;

import com.hospital.model.Department;
import com.hospital.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Department operations
 */
public class DepartmentDAO {
    
    /**
     * Get all departments
     */
    public List<Department> getAllDepartments() {
        List<Department> departments = new ArrayList<>();
        String sql = "SELECT * FROM departments ORDER BY department_name";
        
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                departments.add(extractDepartmentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return departments;
    }
    
    /**
     * Get department by ID
     */
    public Department getDepartmentById(int departmentId) {
        String sql = "SELECT * FROM departments WHERE department_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, departmentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractDepartmentFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Create new department
     */
    public boolean createDepartment(Department department) {
        String sql = "INSERT INTO departments (department_name, description) VALUES (?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, department.getDepartmentName());
            pstmt.setString(2, department.getDescription());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update department
     */
    public boolean updateDepartment(Department department) {
        String sql = "UPDATE departments SET department_name = ?, description = ? WHERE department_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, department.getDepartmentName());
            pstmt.setString(2, department.getDescription());
            pstmt.setInt(3, department.getDepartmentId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete department
     */
    public boolean deleteDepartment(int departmentId) {
        String sql = "DELETE FROM departments WHERE department_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, departmentId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Extract Department object from ResultSet
     */
    private Department extractDepartmentFromResultSet(ResultSet rs) throws SQLException {
        Department dept = new Department();
        dept.setDepartmentId(rs.getInt("department_id"));
        dept.setDepartmentName(rs.getString("department_name"));
        dept.setDescription(rs.getString("description"));
        dept.setCreatedAt(rs.getTimestamp("created_at"));
        return dept;
    }
}

package com.hospital.servlet;

import com.hospital.dao.DoctorDAO;
import com.hospital.dao.DepartmentDAO;
import com.hospital.dao.AppointmentDAO;
import com.hospital.dao.UserDAO;
import com.hospital.model.Doctor;
import com.hospital.model.Department;
import com.hospital.model.Appointment;
import com.hospital.model.User;
import com.hospital.util.CSRFUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Servlet for handling admin operations
 * Now includes CSRF protection for form submissions
 */
@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
    private DoctorDAO doctorDAO;
    private DepartmentDAO departmentDAO;
    private AppointmentDAO appointmentDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAO();
        departmentDAO = new DepartmentDAO();
        appointmentDAO = new AppointmentDAO();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || 
            !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Generate CSRF token for forms
        String csrfToken = CSRFUtil.getToken(session);
        request.setAttribute("csrfToken", csrfToken);
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || "/dashboard".equals(pathInfo)) {
            showDashboard(request, response);
        } else if ("/doctors".equals(pathInfo)) {
            showDoctors(request, response);
        } else if ("/departments".equals(pathInfo)) {
            showDepartments(request, response);
        } else if ("/appointments".equals(pathInfo)) {
            showAppointments(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || 
            !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Validate CSRF token
        if (!CSRFUtil.validateToken(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token. Please try again.");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("addDoctor".equals(action)) {
            addDoctor(request, response);
        } else if ("updateDoctor".equals(action)) {
            updateDoctor(request, response);
        } else if ("deleteDoctor".equals(action)) {
            deleteDoctor(request, response);
        } else if ("addDepartment".equals(action)) {
            addDepartment(request, response);
        } else if ("updateDepartment".equals(action)) {
            updateDepartment(request, response);
        } else if ("deleteDepartment".equals(action)) {
            deleteDepartment(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    private void showDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Appointment> appointments = appointmentDAO.getAllAppointments();
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        List<User> patients = userDAO.getUsersByRole("patient");
        
        request.setAttribute("appointments", appointments);
        request.setAttribute("doctors", doctors);
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("/admin_dashboard.jsp").forward(request, response);
    }
    
    private void showDoctors(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        List<Department> departments = departmentDAO.getAllDepartments();
        request.setAttribute("doctors", doctors);
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/admin_doctor_list.jsp").forward(request, response);
    }
    
    private void showDepartments(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Department> departments = departmentDAO.getAllDepartments();
        request.setAttribute("departments", departments);
        request.getRequestDispatcher("/admin_departments.jsp").forward(request, response);
    }
    
    private void showAppointments(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Appointment> appointments = appointmentDAO.getAllAppointments();
        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("/admin_appointments.jsp").forward(request, response);
    }
    
    private void addDoctor(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            String username = request.getParameter("username");
            
            // Check if username already exists
            User existingUser = userDAO.getUserByUsername(username);
            if (existingUser != null) {
                response.sendRedirect(request.getContextPath() + "/admin/doctors?error=username_exists");
                return;
            }
            
            // First create user account for the doctor
            User user = new User();
            user.setUsername(username);
            user.setPassword(request.getParameter("password"));
            user.setFullName(request.getParameter("name"));
            user.setEmail(request.getParameter("email"));
            user.setPhone(request.getParameter("phone"));
            user.setRole("doctor");
            
            boolean userCreated = userDAO.createUser(user);
            
            if (userCreated) {
                // Get the created user to get the user_id
                User createdUser = userDAO.getUserByUsername(user.getUsername());
                
                // Create doctor record
                Doctor doctor = new Doctor();
                doctor.setUserId(createdUser.getUserId());
                doctor.setName(request.getParameter("name"));
                doctor.setSpecialization(request.getParameter("specialization"));
                doctor.setDepartmentId(Integer.parseInt(request.getParameter("departmentId")));
                doctor.setAvailability(request.getParameter("availability"));
                doctor.setConsultationFee(new BigDecimal(request.getParameter("consultationFee")));
                
                boolean success = doctorDAO.createDoctor(doctor);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/doctors?success=added");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/doctors?error=failed");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/doctors?error=user_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/doctors?error=invalid");
        }
    }
    
    private void updateDoctor(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            Doctor doctor = doctorDAO.getDoctorById(doctorId);
            
            if (doctor != null) {
                doctor.setName(request.getParameter("name"));
                doctor.setSpecialization(request.getParameter("specialization"));
                doctor.setDepartmentId(Integer.parseInt(request.getParameter("departmentId")));
                doctor.setAvailability(request.getParameter("availability"));
                doctor.setConsultationFee(new BigDecimal(request.getParameter("consultationFee")));
                
                boolean success = doctorDAO.updateDoctor(doctor);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/doctors?success=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/doctors?error=failed");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/doctors?error=not_found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/doctors?error=invalid");
        }
    }
    
    private void deleteDoctor(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));
            boolean success = doctorDAO.deleteDoctor(doctorId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/doctors?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/doctors?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/doctors?error=invalid");
        }
    }
    
    private void addDepartment(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            Department department = new Department();
            department.setDepartmentName(request.getParameter("departmentName"));
            department.setDescription(request.getParameter("description"));
            
            boolean success = departmentDAO.createDepartment(department);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/departments?success=added");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/departments?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/departments?error=invalid");
        }
    }
    
    private void updateDepartment(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int departmentId = Integer.parseInt(request.getParameter("departmentId"));
            Department department = departmentDAO.getDepartmentById(departmentId);
            
            if (department != null) {
                department.setDepartmentName(request.getParameter("departmentName"));
                department.setDescription(request.getParameter("description"));
                
                boolean success = departmentDAO.updateDepartment(department);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/departments?success=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/departments?error=failed");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/departments?error=not_found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/departments?error=invalid");
        }
    }
    
    private void deleteDepartment(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int departmentId = Integer.parseInt(request.getParameter("departmentId"));
            boolean success = departmentDAO.deleteDepartment(departmentId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/departments?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/departments?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/departments?error=invalid");
        }
    }
}

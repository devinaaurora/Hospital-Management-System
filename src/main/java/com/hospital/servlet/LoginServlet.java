package com.hospital.servlet;

import com.hospital.dao.UserDAO;
import com.hospital.dao.DoctorDAO;
import com.hospital.model.User;
import com.hospital.model.Doctor;
import com.hospital.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet for handling login and logout
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;
    private DoctorDAO doctorDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        doctorDAO = new DoctorDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            handleLogout(request, response);
        } else {
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Validate input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Please enter both username and password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // Authenticate user
        User user = userDAO.authenticate(username, password);
        
        if (user != null) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            
            // If user is a doctor, get doctor info
            if ("doctor".equals(user.getRole())) {
                Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserId());
                if (doctor != null) {
                    session.setAttribute("doctorId", doctor.getDoctorId());
                    session.setAttribute("doctor", doctor);
                }
            }
            
            // Redirect based on role
            String redirectUrl = getRedirectUrlByRole(user.getRole());
            response.sendRedirect(request.getContextPath() + redirectUrl);
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    private void handleLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
    
    private String getRedirectUrlByRole(String role) {
        switch (role) {
            case "patient":
                return "/patient/dashboard";
            case "doctor":
                return "/doctor/dashboard";
            case "admin":
                return "/admin/dashboard";
            default:
                return "/index.jsp";
        }
    }
}

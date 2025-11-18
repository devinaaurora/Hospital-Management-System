package com.hospital.servlet;

import com.hospital.dao.UserDAO;
import com.hospital.model.User;
import com.hospital.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet for handling user registration
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String fullName = request.getParameter("fullName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate passwords match
        if (!password.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=passwords_mismatch");
            return;
        }
        
        // Validate password complexity
        if (!PasswordUtil.isValidComplexity(password)) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=weak_password");
            return;
        }
        
        // Check if username already exists
        User existingUser = userDAO.getUserByUsername(username);
        if (existingUser != null) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=username_exists");
            return;
        }
        
        // Check if email already exists
        User existingEmail = userDAO.getUserByEmail(email);
        if (existingEmail != null) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=email_exists");
            return;
        }
        
        try {
            // Create new user
            User user = new User();
            user.setUsername(username);
            user.setPassword(PasswordUtil.hashPassword(password)); // Hash with BCrypt
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setRole("patient"); // Default role is patient
            
            boolean success = userDAO.createUser(user);
            
            if (success) {
                // Registration successful
                response.sendRedirect(request.getContextPath() + "/register.jsp?success=true");
            } else {
                // Registration failed
                response.sendRedirect(request.getContextPath() + "/register.jsp?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=exception");
        }
    }
}

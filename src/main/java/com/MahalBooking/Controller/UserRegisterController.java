package com.MahalBooking.Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.regex.Pattern;

import com.MahalBooking.DAO.UserDAO;
import com.MahalBooking.Model.User;

@WebServlet("/UserRegisterController")
public class UserRegisterController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Email regex pattern
    private static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@(.+)$";
    // Phone regex pattern (10 digits)
    private static final String PHONE_REGEX = "^\\d{10}$";
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String mobile = request.getParameter("mobile");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Validate inputs
        if (name == null || name.trim().isEmpty()) {
            setErrorAndForward(request, response, "Name is required");
            return;
        }
        
        if (mobile == null || !Pattern.matches(PHONE_REGEX, mobile)) {
            setErrorAndForward(request, response, "Please enter a valid 10-digit phone number");
            return;
        }
        
        if (email == null || !Pattern.matches(EMAIL_REGEX, email)) {
            setErrorAndForward(request, response, "Please enter a valid email address");
            return;
        }
        
        if (password == null || password.length() < 6) {
            setErrorAndForward(request, response, "Password must be at least 6 characters");
            return;
        }
        
        User newUser = new User();
        newUser.setName(name.trim());
        newUser.setMobile(mobile.trim());
        newUser.setEmail(email.trim().toLowerCase());
        newUser.setPassword(password); // Note: In production, you should hash this
        
        try {
            UserDAO userDAO = new UserDAO();
            
            // Check if email already exists
            if (userDAO.emailExists(email)) {
                setErrorAndForward(request, response, "Email already registered. Please use a different email.");
                return;
            }
            
            // Register the user
            boolean isRegistered = userDAO.registerUser(newUser);
            
            if (isRegistered) {
                // Redirect to login page with success message
                response.sendRedirect("user-login.jsp?registration=success");
            } else {
                setErrorAndForward(request, response, "Registration failed. Please try again.");
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Log the error for debugging
            setErrorAndForward(request, response, "System error occurred. Please try again later.");
        }
    }
    
    private void setErrorAndForward(HttpServletRequest request, HttpServletResponse response, 
                                   String message) throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("user-register.jsp").forward(request, response);
    }
}

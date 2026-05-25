package com.MahalBooking.Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

import com.MahalBooking.DAO.UserDAO;
import com.MahalBooking.Model.User;

@WebServlet("/UserProfileController")
public class UserProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("user-login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("updateProfile".equals(action)) {
            updateProfile(request, response, currentUser);
        } else if ("changePassword".equals(action)) {
            changePassword(request, response, currentUser);
        }
    }
    
    private void updateProfile(HttpServletRequest request, HttpServletResponse response, 
                              User currentUser) throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String mobile = request.getParameter("mobile");
        String email = request.getParameter("email");
        
        // Update user object
        currentUser.setName(name);
        currentUser.setMobile(mobile);
        currentUser.setEmail(email);
        
        try {
            UserDAO userDAO = new UserDAO();
            boolean success = userDAO.updateUser(currentUser);
            
            if (success) {
                // Update session with new user data
                request.getSession().setAttribute("user", currentUser);
                request.setAttribute("success", "Profile updated successfully!");
            } else {
                request.setAttribute("error", "Failed to update profile. Please try again.");
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        }
        
        request.getRequestDispatcher("user-profile.jsp").forward(request, response);
    }
    
    private void changePassword(HttpServletRequest request, HttpServletResponse response, 
                               User currentUser) throws ServletException, IOException {
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        
        // Verify current password
        if (!currentPassword.equals(currentUser.getPassword())) {
            request.setAttribute("error", "Current password is incorrect");
            request.getRequestDispatcher("user-profile.jsp").forward(request, response);
            return;
        }
        
        try {
            UserDAO userDAO = new UserDAO();
            boolean success = userDAO.updatePassword(currentUser.getId(), newPassword);
            
            if (success) {
                // Update user object and session
                currentUser.setPassword(newPassword);
                request.getSession().setAttribute("user", currentUser);
                request.setAttribute("success", "Password changed successfully!");
            } else {
                request.setAttribute("error", "Failed to change password. Please try again.");
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
        }
        
        request.getRequestDispatcher("user-profile.jsp").forward(request, response);
    }
}

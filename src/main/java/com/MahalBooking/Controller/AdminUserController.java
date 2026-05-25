package com.MahalBooking.Controller;

import com.MahalBooking.DAO.AdminDAO;
import com.MahalBooking.Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/AdminUserController")
public class AdminUserController extends HttpServlet {
    private AdminDAO adminDAO;
    
    @Override
    public void init() {
        adminDAO = new AdminDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.sendRedirect("admin-login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if (action == null) {
                listUsers(request, response);
            } else if ("view".equals(action)) {
                viewUser(request, response);
            } else if ("toggleStatus".equals(action)) {
                toggleUserStatus(request, response);
            }
        } catch (SQLException | ServletException | IOException e) {
            throw new ServletException(e);
        }
    }
    
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        List<User> userList = adminDAO.getAllUsers();
        request.setAttribute("userList", userList);
        request.getRequestDispatcher("/admin-users.jsp").forward(request, response);
    }
    
    private void viewUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        
        int userId = Integer.parseInt(request.getParameter("id"));
        User user = adminDAO.getUserById(userId);
        
        if (user != null) {
            request.setAttribute("user", user);
            request.getRequestDispatcher("/admin-user-details.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "User not found");
            request.getRequestDispatcher("/AdminUserController").forward(request, response);
        }
    }
    
    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        int userId = Integer.parseInt(request.getParameter("id"));
        boolean newStatus = !Boolean.parseBoolean(request.getParameter("currentStatus"));
        
        adminDAO.updateUserStatus(userId, newStatus);
        response.sendRedirect("AdminUserController");
    }
}

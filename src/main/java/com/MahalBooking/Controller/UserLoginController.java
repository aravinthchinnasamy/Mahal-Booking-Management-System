package com.MahalBooking.Controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import com.MahalBooking.DAO.UserDAO;
import com.MahalBooking.DAO.VenueDAO;
import com.MahalBooking.Model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UserLoginController")
public class UserLoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private VenueDAO venueDAO;
    
    @Override
    public void init() throws ServletException {
        venueDAO = new VenueDAO();
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.authenticateUser(email, password);
            
            if (user != null) {
            	List venues = venueDAO.getAllVenues();
            	 for(Object ob:venues) {
            		 System.out.println("////"+ob);
                     
                 }
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                request.setAttribute("venues", venues);
               
                session.setAttribute("userId", user.getId());
                session.setAttribute("userName", user.getName());
               // response.sendRedirect("user-dashboard.jsp");
                request.getRequestDispatcher("user-dashboard.jsp").forward(request, response);

            } else {
                request.setAttribute("error", "Invalid email or password");
                request.getRequestDispatcher("user-login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("user-login.jsp").forward(request, response);
        }
    }
}

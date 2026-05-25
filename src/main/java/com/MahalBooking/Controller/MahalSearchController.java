package com.MahalBooking.Controller;

import com.MahalBooking.DAO.VenueDAO;
import com.MahalBooking.Model.Venue;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/MahalSearchController")
public class MahalSearchController extends HttpServlet {
    private VenueDAO venueDAO;
    
    @Override
    public void init() throws ServletException {
        venueDAO = new VenueDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect("user-login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("view".equals(action)) {
            try {
                int venueId = Integer.parseInt(request.getParameter("id"));
                Venue venue = venueDAO.getVenueById(venueId);
                
                if (venue != null && venue.isActive()) {
                    request.setAttribute("venue", venue);
                    request.getRequestDispatcher("/user-venue-details.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Venue not found or not available");
                    response.sendRedirect("UserVenueController");
                }
            } catch (NumberFormatException | SQLException e) {
                request.setAttribute("error", "Error retrieving venue details");
                response.sendRedirect("UserVenueController");
            }
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}

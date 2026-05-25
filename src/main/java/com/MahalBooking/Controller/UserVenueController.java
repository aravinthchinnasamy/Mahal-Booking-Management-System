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
import java.util.List;

@WebServlet("/UserVenueController")
public class UserVenueController extends HttpServlet {
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
        
        try {
            List<Venue> venues = venueDAO.getAllVenues();
            if (venues == null || venues.isEmpty()) {
                request.setAttribute("message", "No venues available");
            } else {
                request.setAttribute("venues", venues);
            }
            request.getRequestDispatcher("/user-dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Error retrieving venues: " + e.getMessage());
            request.getRequestDispatcher("/user-dashboard.jsp").forward(request, response);
        }
    }
    
}

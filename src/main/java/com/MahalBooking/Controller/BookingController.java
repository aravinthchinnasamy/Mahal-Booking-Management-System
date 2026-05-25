package com.MahalBooking.Controller;

import com.MahalBooking.DAO.BookingDAO;
import com.MahalBooking.DAO.VenueDAO;
import com.MahalBooking.Model.Booking;
import com.MahalBooking.Model.User;
import com.MahalBooking.Model.Venue;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/BookingController")
public class BookingController extends HttpServlet {
    private BookingDAO bookingDAO;
    private VenueDAO venueDAO;
    
    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        venueDAO = new VenueDAO();
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("user-login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        String filter = request.getParameter("filter");
        
        try {
            if (action == null) {
                // Show booking form
                String venueId = request.getParameter("venueId");
                if (venueId != null) {
                    Venue venue = venueDAO.getVenueById(Integer.parseInt(venueId));
                    if (venue != null && venue.isActive()) {
                        request.setAttribute("venue", venue);
                        request.getRequestDispatcher("/booking-form.jsp").forward(request, response);
                    } else {
                        request.setAttribute("error", "Venue not available for booking");
                        response.sendRedirect("UserVenueController");
                    }
                } else {
                    // Show all bookings with filter options
                    List<Booking> bookings = bookingDAO.getUserBookingsWithVenueDetails(user.getId(), filter);
                    request.setAttribute("bookings", bookings);
                    request.setAttribute("currentFilter", filter != null ? filter : "all");
                    request.getRequestDispatcher("/my-bookings.jsp").forward(request, response);
                }
            } else if ("confirmed".equals(action)) {
                // Show confirmed bookings
                List<Booking> bookings = bookingDAO.getConfirmedBookings(user.getId());
                request.setAttribute("bookings", bookings);
                request.getRequestDispatcher("/confirmed-bookings.jsp").forward(request, response);
            } else if ("view".equals(action)) {
                // View booking details
                int bookingId = Integer.parseInt(request.getParameter("id"));
                Booking booking = bookingDAO.getBookingWithVenueDetails(bookingId);
                
                if (booking != null && booking.getUserId() == user.getId()) {
                    request.setAttribute("booking", booking);
                    request.getRequestDispatcher("/booking-details.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Booking not found");
                    response.sendRedirect("BookingController");
                }
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/user-dashboard.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("user-login.jsp");
            return;
        }
        
        try {
            int venueId = Integer.parseInt(request.getParameter("venueId"));
            Date fromDate = parseDate(request.getParameter("fromDate"));
            Date toDate = parseDate(request.getParameter("toDate"));
            
            // Validate dates
            if (fromDate.after(toDate)) {
                request.setAttribute("error", "End date must be after start date");
                Venue venue = venueDAO.getVenueById(venueId);
                request.setAttribute("venue", venue);
                request.getRequestDispatcher("/booking-form.jsp").forward(request, response);
                return;
            }
            
            // Check venue availability
            if (!bookingDAO.isVenueAvailable(venueId, fromDate, toDate)) {
                request.setAttribute("error", "Venue is not available for selected dates");
                Venue venue = venueDAO.getVenueById(venueId);
                request.setAttribute("venue", venue);
                request.getRequestDispatcher("/booking-form.jsp").forward(request, response);
                return;
            }
            
            // Get venue price
            Venue venue = venueDAO.getVenueById(venueId);
            if (venue == null) {
                request.setAttribute("error", "Venue not found");
                response.sendRedirect("UserVenueController");
                return;
            }
            
            // Calculate total amount
            long duration = toDate.getTime() - fromDate.getTime();
            int days = (int) (duration / (1000 * 60 * 60 * 24)) + 1;
            double totalAmount = days * venue.getPrice();
            
            // Create booking
            Booking booking = new Booking();
            booking.setUserId(user.getId());
            booking.setVenueId(venueId);
            booking.setFromDate(fromDate);
            booking.setToDate(toDate);
            booking.setTotalAmount(totalAmount);
            booking.setStatus("pending");
            booking.setPaymentStatus("pending");
            
            if (bookingDAO.createBooking(booking)) {
                request.setAttribute("success", "Booking request submitted successfully! It will be confirmed after admin approval.");
                response.sendRedirect("BookingController");
            } else {
                request.setAttribute("error", "Failed to create booking. Please try again.");
                request.setAttribute("venue", venue);
                request.getRequestDispatcher("/booking-form.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/user-dashboard.jsp").forward(request, response);
        } catch (ParseException e) {
            request.setAttribute("error", "Invalid date format");
            request.getRequestDispatcher("/booking-form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid venue ID");
            response.sendRedirect("UserVenueController");
        }
    }
    
    private Date parseDate(String dateString) throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        java.util.Date date = sdf.parse(dateString);
        return new Date(date.getTime());
    }
    
}

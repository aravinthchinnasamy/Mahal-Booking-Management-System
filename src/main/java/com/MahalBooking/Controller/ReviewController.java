package com.MahalBooking.Controller;

import com.MahalBooking.DAO.BookingDAO;
import com.MahalBooking.DAO.ReviewDAO;
import com.MahalBooking.DAO.VenueDAO;
import com.MahalBooking.Model.Review;
import com.MahalBooking.Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/ReviewController")
public class ReviewController extends HttpServlet {
    private ReviewDAO reviewDAO;
    private BookingDAO bookingDAO;
    private VenueDAO venueDAO;
    private static final Logger logger = Logger.getLogger(ReviewController.class.getName());
    
    @Override
    public void init() throws ServletException {
        reviewDAO = new ReviewDAO();
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
        
        try {
            if ("view".equals(action)) {
                // View reviews for a venue
                int venueId = Integer.parseInt(request.getParameter("venueId"));
                request.setAttribute("reviews", reviewDAO.getReviewsByVenue(venueId));
                request.setAttribute("venueName", venueDAO.getVenueById(venueId).getName());
                request.getRequestDispatcher("/venue-reviews.jsp").forward(request, response);
            } else if ("form".equals(action)) {
                // Show review form
                int bookingId = Integer.parseInt(request.getParameter("bookingId"));
                int venueId = Integer.parseInt(request.getParameter("venueId"));
                
                // Check if booking is eligible for review
                if (!reviewDAO.isBookingEligibleForReview(bookingId)) {
                    request.setAttribute("error", "This booking is not eligible for review");
                    response.sendRedirect("BookingController?action=confirmed");
                    return;
                }
                
                // Check if user already submitted a review for this booking
                if (reviewDAO.hasUserReviewedBooking(user.getId(), bookingId)) {
                    request.setAttribute("error", "You have already submitted a review for this booking");
                    response.sendRedirect("BookingController?action=confirmed");
                    return;
                }
                
                request.setAttribute("bookingId", bookingId);
                request.setAttribute("venueId", venueId);
                request.getRequestDispatcher("/review-form.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error in ReviewController doGet", e);
            request.setAttribute("error", "Database error occurred. Please try again.");
            response.sendRedirect("BookingController?action=confirmed");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in ReviewController doGet", e);
            request.setAttribute("error", "An error occurred. Please try again.");
            response.sendRedirect("BookingController?action=confirmed");
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

        String action = request.getParameter("action");
        
        try {
            if ("submit".equals(action)) {
                // Submit a new review
                Review review = new Review();
                review.setBookingId(Integer.parseInt(request.getParameter("bookingId")));
                review.setVenueId(Integer.parseInt(request.getParameter("venueId")));
                review.setUserId(user.getId());
                review.setRating(Integer.parseInt(request.getParameter("rating")));
                review.setComment(request.getParameter("comment"));
                
                boolean success = reviewDAO.submitReview(review);
                
                if (success) {
                    request.setAttribute("success", "Thank you for your review! It will be visible after moderation.");
                } else {
                    request.setAttribute("error", "Failed to submit review. Please try again.");
                }
                
                response.sendRedirect("BookingController?action=confirmed");
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error in ReviewController doPost", e);
            request.setAttribute("error", "Database error occurred. Please try again.");
            request.getRequestDispatcher("/review-form.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in ReviewController doPost", e);
            request.setAttribute("error", "An error occurred. Please try again.");
            request.getRequestDispatcher("/review-form.jsp").forward(request, response);
        }
    }
}

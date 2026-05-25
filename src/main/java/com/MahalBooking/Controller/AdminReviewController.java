package com.MahalBooking.Controller;

import com.MahalBooking.DAO.ReviewDAO;
import com.MahalBooking.Model.Admin;
import com.MahalBooking.Model.Review;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/AdminReviewController")
public class AdminReviewController extends HttpServlet {
    private ReviewDAO reviewDAO;
    private static final Logger logger = Logger.getLogger(AdminReviewController.class.getName());
    
    @Override
    public void init() throws ServletException {
        reviewDAO = new ReviewDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("admin");
        
        if (admin == null) {
            response.sendRedirect("admin-login.jsp");
            return;
        }

        try {
            List<Review> pendingReviews = reviewDAO.getPendingReviews();
            request.setAttribute("pendingReviews", pendingReviews);
            request.getRequestDispatcher("/admin-review.jsp").forward(request, response);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error in AdminReviewController doGet", e);
            request.setAttribute("error", "Database error occurred. Please try again.");
            request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("admin");
        
        if (admin == null) {
            response.sendRedirect("admin-login.jsp");
            return;
        }

        String action = request.getParameter("action");
        int reviewId = Integer.parseInt(request.getParameter("reviewId"));
        
        try {
            boolean success = false;
            String message = "";
            
            if ("approve".equals(action)) {
                success = reviewDAO.updateReviewStatus(reviewId, "approved");
                message = success ? "Review approved successfully" : "Failed to approve review";
            } else if ("reject".equals(action)) {
                success = reviewDAO.updateReviewStatus(reviewId, "rejected");
                message = success ? "Review rejected successfully" : "Failed to reject review";
            } else if ("delete".equals(action)) {
                success = reviewDAO.deleteReview(reviewId);
                message = success ? "Review deleted successfully" : "Failed to delete review";
            }
            
            request.setAttribute(success ? "success" : "error", message);
            response.sendRedirect("AdminReviewController");
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error in AdminReviewController doPost", e);
            request.setAttribute("error", "Database error occurred. Please try again.");
            request.getRequestDispatcher("/admin-review.jsp").forward(request, response);
        }
    }
}


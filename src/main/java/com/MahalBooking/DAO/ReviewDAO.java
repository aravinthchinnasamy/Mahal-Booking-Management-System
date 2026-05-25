//package com.MahalBooking.DAO;
//
//import com.MahalBooking.Model.Review;
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.logging.Level;
//import java.util.logging.Logger;
//
//public class ReviewDAO {
//    private static final Logger logger = Logger.getLogger(ReviewDAO.class.getName());
//
//    public boolean submitReview(Review review) throws SQLException {
//        String sql = "INSERT INTO reviews (booking_id, venue_id, user_id, rating, comment) " +
//                     "VALUES (?, ?, ?, ?, ?)";
//        
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement ps = con.prepareStatement(sql)) {
//            
//            ps.setInt(1, review.getBookingId());
//            ps.setInt(2, review.getVenueId());
//            ps.setInt(3, review.getUserId());
//            ps.setInt(4, review.getRating());
//            ps.setString(5, review.getComment());
//            
//            int affectedRows = ps.executeUpdate();
//            
//            if (affectedRows > 0) {
//                // Update booking to mark review as submitted
//                String updateSql = "UPDATE bookings SET review_submitted = TRUE WHERE id = ?";
//                try (PreparedStatement updatePs = con.prepareStatement(updateSql)) {
//                    updatePs.setInt(1, review.getBookingId());
//                    updatePs.executeUpdate();
//                }
//                return true;
//            }
//            return false;
//        }
//    }
//
//    public List<Review> getReviewsByVenue(int venueId) throws SQLException {
//        List<Review> reviews = new ArrayList<>();
//        String sql = "SELECT r.*, u.name as user_name, v.name as venue_name " +
//                     "FROM reviews r " +
//                     "JOIN users u ON r.user_id = u.id " +
//                     "JOIN venues v ON r.venue_id = v.id " +
//                     "WHERE r.venue_id = ? AND r.status = 'approved' " +
//                     "ORDER BY r.created_at DESC";
//        
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement ps = con.prepareStatement(sql)) {
//            
//            ps.setInt(1, venueId);
//            
//            try (ResultSet rs = ps.executeQuery()) {
//                while (rs.next()) {
//                    Review review = new Review();
//                    review.setId(rs.getInt("id"));
//                    review.setBookingId(rs.getInt("booking_id"));
//                    review.setVenueId(rs.getInt("venue_id"));
//                    review.setUserId(rs.getInt("user_id"));
//                    review.setUserName(rs.getString("user_name"));
//                    review.setVenueName(rs.getString("venue_name"));
//                    review.setRating(rs.getInt("rating"));
//                    review.setComment(rs.getString("comment"));
//                    review.setStatus(rs.getString("status"));
//                    review.setCreatedAt(rs.getTimestamp("created_at"));
//                    review.setUpdatedAt(rs.getTimestamp("updated_at"));
//                    
//                    reviews.add(review);
//                }
//            }
//        }
//        return reviews;
//    }
//
//    public List<Review> getPendingReviews() throws SQLException {
//        List<Review> reviews = new ArrayList<>();
//        String sql = "SELECT r.*, u.name as user_name, v.name as venue_name " +
//                     "FROM reviews r " +
//                     "JOIN users u ON r.user_id = u.id " +
//                     "JOIN venues v ON r.venue_id = v.id " +
//                     "WHERE r.status = 'pending' " +
//                     "ORDER BY r.created_at DESC";
//        
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement ps = con.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//            
//            while (rs.next()) {
//                Review review = new Review();
//                review.setId(rs.getInt("id"));
//                review.setBookingId(rs.getInt("booking_id"));
//                review.setVenueId(rs.getInt("venue_id"));
//                review.setUserId(rs.getInt("user_id"));
//                review.setUserName(rs.getString("user_name"));
//                review.setVenueName(rs.getString("venue_name"));
//                review.setRating(rs.getInt("rating"));
//                review.setComment(rs.getString("comment"));
//                review.setStatus(rs.getString("status"));
//                review.setCreatedAt(rs.getTimestamp("created_at"));
//                review.setUpdatedAt(rs.getTimestamp("updated_at"));
//                
//                reviews.add(review);
//            }
//        }
//        return reviews;
//    }
//
//    public boolean updateReviewStatus(int reviewId, String status) throws SQLException {
//        String sql = "UPDATE reviews SET status = ? WHERE id = ?";
//        
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement ps = con.prepareStatement(sql)) {
//            
//            ps.setString(1, status);
//            ps.setInt(2, reviewId);
//            
//            return ps.executeUpdate() > 0;
//        }
//    }
//
//    public boolean deleteReview(int reviewId) throws SQLException {
//        String sql = "DELETE FROM reviews WHERE id = ?";
//        
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement ps = con.prepareStatement(sql)) {
//            
//            ps.setInt(1, reviewId);
//            return ps.executeUpdate() > 0;
//        }
//    }
//
//    public boolean hasUserReviewedBooking(int userId, int bookingId) throws SQLException {
//        String sql = "SELECT COUNT(*) FROM reviews WHERE user_id = ? AND booking_id = ?";
//        
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement ps = con.prepareStatement(sql)) {
//            
//            ps.setInt(1, userId);
//            ps.setInt(2, bookingId);
//            
//            try (ResultSet rs = ps.executeQuery()) {
//                if (rs.next()) {
//                    return rs.getInt(1) > 0;
//                }
//            }
//        }
//        return false;
//    }
//
//    public boolean isBookingEligibleForReview(int bookingId) throws SQLException {
//        String sql = "SELECT COUNT(*) FROM bookings WHERE id = ? AND to_date < CURDATE() AND review_submitted = FALSE";
//        
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement ps = con.prepareStatement(sql)) {
//            
//            ps.setInt(1, bookingId);
//            
//            try (ResultSet rs = ps.executeQuery()) {
//                if (rs.next()) {
//                    return rs.getInt(1) > 0;
//                }
//            }
//        }
//        return false;
//    }
//}


package com.MahalBooking.DAO;

import com.MahalBooking.Model.Review;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ReviewDAO {
    private static final Logger logger = Logger.getLogger(ReviewDAO.class.getName());

    public boolean submitReview(Review review) throws SQLException {
        String sql = "INSERT INTO reviews (booking_id, venue_id, user_id, rating, comment) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, review.getBookingId());
            ps.setInt(2, review.getVenueId());
            ps.setInt(3, review.getUserId());
            ps.setInt(4, review.getRating());  // THIS IS THE CRITICAL LINE - Make sure rating is being set
            ps.setString(5, review.getComment());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                // Update booking to mark review as submitted
                String updateSql = "UPDATE bookings SET review_submitted = TRUE WHERE id = ?";
                try (PreparedStatement updatePs = con.prepareStatement(updateSql)) {
                    updatePs.setInt(1, review.getBookingId());
                    updatePs.executeUpdate();
                }
                return true;
            }
            return false;
        }
    }

    public List<Review> getReviewsByVenue(int venueId) throws SQLException {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.name as user_name, v.name as venue_name " +
                     "FROM reviews r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN venues v ON r.venue_id = v.id " +
                     "WHERE r.venue_id = ? AND r.status = 'approved' " +
                     "ORDER BY r.created_at DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, venueId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review review = new Review();
                    review.setId(rs.getInt("id"));
                    review.setBookingId(rs.getInt("booking_id"));
                    review.setVenueId(rs.getInt("venue_id"));
                    review.setUserId(rs.getInt("user_id"));
                    review.setUserName(rs.getString("user_name"));
                    review.setVenueName(rs.getString("venue_name"));
                    review.setRating(rs.getInt("rating")); // Make sure rating is being retrieved
                    review.setComment(rs.getString("comment"));
                    review.setStatus(rs.getString("status"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    review.setUpdatedAt(rs.getTimestamp("updated_at"));
                    
                    reviews.add(review);
                }
            }
        }
        return reviews;
    }

    public List<Review> getPendingReviews() throws SQLException {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.name as user_name, v.name as venue_name " +
                     "FROM reviews r " +
                     "JOIN users u ON r.user_id = u.id " +
                     "JOIN venues v ON r.venue_id = v.id " +
                     "WHERE r.status = 'pending' " +
                     "ORDER BY r.created_at DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Review review = new Review();
                review.setId(rs.getInt("id"));
                review.setBookingId(rs.getInt("booking_id"));
                review.setVenueId(rs.getInt("venue_id"));
                review.setUserId(rs.getInt("user_id"));
                review.setUserName(rs.getString("user_name"));
                review.setVenueName(rs.getString("venue_name"));
                review.setRating(rs.getInt("rating")); // Make sure rating is being retrieved
                review.setComment(rs.getString("comment"));
                review.setStatus(rs.getString("status"));
                review.setCreatedAt(rs.getTimestamp("created_at"));
                review.setUpdatedAt(rs.getTimestamp("updated_at"));
                
                reviews.add(review);
            }
        }
        return reviews;
    }

    public boolean updateReviewStatus(int reviewId, String status) throws SQLException {
        String sql = "UPDATE reviews SET status = ?, updated_at = NOW() WHERE id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, reviewId);
            
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteReview(int reviewId) throws SQLException {
        String sql = "DELETE FROM reviews WHERE id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, reviewId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean hasUserReviewedBooking(int userId, int bookingId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reviews WHERE user_id = ? AND booking_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setInt(2, bookingId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public boolean isBookingEligibleForReview(int bookingId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM bookings WHERE id = ? AND to_date < CURDATE() AND review_submitted = FALSE";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
}

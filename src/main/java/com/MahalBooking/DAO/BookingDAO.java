package com.MahalBooking.DAO;

import com.MahalBooking.Model.Booking;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BookingDAO {
    private static final Logger logger = Logger.getLogger(BookingDAO.class.getName());

    public boolean createBooking(Booking booking) throws SQLException {
        String sql = "INSERT INTO bookings (user_id, venue_id, from_date, to_date, total_amount, status, payment_status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, booking.getUserId());
            ps.setInt(2, booking.getVenueId());
            ps.setDate(3, booking.getFromDate());
            ps.setDate(4, booking.getToDate());
            ps.setDouble(5, booking.getTotalAmount());
            ps.setString(6, booking.getStatus());
            ps.setString(7, booking.getPaymentStatus());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows == 0) {
                return false;
            }
            
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int bookingId = generatedKeys.getInt(1);
                    return insertBookingDates(con, bookingId, booking.getVenueId(), 
                                            booking.getFromDate(), booking.getToDate());
                }
            }
            return false;
        }
    }
    
    private boolean insertBookingDates(Connection con, int bookingId, int venueId, 
                                     Date fromDate, Date toDate) throws SQLException {
        String sql = "INSERT INTO booking_dates (booking_id, venue_id, booked_date) VALUES (?, ?, ?)";
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            // Calculate all dates between fromDate and toDate
            java.util.Date start = new java.util.Date(fromDate.getTime());
            java.util.Date end = new java.util.Date(toDate.getTime());
            
            long duration = end.getTime() - start.getTime();
            int days = (int) (duration / (1000 * 60 * 60 * 24)) + 1;
            
            for (int i = 0; i < days; i++) {
                java.util.Date current = new java.util.Date(start.getTime() + (i * 24 * 60 * 60 * 1000));
                ps.setInt(1, bookingId);
                ps.setInt(2, venueId);
                ps.setDate(3, new Date(current.getTime()));
                ps.addBatch();
            }
            
            ps.executeBatch();
            return true;
        }
    }
    
    public boolean isVenueAvailable(int venueId, Date fromDate, Date toDate) throws SQLException {
        String sql = "SELECT COUNT(*) FROM booking_dates WHERE venue_id = ? AND booked_date BETWEEN ? AND ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, venueId);
            ps.setDate(2, fromDate);
            ps.setDate(3, toDate);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        }
        return false;
    }
    
    public List<Booking> getUserBookings(int userId, String filter) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE user_id = ?";
        
        // Add filter condition based on the parameter
        if (filter != null && !filter.isEmpty()) {
            switch (filter.toLowerCase()) {
                case "pending":
                    sql += " AND status = 'pending'";
                    break;
                case "confirmed":
                    sql += " AND status = 'confirmed'";
                    break;
                case "rejected":
                    sql += " AND status = 'rejected'";
                    break;
            }
        }
        
        sql += " ORDER BY from_date DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = new Booking();
                    booking.setId(rs.getInt("id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setVenueId(rs.getInt("venue_id"));
                    booking.setFromDate(rs.getDate("from_date"));
                    booking.setToDate(rs.getDate("to_date"));
                    booking.setTotalAmount(rs.getDouble("total_amount"));
                    booking.setStatus(rs.getString("status"));
                    booking.setPaymentStatus(rs.getString("payment_status"));
                    booking.setPaymentDate(rs.getTimestamp("payment_date"));
                    booking.setCreatedAt(rs.getTimestamp("created_at"));
                    bookings.add(booking);
                }
            }
        }
        return bookings;
    }
    
    public List<Booking> getAllPendingBookings() throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE status = 'pending' ORDER BY created_at DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setVenueId(rs.getInt("venue_id"));
                booking.setFromDate(rs.getDate("from_date"));
                booking.setToDate(rs.getDate("to_date"));
                booking.setTotalAmount(rs.getDouble("total_amount"));
                booking.setStatus(rs.getString("status"));
                booking.setPaymentStatus(rs.getString("payment_status"));
                booking.setCreatedAt(rs.getTimestamp("created_at"));
                bookings.add(booking);
            }
        }
        return bookings;
    }

    public List<Booking> getUserBookingsWithVenueDetails(int userId, String filter) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, v.name as venue_name, v.location as venue_location " +
                     "FROM bookings b " +
                     "JOIN venues v ON b.venue_id = v.id " +
                     "WHERE b.user_id = ?";
        
        // Add filter condition based on the parameter
        if (filter != null && !filter.isEmpty()) {
            switch (filter.toLowerCase()) {
                case "pending":
                    sql += " AND b.status = 'pending'";
                    break;
                case "confirmed":
                    sql += " AND b.status = 'confirmed'";
                    break;
                case "rejected":
                    sql += " AND b.status = 'rejected'";
                    break;
            }
        }
        
        sql += " ORDER BY b.from_date DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = new Booking();
                    booking.setId(rs.getInt("id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setVenueId(rs.getInt("venue_id"));
                    booking.setVenueName(rs.getString("venue_name"));
                    booking.setVenueLocation(rs.getString("venue_location"));
                    booking.setFromDate(rs.getDate("from_date"));
                    booking.setToDate(rs.getDate("to_date"));
                    booking.setTotalAmount(rs.getDouble("total_amount"));
                    booking.setStatus(rs.getString("status"));
                    booking.setPaymentStatus(rs.getString("payment_status"));
                    booking.setPaymentDate(rs.getTimestamp("payment_date"));
                    booking.setCreatedAt(rs.getTimestamp("created_at"));
                    bookings.add(booking);
                }
            }
        }
        return bookings;
    }

    public Booking getBookingWithVenueDetails(int bookingId) throws SQLException {
        String sql = "SELECT b.*, v.name as venue_name, v.location as venue_location " +
                     "FROM bookings b " +
                     "JOIN venues v ON b.venue_id = v.id " +
                     "WHERE b.id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Booking booking = new Booking();
                    booking.setId(rs.getInt("id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setVenueId(rs.getInt("venue_id"));
                    booking.setVenueName(rs.getString("venue_name"));
                    booking.setVenueLocation(rs.getString("venue_location"));
                    booking.setFromDate(rs.getDate("from_date"));
                    booking.setToDate(rs.getDate("to_date"));
                    booking.setTotalAmount(rs.getDouble("total_amount"));
                    booking.setStatus(rs.getString("status"));
                    booking.setPaymentStatus(rs.getString("payment_status"));
                    booking.setPaymentDate(rs.getTimestamp("payment_date"));
                    booking.setCreatedAt(rs.getTimestamp("created_at"));
                    return booking;
                }
            }
        }
        return null;
    }
    
    public boolean isBookingPaid(int bookingId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM bookings WHERE id = ? AND payment_status = 'paid'";
        
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

    public List<Booking> getAllBookingsWithVenueDetails(String filter) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, v.name as venue_name, v.location as venue_location, u.name as user_name " +
                     "FROM bookings b " +
                     "JOIN venues v ON b.venue_id = v.id " +
                     "JOIN users u ON b.user_id = u.id ";
        
        if (filter != null && !filter.isEmpty()) {
            switch (filter.toLowerCase()) {
                case "pending":
                    sql += "WHERE b.status = 'pending' ";
                    break;
                case "confirmed":
                    sql += "WHERE b.status = 'confirmed' ";
                    break;
                case "rejected":
                    sql += "WHERE b.status = 'rejected' ";
                    break;
            }
        }
        
        sql += "ORDER BY b.created_at DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setUserId(rs.getInt("user_id"));
                booking.setVenueId(rs.getInt("venue_id"));
                booking.setVenueName(rs.getString("venue_name"));
                booking.setVenueLocation(rs.getString("venue_location"));
                booking.setFromDate(rs.getDate("from_date"));
                booking.setToDate(rs.getDate("to_date"));
                booking.setTotalAmount(rs.getDouble("total_amount"));
                booking.setStatus(rs.getString("status"));
                booking.setPaymentStatus(rs.getString("payment_status"));
                booking.setPaymentDate(rs.getTimestamp("payment_date"));
                booking.setCreatedAt(rs.getTimestamp("created_at"));
                bookings.add(booking);
            }
        }
        return bookings;
    }

    public Booking getBookingDetailsForAdmin(int bookingId) throws SQLException {
        String sql = "SELECT b.*, v.name as venue_name, v.location as venue_location, u.name as user_name, " +
                     "u.email as user_email, u.mobile as user_mobile " +
                     "FROM bookings b " +
                     "JOIN venues v ON b.venue_id = v.id " +
                     "JOIN users u ON b.user_id = u.id " +
                     "WHERE b.id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Booking booking = new Booking();
                    booking.setId(rs.getInt("id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setVenueId(rs.getInt("venue_id"));
                    booking.setVenueName(rs.getString("venue_name"));
                    booking.setVenueLocation(rs.getString("venue_location"));
                    booking.setFromDate(rs.getDate("from_date"));
                    booking.setToDate(rs.getDate("to_date"));
                    booking.setTotalAmount(rs.getDouble("total_amount"));
                    booking.setStatus(rs.getString("status"));
                    booking.setPaymentStatus(rs.getString("payment_status"));
                    booking.setPaymentDate(rs.getTimestamp("payment_date"));
                    booking.setCreatedAt(rs.getTimestamp("created_at"));
                    return booking;
                }
            }
        }
        return null;
    }

    public boolean updateBookingStatus(int bookingId, String status) throws SQLException {
        String sql = "UPDATE bookings SET status = ? WHERE id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            
            return ps.executeUpdate() > 0;
        }
    }
    
    public boolean updatePaymentStatus(int bookingId, String paymentStatus) throws SQLException {
        String sql = "UPDATE bookings SET payment_status = ?, payment_date = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, paymentStatus);
            ps.setInt(2, bookingId);
            
            return ps.executeUpdate() > 0;
        }
    }
    
    public List<Booking> getConfirmedBookings(int userId) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, v.name as venue_name, v.location as venue_location " +
                     "FROM bookings b " +
                     "JOIN venues v ON b.venue_id = v.id " +
                     "WHERE b.user_id = ? AND b.status = 'confirmed' " +
                     "ORDER BY b.from_date DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = new Booking();
                    booking.setId(rs.getInt("id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setVenueId(rs.getInt("venue_id"));
                    booking.setVenueName(rs.getString("venue_name"));
                    booking.setVenueLocation(rs.getString("venue_location"));
                    booking.setFromDate(rs.getDate("from_date"));
                    booking.setToDate(rs.getDate("to_date"));
                    booking.setTotalAmount(rs.getDouble("total_amount"));
                    booking.setStatus(rs.getString("status"));
                    booking.setPaymentStatus(rs.getString("payment_status"));
                    booking.setPaymentDate(rs.getTimestamp("payment_date"));
                    booking.setCreatedAt(rs.getTimestamp("created_at"));
                    bookings.add(booking);
                }
            }
        }
        return bookings;
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

    // Update this method to include userName
    public Booking getAdminBookingWithDetails(int bookingId) throws SQLException {
        String sql = "SELECT b.*, v.name as venue_name, v.location as venue_location, u.name as user_name " +
                     "FROM bookings b " +
                     "JOIN venues v ON b.venue_id = v.id " +
                     "JOIN users u ON b.user_id = u.id " +
                     "WHERE b.id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Booking booking = new Booking();
                    booking.setId(rs.getInt("id"));
                    booking.setUserId(rs.getInt("user_id"));
                    booking.setVenueId(rs.getInt("venue_id"));
                    booking.setVenueName(rs.getString("venue_name"));
                    booking.setVenueLocation(rs.getString("venue_location"));
                    booking.setFromDate(rs.getDate("from_date"));
                    booking.setToDate(rs.getDate("to_date"));
                    booking.setTotalAmount(rs.getDouble("total_amount"));
                    booking.setStatus(rs.getString("status"));
                    booking.setPaymentStatus(rs.getString("payment_status"));
                    booking.setPaymentDate(rs.getTimestamp("payment_date"));
                    booking.setCreatedAt(rs.getTimestamp("created_at"));
                    booking.setUserName(rs.getString("user_name"));
                    return booking;
                }
            }
        }
        return null;
    }

    
}

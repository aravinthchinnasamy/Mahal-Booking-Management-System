package com.MahalBooking.DAO;

import com.MahalBooking.Model.Payment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    public boolean updatePaymentStatus(int paymentId, String status) throws SQLException {
        String sql = "UPDATE payments SET status = ?, payment_date = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, paymentId);
            
            return ps.executeUpdate() > 0;
        }
    }
    
//    public List<Payment> getAllPayments() throws SQLException {
//        List<Payment> payments = new ArrayList<>();
//        String sql = "SELECT p.*, pm.name as payment_method_name, u.name as user_name, v.name as venue_name " +
//                     "FROM payments p " +
//                     "JOIN payment_methods pm ON p.payment_method_id = pm.id " +
//                     "JOIN bookings b ON p.booking_id = b.i d " +
//                     "JOIN users u ON p.user_id = u.id " +
//                     "JOIN venues v ON b.venue_id = v.id " +
//                     "ORDER BY p.payment_date DESC";
//
//        try (Connection con = DBConnection.getConnection();
//             PreparedStatement ps = con.prepareStatement(sql);
//             ResultSet rs = ps.executeQuery()) {
//
//            while (rs.next()) {
//                Payment payment = new Payment();
//                payment.setId(rs.getInt("id"));
//                payment.setBookingId(rs.getInt("booking_id"));
//                payment.setUserId(rs.getInt("user_id"));
//                payment.setAmount(rs.getDouble("amount"));
//                payment.setPaymentMethodId(rs.getInt("payment_method_id"));
//                payment.setPaymentMethodName(rs.getString("payment_method_name"));
//                payment.setTransactionId(rs.getString("transaction_id"));
//                payment.setStatus(rs.getString("status"));
//                payment.setPaymentDate(rs.getTimestamp("payment_date"));
//                payment.setCreatedAt(rs.getTimestamp("created_at"));
//                payment.setUserName(rs.getString("user_name"));
//                payment.setVenueName(rs.getString("venue_name"));
//                
//                payments.add(payment);
//            }
//        }
//        return payments;
//    }
    public List<Payment> getAllPayments() throws SQLException {
        List<Payment> payments = new ArrayList<>();

        String sql =
            "SELECT p.*, pm.name AS payment_method_name, " +
            "u.name AS user_name, v.name AS venue_name " +
            "FROM payments p " +
            "JOIN payment_methods pm ON p.payment_method_id = pm.id " +
            "JOIN bookings b ON p.booking_id = b.id " +   // ✅ FIXED HERE
            "JOIN users u ON p.user_id = u.id " +
            "JOIN venues v ON b.venue_id = v.id " +
            "ORDER BY p.payment_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Payment payment = new Payment();

                payment.setId(rs.getInt("id"));
                payment.setBookingId(rs.getInt("booking_id"));
                payment.setUserId(rs.getInt("user_id"));
                payment.setAmount(rs.getDouble("amount"));
                payment.setPaymentMethodId(rs.getInt("payment_method_id"));
                payment.setPaymentMethodName(rs.getString("payment_method_name"));
                payment.setTransactionId(rs.getString("transaction_id"));
                payment.setStatus(rs.getString("status"));
                payment.setPaymentDate(rs.getTimestamp("payment_date"));
                payment.setCreatedAt(rs.getTimestamp("created_at"));
                payment.setUserName(rs.getString("user_name"));
                payment.setVenueName(rs.getString("venue_name"));

                payments.add(payment);
            }
        }

        return payments;
    }

    public List<Payment> getPaymentsByStatus(String status) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, pm.name as payment_method_name, u.name as user_name, v.name as venue_name " +
                     "FROM payments p " +
                     "JOIN payment_methods pm ON p.payment_method_id = pm.id " +
                     "JOIN bookings b ON p.booking_id = b.id " +
                     "JOIN users u ON p.user_id = u.id " +
                     "JOIN venues v ON b.venue_id = v.id " +
                     "WHERE p.status = ? " +
                     "ORDER BY p.payment_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Payment payment = new Payment();
                    payment.setId(rs.getInt("id"));
                    payment.setBookingId(rs.getInt("booking_id"));
                    payment.setUserId(rs.getInt("user_id"));
                    payment.setAmount(rs.getDouble("amount"));
                    payment.setPaymentMethodId(rs.getInt("payment_method_id"));
                    payment.setPaymentMethodName(rs.getString("payment_method_name"));
                    payment.setTransactionId(rs.getString("transaction_id"));
                    payment.setStatus(rs.getString("status"));
                    payment.setPaymentDate(rs.getTimestamp("payment_date"));
                    payment.setCreatedAt(rs.getTimestamp("created_at"));
                    payment.setUserName(rs.getString("user_name"));
                    payment.setVenueName(rs.getString("venue_name"));
                    
                    payments.add(payment);
                }
            }
        }
        return payments;
    }

    public Payment getPaymentById(int paymentId) throws SQLException {
        String sql = "SELECT p.*, pm.name as payment_method_name, u.name as user_name, v.name as venue_name " +
                     "FROM payments p " +
                     "JOIN payment_methods pm ON p.payment_method_id = pm.id " +
                     "JOIN bookings b ON p.booking_id = b.id " +
                     "JOIN users u ON p.user_id = u.id " +
                     "JOIN venues v ON b.venue_id = v.id " +
                     "WHERE p.id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, paymentId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Payment payment = new Payment();
                    payment.setId(rs.getInt("id"));
                    payment.setBookingId(rs.getInt("booking_id"));
                    payment.setUserId(rs.getInt("user_id"));
                    payment.setAmount(rs.getDouble("amount"));
                    payment.setPaymentMethodId(rs.getInt("payment_method_id"));
                    payment.setPaymentMethodName(rs.getString("payment_method_name"));
                    payment.setTransactionId(rs.getString("transaction_id"));
                    payment.setStatus(rs.getString("status"));
                    payment.setPaymentDate(rs.getTimestamp("payment_date"));
                    payment.setCreatedAt(rs.getTimestamp("created_at"));
                    payment.setUserName(rs.getString("user_name"));
                    payment.setVenueName(rs.getString("venue_name"));
                    
                    return payment;
                }
            }
        }
        return null;
    }
    
    public List<Payment> getPaymentsByUserId(int userId) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, pm.name as payment_method_name, v.name as venue_name " +
                     "FROM payments p " +
                     "JOIN payment_methods pm ON p.payment_method_id = pm.id " +
                     "JOIN bookings b ON p.booking_id = b.id " +
                     "JOIN venues v ON b.venue_id = v.id " +
                     "WHERE p.user_id = ? " +
                     "ORDER BY p.payment_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Payment payment = new Payment();
                    payment.setId(rs.getInt("id"));
                    payment.setBookingId(rs.getInt("booking_id"));
                    payment.setUserId(rs.getInt("user_id"));
                    payment.setAmount(rs.getDouble("amount"));
                    payment.setPaymentMethodId(rs.getInt("payment_method_id"));
                    payment.setPaymentMethodName(rs.getString("payment_method_name"));
                    payment.setTransactionId(rs.getString("transaction_id"));
                    payment.setStatus(rs.getString("status"));
                    payment.setPaymentDate(rs.getTimestamp("payment_date"));
                    payment.setCreatedAt(rs.getTimestamp("created_at"));
                    payment.setVenueName(rs.getString("venue_name"));
                    
                    payments.add(payment);
                }
            }
        }
        return payments;
    }
    public boolean createPayment(Payment payment) throws SQLException {
        String sql = "INSERT INTO payments (booking_id, user_id, amount, payment_method_id, transaction_id, status, payment_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, payment.getBookingId());
            ps.setInt(2, payment.getUserId());
            ps.setDouble(3, payment.getAmount());
            ps.setInt(4, payment.getPaymentMethodId());
            ps.setString(5, payment.getTransactionId());
            ps.setString(6, payment.getStatus());
            
            // Set payment date - use current time if not specified
            if (payment.getPaymentDate() != null) {
                ps.setTimestamp(7, payment.getPaymentDate());
            } else {
                ps.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
            }
            
            return ps.executeUpdate() > 0;
        }
    }

    public Payment getPaymentByBookingId(int bookingId) throws SQLException {
        String sql = "SELECT p.*, pm.name as payment_method_name FROM payments p " +
                     "JOIN payment_methods pm ON p.payment_method_id = pm.id " +
                     "WHERE p.booking_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Payment payment = new Payment();
                    payment.setId(rs.getInt("id"));
                    payment.setBookingId(rs.getInt("booking_id"));
                    payment.setUserId(rs.getInt("user_id"));
                    payment.setAmount(rs.getDouble("amount"));
                    payment.setPaymentMethodId(rs.getInt("payment_method_id"));
                    payment.setPaymentMethodName(rs.getString("payment_method_name"));
                    payment.setTransactionId(rs.getString("transaction_id"));
                    payment.setStatus(rs.getString("status"));
                    payment.setPaymentDate(rs.getTimestamp("payment_date"));
                    payment.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    return payment;
                }
            }
        }
        return null;
    }
    
}

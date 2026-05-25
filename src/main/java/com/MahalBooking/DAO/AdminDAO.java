package com.MahalBooking.DAO;
import com.MahalBooking.Model.Admin;
import com.MahalBooking.Model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class AdminDAO {

    /* ================= ADMIN LOGIN ================= */

    public Admin authenticateAdmin(String username, String password) {
        Admin admin = null;

        String sql = "SELECT * FROM admin WHERE username = ? AND password = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    admin = new Admin();
                    admin.setId(rs.getInt("id"));
                    admin.setUsername(rs.getString("username"));
                    admin.setEmail(rs.getString("email"));
                    admin.setFullName(rs.getString("full_name"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return admin;
    }

    /* ================= DASHBOARD STATISTICS ================= */

    public DashboardStats getDashboardStats() {
        DashboardStats stats = new DashboardStats();

        try (Connection con = DBConnection.getConnection()) {

            stats.setTotalUsers(
                    getCount(con, "SELECT COUNT(*) AS total FROM users"));

            stats.setTotalVenues(
                    getCount(con, "SELECT COUNT(*) AS total FROM venues"));

            stats.setTodaysBookings(
                    getCount(con, "SELECT COUNT(*) AS total FROM bookings WHERE DATE(booking_date) = CURDATE()"));

            stats.setPendingApprovals(
                    getCount(con, "SELECT COUNT(*) AS total FROM bookings WHERE status = 'pending'"));

            stats.setTotalRevenue(
                    getSum(con, "SELECT COALESCE(SUM(payment_amount),0) AS total FROM payments WHERE status = 'completed'"));

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return stats;
    }

    /* ================= HELPER METHODS ================= */

    private int getCount(Connection con, String sql) {
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            return rs.next() ? rs.getInt("total") : 0;

        } catch (SQLException e) {
            return 0;
        }
    }

    private double getSum(Connection con, String sql) {
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            return rs.next() ? rs.getDouble("total") : 0.0;

        } catch (SQLException e) {
            return 0.0;
        }
    }

    /* ================= USER MANAGEMENT ================= */

    // Get all users
    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();

        String sql = "SELECT * FROM users";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setMobile(rs.getString("mobile"));
                user.setEmail(rs.getString("email"));

                try {
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    user.setActive(rs.getBoolean("is_active"));
                } catch (Exception ignored) {}

                users.add(user);
            }
        }

        return users;
    }

    // Update user active / inactive
    public boolean updateUserStatus(int userId, boolean isActive) throws SQLException {
        String sql = "UPDATE users SET is_active = ? WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setBoolean(1, isActive);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;
        }
    }

    // Get single user by ID
    public User getUserById(int userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setMobile(rs.getString("mobile"));
                    user.setEmail(rs.getString("email"));

                    try {
                        user.setCreatedAt(rs.getTimestamp("created_at"));
                        user.setActive(rs.getBoolean("is_active"));
                    } catch (Exception ignored) {}

                    return user;
                }
            }
        }

        return null;
    }

    /* ================= INNER CLASS: DASHBOARD STATS ================= */

    public static class DashboardStats {

        private int totalUsers;
        private int totalVenues;
        private int todaysBookings;
        private int pendingApprovals;
        private double totalRevenue;

        public int getTotalUsers() {
            return totalUsers;
        }

        public void setTotalUsers(int totalUsers) {
            this.totalUsers = totalUsers;
        }

        public int getTotalVenues() {
            return totalVenues;
        }

        public void setTotalVenues(int totalVenues) {
            this.totalVenues = totalVenues;
        }

        public int getTodaysBookings() {
            return todaysBookings;
        }

        public void setTodaysBookings(int todaysBookings) {
            this.todaysBookings = todaysBookings;
        }

        public int getPendingApprovals() {
            return pendingApprovals;
        }

        public void setPendingApprovals(int pendingApprovals) {
            this.pendingApprovals = pendingApprovals;
        }

        public double getTotalRevenue() {
            return totalRevenue;
        }

        public void setTotalRevenue(double totalRevenue) {
            this.totalRevenue = totalRevenue;
        }
    }
    


    public Map<String, Integer> getUsersReport() throws SQLException {
        Map<String, Integer> report = new LinkedHashMap<>();
        String sql = "SELECT DATE_FORMAT(created_at, '%Y-%m') AS month, COUNT(*) AS count " +
                     "FROM users " +
                     "WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) " +
                     "GROUP BY DATE_FORMAT(created_at, '%Y-%m') " +
                     "ORDER BY month";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                report.put(rs.getString("month"), rs.getInt("count"));
            }
        }
        return report;
    }



}

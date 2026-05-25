package com.MahalBooking.DAO;

import com.MahalBooking.Model.Venue;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class VenueDAO {
    private static final Logger logger = Logger.getLogger(VenueDAO.class.getName());

    public List<Venue> getAllVenuesForAdmin() throws SQLException {
        List<Venue> venues = new ArrayList<>();
        String sql = "SELECT * FROM venues ORDER BY name";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Venue venue = extractVenueFromResultSet(rs, con);
                venues.add(venue);
            }
        }
        return venues;
    }

    public List<Venue> getAllVenues() throws SQLException {
        List<Venue> venues = new ArrayList<>();
        String sql = "SELECT * FROM venues WHERE is_active = TRUE ORDER BY name";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Venue venue = extractVenueFromResultSet(rs, con);
                venues.add(venue);
            }
        }
        return venues;
    }

    public Venue getVenueById(int venueId) throws SQLException {
        String sql = "SELECT * FROM venues WHERE id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, venueId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractVenueFromResultSet(rs, con);
                }
            }
        }
        return null;
    }

    private Venue extractVenueFromResultSet(ResultSet rs, Connection con) throws SQLException {

        Venue venue = new Venue();

        venue.setId(rs.getInt("id"));
        venue.setName(rs.getString("name"));
        venue.setLocation(rs.getString("location"));
        venue.setDescription(rs.getString("description"));
        venue.setCapacity(rs.getInt("capacity"));
        venue.setPrice(rs.getDouble("price"));
        venue.setAmenities(rs.getString("amenities"));
        venue.setActive(rs.getBoolean("is_active"));

        // VERY IMPORTANT
        List<byte[]> images = getVenueImages(con, venue.getId());
        venue.setImages(images != null ? images : new ArrayList<>());

        return venue;
    }



//    private List<String> getVenueImages(Connection con, int venueId) throws SQLException {
//        List<String> images = new ArrayList<>();
//        String sql = "SELECT image_url FROM venue_images WHERE venue_id = ? ORDER BY is_primary DESC";
//        
//        try (PreparedStatement ps = con.prepareStatement(sql)) {
//            ps.setInt(1, venueId);
//            
//            try (ResultSet rs = ps.executeQuery()) {
//                System.out.println("Fetching images for venue ID: " + venueId); // Debug
//                while (rs.next()) {
//                    String imageUrl = rs.getString("image_url");
//                    System.out.println("Found image: " + imageUrl); // Debug
//                    images.add(imageUrl);
//                }
//                System.out.println("Total images found: " + images.size()); // Debug
//            }
//        }
//        return images;
//    }

    private List<byte[]> getVenueImages(Connection con, int venueId) throws SQLException {
        List<byte[]> images = new ArrayList<>();
        String sql = "SELECT image_data FROM venue_images WHERE venue_id = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, venueId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    images.add(rs.getBytes("image_data"));
                }
            }
        }

        return images;
    }


    public boolean addVenue(Venue venue) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet generatedKeys = null;
        
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Start transaction
            
            String sql = "INSERT INTO venues (name, location, description, capacity, price, amenities) " +
                         "VALUES (?, ?, ?, ?, ?, ?)";
            
            ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            ps.setString(1, venue.getName());
            ps.setString(2, venue.getLocation());
            ps.setString(3, venue.getDescription());
            ps.setInt(4, venue.getCapacity());
            ps.setDouble(5, venue.getPrice());
            ps.setString(6, venue.getAmenities());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows == 0) {
                return false;
            }
            
            generatedKeys = ps.getGeneratedKeys();
            if (generatedKeys.next()) {
                int venueId = generatedKeys.getInt(1);
                boolean imagesInserted = insertVenueImages(con, venueId, venue.getImages());
                
                if (imagesInserted) {
                    con.commit();
                    return true;
                } else {
                    con.rollback();
                    return false;
                }
            }
            con.rollback();
            return false;
            
        } catch (SQLException e) {
            if (con != null) {
                con.rollback();
            }
            throw e;
        } finally {
            if (generatedKeys != null) generatedKeys.close();
            if (ps != null) ps.close();
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
    }

    public boolean updateVenue(Venue venue) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Start transaction
            
            String sql = "UPDATE venues SET name = ?, location = ?, description = ?, capacity = ?, " +
                         "price = ?, amenities = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
            
            ps = con.prepareStatement(sql);
            
            ps.setString(1, venue.getName());
            ps.setString(2, venue.getLocation());
            ps.setString(3, venue.getDescription());
            ps.setInt(4, venue.getCapacity());
            ps.setDouble(5, venue.getPrice());
            ps.setString(6, venue.getAmenities());
            ps.setInt(7, venue.getId());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                // Delete existing images and add new ones
                deleteVenueImages(con, venue.getId());
                boolean imagesInserted = false;
                
                if (venue.getImages() != null && !venue.getImages().isEmpty()) {
                    imagesInserted = insertVenueImages(con, venue.getId(), venue.getImages());
                } else {
                    imagesInserted = true;
                }
                
                if (imagesInserted) {
                    con.commit();
                    return true;
                } else {
                    con.rollback();
                    return false;
                }
            }
            con.rollback();
            return false;
            
        } catch (SQLException e) {
            if (con != null) {
                con.rollback();
            }
            throw e;
        } finally {
            if (ps != null) ps.close();
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
    }

    private boolean insertVenueImages(Connection con, int venueId, List<byte[]> images)
 throws SQLException {
        if (images == null || images.isEmpty()) {
            return true;
        }
        
        String sql = "INSERT INTO venue_images (venue_id, image_data, is_primary) VALUES (?, ?, ?)";

        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < images.size(); i++) {
                byte[] imageUrl = images.get(i);
                // REMOVED URL LENGTH CHECK - ACCEPT ANY LENGTH

                
                ps.setInt(1, venueId);
                ps.setBytes(2, images.get(i));
                ps.setBoolean(3, i == 0); // First image is primary
                ps.addBatch();
            }
            
            ps.executeBatch();
            return true;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error inserting venue images", e);
            throw e;
        }
    }

    private void deleteVenueImages(Connection con, int venueId) throws SQLException {
        String sql = "DELETE FROM venue_images WHERE venue_id = ?";
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, venueId);
            ps.executeUpdate();
        }
    }

    public boolean updateVenueStatus(int venueId, boolean isActive) throws SQLException {
        String sql = "UPDATE venues SET is_active = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setBoolean(1, isActive);
            ps.setInt(2, venueId);
            
            return ps.executeUpdate() > 0;
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
    
    
    private boolean hasBookings(Connection con, int venueId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM bookings WHERE venue_id = ?";
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, venueId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            // If bookings table doesn't exist, assume no bookings
            logger.log(Level.INFO, "Bookings table may not exist: " + e.getMessage());
            return false;
        }
        return false;
    }
    
    public boolean deleteVenue(int venueId) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        boolean success = false;
        
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Start transaction
            
            logger.log(Level.INFO, "Starting delete process for venue ID: " + venueId);
            
            // First, try to delete related records in transaction
            // 1. Delete venue images
            String deleteImagesSql = "DELETE FROM venue_images WHERE venue_id = ?";
            ps = con.prepareStatement(deleteImagesSql);
            ps.setInt(1, venueId);
            ps.executeUpdate();
            ps.close();
            
            // 2. Delete venue (this will fail if foreign key constraints exist)
            String deleteVenueSql = "DELETE FROM venues WHERE id = ?";
            ps = con.prepareStatement(deleteVenueSql);
            ps.setInt(1, venueId);
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                con.commit();
                success = true;
                logger.log(Level.INFO, "Successfully deleted venue ID: " + venueId);
            } else {
                con.rollback();
                logger.log(Level.WARNING, "No venue found with ID: " + venueId);
                success = false;
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error deleting venue with ID " + venueId, e);
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException rollbackEx) {
                    logger.log(Level.SEVERE, "Error rolling back transaction", rollbackEx);
                }
            }
            throw e;
        } finally {
            if (ps != null) {
                try {
                    ps.close();
                } catch (SQLException e) {
                    logger.log(Level.WARNING, "Error closing PreparedStatement", e);
                }
            }
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    logger.log(Level.WARNING, "Error closing connection", e);
                }
            }
        }
        return success;
    }
    
    // Alternative method if you prefer to disable foreign key checks temporarily
    public boolean deleteVenueWithForeignKeyDisable(int venueId) throws SQLException {
        Connection con = null;
        PreparedStatement ps = null;
        Statement st = null;
        boolean success = false;
        
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            
            st = con.createStatement();
            // Disable foreign key checks
            st.execute("SET FOREIGN_KEY_CHECKS=0");
            
            // Delete venue
            String sql = "DELETE FROM venues WHERE id = ?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, venueId);
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                // Re-enable foreign key checks
                st.execute("SET FOREIGN_KEY_CHECKS=1");
                con.commit();
                success = true;
                logger.log(Level.INFO, "Successfully deleted venue ID: " + venueId);
            } else {
                st.execute("SET FOREIGN_KEY_CHECKS=1");
                con.rollback();
                success = false;
            }
            
        } catch (SQLException e) {
            if (con != null) {
                con.rollback();
            }
            throw e;
        } finally {
            if (ps != null) ps.close();
            if (st != null) st.close();
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
        return success;
    }

}

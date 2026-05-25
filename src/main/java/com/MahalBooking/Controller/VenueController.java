package com.MahalBooking.Controller;

import com.MahalBooking.DAO.VenueDAO;
import com.MahalBooking.Model.Venue;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;


@MultipartConfig(
	    fileSizeThreshold = 1024 * 1024 * 2,
	    maxFileSize = 1024 * 1024 * 10,
	    maxRequestSize = 1024 * 1024 * 50
	)

@WebServlet("/VenueController")
public class VenueController extends HttpServlet {
    private VenueDAO venueDAO;
    private static final Logger logger = Logger.getLogger(VenueController.class.getName());
    
    @Override
    public void init() throws ServletException {
        venueDAO = new VenueDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.sendRedirect("admin-login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if (action == null) {
                listVenues(request, response);
            } else if ("view".equals(action)) {
                viewVenue(request, response);
            } else if ("add".equals(action)) {
                showAddForm(request, response);
            } else if ("edit".equals(action)) {
                showEditForm(request, response);
            } else if ("toggleStatus".equals(action)) {
                toggleVenueStatus(request, response);
            } else if ("delete".equals(action)) {
                deleteVenue(request, response);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in doGet", e);
            request.setAttribute("error", "Error processing request: " + e.getMessage());
            try {
                listVenues(request, response);
            } catch (Exception ex) {
                throw new ServletException("Could not process request", ex);
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.sendRedirect("admin-login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                addVenue(request, response);
            } else if ("update".equals(action)) {
                updateVenue(request, response);
            } else if ("delete".equals(action)) {
                // Handle delete via POST if needed
                deleteVenue(request, response);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error in doPost", e);
            request.setAttribute("error", "Error processing request: " + e.getMessage());
            
            try {
                if ("add".equals(action)) {
                    showAddForm(request, response);
                } else if ("update".equals(action)) {
                    // For update, we need to get the venue ID to show edit form
                    String id = request.getParameter("id");
                    if (id != null && !id.isEmpty()) {
                        request.setAttribute("id", id);
                        showEditFormWithoutException(request, response);
                    } else {
                        listVenues(request, response);
                    }
                } else {
                    listVenues(request, response);
                }
            } catch (Exception ex) {
                logger.log(Level.SEVERE, "Error showing form after error", ex);
                throw new ServletException("Could not show form after error", ex);
            }
        }
    }

    private void listVenues(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Venue> venues = venueDAO.getAllVenuesForAdmin();
            request.setAttribute("venues", venues);
            request.getRequestDispatcher("/admin-venues.jsp").forward(request, response);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error in listVenues", e);
            request.setAttribute("error", "Database error occurred while fetching venues.");
            request.getRequestDispatcher("/admin-venues.jsp").forward(request, response);
        }
    }

    private void viewVenue(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int venueId = Integer.parseInt(request.getParameter("id"));
            Venue venue = venueDAO.getVenueById(venueId);
            
            if (venue != null) {
                request.setAttribute("venue", venue);
                request.getRequestDispatcher("/admin-venue-details.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Venue not found");
                listVenues(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid venue ID");
            listVenues(request, response);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error in viewVenue", e);
            request.setAttribute("error", "Database error occurred while fetching venue details.");
            listVenues(request, response);
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin-add-venue.jsp").forward(request, response);
    }
  
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        try {
            int venueId = Integer.parseInt(request.getParameter("id"));
            Venue venue = venueDAO.getVenueById(venueId);
            
            if (venue != null) {
                System.out.println("Venue found: " + venue.getName()); // Debug
                System.out.println("Number of images: " + 
                    (venue.getImages() != null ? venue.getImages().size() : 0)); // Debug
                
                request.setAttribute("venue", venue);
                request.getRequestDispatcher("/admin-edit-venue.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Venue not found");
                listVenues(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid venue ID");
            listVenues(request, response);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error in showEditForm", e);
            request.setAttribute("error", "Database error occurred while fetching venue details.");
            listVenues(request, response);
        }
    }

    // Helper method for error handling without throwing SQLException
    private void showEditFormWithoutException(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String id = request.getParameter("id");
        if (id == null) {
            id = (String) request.getAttribute("id");
        }
        
        if (id != null) {
            try {
                int venueId = Integer.parseInt(id);
                Venue venue = venueDAO.getVenueById(venueId);
                
                if (venue != null) {
                    request.setAttribute("venue", venue);
                } else {
                    request.setAttribute("error", "Venue not found");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid venue ID");
            } catch (SQLException e) {
                logger.log(Level.SEVERE, "Database error in showEditFormWithoutException", e);
                request.setAttribute("error", "Database error occurred while fetching venue details.");
            }
        }
        
        request.getRequestDispatcher("/admin-edit-venue.jsp").forward(request, response);
    }

    private void addVenue(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get and validate price
            String priceStr = request.getParameter("price");
            if (priceStr == null || priceStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Price is required");
            }
            
            double price = Double.parseDouble(priceStr);
            if (price <= 0) {
                throw new IllegalArgumentException("Price must be greater than 0");
            }
            
            if (price > 99999999.99) {
                throw new IllegalArgumentException("Price is too large");
            }
            
            // Get and validate capacity
            String capacityStr = request.getParameter("capacity");
            if (capacityStr == null || capacityStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Capacity is required");
            }
            
            int capacity = Integer.parseInt(capacityStr);
            if (capacity <= 0) {
                throw new IllegalArgumentException("Capacity must be greater than 0");
            }
            
            // Get other parameters
            String name = request.getParameter("name");
            String location = request.getParameter("location");
            String description = request.getParameter("description");
            String amenities = request.getParameter("amenities");
            
            // Validate required fields
            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Venue name is required");
            }
            if (location == null || location.trim().isEmpty()) {
                throw new IllegalArgumentException("Location is required");
            }
            if (description == null || description.trim().isEmpty()) {
                throw new IllegalArgumentException("Description is required");
            }
            
            // Create venue object
            Venue venue = new Venue();
            venue.setName(name.trim());
            venue.setLocation(location.trim());
            venue.setDescription(description.trim());
            venue.setCapacity(capacity);
            venue.setPrice(price);
            venue.setAmenities(amenities != null ? amenities.trim() : "");
            
            // Get image URLs
         // Get uploaded images
            List<byte[]> images = new ArrayList<>();

            for (Part part : request.getParts()) {
                if ("images".equals(part.getName()) && part.getSize() > 0) {
                    byte[] imageBytes = part.getInputStream().readAllBytes();
                    images.add(imageBytes);
                }
            }

            if (images.isEmpty()) {
                request.setAttribute("error", "At least one image is required");
                request.getRequestDispatcher("/admin-add-venue.jsp").forward(request, response);
                return;
            }

            venue.setImages(images);

            
            // Add venue to database
            boolean success = venueDAO.addVenue(venue);
            
            if (success) {
                request.setAttribute("success", "Venue added successfully!");
                listVenues(request, response);
            } else {
                request.setAttribute("error", "Failed to add venue. Please try again.");
                request.getRequestDispatcher("/admin-add-venue.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format: " + e.getMessage());
            request.getRequestDispatcher("/admin-add-venue.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/admin-add-venue.jsp").forward(request, response);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error adding venue", e);
            request.setAttribute("error", "Database error occurred: " + e.getMessage());
            request.getRequestDispatcher("/admin-add-venue.jsp").forward(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error adding venue", e);
            request.setAttribute("error", "Error adding venue: " + e.getMessage());
            request.getRequestDispatcher("/admin-add-venue.jsp").forward(request, response);
        }
    }

    private void updateVenue(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get venue ID
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Venue ID is required");
            }
            int venueId = Integer.parseInt(idStr);
            
            // Get and validate price
            String priceStr = request.getParameter("price");
            if (priceStr == null || priceStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Price is required");
            }
            
            double price = Double.parseDouble(priceStr);
            if (price <= 0) {
                throw new IllegalArgumentException("Price must be greater than 0");
            }
            
            if (price > 99999999.99) {
                throw new IllegalArgumentException("Price is too large");
            }
            
            // Get and validate capacity
            String capacityStr = request.getParameter("capacity");
            if (capacityStr == null || capacityStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Capacity is required");
            }
            
            int capacity = Integer.parseInt(capacityStr);
            if (capacity <= 0) {
                throw new IllegalArgumentException("Capacity must be greater than 0");
            }
            
            // Get other parameters
            String name = request.getParameter("name");
            String location = request.getParameter("location");
            String description = request.getParameter("description");
            String amenities = request.getParameter("amenities");
            
            // Validate required fields
            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Venue name is required");
            }
            if (location == null || location.trim().isEmpty()) {
                throw new IllegalArgumentException("Location is required");
            }
            if (description == null || description.trim().isEmpty()) {
                throw new IllegalArgumentException("Description is required");
            }
            
            // Create venue object
            Venue venue = new Venue();
            venue.setId(venueId);
            venue.setName(name.trim());
            venue.setLocation(location.trim());
            venue.setDescription(description.trim());
            venue.setCapacity(capacity);
            venue.setPrice(price);
            venue.setAmenities(amenities != null ? amenities.trim() : "");
            
         // 1️⃣ Get existing images from DB
            Venue existingVenue = venueDAO.getVenueById(venueId);
            List<byte[]> updatedImages = new ArrayList<>(existingVenue.getImages());

            // 2️⃣ Remove selected images
            String[] removeIndexes = request.getParameterValues("removeImageIndex");

            if (removeIndexes != null) {

                List<Integer> indexes = new ArrayList<>();
                for (String index : removeIndexes) {
                    indexes.add(Integer.parseInt(index));
                }

                // IMPORTANT: reverse sort to prevent shifting
                indexes.sort((a, b) -> b - a);

                for (int index : indexes) {
                    if (index >= 0 && index < updatedImages.size()) {
                        updatedImages.remove(index);
                    }
                }
            }

            // 3️⃣ Add newly uploaded images
            for (Part part : request.getParts()) {
                if ("images".equals(part.getName()) && part.getSize() > 0) {
                    updatedImages.add(part.getInputStream().readAllBytes());
                }
            }

            // 4️⃣ Set final image list
            venue.setImages(updatedImages);



            
            // Update venue in database
            boolean success = venueDAO.updateVenue(venue);
            
            if (success) {
                request.setAttribute("success", "Venue updated successfully!");
                listVenues(request, response);
            } else {
                request.setAttribute("error", "Failed to update venue. Please try again.");
                request.setAttribute("id", venueId);
                showEditFormWithoutException(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format: " + e.getMessage());
            String id = request.getParameter("id");
            if (id != null) {
                request.setAttribute("id", id);
            }
            showEditFormWithoutException(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            String id = request.getParameter("id");
            if (id != null) {
                request.setAttribute("id", id);
            }
            showEditFormWithoutException(request, response);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error updating venue", e);
            request.setAttribute("error", "Database error occurred: " + e.getMessage());
            String id = request.getParameter("id");
            if (id != null) {
                request.setAttribute("id", id);
            }
            showEditFormWithoutException(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error updating venue", e);
            request.setAttribute("error", "Error updating venue: " + e.getMessage());
            String id = request.getParameter("id");
            if (id != null) {
                request.setAttribute("id", id);
            }
            showEditFormWithoutException(request, response);
        }
    }

    private void toggleVenueStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int venueId = Integer.parseInt(request.getParameter("id"));
            boolean currentStatus = Boolean.parseBoolean(request.getParameter("currentStatus"));
            boolean newStatus = !currentStatus;
            
            venueDAO.updateVenueStatus(venueId, newStatus);
            response.sendRedirect("VenueController");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid venue ID");
            listVenues(request, response);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error toggling venue status", e);
            request.setAttribute("error", "Database error occurred");
            listVenues(request, response);
        }
    }

    private void deleteVenue(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int venueId = Integer.parseInt(request.getParameter("id"));
            logger.log(Level.INFO, "Attempting to delete venue with ID: " + venueId);
            
            boolean success = venueDAO.deleteVenue(venueId);
            
            if (success) {
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Venue deleted successfully!");
                response.sendRedirect("VenueController");
            } else {
                request.setAttribute("error", "Failed to delete venue. The venue may not exist or may have active bookings.");
                listVenues(request, response);
            }
        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid venue ID format");
            request.setAttribute("error", "Invalid venue ID format");
            listVenues(request, response);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error deleting venue", e);
            
            String errorMessage;
            if (e.getMessage() != null && e.getMessage().contains("foreign key constraint")) {
                errorMessage = "Cannot delete venue because it has associated bookings. Please cancel bookings first.";
                // You can add logic here to show a specific error page or message
            } else {
                errorMessage = "Database error occurred: " + e.getMessage();
            }
            
            request.setAttribute("error", errorMessage);
            listVenues(request, response);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Unexpected error deleting venue", e);
            request.setAttribute("error", "Error deleting venue: " + e.getMessage());
            listVenues(request, response);
        }
    }
}

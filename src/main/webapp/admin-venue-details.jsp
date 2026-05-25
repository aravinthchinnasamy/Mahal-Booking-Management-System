<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.Venue" %>
<%@ page import="java.util.Base64" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Venue Details | Royal Mahal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #1e3a8a;
            --sidebar: #0f172a;
            --bg: #f5f7fb;
            --card: #ffffff;
            --text: #111827;
            --muted: #6b7280;
            --success: #22c55e;
            --danger: #ef4444;
            --warning: #f59e0b;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', sans-serif;
        }

        body {
            background: var(--bg);
            color: var(--text);
        }

        .container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: var(--sidebar);
            color: #fff;
            padding: 25px 0;
        }

        .sidebar-header {
            padding: 0 25px 25px;
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .sidebar-menu {
            list-style: none;
            padding-top: 20px;
        }

        .sidebar-menu li a {
            display: block;
            padding: 14px 25px;
            color: #d1d5db;
            text-decoration: none;
            transition: 0.3s;
        }

        .sidebar-menu li a i {
            margin-right: 10px;
        }

        .sidebar-menu li a:hover,
        .sidebar-menu li a.active {
            background: var(--primary);
            color: #fff;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 30px;
        }

        /* Header */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .header h1 {
            font-size: 26px;
        }

        .btn {
            padding: 10px 20px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 600;
            transition: 0.3s;
        }

        .btn-secondary {
            background: var(--muted);
        }

        .btn:hover {
            opacity: 0.9;
        }

        /* Venue Details */
        .venue-details {
            background: var(--card);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            max-width: 800px;
            margin: 0 auto;
        }

        .venue-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }

        .venue-title {
            font-size: 24px;
            color: var(--primary);
        }

        .venue-price {
            font-size: 20px;
            font-weight: 600;
            color: var(--success);
        }

        .venue-meta {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }

        .venue-meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--muted);
        }

        .venue-description {
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .venue-images {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }

        .venue-image {
            height: 150px;
            width: 100%;
            object-fit: cover;
            border-radius: 8px;
        }

        .venue-amenities {
            margin-bottom: 30px;
        }

        .amenities-list {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 15px;
        }

        .amenity-tag {
            background: var(--bg);
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 14px;
        }

        .status-active {
            color: var(--success);
            font-weight: 600;
        }

        .status-inactive {
            color: var(--danger);
            font-weight: 600;
        }

        .venue-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn-toggle {
            background: var(--warning);
            color: #111;
        }

        .btn-delete {
            background: var(--danger);
            color: white;
        }
    </style>
</head>
<body>
<div class="container">

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h2>Royal Mahal</h2>
            <p>Admin Panel</p>
        </div>

        <ul class="sidebar-menu">
            <li><a href="admin-dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a></li>
            <li><a href="AdminUserController"><i class="fas fa-users"></i> User Management</a></li>
            <li><a href="VenueController" class="active"><i class="fas fa-building"></i> Venue Management</a></li>
            <li><a href="AdminBookingController"><i class="fas fa-calendar"></i> Booking Management</a></li>
            <li><a href="AdminPaymentController"><i class="fas fa-money-bill"></i> Payments</a></li>
            <li><a href="AdminReviewController"><i class="fas fa-star"></i> Reviews</a></li>
            <li><a href="AdminLogoutController"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">

        <div class="header">
            <h1>Venue Details</h1>
            <a href="VenueController" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back
            </a>
        </div>

        <% 
            Venue venue = (Venue) request.getAttribute("venue");
            if (venue != null) {
        %>
        <div class="venue-details">
            <div class="venue-header">
                <h2 class="venue-title"><%= venue.getName() %></h2>
                <div class="venue-price">₹<%= String.format("%.2f", venue.getPrice()) %></div>
            </div>
            
            <div class="venue-meta">
                <div class="venue-meta-item">
                    <i class="fas fa-map-marker-alt"></i>
                    <span><%= venue.getLocation() %></span>
                </div>
                <div class="venue-meta-item">
                    <i class="fas fa-users"></i>
                    <span><%= venue.getCapacity() %> guests</span>
                </div>
                <div class="venue-meta-item">
                    <i class="fas fa-circle"></i>
                    <span class="<%= venue.isActive() ? "status-active" : "status-inactive" %>">
                        <%= venue.isActive() ? "Active" : "Inactive" %>
                    </span>
                </div>
            </div>
            
            <div class="venue-description">
                <p><%= venue.getDescription() %></p>
            </div>
            
        

<div class="venue-images">

<% 
    if (venue.getImages() != null && !venue.getImages().isEmpty()) { 
        for (byte[] img : venue.getImages()) {
            String base64 = Base64.getEncoder().encodeToString(img);
%>

    <img src="data:image/jpeg;base64,<%= base64 %>" 
         class="venue-image">

<% 
        }
    } else { 
%>

    <img src="https://via.placeholder.com/300x200?text=No+Image"
         class="venue-image">

<% } %>

</div>





            
            <div class="venue-amenities">
                <h3>Amenities</h3>
                <div class="amenities-list">
                    <% 
                        String[] amenities = venue.getAmenities().split(",");
                        for (String amenity : amenities) {
                    %>
                        <div class="amenity-tag"><%= amenity.trim() %></div>
                    <% } %>
                </div>
            </div>
            
            <div class="venue-actions">
                <a href="VenueController?action=toggleStatus&id=<%= venue.getId() %>&currentStatus=<%= venue.isActive() %>" 
                   class="btn btn-toggle">
                    <%= venue.isActive() ? "<i class='fas fa-ban'></i> Deactivate" : "<i class='fas fa-check'></i> Activate" %>
                </a>
                <a href="VenueController?action=delete&id=<%= venue.getId() %>" class="btn btn-delete"
                   onclick="return confirm('Are you sure you want to delete this venue?');">
                    <i class="fas fa-trash"></i> Delete
                </a>
            </div>
        </div>
        <% } else { %>
            <div style="text-align: center; padding: 50px;">
                <h2>Venue not found</h2>
                <a href="VenueController" class="btn" style="margin-top: 20px;">
                    <i class="fas fa-arrow-left"></i> Back to Venues
                </a>
            </div>
        <% } %>
    </div>
</div>
</body>
</html>

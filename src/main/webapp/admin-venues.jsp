<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.Venue" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Venue Management | Royal Mahal</title>
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

        .btn:hover {
            opacity: 0.9;
        }

        /* Alert Messages */
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 6px;
            font-weight: 500;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        /* Venue Grid */
        .venue-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
        }

        .venue-card {
            background: var(--card);
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: 0.3s;
        }

        .venue-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }

        .venue-image {
            height: 200px;
            width: 100%;
            object-fit: cover;
        }

        .venue-content {
            padding: 20px;
        }

        .venue-content h3 {
            margin-bottom: 10px;
            color: var(--primary);
        }

        .venue-meta {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            color: var(--muted);
            font-size: 14px;
        }

        .venue-price {
            font-weight: 600;
            color: var(--success);
        }

        .venue-status {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-active {
            background-color: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background-color: #f5c6cb;
            color: #721c24;
        }

        .venue-actions {
            display: flex;
            gap: 8px;
            margin-top: 15px;
            flex-wrap: wrap;
        }

        .btn-view {
            padding: 8px 12px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 14px;
            white-space: nowrap;
        }

        .btn-edit {
            padding: 8px 12px;
            background: var(--success);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 14px;
            white-space: nowrap;
        }

        .btn-toggle {
            padding: 8px 12px;
            background: var(--warning);
            color: #111;
            text-decoration: none;
            border-radius: 6px;
            font-size: 14px;
            white-space: nowrap;
        }

        .btn-delete {
            padding: 8px 12px;
            background: var(--danger);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 14px;
            white-space: nowrap;
            border: none;
            cursor: pointer;
        }

        .empty-state {
            text-align: center;
            padding: 50px;
            color: var(--muted);
        }

        .empty-state i {
            font-size: 50px;
            margin-bottom: 20px;
            color: var(--muted);
        }
    </style>
    <script>
        function confirmDelete(venueId, venueName) {
            return confirm('Are you sure you want to delete "' + venueName + '"? This action cannot be undone.');
        }
        
        // Check for success message from session
        <% 
            String successMessage = (String) session.getAttribute("successMessage");
            if (successMessage != null) {
        %>
            alert('<%= successMessage %>');
            <% session.removeAttribute("successMessage"); %>
        <% } %>
        
        function deleteVenue(id, name) {
            if (confirm('Are you sure you want to delete "' + name + '"? This action cannot be undone.')) {
                console.log('Attempting to delete venue ID:', id);
                return true;
            }
            return false;
        }
    </script>
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
            <h1>Venue Management</h1>
            <a href="VenueController?action=add" class="btn">
                <i class="fas fa-plus"></i> Add Venue
            </a>
        </div>

        <!-- Error Messages -->
        <%
            String error = (String) request.getAttribute("error");
            if (error != null && !error.isEmpty()) {
        %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> <%= error %>
            </div>
        <%
            }
        %>

        <!-- Success Messages -->
        <%
            String success = (String) request.getAttribute("success");
            if (success != null && !success.isEmpty()) {
        %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> <%= success %>
            </div>
        <%
            }
        %>

        <div class="venue-grid">
            <% 
                List<Venue> venues = (List<Venue>) request.getAttribute("venues");
                if (venues != null && !venues.isEmpty()) {
                    for (Venue venue : venues) {
            %>
            <div class="venue-card">
                <% if (venue != null && venue.getImages() != null && !venue.getImages().isEmpty()) { %>

    <img src="<%= request.getContextPath() %>/VenueImageServlet?id=<%= venue.getId() %>"
         alt="<%= venue.getName() %>"
         class="venue-image">

<% } else { %>


    <img src="https://via.placeholder.com/300x200?text=No+Image"
         class="venue-image">

<% } %>
                <div class="venue-content">
                    <h3><%= venue.getName() %></h3>
                    <div class="venue-meta">
                        <span><i class="fas fa-map-marker-alt"></i> <%= venue.getLocation() %></span>
                        <span class="venue-price">₹<%= String.format("%.2f", venue.getPrice()) %></span>
                    </div>
                    <div class="venue-meta">
                        <span><i class="fas fa-users"></i> <%= venue.getCapacity() %> guests</span>
                        <span class="venue-status <%= venue.isActive() ? "status-active" : "status-inactive" %>">
                            <%= venue.isActive() ? "Active" : "Inactive" %>
                        </span>
                    </div>
                    
                    <div class="venue-actions">
                        <a href="VenueController?action=view&id=<%= venue.getId() %>" class="btn-view">
                            <i class="fas fa-eye"></i> View
                        </a>
                        <a href="VenueController?action=edit&id=<%= venue.getId() %>" class="btn-edit">
                            <i class="fas fa-edit"></i> Edit
                        </a>
                        <a href="VenueController?action=toggleStatus&id=<%= venue.getId() %>&currentStatus=<%= venue.isActive() %>" 
                           class="btn-toggle">
                            <%= venue.isActive() ? "<i class='fas fa-ban'></i> Deactivate" : "<i class='fas fa-check'></i> Activate" %>
                        </a>
                        <a href="VenueController?action=delete&id=<%= venue.getId() %>" 
                           class="btn-delete"
                           onclick="return confirmDelete(<%= venue.getId() %>, '<%= venue.getName().replace("'", "\\'") %>')">
                            <i class="fas fa-trash"></i> Delete
                        </a>
                    </div>
                </div>
            </div>
            <% 
                    }
                } else { 
            %>
            <div class="empty-state">
                <i class="fas fa-building"></i>
                <h2>No Venues Found</h2>
                <p>There are no venues available. Add a new venue to get started.</p>
                <a href="VenueController?action=add" class="btn" style="margin-top: 20px;">
                    <i class="fas fa-plus"></i> Add First Venue
                </a>
            </div>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>
 
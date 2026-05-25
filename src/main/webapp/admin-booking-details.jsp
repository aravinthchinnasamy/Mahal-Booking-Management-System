<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.Booking" %>
<%@ page import="com.MahalBooking.Model.Admin" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    Booking booking = (Booking) request.getAttribute("booking");
    Admin admin = (Admin) session.getAttribute("admin");
    
    if (booking == null || admin == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking Details | Royal Mahal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #1e3a8a;
            --secondary: #3b82f6;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --dark: #111827;
            --light: #f9fafb;
            --card: #ffffff;
            --gray: #6b7280;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: var(--light);
            color: var(--dark);
        }

        .container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: var(--dark);
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
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 25px;
            color: #d1d5db;
            text-decoration: none;
            transition: 0.3s;
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

        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
        }

        .booking-details {
            background: var(--card);
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            max-width: 800px;
            margin: 0 auto;
        }

        .booking-header {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }

        .booking-header h1 {
            color: var(--primary);
            margin-bottom: 10px;
        }

        .booking-status {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-confirmed {
            background: #d1fae5;
            color: #065f46;
        }

        .status-rejected {
            background: #fee2e2;
            color: #991b1b;
        }

        .payment-status {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .status-paid {
            background: #d1fae5;
            color: #065f46;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .booking-meta {
            margin-bottom: 20px;
        }

        .meta-row {
            display: flex;
            margin-bottom: 10px;
        }

        .meta-label {
            width: 150px;
            font-weight: 600;
            color: var(--gray);
        }

        .meta-value {
            flex: 1;
        }

        .booking-amount {
            font-size: 20px;
            font-weight: bold;
            color: var(--primary);
            margin: 20px 0;
        }

        .action-buttons {
            margin-top: 30px;
            display: flex;
            gap: 15px;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-secondary {
            background: var(--gray);
            color: white;
        }

        .btn-success {
            background: var(--success);
            color: white;
        }

        .btn-danger {
            background: var(--danger);
            color: white;
        }

        .btn:hover {
            opacity: 0.9;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Sidebar -->
<!--     <div class="sidebar">
        <div class="sidebar-header">
            <h2>Royal Mahal</h2>
            <p>Admin Panel</p>
        </div>
        <ul class="sidebar-menu">
            <li><a href="admin-dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a></li>
            <li><a href="AdminUserController"><i class="fas fa-users"></i> User Management</a></li>
            <li><a href="VenueController"><i class="fas fa-building"></i> Venue Management</a></li>
            <li><a href="AdminBookingController" class="active"><i class="fas fa-calendar-alt"></i> Booking Management</a></li>
            <li><a href="AdminLogoutController"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div> -->
    <div class="sidebar">
    <div class="sidebar-header">
        <h2>Royal Mahal</h2>
        <p>Admin Panel</p>
    </div>

    <ul class="sidebar-menu">
        <li><a href="admin-dashboard.jsp" class="active"><i class="fas fa-home"></i> Dashboard</a></li>
        <li><a href="AdminUserController"><i class="fas fa-users"></i> User Management</a></li>
        <li><a href="VenueController"><i class="fas fa-building"></i> Venue Management</a></li>
        <!-- <li><a href="AdminBookingController"><i class="fas fa-calendar-alt"></i> Booking Management</a></li> -->
        <li><a href="AdminBookingController" class="active"><i class="fas fa-calendar"></i> Booking Management</a></li>
        
        <li><a href="AdminPaymentController"><i class="fas fa-money-bill-wave"></i> Payment Management</a></li>
      <!--   <li><a href="#"><i class="fas fa-star"></i> Reviews & Ratings</a></li> -->
        <li><a href="AdminReviewController"><i class="fas fa-star"></i> Review Moderation</a></li>
       <!--  <li><a href="admin-reports"><i class="fas fa-chart-line"></i> Reports & Analytics</a></li> -->
       <!--  <li><a href="#"><i class="fas fa-cog"></i> Settings</a></li> -->
        <li><a href="AdminLogoutController"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</div>

    <!-- Main Content -->
    <div class="main-content">
        <a href="AdminBookingController" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Bookings
        </a>

        <div class="booking-details">
            <div class="booking-header">
                <h1>Booking Details</h1>
                <span class="booking-status status-<%= booking.getStatus() %>">
                    <%= booking.getStatus().substring(0, 1).toUpperCase() + booking.getStatus().substring(1) %>
                </span>
                <span class="payment-status status-<%= booking.getPaymentStatus() %>">
                    Payment: <%= booking.getPaymentStatus().substring(0, 1).toUpperCase() + booking.getPaymentStatus().substring(1) %>
                </span>
            </div>

            <div class="booking-meta">
                <div class="meta-row">
                    <span class="meta-label">Booking ID:</span>
                    <span class="meta-value">#<%= booking.getId() %></span>
                </div>
                <div class="meta-row">
                    <span class="meta-label">User ID:</span>
                    <span class="meta-value"><%= booking.getUserId() %></span>
                </div>
                <div class="meta-row">
                    <span class="meta-label">Venue:</span>
                    <span class="meta-value"><%= booking.getVenueName() %>, <%= booking.getVenueLocation() %></span>
                </div>
                <div class="meta-row">
                    <span class="meta-label">Booking Date:</span>
                    <span class="meta-value"><%= dateFormat.format(booking.getCreatedAt()) %></span>
                </div>
                <div class="meta-row">
                    <span class="meta-label">Event Dates:</span>
                    <span class="meta-value">
                        <%= dateFormat.format(booking.getFromDate()) %> to <%= dateFormat.format(booking.getToDate()) %>
                        (<%= booking.getTotalDays() %> days)
                    </span>
                </div>
            </div>

            <div class="booking-amount">
                Total Amount: ₹<%= String.format("%.2f", booking.getTotalAmount()) %>
            </div>

            <% if ("pending".equals(booking.getStatus())) { %>
                <div class="action-buttons">
                    <a href="AdminBookingController?action=confirm&id=<%= booking.getId() %>" 
                       class="btn btn-success">
                        <i class="fas fa-check"></i> Confirm Booking
                    </a>
                    <a href="AdminBookingController?action=reject&id=<%= booking.getId() %>" 
                       class="btn btn-danger">
                        <i class="fas fa-times"></i> Reject Booking
                    </a>
                </div>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>
 
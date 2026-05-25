<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.Booking" %>
<%@ page import="com.MahalBooking.Model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    Booking booking = (Booking) request.getAttribute("booking");
    User user = (User) session.getAttribute("user");
    
    if (booking == null || user == null) {
        response.sendRedirect("user-login.jsp");
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
            --primary: #8b5a2b;
            --secondary: #d4a76a;
            --accent: #e31837;
            --dark: #3d2b1f;
            --light: #f8f4e9;
            --gray: #6c757d;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: var(--light);
            color: var(--dark);
        }

        .container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: linear-gradient(180deg, #3d2b1f, #2a1c13);
            color: white;
            padding: 20px 0;
        }

        .sidebar-header {
            text-align: center;
            padding: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .sidebar-menu {
            list-style: none;
            padding-top: 20px;
        }

        .sidebar-menu a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 20px;
            color: #ddd;
            text-decoration: none;
            transition: 0.3s;
        }

        .sidebar-menu a:hover,
        .sidebar-menu a.active {
            background: rgba(255,255,255,0.1);
            color: #fff;
            border-left: 4px solid #d4a76a;
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
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
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

        .status-cancelled {
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

        .status-failed {
            background: #fee2e2;
            color: #991b1b;
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
            color: var(--accent);
            margin: 20px 0;
        }

        .booking-image {
            width: 100%;
            height: 300px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 20px;
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

        .btn-danger {
            background: var(--accent);
            color: white;
        }

        .btn-success {
            background: #22c55e;
            color: white;
        }

        .btn-disabled {
            background: #d1d5db;
            color: #6b7280;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h2>Royal Mahal</h2>
            <p>User Dashboard</p>
        </div>

        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/UserVenueController">
                <i class="fas fa-home"></i> Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/BookingController">
                <i class="fas fa-calendar-check"></i> My Bookings</a></li>
            <li><a href="${pageContext.request.contextPath}/BookingController?action=confirmed">
                <i class="fas fa-calendar-alt"></i> Confirmed Bookings</a></li>
            <li><a href="${pageContext.request.contextPath}/user-profile.jsp">
                <i class="fas fa-user"></i> User Profile</a></li>
            <li><a href="${pageContext.request.contextPath}/UserLogoutController">
                <i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <a href="BookingController" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to My Bookings
        </a>

        <div class="booking-details">
            <div class="booking-header">
                <h1><%= booking.getVenueName() %></h1>
                <span class="booking-status status-<%= booking.getStatus() %>">
                    <%= booking.getStatus().substring(0, 1).toUpperCase() + booking.getStatus().substring(1) %>
                </span>
                <% if ("confirmed".equals(booking.getStatus())) { %>
                    <span class="payment-status status-<%= booking.getPaymentStatus() %>">
                        Payment: <%= booking.getPaymentStatus().substring(0, 1).toUpperCase() + booking.getPaymentStatus().substring(1) %>
                    </span>
                <% } %>
                <p><i class="fas fa-map-marker-alt"></i> <%= booking.getVenueLocation() %></p>
            </div>

            <img src="https://source.unsplash.com/800x400/?wedding,hall" alt="Venue Image" class="booking-image">

            <div class="booking-meta">
                <div class="meta-row">
                    <span class="meta-label">Booking ID:</span>
                    <span class="meta-value">#<%= booking.getId() %></span>
                </div>
                <div class="meta-row">
                    <span class="meta-label">Booking Date:</span>
                    <span class="meta-value"><%= dateFormat.format(booking.getCreatedAt()) %></span>
                </div>
                <div class="meta-row">
                    <span class="meta-label">Event Dates:</span>
                    <span class="meta-value"><%= dateFormat.format(booking.getFromDate()) %> to <%= dateFormat.format(booking.getToDate()) %></span>
                </div>
                <div class="meta-row">
                    <span class="meta-label">Total Days:</span>
                    <span class="meta-value"><%= booking.getTotalDays() %></span>
                </div>
            </div>

            <div class="booking-amount">
                Total Amount: ₹<%= String.format("%.2f", booking.getTotalAmount()) %>
            </div>

            <div class="action-buttons">
                <a href="UserVenueController" class="btn btn-primary">
                    <i class="fas fa-home"></i> Book Another Venue
                </a>
                <% if ("confirmed".equals(booking.getStatus()) && "pending".equals(booking.getPaymentStatus())) { %>
                 <%--    <form action="${pageContext.request.contextPath}/PaymentController" method="post">
                        <input type="hidden" name="action" value="processPayment">
                        <input type="hidden" name="bookingId" value="<%= booking.getId() %>">
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-money-bill-wave"></i> Pay Now
                        </button>
                    </form> --%>
                <% } else if ("confirmed".equals(booking.getStatus()) && "paid".equals(booking.getPaymentStatus())) { %>
                    <button class="btn btn-disabled">
                        <i class="fas fa-check-circle"></i> Payment Completed
                    </button>
                <% } %>
                <% if ("pending".equals(booking.getStatus())) { %>
                    <a href="#" class="btn btn-danger">
                        <i class="fas fa-times"></i> Cancel Booking
                    </a>
                <% } %>
            </div>
        </div>
    </div>
</div>
</body>
</html>
   
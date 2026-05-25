<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.Booking" %>
<%@ page import="com.MahalBooking.Model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("user-login.jsp");
        return;
    }

    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    String currentFilter = (String) request.getAttribute("currentFilter");
    if (currentFilter == null) currentFilter = "all";
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Bookings | Royal Mahal</title>
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

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .header h1 {
            color: var(--primary);
        }

        .filter-buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .filter-btn {
            padding: 8px 15px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            outline: none; /* Added to remove outline */
            box-shadow: none; /* Added to remove any potential box shadow */
        }

        .filter-btn.active {
            background: var(--primary);
            color: white;
        }

        .filter-btn:not(.active) {
            background: #e0e0e0;
            color: var(--dark);
        }

        /* Table Styles */
        .bookings-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .bookings-table th, 
        .bookings-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .bookings-table th {
            background-color: var(--primary);
            color: white;
            font-weight: 600;
        }

        .bookings-table tr:hover {
            background-color: rgba(139, 90, 43, 0.05);
        }

        /* Status Badges */
        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
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
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }

        .status-paid {
            background: #d1fae5;
            color: #065f46;
        }

        /* Action Buttons */
        .action-btn {
            padding: 6px 12px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
        }

        .btn-view {
            background: var(--primary);
            color: white;
        }

        .btn-view:hover {
            background: var(--dark);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 50px;
            color: var(--gray);
        }

        .empty-state i {
            font-size: 50px;
            margin-bottom: 20px;
            color: var(--secondary);
        }

        /* Success Message */
        .success-message {
            background: rgba(0, 200, 0, 0.1);
            color: green;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            border-left: 4px solid green;
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
            <li><a href="${pageContext.request.contextPath}/BookingController" class="active">
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
        <div class="header">
            <h1>My Bookings</h1>
        </div>

        <% if (request.getAttribute("success") != null) { %>
            <div class="success-message">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <div class="filter-buttons">
            <a href="BookingController?filter=all" 
               class="filter-btn <%= "all".equals(currentFilter) ? "active" : "" %>">
                All Bookings
            </a>
            <a href="BookingController?filter=pending" 
               class="filter-btn <%= "pending".equals(currentFilter) ? "active" : "" %>">
                Pending
            </a>
            <a href="BookingController?filter=confirmed" 
               class="filter-btn <%= "confirmed".equals(currentFilter) ? "active" : "" %>">
                Confirmed
            </a>
            <a href="BookingController?filter=rejected" 
               class="filter-btn <%= "rejected".equals(currentFilter) ? "active" : "" %>">
                Rejected
            </a>
        </div>

        <% if (bookings != null && !bookings.isEmpty()) { %>
            <table class="bookings-table">
                <thead>
                    <tr>
                        <th>Venue</th>
                        <th>Location</th>
                        <th>Dates</th>
                        <th>Days</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Payment</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Booking booking : bookings) { %>
                        <tr>
                            <td><%= booking.getVenueName() %></td>
                            <td><%= booking.getVenueLocation() %></td>
                            <td>
                                <%= dateFormat.format(booking.getFromDate()) %> - 
                                <%= dateFormat.format(booking.getToDate()) %>
                            </td>
                            <td><%= booking.getTotalDays() %></td>
                            <td>₹<%= String.format("%.2f", booking.getTotalAmount()) %></td>
                            <td>
                                <span class="status-badge status-<%= booking.getStatus() %>">
                                    <%= booking.getStatus().substring(0, 1).toUpperCase() + booking.getStatus().substring(1) %>
                                </span>
                            </td>
                            <td>
                                <% if ("confirmed".equals(booking.getStatus())) { %>
                                    <span class="payment-status status-<%= booking.getPaymentStatus() %>">
                                        <%= booking.getPaymentStatus().substring(0, 1).toUpperCase() + booking.getPaymentStatus().substring(1) %>
                                    </span>
                                <% } else { %>
                                    -
                                <% } %>
                            </td>
                            <td>
                                <a href="BookingController?action=view&id=<%= booking.getId() %>" 
                                   class="action-btn btn-view">
                                    <i class="fas fa-eye"></i> Details
                                </a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <div class="empty-state">
                <i class="fas fa-calendar-times"></i>
                <h2>No Bookings Found</h2>
                <p>You haven't made any bookings yet.</p>
            </div>
        <% } %>
    </div>
</div>
</body>
</html>
         
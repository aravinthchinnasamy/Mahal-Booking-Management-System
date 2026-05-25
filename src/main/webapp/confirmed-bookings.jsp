<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.Booking" %>
<%@ page import="com.MahalBooking.Model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.MahalBooking.DAO.BookingDAO" %>

<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    User user = (User) session.getAttribute("user");
    BookingDAO bookingDAO = new BookingDAO();
    
    if (user == null) {
        response.sendRedirect("user-login.jsp");
        return;
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Confirmed Bookings | Royal Mahal</title>
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

        .status-confirmed {
            background: #d1fae5;
            color: #065f46;
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

        .status-pending {
            background: #fef3c7;
            color: #92400e;
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

        .btn-pay {
            background: var(--primary);
            color: white;
            border: none;
            cursor: pointer;
        }

        .btn-pay:hover {
            background: var(--dark);
        }

        .btn-paid {
            background: #d1fae5;
            color: #065f46;
            border: none;
            cursor: default;
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

        .btn {
            padding: 6px 12px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-block;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--dark);
        }

        .badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            display: inline-block;
        }

        .bg-success {
            background: #d1fae5;
            color: #065f46;
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
            <li><a href="${pageContext.request.contextPath}/BookingController?action=confirmed" class="active">
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
            <h1>Confirmed Bookings</h1>
        </div>

        <% if (request.getAttribute("success") != null) { %>
            <div class="success-message">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <% if (bookings != null && !bookings.isEmpty()) { %>
            <table class="bookings-table">
                <thead>
                    <tr>
                        <th>Venue</th>
                        <th>Location</th>
                        <th>Dates</th>
                        <th>Days</th>
                        <th>Amount</th>
                        <th>Payment Status</th>
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
                                <span class="payment-status status-<%= booking.getPaymentStatus() %>">
                                    <%= booking.getPaymentStatus().substring(0, 1).toUpperCase() + booking.getPaymentStatus().substring(1) %>
                                </span>
                            </td>
                            <td>
                                <% if ("confirmed".equals(booking.getStatus())) { 
                                    if (!"paid".equals(booking.getPaymentStatus())) { %>
                                        <form action="${pageContext.request.contextPath}/PaymentController" method="get">
                                            <input type="hidden" name="action" value="process">
                                            <input type="hidden" name="bookingId" value="<%= booking.getId() %>">
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-money-bill-wave"></i> Pay Now
                                            </button>
                                        </form>
                                    <% } else { 
                                        boolean isEligible = bookingDAO.isBookingEligibleForReview(booking.getId());
                                        boolean hasReviewed = bookingDAO.hasUserReviewedBooking(user.getId(), booking.getId());
                                        
                                        if (isEligible && !hasReviewed) { %>
                                            <a href="${pageContext.request.contextPath}/ReviewController?action=form&bookingId=<%= booking.getId() %>&venueId=<%= booking.getVenueId() %>" 
                                               class="btn btn-primary">
                                                <i class="fas fa-star"></i> Write Review
                                            </a>
                                        <% } else if (hasReviewed) { %>
                                            <span class="badge bg-success">Reviewed</span>
                                        <% } else { %>
                                            <span class="badge bg-success">Paid</span>
                                        <% } %>
                                    <% } %>
                                <% } %>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <div class="empty-state">
                <i class="fas fa-calendar-check"></i>
                <h2>No Confirmed Bookings</h2>
                <p>You don't have any confirmed bookings yet.</p>
            </div>
        <% } %>
    </div>
</div>
</body>
</html>
            
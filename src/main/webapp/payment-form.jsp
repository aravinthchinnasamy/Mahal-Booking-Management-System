<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.Booking" %>
<%@ page import="com.MahalBooking.Model.User" %>
<%@ page import="com.MahalBooking.Model.Payment" %>
<%@ page import="java.util.List" %>

<%
    Booking booking = (Booking) request.getAttribute("booking");
    User user = (User) session.getAttribute("user");
    
    if (booking == null || user == null) {
        response.sendRedirect("user-login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment | Royal Mahal</title>
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

        .payment-container {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            max-width: 800px;
            margin: 0 auto;
        }

        .payment-header {
            margin-bottom: 30px;
            text-align: center;
        }

        .payment-header h2 {
            color: var(--primary);
            margin-bottom: 10px;
        }

        .booking-info {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }

        .booking-info h3 {
            color: var(--primary);
            margin-bottom: 10px;
        }

        .booking-meta {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .booking-amount {
            font-size: 24px;
            font-weight: bold;
            color: var(--accent);
            text-align: center;
            margin: 20px 0;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
        }

        .form-group select,
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
        }

        .btn-submit {
            width: 100%;
            padding: 15px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-submit:hover {
            background: var(--dark);
        }

        .error-message {
            color: var(--accent);
            padding: 10px;
            background: rgba(227, 24, 55, 0.1);
            border-radius: 6px;
            margin-bottom: 20px;
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
        <a href="BookingController?action=confirmed" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Confirmed Bookings
        </a>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <div class="payment-container">
            <div class="payment-header">
                <h1>Complete Payment</h1>
                <p>Secure payment for your booking</p>
            </div>

            <div class="booking-info">
                <h3><%= booking.getVenueName() %></h3>
                <div class="booking-meta">
                    <span><i class="fas fa-map-marker-alt"></i> <%= booking.getVenueLocation() %></span>
                    <span><i class="fas fa-calendar-day"></i> <%= booking.getFromDate() %> to <%= booking.getToDate() %></span>
                </div>
            </div>

            <div class="booking-amount">
                Total Amount: ₹<%= String.format("%.2f", booking.getTotalAmount()) %>
            </div>

            <form action="${pageContext.request.contextPath}/PaymentController" method="post">
                <input type="hidden" name="bookingId" value="<%= booking.getId() %>">
                
                <div class="form-group">
                    <label for="paymentMethod">Payment Method</label>
                    <select id="paymentMethod" name="paymentMethod" required>
                        <option value="">Select Payment Method</option>
                        <option value="1">Credit Card</option>
                        <option value="2">Debit Card</option>
                        <option value="3">UPI</option>
                        <option value="4">Net Banking</option>
                        <option value="5">Wallet</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="transactionId">Account NO:</label>
                    <input type="text" id="transactionId" name="transactionId" 
                           placeholder="Enter transaction reference" required>
                </div>
                
                <button type="submit" class="btn-submit">
                    <i class="fas fa-money-bill-wave"></i> Complete Payment
                </button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
   
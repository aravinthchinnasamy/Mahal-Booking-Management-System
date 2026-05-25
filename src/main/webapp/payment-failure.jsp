<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.Payment" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    Payment payment = (Payment) request.getAttribute("payment");
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payment Failed | Royal Mahal</title>
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

        .failure-container {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            max-width: 800px;
            margin: 0 auto;
            text-align: center;
        }

        .failure-icon {
            font-size: 4rem;
            color: #dc3545;
            margin-bottom: 20px;
        }

        .failure-container h2 {
            color: var(--primary);
            margin-bottom: 15px;
        }

        .payment-details {
            background: var(--light);
            padding: 20px;
            border-radius: 8px;
            margin: 30px 0;
            text-align: left;
        }

        .payment-details p {
            margin-bottom: 10px;
        }

        .payment-details strong {
            color: var(--dark);
        }

        .btn {
            padding: 12px 25px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            margin: 0 10px;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--dark);
        }

        .btn-secondary {
            background: white;
            color: var(--primary);
            border: 1px solid var(--primary);
        }

        .btn-secondary:hover {
            background: var(--light);
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
        <div class="failure-container">
            <div class="failure-icon">
                <i class="fas fa-times-circle"></i>
            </div>
            
            <h2>Payment Failed</h2>
            <p>We couldn't process your payment. Please try again.</p>
            
            <% if (payment != null) { %>
                <div class="payment-details">
                    <p><strong>Transaction ID:</strong> <%= payment.getTransactionId() %></p>
                    <p><strong>Amount:</strong> ₹<%= String.format("%.2f", payment.getAmount()) %></p>
                    <p><strong>Payment Method:</strong> <%= payment.getPaymentMethodName() %></p>
                    <p><strong>Date:</strong> <%= dateFormat.format(payment.getPaymentDate()) %></p>
                </div>
            <% } %>
            
            <div style="margin-top: 30px;">
                <a href="${pageContext.request.contextPath}/BookingController" class="btn btn-secondary">
                    Back to Bookings
                </a>
                <a href="${pageContext.request.contextPath}/PaymentController?action=process&bookingId=<%= payment.getBookingId() %>" class="btn btn-primary">
                    Try Again
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>

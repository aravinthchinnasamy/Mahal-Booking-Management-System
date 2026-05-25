<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.Payment" %>
<%@ page import="com.MahalBooking.Model.Admin" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
    Admin admin = (Admin) session.getAttribute("admin");
    
    if (admin == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payment Management | Royal Mahal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #1e3a8a;
            --secondary: #3b82f6;
            --success: #10b981;
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

        /* Header */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .header h1 {
            font-size: 26px;
            color: var(--primary);
        }

        /* Table Styles */
        .payments-table {
            width: 100%;
            border-collapse: collapse;
            background: var(--card);
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .payments-table th, 
        .payments-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .payments-table th {
            background-color: var(--primary);
            color: white;
            font-weight: 600;
        }

        .payments-table tr:hover {
            background-color: rgba(30, 58, 138, 0.05);
        }

        /* Status Badges */
        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }

        .status-completed {
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

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 50px;
            color: var(--gray);
        }

        .empty-state i {
            font-size: 50px;
            margin-bottom: 20px;
            color: #d1d5db;
        }

        /* Error Message */
        .error-message {
            background: rgba(239,68,68,0.1);
            color: var(--danger);
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            border-left: 4px solid var(--danger);
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
            <li><a href="VenueController"><i class="fas fa-building"></i> Venue Management</a></li>
            <li><a href="AdminBookingController"><i class="fas fa-calendar-alt"></i> Booking Management</a></li>
            <li><a href="AdminPaymentController" class="active"><i class="fas fa-money-bill-wave"></i> Payments</a></li>
            <li><a href="AdminReviewController"><i class="fas fa-star"></i> Reviews</a></li>
            <li><a href="AdminLogoutController"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <h1>Payment Management</h1>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <table class="payments-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>User</th>
                    <th>Venue</th>
                    <th>Amount</th>
                    <th>Method</th>
                    <th>Transaction ID</th>
                    <th>Date</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <% if (payments != null && !payments.isEmpty()) { 
                    for (Payment payment : payments) { %>
                        <tr>
                            <td>#<%= payment.getId() %></td>
                            <td><%= payment.getUserName() %></td>
                            <td><%= payment.getVenueName() %></td>
                            <td>₹<%= String.format("%.2f", payment.getAmount()) %></td>
                            <td>
                                <% 
                                    String method = "";
                                    switch(payment.getPaymentMethodId()) {
                                        case 1: method = "Credit Card"; break;
                                        case 2: method = "Debit Card"; break;
                                        case 3: method = "UPI"; break;
                                        case 4: method = "Net Banking"; break;
                                        case 5: method = "Wallet"; break;
                                        default: method = "Unknown";
                                    }
                                %>
                                <%= method %>
                            </td>
                            <td><%= payment.getTransactionId() %></td>
                            <td><%= dateFormat.format(payment.getPaymentDate()) %></td>
                            <td>
                                <span class="status-badge status-<%= payment.getStatus().toLowerCase() %>">
                                    <%= payment.getStatus().substring(0, 1).toUpperCase() + payment.getStatus().substring(1).toLowerCase() %>
                                </span>
                            </td>
                        </tr>
                    <% } 
                } else { %>
                    <tr>
                        <td colspan="8" class="empty-state">
                            <i class="fas fa-money-bill-wave"></i>
                            <h2>No Payments Found</h2>
                            <p>There are no payment records available.</p>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
 
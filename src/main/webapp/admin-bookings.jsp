<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.Booking" %>
<%@ page import="com.MahalBooking.Model.Admin" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // Check if admin is logged in
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    // Get bookings list and current filter
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    String currentFilter = (String) request.getAttribute("currentFilter");
    if (currentFilter == null) currentFilter = "all";

    SimpleDateFormat dateFormat = new SimpleDateFormat("MMM dd, yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking Management | Royal Mahal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #1e3a8a;
            --success: #10b981;
            --danger: #ef4444;
            --dark: #111827;
            --light: #f9fafb;
            --card: #ffffff;
            --gray: #6b7280;
        }
        * { margin:0; padding:0; box-sizing:border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: var(--light); color: var(--dark); }
        .container { display:flex; min-height:100vh; }

        /* Sidebar */
        .sidebar { width:260px; background:var(--dark); color:#fff; padding:25px 0; }
        .sidebar-header { padding:0 25px 25px; text-align:center; border-bottom:1px solid rgba(255,255,255,0.1);}
        .sidebar-menu { list-style:none; padding-top:20px; }
        .sidebar-menu li a { display:flex; align-items:center; gap:12px; padding:14px 25px; color:#d1d5db; text-decoration:none; transition:0.3s;}
        .sidebar-menu li a:hover, .sidebar-menu li a.active { background: var(--primary); color:#fff; }

        /* Main Content */
        .main-content { flex:1; padding:30px; }
        .header { display:flex; justify-content:space-between; align-items:center; margin-bottom:30px; }
        .header h1 { color:var(--primary); }

        /* Filter buttons */
        .filter-buttons { display:flex; gap:10px; margin-bottom:20px; flex-wrap:wrap; }
        .filter-btn { padding:8px 15px; border-radius:5px; border:none; cursor:pointer; font-weight:600; transition:0.3s; text-decoration:none; display:inline-block; }
        .filter-btn.active { background:var(--primary); color:#fff; }
        .filter-btn:not(.active) { background:#e0e0e0; color:var(--dark); }

        /* Table */
        .bookings-table { width:100%; border-collapse:collapse; background:var(--card); border-radius:10px; overflow:hidden; box-shadow:0 5px 15px rgba(0,0,0,0.05); }
        .bookings-table th, .bookings-table td { padding:12px 15px; text-align:left; border-bottom:1px solid #eee; vertical-align: middle; }
        .bookings-table th { background-color: var(--primary); color:white; font-weight:600; }
        .bookings-table tr:hover { background-color: rgba(30, 58, 138, 0.05); }

        /* Status Badges */
        .status-badge { display:inline-block; padding:5px 10px; border-radius:20px; font-size:14px; font-weight:600; }
        .status-pending { background:#fef3c7; color:#92400e; }
        .status-confirmed { background:#d1fae5; color:#065f46; }
        .status-rejected { background:#fee2e2; color:#991b1b; }

        .payment-status { display:inline-block; padding:5px 10px; border-radius:20px; font-size:14px; font-weight:600; }
        .status-paid { background:#d1fae5; color:#065f46; }
        .status-pending { background:#fef3c7; color:#92400e; }

        /* Action Buttons */
        .action-btn { padding:6px 12px; border-radius:5px; text-decoration:none; font-size:14px; font-weight:600; transition:all 0.3s; display:flex; align-items:center; justify-content:center; }
        .btn-view { background:var(--primary); color:white; }
        .btn-view:hover { background:#1e40af; }
        .btn-confirm { background:var(--success); color:white; }
        .btn-confirm:hover { background:#059669; }
        .btn-reject { background:var(--danger); color:white; }
        .btn-reject:hover { background:#dc2626; }

        /* Empty state */
        .empty-state { text-align:center; padding:50px; color:var(--gray); }
        .empty-state i { font-size:50px; margin-bottom:20px; color:#d1d5db; }

        /* Messages */
        .success-message { background: rgba(16,185,129,0.1); color: var(--success); padding:15px; border-radius:6px; margin-bottom:20px; border-left:4px solid var(--success);}
        .error-message { background: rgba(239,68,68,0.1); color: var(--danger); padding:15px; border-radius:6px; margin-bottom:20px; border-left:4px solid var(--danger);}
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
        <div class="header">
            <h1>Booking Management</h1>
        </div>

        <% if (request.getAttribute("success") != null) { %>
            <div class="success-message"><%= request.getAttribute("success") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message"><%= request.getAttribute("error") %></div>
        <% } %>

        <!-- Filter Buttons -->
        <div class="filter-buttons">
            <a href="AdminBookingController?filter=all" class="filter-btn <%= "all".equals(currentFilter) ? "active" : "" %>">All Bookings</a>
            <a href="AdminBookingController?filter=pending" class="filter-btn <%= "pending".equals(currentFilter) ? "active" : "" %>">Pending</a>
            <a href="AdminBookingController?filter=confirmed" class="filter-btn <%= "confirmed".equals(currentFilter) ? "active" : "" %>">Confirmed</a>
            <a href="AdminBookingController?filter=rejected" class="filter-btn <%= "rejected".equals(currentFilter) ? "active" : "" %>">Rejected</a>
        </div>

        <% if (bookings != null && !bookings.isEmpty()) { %>
            <table class="bookings-table">
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>User</th>
                        <th>Venue</th>
                        <th>Dates</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Payment</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Booking booking : bookings) { %>
                    <tr>
                        <td>#<%= booking.getId() %></td>
                        <td>User #<%= booking.getUserId() %></td>
                        <td><%= booking.getVenueName() %></td>
                        <td><%= dateFormat.format(booking.getFromDate()) %> - <%= dateFormat.format(booking.getToDate()) %></td>
                        <td>₹<%= String.format("%.2f", booking.getTotalAmount()) %></td>
                        <td><span class="status-badge status-<%= booking.getStatus() %>">
                            <%= booking.getStatus().substring(0,1).toUpperCase() + booking.getStatus().substring(1) %>
                        </span></td>
                        <td><span class="payment-status status-<%= booking.getPaymentStatus() %>">
                            <%= booking.getPaymentStatus().substring(0,1).toUpperCase() + booking.getPaymentStatus().substring(1) %>
                        </span></td>
                        <td>
                            <div style="display:flex; gap:5px; flex-wrap:wrap;">
                                <a href="AdminBookingController?action=view&id=<%= booking.getId() %>" class="action-btn btn-view" title="View Booking">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <% if ("pending".equals(booking.getStatus())) { %>
                                    <a href="AdminBookingController?action=confirm&id=<%= booking.getId() %>" class="action-btn btn-confirm" title="Confirm Booking">
                                        <i class="fas fa-check"></i>
                                    </a>
                                    <a href="AdminBookingController?action=reject&id=<%= booking.getId() %>" class="action-btn btn-reject" title="Reject Booking">
                                        <i class="fas fa-times"></i>
                                    </a>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        <% } else { %>
            <div class="empty-state">
                <i class="fas fa-calendar-times"></i>
                <h2>No Bookings Found</h2>
                <p>There are no bookings matching your criteria.</p>
            </div>
        <% } %>
    </div>
</div>
</body>
</html>
     
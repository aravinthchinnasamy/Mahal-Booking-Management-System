<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.DAO.AdminDAO" %>
<%@ page import="com.MahalBooking.Model.Admin" %>

<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    AdminDAO adminDAO = new AdminDAO();
    AdminDAO.DashboardStats stats = adminDAO.getDashboardStats();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Royal Mahal | Admin Dashboard</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
:root {
    --primary: #1e3a8a;   /* Navy Blue */
    --secondary: #3b82f6; /* Soft Blue */
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
    font-family: 'Segoe UI', sans-serif;
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
}

.sidebar-header {
    padding: 25px;
    text-align: center;
    border-bottom: 1px solid rgba(255,255,255,0.1);
}

.sidebar-header h2 {
    font-size: 22px;
    margin-bottom: 5px;
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
    padding: 25px;
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

.header strong {
    color: var(--primary);
}

/* Stats Cards */
.stats-cards {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
    gap: 20px;
    margin-bottom: 35px;
}

.stat-card {
    background: var(--card);
    padding: 22px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    box-shadow: 0 8px 20px rgba(0,0,0,0.05);
}

.stat-icon {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
    margin-right: 18px;
    color: #fff;
}

.stat-info h3 {
    font-size: 22px;
}

.stat-info p {
    font-size: 14px;
    color: var(--gray);
}

/* Modules */
.modules-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
    gap: 20px;
}

.module-card-link {
    text-decoration: none;
    display: block;
}

.module-card {
    background: var(--card);
    padding: 30px;
    border-radius: 12px;
    text-align: center;
    font-size: 18px;
    font-weight: 600;
    color: var(--primary);
    box-shadow: 0 8px 20px rgba(0,0,0,0.05);
    transition: 0.3s;
    cursor: pointer;
}

.module-card:hover {
    transform: translateY(-5px);
    background: var(--primary);
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
        <li><a href="admin-dashboard.jsp" class="active"><i class="fas fa-home"></i> Dashboard</a></li>
        <li><a href="AdminUserController"><i class="fas fa-users"></i> User Management</a></li>
        <li><a href="VenueController"><i class="fas fa-building"></i> Venue Management</a></li>
        <li><a href="AdminBookingController"><i class="fas fa-calendar"></i> Booking Management</a></li>
        <li><a href="AdminPaymentController"><i class="fas fa-money-bill-wave"></i> Payment Management</a></li>
        <li><a href="AdminReviewController"><i class="fas fa-star"></i> Review Moderation</a></li>
        <li><a href="AdminLogoutController"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</div>

<!-- Main Content -->
<div class="main-content">

<div class="header">
    <h1>Dashboard</h1>
    <div>Welcome, <strong><%= admin.getFullName() %></strong></div>
</div>

<div class="stats-cards">

    <div class="stat-card">
        <div class="stat-icon" style="background:var(--secondary)">
            <i class="fas fa-users"></i>
        </div>
        <div class="stat-info">
            <h3><%= stats.getTotalUsers() %></h3>
            <p>Total Users</p>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon" style="background:var(--success)">
            <i class="fas fa-calendar-check"></i>
        </div>
        <div class="stat-info">
            <h3><%= stats.getTodaysBookings() %></h3>
            <p>Today's Bookings</p>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon" style="background:var(--warning)">
            <i class="fas fa-clock"></i>
        </div>
        <div class="stat-info">
            <h3><%= stats.getPendingApprovals() %></h3>
            <p>Pending Approvals</p>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon" style="background:var(--danger)">
            <i class="fas fa-money-bill-wave"></i>
        </div>
        <div class="stat-info">
            <h3>₹<%= String.format("%.2f", stats.getTotalRevenue()) %></h3>
            <p>Total Revenue</p>
        </div>
    </div>

</div>

<div class="modules-grid">
    <a href="AdminUserController" class="module-card-link">
        <div class="module-card">User Management</div>
    </a>
    <a href="VenueController" class="module-card-link">
        <div class="module-card">Venue Management</div>
    </a>
    <a href="AdminBookingController" class="module-card-link">
        <div class="module-card">Booking Management</div>
    </a>
    <a href="AdminPaymentController" class="module-card-link">
        <div class="module-card">Payment Management</div>
    </a>
</div>

</div>
</div>
</body>
</html>
 
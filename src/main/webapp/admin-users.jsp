<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.User" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>User Management | Royal Mahal</title>
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

/* ========== SIDEBAR ========== */
.sidebar {
    width: 260px;
    background: var(--sidebar);
    color: #fff;
}

.sidebar-header {
    padding: 25px;
    text-align: center;
    border-bottom: 1px solid rgba(255,255,255,0.1);
}

.sidebar-header h2 {
    font-size: 22px;
}

.sidebar-header p {
    font-size: 13px;
    opacity: 0.8;
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

/* ========== MAIN ========== */
.main-content {
    flex: 1;
    padding: 30px;
}

.page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 25px;
}

.page-header h1 {
    color: var(--primary);
}

/* ========== CARD ========== */
.card {
    background: var(--card);
    border-radius: 12px;
    padding: 25px;
    box-shadow: 0 10px 25px rgba(0,0,0,0.05);
}

/* ========== SEARCH ========== */
.search-box {
    display: flex;
    gap: 10px;
    margin-bottom: 20px;
}

.search-box input {
    flex: 1;
    padding: 10px 15px;
    border-radius: 8px;
    border: 1px solid #d1d5db;
}

.search-box button {
    padding: 10px 18px;
    background: var(--primary);
    color: #fff;
    border: none;
    border-radius: 8px;
    cursor: pointer;
}

/* ========== TABLE ========== */
table {
    width: 100%;
    border-collapse: collapse;
}

th, td {
    padding: 14px;
    border-bottom: 1px solid #e5e7eb;
    text-align: left;
}

th {
    background: #f9fafb;
    font-weight: 600;
}

tr:hover {
    background: #f9fafb;
}

/* ========== STATUS ========== */
.status-active {
    color: var(--success);
    font-weight: 600;
}

.status-inactive {
    color: var(--danger);
    font-weight: 600;
}

/* ========== ACTIONS ========== */
.btn {
    padding: 6px 14px;
    border-radius: 8px;
    font-size: 14px;
    text-decoration: none;
    font-weight: 600;
    display: inline-block;
}

.btn-view {
    background: var(--primary);
    color: #fff;
}

.btn-toggle {
    background: var(--warning);
    color: #111;
}

.btn:hover {
    opacity: 0.9;
}
</style>
</head>

<body>
<div class="container">

<!-- SIDEBAR -->
<div class="sidebar">
    <div class="sidebar-header">
        <h2>Royal Mahal</h2>
        <p>Admin Panel</p>
    </div>

    <ul class="sidebar-menu">
        <li><a href="admin-dashboard.jsp"><i class="fas fa-home"></i> Dashboard</a></li>
        <li><a href="AdminUserController" class="active"><i class="fas fa-users"></i> Users</a></li>
        <li><a href="VenueController"><i class="fas fa-building"></i> Venues</a></li>
        <li><a href="AdminBookingController"><i class="fas fa-calendar"></i> Bookings</a></li>
        <li><a href="AdminPaymentController"><i class="fas fa-money-bill"></i> Payments</a></li>
        <li><a href="AdminReviewController"><i class="fas fa-star"></i> Reviews</a></li>
        <li><a href="AdminLogoutController"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</div>

<!-- MAIN -->
<div class="main-content">

<div class="page-header">
    <h1>User Management</h1>
</div>

<div class="card">

<div class="search-box">
    <input type="text" placeholder="Search users by name or email...">
    <button><i class="fas fa-search"></i> Search</button>
</div>

<table>
<thead>
<tr>
    <th>ID</th>
    <th>Name</th>
    <th>Email</th>
    <th>Mobile</th>
    <th>Joined Date</th>
    <th>Status</th>
    <th>Actions</th>
</tr>
</thead>
<tbody>

<%
    List<User> userList = (List<User>) request.getAttribute("userList");
    if (userList != null && !userList.isEmpty()) {
        for (User user : userList) {
%>
<tr>
    <td>#<%= user.getId() %></td>
    <td><%= user.getName() %></td>
    <td><%= user.getEmail() %></td>
    <td><%= user.getMobile() %></td>
    <td><%= user.getCreatedAt() %></td>
    <td>
        <% if (user.isActive()) { %>
            <span class="status-active">Active</span>
        <% } else { %>
            <span class="status-inactive">Inactive</span>
        <% } %>
    </td>
    <td>
        <a class="btn btn-view"
           href="AdminUserController?action=view&id=<%= user.getId() %>">
           <i class="fas fa-eye"></i> View
        </a>

        <a class="btn btn-toggle"
           href="AdminUserController?action=toggleStatus&id=<%= user.getId() %>&currentStatus=<%= user.isActive() %>">
           <% if (user.isActive()) { %>
               <i class="fas fa-ban"></i> Deactivate
           <% } else { %>
               <i class="fas fa-check"></i> Activate
           <% } %>
        </a>
    </td>
</tr>
<%
        }
    }
%>

</tbody>
</table>

</div>
</div>
</div>
</body>
</html>

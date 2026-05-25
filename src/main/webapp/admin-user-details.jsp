	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ page import="com.MahalBooking.Model.User" %>
	<!DOCTYPE html>
	<html lang="en">
	<head>
	    <meta charset="UTF-8">
	    <title>User Details | Royal Mahal Admin</title>
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
	
	        body {
	            margin: 0;
	            font-family: 'Segoe UI', sans-serif;
	            background: #f5f7f9;
	        }
	
	        .container {
	            display: flex;
	            min-height: 100vh;
	        }
	
	        /* Sidebar */
	        .sidebar {
	            width: 250px;
	            background: var(--dark);
	            color: white;
	            padding: 20px 0;
	        }
	
	        .sidebar-header {
	            text-align: center;
	            border-bottom: 1px solid rgba(255,255,255,0.1);
	            padding: 20px;
	        }
	
	        .sidebar-menu {
	            list-style: none;
	            padding: 0;
	        }
	
	        .sidebar-menu a {
	            display: block;
	            padding: 12px 20px;
	            color: #ddd;
	            text-decoration: none;
	        }
	
	        .sidebar-menu a:hover {
	            background: rgba(255,255,255,0.1);
	            color: white;
	            border-left: 4px solid var(--secondary);
	        }
	
	        /* Main Content */
	        .main-content {
	            flex: 1;
	            padding: 30px;
	        }
	
	        .back-link {
	            text-decoration: none;
	            color: var(--primary);
	            font-weight: 600;
	        }
	
	        .user-detail-card {
	            background: white;
	            padding: 30px;
	            border-radius: 10px;
	            max-width: 800px;
	            margin: 20px auto;
	        }
	
	        .user-header {
	            display: flex;
	            align-items: center;
	            margin-bottom: 20px;
	        }
	
	        .user-avatar {
	            width: 80px;
	            height: 80px;
	            border-radius: 50%;
	            background: var(--light);
	            display: flex;
	            justify-content: center;
	            align-items: center;
	            font-size: 2rem;
	            color: var(--primary);
	            margin-right: 20px;
	        }
	
	        .status-active {
	            color: green;
	            font-weight: bold;
	        }
	
	        .status-inactive {
	            color: red;
	            font-weight: bold;
	        }
	
	        .action-buttons a {
	            margin-right: 10px;
	            padding: 10px 15px;
	            border-radius: 5px;
	            text-decoration: none;
	            color: white;
	        }
	
	        .btn-back { background: gray; }
	        .btn-toggle { background: var(--secondary); }  /* Sidebar */
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
	            <li><a href="admin-dashboard.jsp" class="active"><i class="fas fa-home"></i> Dashboard</a></li>
	            <li><a href="AdminUserController"><i class="fas fa-users"></i> User Management</a></li>
	            <li><a href="VenueController"><i class="fas fa-building"></i> Venue Management</a></li>
	            <li><a href="AdminBookingController"><i class="fas fa-calendar-alt"></i> Booking Management</a></li>
	            <li><a href="admin-payments.jsp"><i class="fas fa-money-bill-wave"></i> Payment Management</a></li>
	            <li><a href="admin-reports.jsp"><i class="fas fa-star"></i> Reviews & Ratings</a></li>
	            <li><a href="admin-reports"><i class="fas fa-chart-line"></i> Reports & Analytics</a></li>
	            <li><a href="#"><i class="fas fa-cog"></i> Settings</a></li>
	            <li>
	                <a href="AdminLogoutController">
	                    <i class="fas fa-sign-out-alt"></i> Logout
	                </a>
	            </li>
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
	        <li><a href="AdminBookingController"><i class="fas fa-calendar-alt"></i> Booking Management</a></li>
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
	
	        <a href="AdminUserController" class="back-link">
	            <i class="fas fa-arrow-left"></i> Back to User List
	        </a>
	
	        <%
	            User user = (User) request.getAttribute("user");
	            if (user != null) {
	        %>
	
	        <div class="user-detail-card">
	            <div class="user-header">
	                <div class="user-avatar">
	                    <i class="fas fa-user"></i>
	                </div>
	                <div>
	                    <h2><%= user.getName() %></h2>
	                    <p><%= user.getEmail() %></p>
	                    <span class="<%= user.isActive() ? "status-active" : "status-inactive" %>">
	                        <%= user.isActive() ? "Active" : "Inactive" %>
	                    </span>
	                </div>
	            </div>
	
	            <p><strong>User ID:</strong> <%= user.getId() %></p>
	            <p><strong>Mobile:</strong> <%= user.getMobile() %></p>
	            <p><strong>Registered:</strong> <%= user.getCreatedAt() %></p>
	
	            <div class="action-buttons">
	                <a href="AdminUserController" class="btn-back">Back</a>
	
	                <a href="AdminUserController?action=toggleStatus&id=<%= user.getId() %>&currentStatus=<%= user.isActive() %>"
	                   class="btn-toggle">
	                    <%= user.isActive() ? "Deactivate" : "Activate" %>
	                </a>
	            </div>
	        </div>
	
	        <% } else { %>
	            <h3>User not found</h3>
	        <% } %>
	
	    </div>
	</div>
	</body>
	</html>

<%--  <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.Review" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    List<Review> pendingReviews = (List<Review>) request.getAttribute("pendingReviews");
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Review Moderation | Royal Mahal Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #1e3a8a;
            --secondary: #3b82f6;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --dark: #111827;
            --light: #f9fafb;
            --card: #ffffff;
            --gray: #6c757d;
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
            color: white;
            padding: 20px 0;
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

        .sidebar-menu li {
            margin-bottom: 5px;
        }

        .sidebar-menu a {
            display: block;
            padding: 12px 25px;
            color: #d1d5db;
            text-decoration: none;
            transition: all 0.3s;
        }

        .sidebar-menu a:hover,
        .sidebar-menu a.active {
            background: var(--primary);
            color: white;
            border-left: 4px solid var(--secondary);
        }

        .sidebar-menu i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 30px;
            overflow-y: auto;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .header h1 {
            color: var(--primary);
            font-size: 1.8rem;
        }

        /* Table Styles */
        .review-table {
            width: 100%;
            border-collapse: collapse;
            background: var(--card);
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }

        .review-table th,
        .review-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .review-table th {
            background-color: var(--primary);
            color: white;
            font-weight: 600;
        }

        .review-table tr:hover {
            background-color: #f8f9fa;
        }

        .rating-stars {
            color: #f59e0b;
            font-size: 0.9rem;
        }

        .review-comment {
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .action-btn {
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
            border: none;
            color: white;
            margin-right: 5px;
        }

        .approve-btn {
            background: var(--success);
        }

        .reject-btn {
            background: var(--warning);
        }

        .delete-btn {
            background: var(--danger);
        }

        .action-btn:hover {
            opacity: 0.8;
            transform: translateY(-1px);
        }

        .empty-state {
            text-align: center;
            padding: 50px;
            background: var(--card);
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .empty-state i {
            font-size: 3rem;
            color: #ddd;
            margin-bottom: 20px;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            background: #d4edda;
            color: #155724;
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
            <li><a href="AdminPaymentController"><i class="fas fa-money-bill-wave"></i> Payment Management</a></li>
            <li><a href="AdminReviewController" class="active"><i class="fas fa-star"></i> Review Moderation</a></li>
            <li><a href="AdminLogoutController"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <h1>Review Moderation</h1>
            <p>Manage and approve customer reviews</p>
        </div>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <% if (pendingReviews != null && !pendingReviews.isEmpty()) { %>
            <table class="review-table">
                <thead>
                    <tr>
                        <th>User</th>
                        <th>Venue</th>
                        <th>Rating</th>
                        <th>Review</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Review review : pendingReviews) { %>
                    <tr>
                        <td><%= review.getUserName() %></td>
                        <td><%= review.getVenueName() %></td>
                        <td>
                            <span class="rating-stars">
                                <% for (int i = 1; i <= 5; i++) { %>
                                    <i class="fas fa-star <%= i <= review.getRating() ? "" : "far" %>"></i>
                                <% } %>
                            </span>
                        </td>
                        <td class="review-comment" title="<%= review.getComment() %>">
                            <%= review.getComment() %>
                        </td>
                        <td><%= dateFormat.format(review.getCreatedAt()) %></td>
                        <td>
                            <form action="AdminReviewController" method="post" style="display: inline;">
                                <input type="hidden" name="reviewId" value="<%= review.getId() %>">
                                <input type="hidden" name="action" value="approve">
                                <button type="submit" class="action-btn approve-btn">
                                    <i class="fas fa-check"></i> Approve
                                </button>
                            </form>
                            <form action="AdminReviewController" method="post" style="display: inline;">
                                <input type="hidden" name="reviewId" value="<%= review.getId() %>">
                                <input type="hidden" name="action" value="reject">
                                <button type="submit" class="action-btn reject-btn">
                                    <i class="fas fa-times"></i> Reject
                                </button>
                            </form>
                            <form action="AdminReviewController" method="post" style="display: inline;">
                                <input type="hidden" name="reviewId" value="<%= review.getId() %>">
                                <input type="hidden" name="action" value="delete">
                                <button type="submit" class="action-btn delete-btn">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <div class="empty-state">
                <i class="fas fa-check-circle"></i>
                <h3>No Pending Reviews</h3>
                <p>All reviews have been moderated</p>
            </div>
        <% } %>
    </div>
</div>
</body>
</html>

 
 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.Review" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    List<Review> pendingReviews = (List<Review>) request.getAttribute("pendingReviews");
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Review Moderation | Royal Mahal Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #1e3a8a;
            --secondary: #3b82f6;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --dark: #111827;
            --light: #f9fafb;
            --card: #ffffff;
            --gray: #6c757d;
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
            color: white;
            padding: 20px 0;
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

        .sidebar-menu li {
            margin-bottom: 5px;
        }

        .sidebar-menu a {
            display: block;
            padding: 12px 25px;
            color: #d1d5db;
            text-decoration: none;
            transition: all 0.3s;
        }

        .sidebar-menu a:hover,
        .sidebar-menu a.active {
            background: var(--primary);
            color: white;
            border-left: 4px solid var(--secondary);
        }

        .sidebar-menu i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 30px;
            overflow-y: auto;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .header h1 {
            color: var(--primary);
            font-size: 1.8rem;
        }

        /* Table Styles */
        .review-table {
            width: 100%;
            border-collapse: collapse;
            background: var(--card);
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }

        .review-table th,
        .review-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .review-table th {
            background-color: var(--primary);
            color: white;
            font-weight: 600;
        }

        .review-table tr:hover {
            background-color: #f8f9fa;
        }

        .rating-stars {
            color: #f59e0b;
            font-size: 0.9rem;
        }

        .review-comment {
            max-width: 300px;
            white-space: wrap;
            overflow: hidden;
        }

        .action-btn {
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
            border: none;
            color: white;
            margin-right: 5px;
        }

        .approve-btn {
            background: var(--success);
        }

        .reject-btn {
            background: var(--warning);
        }

        .delete-btn {
            background: var(--danger);
        }

        .action-btn:hover {
            opacity: 0.8;
            transform: translateY(-1px);
        }

        .empty-state {
            text-align: center;
            padding: 50px;
            background: var(--card);
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .empty-state i {
            font-size: 3rem;
            color: #ddd;
            margin-bottom: 20px;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            background: #d4edda;
            color: #155724;
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
            <li><a href="AdminPaymentController"><i class="fas fa-money-bill-wave"></i> Payment Management</a></li>
            <li><a href="AdminReviewController" class="active"><i class="fas fa-star"></i> Review Moderation</a></li>
            <li><a href="AdminLogoutController"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <h1>Review Moderation</h1>
            <p>Manage and approve customer reviews</p>
        </div>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <% if (pendingReviews != null && !pendingReviews.isEmpty()) { %>
            <table class="review-table">
                <thead>
                    <tr>
                        <th>User</th>
                        <th>Venue</th>
                        <th>Rating</th>
                        <th>Review</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Review review : pendingReviews) { %>
                    <tr>
                        <td><%= review.getUserName() %></td>
                        <td><%= review.getVenueName() %></td>
                        <td>
                            <span class="rating-stars">
                                <% 
                                    int rating = review.getRating();
                                    for (int i = 1; i <= 5; i++) { 
                                %>
                                    <i class="fas fa-star <%= i <= rating ? "" : "far" %>"></i>
                                <% } %>
                                (<%= rating %>/<%= 5 %>)
                            </span>
                        </td>
                        <td class="review-comment" title="<%= review.getComment() %>">
                            <%= review.getComment() %>
                        </td>
                        <td><%= dateFormat.format(review.getCreatedAt()) %></td>
                        <td>
                            <form action="AdminReviewController" method="post" style="display: inline;">
                                <input type="hidden" name="reviewId" value="<%= review.getId() %>">
                                <input type="hidden" name="action" value="approve">
                                <button type="submit" class="action-btn approve-btn">
                                    <i class="fas fa-check"></i> Approve
                                </button>
                            </form>
                            <form action="AdminReviewController" method="post" style="display: inline;">
                                <input type="hidden" name="reviewId" value="<%= review.getId() %>">
                                <input type="hidden" name="action" value="reject">
                                <button type="submit" class="action-btn reject-btn">
                                    <i class="fas fa-times"></i> Reject
                                </button>
                            </form>
                            <form action="AdminReviewController" method="post" style="display: inline;">
                                <input type="hidden" name="reviewId" value="<%= review.getId() %>">
                                <input type="hidden" name="action" value="delete">
                                <button type="submit" class="action-btn delete-btn">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <div class="empty-state">
                <i class="fas fa-check-circle"></i>
                <h3>No Pending Reviews</h3>
                <p>All reviews have been moderated</p>
            </div>
        <% } %>
    </div>
</div>
</body>
</html>
  --%>
  
  <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.Review" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    List<Review> pendingReviews = (List<Review>) request.getAttribute("pendingReviews");
    SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Review Moderation | Royal Mahal Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #1e3a8a;
            --secondary: #3b82f6;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --dark: #111827;
            --light: #f9fafb;
            --card: #ffffff;
            --gray: #6c757d;
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
            color: white;
            padding: 20px 0;
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

        .sidebar-menu li {
            margin-bottom: 5px;
        }

        .sidebar-menu a {
            display: block;
            padding: 12px 25px;
            color: #d1d5db;
            text-decoration: none;
            transition: all 0.3s;
        }

        .sidebar-menu a:hover,
        .sidebar-menu a.active {
            background: var(--primary);
            color: white;
            border-left: 4px solid var(--secondary);
        }

        .sidebar-menu i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 30px;
            overflow-y: auto;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .header h1 {
            color: var(--primary);
            font-size: 1.8rem;
        }

        /* Table Styles */
        .review-table {
            width: 100%;
            border-collapse: collapse;
            background: var(--card);
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }

        .review-table th,
        .review-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .review-table th {
            background-color: var(--primary);
            color: white;
            font-weight: 600;
        }

        .review-table tr:hover {
            background-color: #f8f9fa;
        }

        .rating-stars {
            color: #f59e0b;
            font-size: 0.9rem;
        }

        .review-comment {
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .action-btn {
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
            border: none;
            color: white;
            margin-right: 5px;
        }

        .approve-btn {
            background: var(--success);
        }

        .reject-btn {
            background: var(--warning);
        }

        .delete-btn {
            background: var(--danger);
        }

        .action-btn:hover {
            opacity: 0.8;
            transform: translateY(-1px);
        }

        .empty-state {
            text-align: center;
            padding: 50px;
            background: var(--card);
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .empty-state i {
            font-size: 3rem;
            color: #ddd;
            margin-bottom: 20px;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            background: #d4edda;
            color: #155724;
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
            <li><a href="AdminPaymentController"><i class="fas fa-money-bill-wave"></i> Payment Management</a></li>
            <li><a href="AdminReviewController" class="active"><i class="fas fa-star"></i> Review Moderation</a></li>
            <li><a href="AdminLogoutController"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <h1>Review Moderation</h1>
            <p>Manage and approve customer reviews</p>
        </div>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <% if (pendingReviews != null && !pendingReviews.isEmpty()) { %>
            <table class="review-table">
                <thead>
                    <tr>
                        <th>User</th>
                        <th>Venue</th>
                        <th>Rating</th>
                        <th>Review</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Review review : pendingReviews) { %>
                    <tr>
                        <td><%= review.getUserName() %></td>
                        <td><%= review.getVenueName() %></td>
                        <td>
                            <span class="rating-stars" title="<%= review.getRating() %> out of 5 stars">
                                <% 
                                    int rating = review.getRating();
                                    for (int i = 1; i <= 5; i++) {
                                        if (i <= rating) {
                                %>
                                    <i class="fas fa-star"></i>
                                <% } else { %>
                                    <i class="far fa-star"></i>
                                <% } } %>
                                <span style="margin-left: 5px; font-size: 12px; color: var(--gray);">
                                    (<%= rating %>)
                                </span>
                            </span>
                        </td>
                        <td class="review-comment" title="<%= review.getComment() %>">
                            <%= review.getComment() %>
                        </td>
                        <td><%= dateFormat.format(review.getCreatedAt()) %></td>
                        <td>
                            <form action="AdminReviewController" method="post" style="display: inline;">
                                <input type="hidden" name="reviewId" value="<%= review.getId() %>">
                                <input type="hidden" name="action" value="approve">
                                <button type="submit" class="action-btn approve-btn">
                                    <i class="fas fa-check"></i> Approve
                                </button>
                            </form>
                            <form action="AdminReviewController" method="post" style="display: inline;">
                                <input type="hidden" name="reviewId" value="<%= review.getId() %>">
                                <input type="hidden" name="action" value="reject">
                                <button type="submit" class="action-btn reject-btn">
                                    <i class="fas fa-times"></i> Reject
                                </button>
                            </form>
                            <form action="AdminReviewController" method="post" style="display: inline;">
                                <input type="hidden" name="reviewId" value="<%= review.getId() %>">
                                <input type="hidden" name="action" value="delete">
                                <button type="submit" class="action-btn delete-btn">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } else { %>
            <div class="empty-state">
                <i class="fas fa-check-circle"></i>
                <h3>No Pending Reviews</h3>
                <p>All reviews have been moderated</p>
            </div>
        <% } %>
    </div>
</div>
</body>
</html>
  
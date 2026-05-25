<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.Review" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    String venueName = (String) request.getAttribute("venueName");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Venue Reviews | Royal Mahal</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
:root {
    --primary: #7b3f00;
    --secondary: #d4a373;
    --dark: #2f1b0c;
    --light: #fdf6ec;
    --card: #ffffff;
    --gray: #6b7280;
    --star: #f59e0b;
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

/* LAYOUT */
.wrapper {
    display: flex;
    min-height: 100vh;
}

/* SIDEBAR */
.sidebar {
    width: 260px;
    background: linear-gradient(180deg, #3b240f, #2a1708);
    color: #fff;
}

.sidebar-header {
    padding: 25px;
    text-align: center;
    border-bottom: 1px solid rgba(255,255,255,0.1);
}

.sidebar-header h2 {
    color: var(--secondary);
    margin-bottom: 5px;
}

.sidebar-menu {
    list-style: none;
    margin-top: 20px;
}

.sidebar-menu a {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 14px 25px;
    color: #e5e5e5;
    text-decoration: none;
    transition: 0.3s;
}

.sidebar-menu a:hover,
.sidebar-menu a.active {
    background: rgba(255,255,255,0.12);
    border-left: 4px solid var(--secondary);
    color: #fff;
}

/* CONTENT */
.content {
    flex: 1;
    padding: 30px;
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 25px;
}

.back-btn {
    background: var(--primary);
    color: #fff;
    padding: 10px 16px;
    border-radius: 6px;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 6px;
}

.back-btn:hover {
    background: #5c2f00;
}

.page-title {
    color: var(--primary);
    margin-bottom: 20px;
}

/* REVIEWS */
.reviews-list {
    display: grid;
    gap: 20px;
}

.review-card {
    background: var(--card);
    border-radius: 10px;
    padding: 22px;
    box-shadow: 0 8px 18px rgba(0,0,0,0.08);
}

.review-header {
    display: flex;
    justify-content: space-between;
    margin-bottom: 8px;
}

.review-user {
    font-weight: 600;
}

.review-date {
    font-size: 0.9rem;
    color: var(--gray);
}

.review-rating i {
    color: var(--star);
    margin-right: 2px;
}

.review-comment {
    margin-top: 12px;
    color: #444;
    line-height: 1.6;
}

/* NO REVIEWS */
.no-reviews {
    text-align: center;
    padding: 50px;
    background: #fff;
    border-radius: 10px;
    color: var(--gray);
}
</style>
</head>

<body>

<div class="wrapper">

    <!-- SIDEBAR -->
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

    <!-- CONTENT -->
    <div class="content">

        <div class="header">
            <h1 class="page-title">Reviews for <%= venueName %></h1>
            <a href="${pageContext.request.contextPath}/UserVenueController" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back
            </a>
        </div>

        <div class="reviews-list">
            <% if (reviews != null && !reviews.isEmpty()) { %>
                <% for (Review review : reviews) { %>
                    <div class="review-card">
                        <div class="review-header">
                            <div class="review-user">
                                <%= review.getUserName() != null ? review.getUserName() : "Anonymous" %>
                            </div>
                            <div class="review-date">
                                <%= dateFormat.format(review.getCreatedAt()) %>
                            </div>
                        </div>

                        <div class="review-rating">
                            <% for (int i = 1; i <= 5; i++) { %>
                                <i class="fas fa-star <%= i <= review.getRating() ? "" : "fa-regular" %>"></i>
                            <% } %>
                        </div>

                        <div class="review-comment">
                            <%= review.getComment() != null ? review.getComment() : "No comment provided." %>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="no-reviews">
                    <i class="fas fa-comment-slash fa-3x"></i>
                    <h3>No Reviews Yet</h3>
                    <p>This venue has not received any reviews.</p>
                </div>
            <% } %>
        </div>

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
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    String venueName = (String) request.getAttribute("venueName");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Venue Reviews | Royal Mahal</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
:root {
    --primary: #7b3f00;
    --secondary: #d4a373;
    --dark: #2f1b0c;
    --light: #fdf6ec;
    --card: #ffffff;
    --gray: #6b7280;
    --star: #f59e0b;
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

/* LAYOUT */
.wrapper {
    display: flex;
    min-height: 100vh;
}

/* SIDEBAR */
.sidebar {
    width: 260px;
    background: linear-gradient(180deg, #3b240f, #2a1708);
    color: #fff;
}

.sidebar-header {
    padding: 25px;
    text-align: center;
    border-bottom: 1px solid rgba(255,255,255,0.1);
}

.sidebar-header h2 {
    color: var(--secondary);
    margin-bottom: 5px;
}

.sidebar-menu {
    list-style: none;
    margin-top: 20px;
}

.sidebar-menu a {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 14px 25px;
    color: #e5e5e5;
    text-decoration: none;
    transition: 0.3s;
}

.sidebar-menu a:hover,
.sidebar-menu a.active {
    background: rgba(255,255,255,0.12);
    border-left: 4px solid var(--secondary);
    color: #fff;
}

/* CONTENT */
.content {
    flex: 1;
    padding: 30px;
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 25px;
}

.back-btn {
    background: var(--primary);
    color: #fff;
    padding: 10px 16px;
    border-radius: 6px;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 6px;
}

.back-btn:hover {
    background: #5c2f00;
}

.page-title {
    color: var(--primary);
    margin-bottom: 20px;
}

/* REVIEWS */
.reviews-list {
    display: grid;
    gap: 20px;
}

.review-card {
    background: var(--card);
    border-radius: 10px;
    padding: 22px;
    box-shadow: 0 8px 18px rgba(0,0,0,0.08);
}

.review-header {
    display: flex;
    justify-content: space-between;
    margin-bottom: 8px;
}

.review-user {
    font-weight: 600;
}

.review-date {
    font-size: 0.9rem;
    color: var(--gray);
}

.review-rating i {
    color: var(--star);
    margin-right: 2px;
}

.review-comment {
    margin-top: 12px;
    color: #444;
    line-height: 1.6;
}

/* NO REVIEWS */
.no-reviews {
    text-align: center;
    padding: 50px;
    background: #fff;
    border-radius: 10px;
    color: var(--gray);
    
    .rating-number {
    margin-left: 8px;
    color: var(--gray);
    font-size: 0.9rem;
}
}
</style>
</head>

<body>

<div class="wrapper">

    <!-- SIDEBAR -->
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

    <!-- CONTENT -->
    <div class="content">

        <div class="header">
            <h1 class="page-title">Reviews for <%= venueName %></h1>
            <a href="${pageContext.request.contextPath}/UserVenueController" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back
            </a>
        </div>

        <div class="reviews-list">
            <% if (reviews != null && !reviews.isEmpty()) { %>
                <% for (Review review : reviews) { %>
                    <div class="review-card">
                        <div class="review-header">
                            <div class="review-user">
                                <%= review.getUserName() != null ? review.getUserName() : "Anonymous" %>
                            </div>
                            <div class="review-date">
                                <%= dateFormat.format(review.getCreatedAt()) %>
                            </div>
                        </div>

                        <%-- <div class="review-rating">
                            <% 
                                int rating = review.getRating();
                                for (int i = 1; i <= 5; i++) { 
                            %>
                                <i class="fas fa-star <%= i <= rating ? "" : "fa-regular" %>"></i>
                            <% } %>
                            <span style="margin-left: 8px; color: var(--dark); font-weight: 600;">
                                (<%= rating %>/<%= 5 %>)
                            </span>
                        </div> --%>
                        
                        <div class="review-rating">
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
    <span class="rating-number">(<%= review.getRating() %>)</span>
</div>

                        <div class="review-comment">
                            <%= review.getComment() != null ? review.getComment() : "No comment provided." %>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <div class="no-reviews">
                    <i class="fas fa-comment-slash fa-3x"></i>
                    <h3>No Reviews Yet</h3>
                    <p>This venue has not received any reviews.</p>
                </div>
            <% } %>
        </div>

    </div>
</div>

</body>
</html>
  
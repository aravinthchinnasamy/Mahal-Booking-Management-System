<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.Venue" %>
<%@ page import="com.MahalBooking.Model.User" %>

<%
    Venue venue = (Venue) request.getAttribute("venue");
    User user = (User) session.getAttribute("user");
    
    if (venue == null || user == null) {
        response.sendRedirect("user-login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%= venue.getName() %> | Royal Mahal</title>
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

        .venue-details {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            max-width: 800px;
            margin: 0 auto;
        }

        .venue-header {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }

        .venue-header h1 {
            color: var(--primary);
            margin-bottom: 10px;
        }

        .venue-price {
            font-size: 24px;
            font-weight: bold;
            color: var(--accent);
            margin: 10px 0;
        }

        .venue-meta {
            display: flex;
            gap: 20px;
            margin-bottom: 15px;
            color: var(--gray);
        }

        .venue-meta span {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .venue-images {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }

        .venue-images img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 8px;
        }

        .venue-description {
            margin: 20px 0;
            line-height: 1.6;
        }

        .amenities {
            margin: 30px 0;
        }

        .amenities h3 {
            margin-bottom: 15px;
            color: var(--primary);
        }

        .amenities-list {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .amenity-tag {
            background: var(--light);
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 14px;
        }

        .reviews {
            margin: 30px 0;
        }

        .reviews h3 {
            margin-bottom: 15px;
            color: var(--primary);
        }

        .review-item {
            background: var(--light);
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .review-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .reviewer {
            font-weight: 600;
        }

        .review-rating {
            color: var(--secondary);
        }

        .booking-section {
            margin-top: 30px;
            text-align: center;
        }

        .btn-book {
            padding: 12px 30px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-book:hover {
            background: var(--dark);
            transform: translateY(-2px);
        }

        .error-message {
            color: var(--accent);
            margin-top: 10px;
            padding: 12px;
            background: rgba(227, 24, 55, 0.1);
            border-radius: 6px;
            border-left: 4px solid var(--accent);
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
        <a href="UserVenueController" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Venues
        </a>

        <div class="venue-details">
            <div class="venue-header">
                <h1><%= venue.getName() %></h1>
                <div class="venue-price">₹<%= String.format("%.2f", venue.getPrice()) %></div>
                <div class="venue-meta">
                    <span><i class="fas fa-map-marker-alt"></i> <%= venue.getLocation() %></span>
                    <span><i class="fas fa-users"></i> Capacity: <%= venue.getCapacity() %> guests</span>
                </div>
            </div>

           <div class="venue-images">

<% 
    if (venue.getImages() != null && !venue.getImages().isEmpty()) { 
        for (byte[] imageBytes : venue.getImages()) {

            String base64Image = java.util.Base64.getEncoder().encodeToString(imageBytes);
%>

    <img src="data:image/jpeg;base64,<%= base64Image %>" 
         alt="<%= venue.getName() %>">

<% 
        }
    } else { 
%>

    <img src="https://source.unsplash.com/600x400/?wedding,hall" 
         alt="Wedding Venue">

<% } %>

</div>


            <div class="venue-description">
                <h3>About this venue</h3>
                <p><%= venue.getDescription() %></p>
            </div>

            <div class="amenities">
                <h3>Amenities</h3>
                <div class="amenities-list">
                    <% 
                        String[] amenities = venue.getAmenities().split(",");
                        for (String amenity : amenities) { 
                            if (!amenity.trim().isEmpty()) { %>
                                <div class="amenity-tag"><%= amenity.trim() %></div>
                            <% }
                        } 
                    %>
                </div>
            </div>

<!--             <div class="reviews">
                <h3>Reviews</h3>
                <div class="review-item">
                    <div class="review-header">
                        <span class="reviewer">Rajesh Kumar</span>
                        <span class="review-rating">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                        </span>
                    </div>
                    <p>Excellent venue for weddings. The staff was very cooperative and the food was delicious.</p>
                </div>

                <div class="review-item">
                    <div class="review-header">
                        <span class="reviewer">Priya Sharma</span>
                        <span class="review-rating">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star-half-alt"></i>
                        </span>
                    </div>
                    <p>Beautiful decor and ample parking space. The only issue was with the sound system which could be improved.</p>
                </div>
            </div> -->
            
            <div class="reviews">
    <h3>Reviews 
        <a href="${pageContext.request.contextPath}/ReviewController?action=view&venueId=<%= venue.getId() %>" 
           style="font-size: 14px; margin-left: 10px;">
           (View All)
        </a>
    </h3>
    
    <% 
        // You'll need to add logic to fetch reviews for this venue
        // List<Review> venueReviews = reviewDAO.getReviewsByVenue(venue.getId());
        // Show only top 2 reviews
        // for (Review review : venueReviews) {
    %>
    
    <!-- Sample static reviews (replace with dynamic when you implement) -->
    <div class="review-item">
        <div class="review-header">
            <span class="reviewer">Rajesh Kumar</span>
            <span class="review-rating">
                <i class="fas fa-star"></i>
                <i class="fas fa-star"></i>
                <i class="fas fa-star"></i>
                <i class="fas fa-star"></i>
                <i class="fas fa-star"></i>
                <span style="margin-left: 5px; font-size: 14px;">(5/5)</span>
            </span>
        </div>
        <p>Excellent venue for weddings. The staff was very cooperative and the food was delicious.</p>
    </div>

    <div class="review-item">
        <div class="review-header">
            <span class="reviewer">Priya Sharma</span>
            <span class="review-rating">
                <i class="fas fa-star"></i>
                <i class="fas fa-star"></i>
                <i class="fas fa-star"></i>
                <i class="fas fa-star"></i>
                <i class="far fa-star"></i>
                <span style="margin-left: 5px; font-size: 14px;">(4/5)</span>
            </span>
        </div>
        <p>Beautiful decor and ample parking space. The only issue was with the sound system which could be improved.</p>
    </div>
</div>
            
             <a href="${pageContext.request.contextPath}/ReviewController?action=view&venueId=<%= venue.getId() %>" 
       class="btn-book">
        <i class="fas fa-star"></i> View Reviews
    </a>

            <div class="booking-section">
            
            
            
    <form action="${pageContext.request.contextPath}/BookingController" method="get">
        <input type="hidden" name="venueId" value="<%= venue.getId() %>">
        <button type="submit" class="btn-book">
            <i class="fas fa-calendar-check"></i> Book This Venue
        </button>
    </form>
</div>
        </div>
    </div>
</div>
</body>
</html>
   

  <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.User" %>
<%@ page import="com.MahalBooking.Model.Venue" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>

<%
User user = (User) session.getAttribute("user");
if (user == null) {
    response.sendRedirect("user-login.jsp");
    return;
}

List<Venue> venues = (List<Venue>) request.getAttribute("venues");

if (venues != null) {
    for (Venue v : venues) {
        System.out.println("Venue: " + v.getName());
    }
}

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Royal Mahal - User Dashboard</title>
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
            font-family: "Segoe UI", Arial, sans-serif;
            background: #f4f6f9;
        }

        .container {
            display: flex;
            min-height: 100vh;
        }

        /* SIDEBAR */
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

        .sidebar-header h2 {
            margin: 0;
            font-size: 24px;
            color: #d4a76a;
        }

        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin-top: 20px;
        }

        .sidebar-menu a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 20px;
            color: #ddd;
            text-decoration: none;
            font-size: 15px;
            transition: 0.3s;
        }

        .sidebar-menu a:hover,
        .sidebar-menu a.active {
            background: rgba(255,255,255,0.1);
            color: #fff;
            border-left: 4px solid #d4a76a;
        }

        /* MAIN */
        .main-content {
            flex: 1;
            padding: 25px 35px;
        }

        /* TOP BAR */
        .top-bar {
            background: #fff;
            padding: 15px 25px;
            border-radius: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 3px 12px rgba(0,0,0,0.08);
        }

        .logo-box {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo-box img {
            width: 45px;
            height: 45px;
        }

        .logo-text {
            font-size: 22px;
            font-weight: 800;
        }

        .logo-text .royal { color: #8b5a2b; }
        .logo-text .mahal { color: #e31837; }

        .user-info {
            display: flex;
            align-items: center;
            gap: 12px;
            color: #444;
        }

        .avatar {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            background: #8b5a2b;
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }

        /* WELCOME */
        .welcome {
            text-align: center;
            margin: 30px 0;
            font-size: 26px;
            font-weight: 700;
            color: #3d2b1f;
        }

        /* SEARCH */
        .search-module {
            background: #fff;
            padding: 18px 22px;
            border-radius: 10px;
            width: 70%;
            margin: 0 auto 30px;
            display: flex;
            align-items: center;
            gap: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }

        .search-module input {
            border: none;
            outline: none;
            width: 100%;
            font-size: 16px;
            background: transparent;
        }

        /* VENUES */
        .section-title {
            font-size: 22px;
            color: #8b5a2b;
            margin-bottom: 20px;
        }

        .venue-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 25px;
        }

        .venue-card {
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 10px 20px rgba(0,0,0,0.08);
            transition: 0.3s;
        }

        .venue-card:hover {
            transform: translateY(-5px);
        }

        .venue-card img {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }

        .venue-content {
            padding: 16px;
        }

        .venue-content h3 {
            margin: 6px 0;
            color: #3d2b1f;
        }

        .venue-content p {
            color: #666;
            font-size: 14px;
        }

        .rating {
            display: flex;
            align-items: center;
            gap: 5px;
            margin: 10px 0;
            color: var(--warning);
        }

        .venue-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .btn-view {
            padding: 8px 14px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 14px;
        }

        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #666;
        }

        .empty-state i {
            font-size: 50px;
            color: #d4a76a;
            margin-bottom: 20px;
        }
    </style>
</head>

<body>
<div class="container">

    <!-- SIDEBAR -->
    <div class="sidebar">
        <div class="sidebar-header">
            <h2>Royal Mahal</h2>
            <p>User Dashboard</p>
        </div>

        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/UserVenueController" class="active">
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

    <!-- MAIN CONTENT -->
    <div class="main-content">

        <div class="top-bar">
            <div class="logo-box">
                <img src="https://cdn-icons-png.flaticon.com/512/619/619153.png">
                <div class="logo-text">
                    <span class="royal">Royal</span>
                    <span class="mahal">Mahal</span>
                </div>
            </div>

            <div class="user-info">
                <div class="avatar"><%= user.getName().charAt(0) %></div>
                <div><%= user.getEmail() %></div>
            </div>
        </div>

        <div class="welcome">Welcome, <%= user.getName() %></div>

        <div class="search-module">
            <i class="fas fa-search"></i>
            <input type="text" id="venueSearch" placeholder="Search by Mahal Name or City" onkeyup="filterVenues()">
        </div>

        <div class="section-title">Available Venues</div>
 
    <div class="venue-grid">
            <% if (venues != null && !venues.isEmpty()) { 
                for (Venue venue : venues) { 
                    if (venue.isActive()) { %>
                        <div class="venue-card"
                             data-name="<%= venue.getName().toLowerCase() %>"
                             data-city="<%= venue.getLocation().toLowerCase() %>">
                            
                           <% if (venue.getImages() != null && !venue.getImages().isEmpty()) { 
       byte[] img = venue.getImages().get(0);
       String base64 = Base64.getEncoder().encodeToString(img);
%>

    <img src="data:image/jpeg;base64,<%= base64 %>" 
         alt="<%= venue.getName() %>" 
         class="venue-image">

<% } else { %>

    <img src="https://source.unsplash.com/400x300/?wedding,hall,india" 
         alt="Wedding Venue" 
         class="venue-image">

<% } %>
                            
                            <div class="venue-content">
                                <h3><%= venue.getName() %></h3>
                                <p><i class="fas fa-map-marker-alt"></i> <%= venue.getLocation() %></p>
                                <p>₹<%= String.format("%.2f", venue.getPrice()) %></p>
                                
                                <div class="rating">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star-half-alt"></i>
                                    <span>(24 reviews)</span>
                                </div>
                                
                                <div class="venue-actions">
                                    <a href="${pageContext.request.contextPath}/MahalSearchController?action=view&id=<%= venue.getId() %>"
                                       class="btn-view">View Details</a>
                                </div>
                            </div>
                        </div>
                    <% } 
                } 
            } else { %>
                <div class="empty-state">
                    <i class="fas fa-building"></i>
                    <h2>No Venues Found</h2>
                    <p><%= request.getAttribute("message") != null ? request.getAttribute("message") : "There are no venues available." %></p>
                    <a href="${pageContext.request.contextPath}/UserVenueController" class="btn" style="margin-top: 20px;">
                        <i class="fas fa-sync-alt"></i> Refresh
                    </a>
                </div>
            <% } %>
        </div>
    </div>
</div>

<script>
function filterVenues() {
    let input = document.getElementById("venueSearch").value.toLowerCase();
    let venues = document.querySelectorAll(".venue-card");

    venues.forEach(venue => {
        let name = venue.getAttribute("data-name");
        let city = venue.getAttribute("data-city");

        venue.style.display = (name.includes(input) || city.includes(input)) ? "block" : "none";
    });
}
</script>

</body>
</html>
  
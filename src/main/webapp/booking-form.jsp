
   
   <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.Venue" %>
<%@ page import="com.MahalBooking.Model.User" %>
<%@ page import="java.util.Base64" %>


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
    <title>Book <%= venue.getName() %> | Royal Mahal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/css/bootstrap-datepicker.min.css">
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

        /* Header */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .btn {
            padding: 10px 20px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 600;
        }

        /* Booking Form */
        .booking-container {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            max-width: 800px;
            margin: 0 auto;
        }

        .booking-header {
            margin-bottom: 30px;
            text-align: center;
        }

        .booking-header h1 {
            color: var(--primary);
            margin-bottom: 10px;
        }

        .venue-info {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
        }

        .venue-image {
            width: 300px;
            height: 200px;
            object-fit: cover;
            border-radius: 8px;
        }

        .venue-details h2 {
            color: var(--primary);
            margin-bottom: 10px;
        }

        .venue-price {
            font-size: 24px;
            font-weight: bold;
            color: var(--accent);
            margin: 10px 0;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
        }

        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
        }

        .date-picker-container {
            display: flex;
            gap: 20px;
        }

        .date-picker {
            flex: 1;
        }

        .total-amount {
            text-align: right;
            font-size: 20px;
            font-weight: bold;
            margin: 20px 0;
        }

        .btn-submit {
            width: 100%;
            padding: 15px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-submit:hover {
            background: var(--dark);
        }

        .error-message {
            color: var(--accent);
            padding: 10px;
            background: rgba(227, 24, 55, 0.1);
            border-radius: 6px;
            margin-bottom: 20px;
        }

        .success-message {
            color: green;
            padding: 10px;
            background: rgba(0, 255, 0, 0.1);
            border-radius: 6px;
            margin-bottom: 20px;
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
        <div class="header">
            <h1>Book Venue</h1>
            <a href="${pageContext.request.contextPath}/UserVenueController" class="btn">
                <i class="fas fa-arrow-left"></i> Back to Venues
            </a>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <div class="booking-container">
            <div class="booking-header">
                <h1><%= venue.getName() %></h1>
                <p>Please select your booking dates</p>
            </div>

            <div class="venue-info">

<% if (venue.getImages() != null && !venue.getImages().isEmpty()) { 
       byte[] imageBytes = venue.getImages().get(0);
       String base64Image = Base64.getEncoder().encodeToString(imageBytes);
%>

    <img src="data:image/jpeg;base64,<%= base64Image %>" 
         alt="<%= venue.getName() %>" 
         class="venue-image">

<% } else { %>

    <img src="https://source.unsplash.com/600x400/?wedding,hall" 
         alt="Wedding Venue" 
         class="venue-image">

<% } %>

    <div class="venue-details">
        <h2><%= venue.getName() %></h2>
        <p><i class="fas fa-map-marker-alt"></i> <%= venue.getLocation() %></p>
        <div class="venue-price">₹<%= String.format("%.2f", venue.getPrice()) %> per day</div>
        <p><i class="fas fa-users"></i> Capacity: <%= venue.getCapacity() %> guests</p>
    </div>

</div>


            <form action="${pageContext.request.contextPath}/BookingController" method="post">
                <input type="hidden" name="venueId" value="<%= venue.getId() %>">

                <div class="date-picker-container">
                    <div class="form-group date-picker">
                        <label for="fromDate">From Date</label>
                        <input type="date" id="fromDate" name="fromDate" required>
                    </div>

                    <div class="form-group date-picker">
                        <label for="toDate">To Date</label>
                        <input type="date" id="toDate" name="toDate" required>
                    </div>
                </div>

                <div class="total-amount">
                    Total Amount: <span id="totalAmount">₹0.00</span>
                </div>

                <button type="submit" class="btn-submit">
                    <i class="fas fa-calendar-check"></i> Submit Booking Request
                </button>
            </form>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>
<script>
    $(document).ready(function() {
        const pricePerDay = <%= venue.getPrice() %>;
        
        function calculateTotal() {
            const fromDate = new Date($('#fromDate').val());
            const toDate = new Date($('#toDate').val());
            
            if ($('#fromDate').val() && $('#toDate').val() && fromDate <= toDate) {
                const timeDiff = toDate.getTime() - fromDate.getTime();
                const daysDiff = Math.ceil(timeDiff / (1000 * 3600 * 24)) + 1;
                const total = daysDiff * pricePerDay;
                $('#totalAmount').text('₹' + total.toFixed(2));
            } else {
                $('#totalAmount').text('₹0.00');
            }
        }
        
        $('#fromDate, #toDate').change(calculateTotal);
        
        // Set min date to today
        const today = new Date().toISOString().split('T')[0];
        $('#fromDate').attr('min', today);
        $('#toDate').attr('min', today);
    });
</script>
</body>
</html>
   
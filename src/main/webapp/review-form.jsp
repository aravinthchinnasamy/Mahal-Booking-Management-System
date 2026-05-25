 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.Booking" %>
<%
    int bookingId = (int) request.getAttribute("bookingId");
    int venueId = (int) request.getAttribute("venueId");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Write Review | Royal Mahal</title>
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
            background: #f5f7f9;
            color: var(--dark);
        }
        
        .container {
            display: flex;
            min-height: 100vh;
        }
        
        /* Main Content */
        .main-content {
            flex: 1;
            padding: 30px;
        }
        
        .header {
            margin-bottom: 30px;
        }
        
        .header h1 {
            color: var(--primary);
            font-size: 2rem;
        }
        
        /* Review Form */
        .review-form {
            background: white;
            border-radius: 10px;
            padding: 30px;
            max-width: 600px;
            margin: 0 auto;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--dark);
        }
        
        .rating-stars {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
        }
        
        .rating-stars input {
            display: none;
        }
        
        .rating-stars label {
            font-size: 2rem;
            color: #ddd;
            cursor: pointer;
            transition: color 0.2s;
        }
        
        .rating-stars input:checked ~ label,
        .rating-stars input:checked ~ label ~ label {
            color: #ffc107;
        }
        
        .rating-stars label:hover,
        .rating-stars label:hover ~ label {
            color: #ffc107;
        }
        
        textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            min-height: 120px;
            resize: vertical;
        }
        
        .btn {
            padding: 12px 25px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
        }
        
        .btn-primary {
            background: var(--primary);
            color: white;
        }
        
        .btn-primary:hover {
            background: var(--dark);
        }
        
        .btn-secondary {
            background: white;
            color: var(--primary);
            border: 1px solid var(--primary);
        }
        
        .btn-secondary:hover {
            background: var(--light);
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
            <li><a href="${pageContext.request.contextPath}/user-dashboard.jsp" class="active">
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
            <h1>Write Your Review</h1>
        </div>
        
        <% if (request.getAttribute("error") != null) { %>
            <div style="color: red; margin-bottom: 20px; padding: 10px; background: #ffeeee; border-radius: 5px;">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/ReviewController" method="post" class="review-form">
            <input type="hidden" name="action" value="submit">
            <input type="hidden" name="venueId" value="<%= venueId %>">
            <input type="hidden" name="bookingId" value="<%= bookingId %>">
            
            <div class="form-group">
                <label>Rating</label>
                <div class="rating-stars">
                    <input type="radio" id="star1" name="rating" value="1" required>
                    <label for="star1"><i class="fas fa-star"></i></label>
                    
                    <input type="radio" id="star2" name="rating" value="2">
                    <label for="star2"><i class="fas fa-star"></i></label>
                    
                    <input type="radio" id="star3" name="rating" value="3">
                    <label for="star3"><i class="fas fa-star"></i></label>
                    
                    <input type="radio" id="star4" name="rating" value="4">
                    <label for="star4"><i class="fas fa-star"></i></label>
                    
                    <input type="radio" id="star5" name="rating" value="5">
                    <label for="star5"><i class="fas fa-star"></i></label>
                </div>
            </div>
            
            <div class="form-group">
                <label for="comment">Your Review</label>
                <textarea id="comment" name="comment" placeholder="Share your experience..." required></textarea>
            </div>
            
            <div style="display: flex; gap: 10px;">
                <button type="submit" class="btn btn-primary">Submit Review</button>
                <a href="${pageContext.request.contextPath}/BookingController?action=confirmed" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const stars = document.querySelectorAll('.rating-stars label');
        
        stars.forEach(star => {
            star.addEventListener('click', function() {
                const radio = this.previousElementSibling;
                radio.checked = true;
                updateStars();
            });
            
            star.addEventListener('mouseover', function() {
                const radio = this.previousElementSibling;
                const value = parseInt(radio.value);
                highlightStars(value);
            });
            
            star.addEventListener('mouseout', function() {
                updateStars();
            });
        });
        
        function highlightStars(count) {
            stars.forEach((star, index) => {
                const starValue = parseInt(star.previousElementSibling.value);
                if (starValue <= count) {
                    star.style.color = '#ffc107';
                } else {
                    star.style.color = '#ddd';
                }
            });
        }
        
        function updateStars() {
            const checkedStar = document.querySelector('.rating-stars input:checked');
            if (checkedStar) {
                highlightStars(parseInt(checkedStar.value));
            } else {
                stars.forEach(star => {
                    star.style.color = '#ddd';
                });
            }
        }
    });
</script>
</body>
</html>
   
    
       
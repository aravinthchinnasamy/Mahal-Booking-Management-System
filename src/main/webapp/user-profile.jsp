<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("user-login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Royal Mahal | User Profile</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
:root {
    --primary: #8b5a2b;
    --secondary: #d4a76a;
    --dark: #3d2b1f;
    --light: #f8f4e9;
    --gray: #6c757d;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI', sans-serif;
}

body {
    background: var(--light);
    min-height: 100vh;
    display: flex;
}

/* SIDEBAR */
.sidebar {
    width: 260px;
    background: linear-gradient(180deg, #3d2b1f, #2a1c13);
    color: #fff;
}

.sidebar-header {
    text-align: center;
    padding: 25px;
    border-bottom: 1px solid rgba(255,255,255,0.1);
}

.sidebar-header h2 {
    color: var(--secondary);
}

.sidebar-menu {
    list-style: none;
    margin-top: 20px;
}

.sidebar-menu a {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 14px 22px;
    color: #ddd;
    text-decoration: none;
    transition: 0.3s;
}

.sidebar-menu a:hover,
.sidebar-menu a.active {
    background: rgba(255,255,255,0.12);
    border-left: 4px solid var(--secondary);
    color: #fff;
}

/* MAIN */
.main-content {
    flex: 1;
    display: flex;
    flex-direction: column;
}

/* TOP BAR */
.top-bar {
    background: #fff;
    padding: 15px 25px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.back-btn {
    background: var(--primary);
    color: #fff;
    padding: 8px 16px;
    border-radius: 5px;
    text-decoration: none;
    font-weight: 600;
}

.back-btn:hover {
    background: var(--dark);
}

/* PROFILE */
.profile-section {
    padding: 30px;
    flex: 1;
}

.profile-container {
    background: #fff;
    max-width: 850px;
    margin: auto;
    padding: 35px;
    border-radius: 10px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.1);
}

.profile-header {
    text-align: center;
    margin-bottom: 25px;
}

.profile-header h2 {
    color: var(--primary);
}

.profile-content {
    display: flex;
    gap: 30px;
    flex-wrap: wrap;
}

.profile-info,
.password-change {
    flex: 1;
    min-width: 300px;
}

.profile-info h3,
.password-change h3 {
    color: var(--primary);
    border-bottom: 2px solid var(--secondary);
    padding-bottom: 8px;
    margin-bottom: 18px;
}

.form-group {
    margin-bottom: 18px;
}

label {
    font-weight: 600;
    margin-bottom: 6px;
    display: block;
}

.input-with-icon {
    position: relative;
}

.input-with-icon i {
    position: absolute;
    top: 50%;
    left: 14px;
    transform: translateY(-50%);
    color: var(--gray);
}

.input-with-icon input {
    width: 100%;
    padding: 12px 14px 12px 42px;
    border-radius: 5px;
    border: 1px solid #ccc;
}

.btn {
    background: var(--primary);
    color: #fff;
    padding: 12px 22px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.btn:hover {
    background: var(--dark);
}

.error-message {
    background: #ffe5e5;
    color: red;
    padding: 10px;
    border-radius: 5px;
    margin-bottom: 15px;
}

.success-message {
    background: #e7ffe7;
    color: green;
    padding: 10px;
    border-radius: 5px;
    margin-bottom: 15px;
}

footer {
    background: var(--dark);
    color: #aaa;
    text-align: center;
    padding: 12px;
}
</style>
</head>

<body>

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

        <li><a href="${pageContext.request.contextPath}/BookingController?action=confirmed">
            <i class="fas fa-calendar-alt"></i> Confirmed Bookings</a></li>

        <li><a class="active">
            <i class="fas fa-user"></i> User Profile</a></li>

        <li><a href="${pageContext.request.contextPath}/UserLogoutController">
            <i class="fas fa-sign-out-alt"></i> Logout</a></li>
    </ul>
</div>

<!-- MAIN CONTENT -->
<div class="main-content">

    <div class="top-bar">
        <h3>User Profile</h3>
        <a href="${pageContext.request.contextPath}/UserVenueController" class="back-btn">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>

    <div class="profile-section">
        <div class="profile-container">

            <% if (request.getAttribute("error") != null) { %>
                <div class="error-message"><%= request.getAttribute("error") %></div>
            <% } %>

            <% if (request.getAttribute("success") != null) { %>
                <div class="success-message"><%= request.getAttribute("success") %></div>
            <% } %>

            <div class="profile-content">

                <!-- PROFILE INFO -->
                <div class="profile-info">
                    <h3>Personal Information</h3>
                    <form action="${pageContext.request.contextPath}/UserProfileController" method="post">
                        <input type="hidden" name="action" value="updateProfile">

                        <div class="form-group">
                            <label>Full Name</label>
                            <div class="input-with-icon">
                                <i class="fas fa-user"></i>
                                <input type="text" name="name" value="<%= user.getName() %>" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Mobile</label>
                            <div class="input-with-icon">
                                <i class="fas fa-phone"></i>
                                <input type="text" name="mobile" value="<%= user.getMobile() %>" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Email</label>
                            <div class="input-with-icon">
                                <i class="fas fa-envelope"></i>
                                <input type="email" name="email" value="<%= user.getEmail() %>" required>
                            </div>
                        </div>

                        <button class="btn">Update Profile</button>
                    </form>
                </div>

                <!-- PASSWORD -->
                <div class="password-change">
                    <h3>Change Password</h3>
                    <form action="${pageContext.request.contextPath}/UserProfileController" method="post">
                        <input type="hidden" name="action" value="changePassword">

                        <div class="form-group">
                            <label>Current Password</label>
                            <div class="input-with-icon">
                                <i class="fas fa-lock"></i>
                                <input type="password" name="currentPassword" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>New Password</label>
                            <div class="input-with-icon">
                                <i class="fas fa-lock"></i>
                                <input type="password" id="newPassword" name="newPassword" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Confirm Password</label>
                            <div class="input-with-icon">
                                <i class="fas fa-lock"></i>
                                <input type="password" id="confirmPassword" required>
                            </div>
                        </div>

                        <button class="btn">Change Password</button>
                    </form>
                </div>

            </div>
        </div>
    </div>

    <footer>
        © 2026 Royal Mahal. All Rights Reserved.
    </footer>

</div>

<script>
document.querySelector('form[action*="changePassword"]').addEventListener('submit', function(e){
    if(document.getElementById('newPassword').value !==
       document.getElementById('confirmPassword').value){
        e.preventDefault();
        alert("Passwords do not match!");
    }
});
</script>

</body>
</html>
   
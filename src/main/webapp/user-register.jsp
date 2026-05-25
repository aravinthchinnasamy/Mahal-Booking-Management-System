<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Royal Mahal - User Registration</title>
    <!-- Font Awesome -->
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
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .container {
            max-width: 1200px;
            margin: auto;
            padding: 0 20px;
        }

        /* Header */
        header {
            background: #fff;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
        }

        .header-top {
            display: flex;
            align-items: center;
            padding: 15px 0;
        }

        .logo {
            display: flex;
            align-items: center;
        }

        .logo img {
            height: 50px;
            margin-right: 10px;
        }

        .logo h1 {
            font-size: 1.8rem;
            color: var(--primary);
        }

        .logo span {
            color: var(--accent);
        }

        /* Registration */
        .register-section {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            background: url('https://t4.ftcdn.net/jpg/18/54/08/97/360_F_1854089740_UM49ykGF5wc05Anh5J6QcgGcNXD2Maz0.jpg') no-repeat center/cover;
            padding: 40px 0;
        }

        .register-container {
            background: #fff;
            padding: 40px;
            border-radius: 10px;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
        }

        .register-header {
            text-align: center;
            margin-bottom: 25px;
        }

        .register-header h2 {
            color: var(--primary);
            margin-bottom: 10px;
        }

        .register-header p {
            color: var(--gray);
        }

        .form-group {
            margin-bottom: 18px;
        }

        label {
            font-weight: 600;
            margin-bottom: 6px;
            display: block;
            color: var(--dark);
        }

        .input-with-icon {
            position: relative;
        }

        .input-with-icon i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray);
        }

        .input-with-icon input {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
            transition: all 0.3s;
        }

        .input-with-icon input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(139, 90, 43, 0.1);
            outline: none;
        }

        .register-btn {
            width: 100%;
            padding: 12px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }

        .register-btn:hover {
            background: var(--dark);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
        }

        .error-message {
            color: var(--accent);
            margin-bottom: 15px;
            padding: 10px;
            background: rgba(227, 24, 55, 0.1);
            border-radius: 5px;
        }

        .success-message {
            color: green;
            margin-bottom: 15px;
            padding: 10px;
            background: rgba(0, 255, 0, 0.1);
            border-radius: 5px;
        }

        .login-link {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: var(--primary);
            font-weight: 600;
            text-decoration: none;
        }

        .login-link:hover {
            text-decoration: underline;
        }

        footer {
            background: var(--dark);
            color: #aaa;
            text-align: center;
            padding: 15px;
            margin-top: auto;
        }

        /* Error text styles */
        .error-text {
            color: var(--accent);
            font-size: 0.8rem;
            margin-top: 5px;
            display: none;
        }

        @media (max-width: 768px) {
            .register-container {
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Session Check -->
    <%
        // Redirect to dashboard if already logged in
        if (session.getAttribute("user") != null) {
            response.sendRedirect("user-dashboard.jsp");
            return;
        }
    %>

<header>
    <div class="container">
        <div class="header-top">
            <div class="logo">
                <img src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MCIgaGVpZ2h0PSI1MCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiM4YjVhMmIiIHN0cm9rZS13aWR0aD0iMiIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj48cGF0aCBkPSJNMyA5bDktNyA5IDd2MTFhMiAyIDAgMCAxLTIgMkg1YTIgMiAwIDAgMS0yLTJ6Ij48L3BhdGg+PHBvbHlsaW5lIHBvaW50cz0iOSAyMiA5IDEyIDE1IDEyIDE1IDIyIj48L3BvbHlsaW5lPjwvc3ZnPg==" alt="Royal Mahal Logo">
                <h1>Royal <span>Mahal</span></h1>
            </div>
        </div>
    </div>
</header>

<section class="register-section">
    <div class="register-container">
        <div class="register-header">
            <h2>Create Account</h2>
            <p>Register to book premium wedding venues</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <% if (request.getAttribute("success") != null) { %>
            <div class="success-message">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <form id="registrationForm" action="${pageContext.request.contextPath}/UserRegisterController" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <label>Full Name</label>
                <div class="input-with-icon">
                    <i class="fas fa-user"></i>
                    <input type="text" name="name" id="name" placeholder="Enter your full name" required>
                </div>
                <small id="nameError" class="error-text"></small>
            </div>

            <div class="form-group">
                <label>Mobile Number</label>
                <div class="input-with-icon">
                    <i class="fas fa-phone"></i>
                    <input type="tel" name="mobile" id="mobile" placeholder="Enter 10-digit mobile number" required>
                </div>
                <small id="mobileError" class="error-text"></small>
            </div>

            <div class="form-group">
                <label>Email</label>
                <div class="input-with-icon">
                    <i class="fas fa-envelope"></i>
                    <input type="email" name="email" id="email" placeholder="Enter your email address" required>
                </div>
                <small id="emailError" class="error-text"></small>
            </div>

            <div class="form-group">
                <label>Password</label>
                <div class="input-with-icon">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" id="password" placeholder="Enter password (min 6 characters)" required>
                </div>
                <small id="passwordError" class="error-text"></small>
            </div>

            <button type="submit" class="register-btn">Register</button>
        </form>

        <a class="login-link" href="${pageContext.request.contextPath}/user-login.jsp">
            Already have an account? Login
        </a>
    </div>
</section>

<footer>
    <div class="container">
        <p>&copy; 2023 Royal Mahal. All Rights Reserved.</p>
    </div>
</footer>

<script>
    function validateForm() {
        // Reset errors
        document.querySelectorAll('.error-text').forEach(el => {
            el.style.display = 'none';
            el.textContent = '';
        });
        
        let isValid = true;
        
        // Name validation
        const name = document.getElementById('name').value.trim();
        if (name === '') {
            showError('nameError', 'Name is required');
            isValid = false;
        }
        
        // Mobile validation
        const mobile = document.getElementById('mobile').value.trim();
        const mobileRegex = /^\d{10}$/;
        if (!mobileRegex.test(mobile)) {
            showError('mobileError', 'Please enter a valid 10-digit phone number');
            isValid = false;
        }
        
        // Email validation
        const email = document.getElementById('email').value.trim();
        const emailRegex = /^[A-Za-z0-9+_.-]+@(.+)$/;
        if (!emailRegex.test(email)) {
            showError('emailError', 'Please enter a valid email address');
            isValid = false;
        }
        
        // Password validation
        const password = document.getElementById('password').value;
        if (password.length < 6) {
            showError('passwordError', 'Password must be at least 6 characters');
            isValid = false;
        }
        
        return isValid;
    }
    
    function showError(elementId, message) {
        const element = document.getElementById(elementId);
        element.textContent = message;
        element.style.display = 'block';
    }
</script>
</body>
</html>

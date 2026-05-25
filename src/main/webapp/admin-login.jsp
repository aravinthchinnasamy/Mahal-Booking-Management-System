<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Royal Mahal - Admin Login</title>
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
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .container {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* Header Styles */
        header {
            background-color: white;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .header-top {
            display: flex;
            justify-content: space-between;
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
            font-weight: 700;
        }

        .logo span {
            color: var(--accent);
        }

        /* Login Section */
        .login-section {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 80vh;
            padding: 40px 0;
            background-image: url('https://t4.ftcdn.net/jpg/18/54/08/97/360_F_1854089740_UM49ykGF5wc05Anh5J6QcgGcNXD2Maz0.jpg');
            background-repeat: no-repeat;
            background-attachment: fixed;
            background-size: cover;
        }

        .login-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
            width: 100%;
            max-width: 450px;
            padding: 40px;
            text-align: center;
        }

        .login-header {
            margin-bottom: 30px;
        }

        .login-header h2 {
            font-size: 2rem;
            color: #800000;
            margin-bottom: 10px;
        }

        .login-header p {
            color: var(--gray);
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
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

        .login-btn {
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

        .login-btn:hover {
            background: var(--dark);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
        }

        .error-message {
            color: var(--accent);
            margin-top: 15px;
            padding: 10px;
            background: rgba(227, 24, 55, 0.1);
            border-radius: 5px;
            display: ${not empty error ? 'block' : 'none'};
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        /* Footer */
        footer {
            background: var(--dark);
            color: white;
            padding: 40px 0 20px;
            margin-top: auto;
        }

        .copyright {
            text-align: center;
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            font-size: 0.9rem;
            color: #aaa;
        }

        @media (max-width: 768px) {
            .login-container {
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
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

    <!-- Login Section -->
    <section class="login-section">
        <div class="container">
            <div class="login-container">
                <div class="login-header">
                    <h2>Admin Login</h2>
                    <p>Access the admin dashboard to manage bookings</p>
                </div>
                
                <form action="${pageContext.request.contextPath}/AdminLoginController" method="POST">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <div class="input-with-icon">
                            <i class="fas fa-user"></i>
                            <input type="text" id="username" name="username" placeholder="Enter your username" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">Password</label>
                        <div class="input-with-icon">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="password" name="password" placeholder="Enter your password" required>
                        </div>
                    </div>
                    
                    <button type="submit" class="login-btn">Login</button>
                    
                    <% if(request.getAttribute("error") != null) { %>
                        <div class="error-message">
                            <%= request.getAttribute("error") %>
                        </div>
                    <% } %>
                </form>
                
                <a href="${pageContext.request.contextPath}/" class="back-link">
                    <i class="fas fa-arrow-left"></i> Back to Home
                </a>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="copyright">
                <p>&copy; 2023 Royal Mahal. All Rights Reserved. | Designed with <i class="fas fa-heart" style="color: var(--accent);"></i> for your special day</p>
            </div>
        </div>
    </footer>

    <script>
        // Simple form validation
        document.addEventListener('DOMContentLoaded', function() {
            const loginForm = document.querySelector('form');
            
            loginForm.addEventListener('submit', function(e) {
                let isValid = true;
                const username = document.getElementById('username');
                const password = document.getElementById('password');
                
                if (username.value.trim() === '') {
                    isValid = false;
                    highlightError(username);
                }
                
                if (password.value.trim() === '') {
                    isValid = false;
                    highlightError(password);
                }
                
                if (!isValid) {
                    e.preventDefault();
                }
            });
            
            function highlightError(input) {
                input.style.borderColor = 'var(--accent)';
                input.style.boxShadow = '0 0 0 3px rgba(227, 24, 55, 0.1)';
                
                // Remove error highlight after 3 seconds
                setTimeout(() => {
                    input.style.borderColor = '#ddd';
                    input.style.boxShadow = 'none';
                }, 3000);
            }
        });
    </script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.MahalBooking.Model.Venue" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
<%
    Venue venue = (Venue) request.getAttribute("venue");
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Venue | Royal Mahal</title>
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
            --gray: #6b7280;
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

        .container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 260px;
            background: var(--dark);
            color: #fff;
            padding: 25px 0;
        }

        .sidebar-header {
            padding: 0 25px 25px;
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

        .header h1 {
            font-size: 26px;
            color: var(--primary);
        }

        .btn {
            padding: 10px 20px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 600;
            transition: 0.3s;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-secondary {
            background: var(--gray);
        }

        .btn:hover {
            opacity: 0.9;
        }

        /* Form */
        .form-container {
            background: var(--card);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.05);
            max-width: 800px;
            margin: 0 auto;
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

        .form-group label.required:after {
            content: " *";
            color: var(--danger);
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
        }

        .form-group textarea {
            min-height: 100px;
            resize: vertical;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 30px;
        }

        /* Image Inputs */
        .image-group {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .image-group input {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
        }

        .btn-remove {
            background: var(--danger);
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 5px;
            transition: 0.3s;
        }

        .btn-remove:hover {
            opacity: 0.9;
        }

        .btn-remove:disabled {
            background: #999;
            cursor: not-allowed;
            opacity: 0.5;
        }

        .btn-add {
            background: var(--success);
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            margin-top: 10px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: 0.3s;
        }

        .btn-add:hover {
            opacity: 0.9;
        }

        /* Messages */
        .error-message {
            background: rgba(239,68,68,0.1);
            color: var(--danger);
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            border-left: 4px solid var(--danger);
        }

        .success-message {
            background: rgba(16,185,129,0.1);
            color: var(--success);
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            border-left: 4px solid var(--success);
        }

        .info-message {
            background: rgba(59,130,246,0.1);
            color: var(--secondary);
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            border-left: 4px solid var(--secondary);
        }

        .btn-secondary {
            background: var(--gray);
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
            <li><a href="VenueController" class="active"><i class="fas fa-building"></i> Venue Management</a></li>
            <li><a href="AdminBookingController"><i class="fas fa-calendar-alt"></i> Booking Management</a></li>
            <li><a href="AdminPaymentController"><i class="fas fa-money-bill-wave"></i> Payments</a></li>
            <li><a href="AdminReviewController"><i class="fas fa-star"></i> Reviews</a></li>
            <li><a href="AdminLogoutController"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <h1>Edit Venue</h1>
            <a href="VenueController" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back
            </a>
        </div>

        <div class="form-container">
            <% if (request.getAttribute("error") != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <% if (request.getAttribute("success") != null) { %>
                <div class="success-message">
                    <i class="fas fa-check-circle"></i> <%= request.getAttribute("success") %>
                </div>
            <% } %>
            
            <% if (venue != null) { %>
            <div class="info-message">
                <i class="fas fa-info-circle"></i> Editing venue: <%= venue.getName() %>
            </div>
            
            <form action="VenueController" 
      method="post" 
      enctype="multipart/form-data" id="venueForm" onsubmit="return validateForm()">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= venue.getId() %>">
                
                <div class="form-group">
                    <label for="name" class="required">Venue Name</label>
                    <input type="text" id="name" name="name" value="<%= venue.getName() != null ? venue.getName() : "" %>" 
                           required placeholder="Enter venue name" maxlength="255">
                </div>
                
                <div class="form-group">
                    <label for="location" class="required">Location</label>
                    <input type="text" id="location" name="location" value="<%= venue.getLocation() != null ? venue.getLocation() : "" %>" 
                           required placeholder="Enter venue location" maxlength="255">
                </div>
                
                <div class="form-group">
                    <label for="description" class="required">Description</label>
                    <textarea id="description" name="description" required 
                              placeholder="Describe the venue..." rows="4" maxlength="2000"><%= venue.getDescription() != null ? venue.getDescription() : "" %></textarea>
                </div>
                
                <div class="form-group">
                    <label for="capacity" class="required">Capacity</label>
                    <input type="number" id="capacity" name="capacity" min="1" max="99999" 
                           value="<%= venue.getCapacity() %>" required placeholder="Enter maximum capacity">
                </div>
                
                <div class="form-group">
                    <label for="price" class="required">Price (₹)</label>
                    <input type="number" id="price" name="price" min="0" step="0.01" 
                           max="99999999.99" value="<%= venue.getPrice() %>" required placeholder="Enter price per day">
                </div>
                
                <div class="form-group">
                    <label for="amenities" class="required">Amenities</label>
                    <input type="text" id="amenities" name="amenities" 
                           value="<%= venue.getAmenities() != null ? venue.getAmenities() : "" %>" 
                           placeholder="AC, Parking, Catering, etc." required maxlength="1000">
                </div>
                
   <%--              <div class="form-group">
    <label>Existing Images</label>

    <% if (venue.getImages() != null && !venue.getImages().isEmpty()) { %>
        <div style="display:flex; gap:10px; flex-wrap:wrap;">
            <% for (byte[] img : venue.getImages()) {
                   String base64 = Base64.getEncoder().encodeToString(img);
            %>
                <img src="data:image/jpeg;base64,<%= base64 %>"
                     style="width:120px; height:90px; object-fit:cover; border-radius:6px;">
            <% } %>
        </div>
    <% } else { %>
        <p>No Images Available</p>
    <% } %>
</div> --%>
<div class="form-group">
    <label>Existing Images</label>

    <% if (venue.getImages() != null && !venue.getImages().isEmpty()) { %>
        <div style="display:flex; gap:10px; flex-wrap:wrap;">
            <% 
                int index = 0;
                for (byte[] img : venue.getImages()) {
                    String base64 = Base64.getEncoder().encodeToString(img);
            %>

                <div style="position:relative;">
                    <img src="data:image/jpeg;base64,<%= base64 %>"
                         style="width:120px; height:90px; object-fit:cover; border-radius:6px;">

                    <!-- Checkbox to remove image -->
                    <div style="text-align:center; margin-top:5px;">
                        <input type="checkbox" name="removeImageIndex" value="<%= index %>">
                        Remove
                    </div>
                </div>

            <% 
                index++;
                }
            %>
        </div>
    <% } else { %>
        <p>No Images Available</p>
    <% } %>
</div>

<div class="form-group">
    <label>Upload New Images (Optional)</label>

    <input type="file" name="images" accept="image/*" multiple>
</div>

                    
                    <button type="button" class="btn-add" onclick="addImageInput()">
                        <i class="fas fa-plus"></i> Add Another Image
                    </button>
                    <small style="display: block; margin-top: 8px; color: #666;">
                        You can add multiple image URLs. Accepts any valid URL: http://..., https://..., //..., data:..., or relative paths
                    </small>
                </div>
                
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="window.location.href='VenueController'">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                    <button type="reset" class="btn btn-secondary">
                        <i class="fas fa-undo"></i> Reset Form
                    </button>
                    <button type="submit" class="btn">
                        <i class="fas fa-save"></i> Update Venue
                    </button>
                </div>
            </form>
            <% } else { %>
                <div class="error-message">
                    <i class="fas fa-times-circle"></i> Venue not found
                </div>
            <% } %>
        </div>
    </div>
</div>

<script>
    // Function to add a new image input field
    function addImageInput() {
        const container = document.getElementById('image-inputs');
        const newDiv = document.createElement('div');
        newDiv.className = 'image-group';
        newDiv.innerHTML = `
            <input type="text" name="imageUrls" 
                   placeholder="Enter image URL" 
                   required>
            <button type="button" class="btn-remove" onclick="removeImageInput(this)">
                <i class="fas fa-trash"></i> Remove
            </button>
        `;
        container.appendChild(newDiv);
        updateRemoveButtons();
    }
    
    // Function to remove an image input field
    function removeImageInput(button) {
        const container = document.getElementById('image-inputs');
        const imageGroups = container.querySelectorAll('.image-group');
        
        if (imageGroups.length > 1) {
            button.parentElement.remove();
        }
        updateRemoveButtons();
    }
    
    // Function to update the state of remove buttons
    function updateRemoveButtons() {
        const container = document.getElementById('image-inputs');
        const imageGroups = container.querySelectorAll('.image-group');
        const removeButtons = container.querySelectorAll('.btn-remove');
        
        // If there's only one image input, disable removal
        removeButtons.forEach((btn, index) => {
            if (imageGroups.length === 1) {
                btn.disabled = true;
                btn.style.opacity = '0.5';
                btn.style.cursor = 'not-allowed';
            } else {
                btn.disabled = false;
                btn.style.opacity = '1';
                btn.style.cursor = 'pointer';
            }
        });
    }
    
    // Form validation
   function validateForm() {

    const name = document.getElementById('name').value.trim();
    const location = document.getElementById('location').value.trim();
    const description = document.getElementById('description').value.trim();
    const capacity = document.getElementById('capacity').value;
    const price = document.getElementById('price').value;
    const amenities = document.getElementById('amenities').value.trim();

    if (!name || !location || !description || !capacity || !price || !amenities) {
        alert('Please fill in all required fields.');
        return false;
    }

    const capacityNum = parseInt(capacity);
    if (isNaN(capacityNum) || capacityNum <= 0) {
        alert('Please enter valid capacity.');
        return false;
    }

    const priceNum = parseFloat(price);
    if (isNaN(priceNum) || priceNum <= 0) {
        alert('Please enter valid price.');
        return false;
    }

    return true;
}

</script>
</body>
</html>
     
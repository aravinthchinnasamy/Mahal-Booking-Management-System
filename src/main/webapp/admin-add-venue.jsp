<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add New Venue | Royal Mahal</title>
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
            transform: translateY(-2px);
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
        .form-group textarea,
        .form-group select {
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
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-remove:disabled {
            background: var(--gray);
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
            <h1>Add New Venue</h1>
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
            
            <div class="info-message">
                <i class="fas fa-info-circle"></i> Please fill in all required fields.
            </div>
            
            
           <form action="VenueController" method="post"
      enctype="multipart/form-data"
      id="venueForm"
      onsubmit="return validateForm()">

            
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label for="name" class="required">Venue Name</label>
                    <input type="text" id="name" name="name" required 
                           placeholder="Enter venue name" maxlength="255">
                </div>
                
                <div class="form-group">
                    <label for="location" class="required">Location</label>
                    <input type="text" id="location" name="location" required 
                           placeholder="Enter venue location" maxlength="255">
                </div>
                
                <div class="form-group">
                    <label for="description" class="required">Description</label>
                    <textarea id="description" name="description" required 
                              placeholder="Describe the venue..." rows="4" maxlength="2000"></textarea>
                </div>
                
                <div class="form-group">
                    <label for="capacity" class="required">Capacity</label>
                    <input type="number" id="capacity" name="capacity" min="1" max="99999" 
                           required placeholder="Enter maximum capacity">
                </div>
                
                <div class="form-group">
                    <label for="price" class="required">Price (₹)</label>
                    <input type="number" id="price" name="price" min="0" step="0.01" 
                           max="99999999.99" required placeholder="Enter price per day">
                </div>
                
                <div class="form-group">
                    <label for="amenities" class="required">Amenities</label>
                    <input type="text" id="amenities" name="amenities" 
                           placeholder="AC, Parking, Catering, etc." required maxlength="1000">
                </div>
                
            
					<div class="form-group">
						<label class="required">Upload Venue Images</label>

						<div id="image-container">

							<div class="image-group">
								<input type="file" name="images" accept="image/*" required>

								<button type="button" class="btn-remove"
									onclick="removeImageField(this)">
									<i class="fas fa-trash"></i> Remove
								</button>
							</div>

						</div>

						<button type="button" class="btn-add" onclick="addImageField()">
							<i class="fas fa-plus"></i> Add Another Image
						</button>

						<small style="display: block; margin-top: 8px; color: #666;">
							You can upload multiple images (JPG, PNG, JPEG). </small>
					</div>


					<div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="resetForm()">
                        <i class="fas fa-undo"></i> Reset Form
                    </button>
                    <button type="submit" class="btn">
                        <i class="fas fa-save"></i> Save Venue
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function addImageField() {
    const container = document.getElementById("image-container");

    const div = document.createElement("div");
    div.className = "image-group";

    div.innerHTML = `
        <input type="file"
               name="images"
               accept="image/*">

        <button type="button"
                class="btn-remove"
                onclick="removeImageField(this)">
            <i class="fas fa-trash"></i> Remove
        </button>
    `;

    container.appendChild(div);
    updateRemoveButtons();
}

function removeImageField(button) {
    const container = document.getElementById("image-container");
    const groups = container.querySelectorAll(".image-group");

    if (groups.length > 1) {
        button.parentElement.remove();
    }

    updateRemoveButtons();
}

function updateRemoveButtons() {
    const container = document.getElementById("image-container");
    const groups = container.querySelectorAll(".image-group");
    const removeButtons = container.querySelectorAll(".btn-remove");

    removeButtons.forEach(btn => {
        if (groups.length === 1) {
            btn.disabled = true;
            btn.style.opacity = "0.5";
        } else {
            btn.disabled = false;
            btn.style.opacity = "1";
        }
    });
}

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

    const imageInputs = document.querySelectorAll('input[type="file"]');
    let hasFile = false;

    imageInputs.forEach(input => {
        if (input.files.length > 0) {
            hasFile = true;
        }
    });

    if (!hasFile) {
        alert("Please upload at least one image.");
        return false;
    }

    return true;
}

    // Reset form function
    function resetForm() {
        if (confirm('Are you sure you want to reset the form? All entered data will be lost.')) {
            document.getElementById('venueForm').reset();
            const container = document.getElementById('image-inputs');
            
            // Remove all but first image input
            while (container.children.length > 1) {
                container.removeChild(container.lastChild);
            }
            
            // Reset the first input
            const firstInput = container.querySelector('input[name="imageUrls"]');
            if (firstInput) {
                firstInput.value = '';
            }
            
            updateRemoveButtons();
        }
    }
    
    // Initialize the page
    document.addEventListener('DOMContentLoaded', function() {
        updateRemoveButtons();
    });
</script>
</body>
</html>
   
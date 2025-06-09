<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - Appointment Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 px-0 position-fixed sidebar">
                <div class="sidebar-brand">
                    <h2><i class="fas fa-calendar-check me-2"></i>AMS</h2>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="student-dashboard.jsp">
                            <i class="fas fa-tachometer-alt"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="book-appointment.jsp">
                            <i class="fas fa-calendar-plus"></i> Book Appointment
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="my-appointments.jsp">
                            <i class="fas fa-calendar-alt"></i> My Appointments
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="profile.jsp">
                            <i class="fas fa-user"></i> Profile
                        </a>
                    </li>
                    <li class="nav-item mt-auto">
                        <a class="nav-link" href="login">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 ms-auto main-content">
                <!-- Topbar -->
                <div class="topbar d-flex justify-content-between align-items-center">
                    <h4 class="mb-0">My Profile</h4>
                    <div class="d-flex align-items-center">
                        <span class="me-3"><i class="fas fa-bell"></i></span>
                        <span><i class="fas fa-user-circle"></i></span>
                    </div>
                </div>

                <div class="row">
                    <!-- Profile Information -->
                    <div class="col-lg-4">
                        <div class="card mb-4">
                            <div class="card-body text-center">
                                <img src="https://via.placeholder.com/150" class="rounded-circle mb-3" alt="Profile Picture">
                                <h5 class="mb-1"><%= session.getAttribute("username") %></h5>
                                <p class="text-muted mb-3">Student ID: 12345</p>
                                <div class="d-grid">
                                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#changePhotoModal">
                                        <i class="fas fa-camera me-2"></i>Change Photo
                                    </button>
                                </div>
                            </div>
                        </div>

                        <div class="card mb-4">
                            <div class="card-header">
                                <h6 class="m-0 font-weight-bold">Quick Stats</h6>
                            </div>
                            <div class="card-body">
                                <div class="row text-center">
                                    <div class="col-6 mb-3">
                                        <h6 class="text-muted">Appointments</h6>
                                        <h4 class="mb-0">15</h4>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <h6 class="text-muted">Completed</h6>
                                        <h4 class="mb-0">12</h4>
                                    </div>
                                    <div class="col-6">
                                        <h6 class="text-muted">Upcoming</h6>
                                        <h4 class="mb-0">3</h4>
                                    </div>
                                    <div class="col-6">
                                        <h6 class="text-muted">Cancelled</h6>
                                        <h4 class="mb-0">0</h4>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Profile Details -->
                    <div class="col-lg-8">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h6 class="m-0 font-weight-bold">Profile Information</h6>
                                <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                                    <i class="fas fa-edit me-2"></i>Edit Profile
                                </button>
                            </div>
                            <div class="card-body">
                                <% if (request.getAttribute("error") != null) { %>
                                    <div class="alert alert-danger">
                                        <%= request.getAttribute("error") %>
                                    </div>
                                <% } %>
                                <% if (request.getAttribute("success") != null) { %>
                                    <div class="alert alert-success">
                                        <%= request.getAttribute("success") %>
                                    </div>
                                <% } %>
                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <h6 class="font-weight-bold">Personal Information</h6>
                                        <hr>
                                        <div class="mb-3">
                                            <label class="text-muted">Full Name</label>
                                            <p class="mb-0">John Doe</p>
                                        </div>
                                        <div class="mb-3">
                                            <label class="text-muted">Email</label>
                                            <p class="mb-0">john.doe@university.edu</p>
                                        </div>
                                        <div class="mb-3">
                                            <label class="text-muted">Phone</label>
                                            <p class="mb-0">(555) 123-4567</p>
                                        </div>
                                        <div class="mb-3">
                                            <label class="text-muted">Date of Birth</label>
                                            <p class="mb-0">January 1, 2000</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <h6 class="font-weight-bold">Academic Information</h6>
                                        <hr>
                                        <div class="mb-3">
                                            <label class="text-muted">Student ID</label>
                                            <p class="mb-0">12345</p>
                                        </div>
                                        <div class="mb-3">
                                            <label class="text-muted">Major</label>
                                            <p class="mb-0">Computer Science</p>
                                        </div>
                                        <div class="mb-3">
                                            <label class="text-muted">Year Level</label>
                                            <p class="mb-0">3rd Year</p>
                                        </div>
                                        <div class="mb-3">
                                            <label class="text-muted">Academic Advisor</label>
                                            <p class="mb-0">Dr. Smith</p>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-12">
                                        <h6 class="font-weight-bold">Preferences</h6>
                                        <hr>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="text-muted">Preferred Contact Method</label>
                                                    <p class="mb-0">Email</p>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="text-muted">Preferred Appointment Time</label>
                                                    <p class="mb-0">Morning (9:00 AM - 12:00 PM)</p>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="mb-3">
                                                    <label class="text-muted">Notification Preferences</label>
                                                    <p class="mb-0">Email and SMS</p>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="text-muted">Language</label>
                                                    <p class="mb-0">English</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Security Settings -->
                        <div class="card mt-4">
                            <div class="card-header">
                                <h6 class="m-0 font-weight-bold">Security Settings</h6>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="text-muted">Password</label>
                                            <p class="mb-0">Last changed 30 days ago</p>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="text-muted">Two-Factor Authentication</label>
                                            <p class="mb-0">Not enabled</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="d-grid gap-2">
                                    <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#changePasswordModal">
                                        <i class="fas fa-key me-2"></i>Change Password
                                    </button>
                                    <button class="btn btn-outline-primary">
                                        <i class="fas fa-shield-alt me-2"></i>Enable Two-Factor Authentication
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Profile Modal -->
    <div class="modal fade" id="editProfileModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Profile</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="update-profile" method="POST">
                        <div class="mb-3">
                            <label for="fullName" class="form-label">Full Name</label>
                            <input type="text" class="form-control" id="fullName" name="fullName" value="John Doe">
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email" value="john.doe@university.edu">
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label">Phone</label>
                            <input type="tel" class="form-control" id="phone" name="phone" value="(555) 123-4567">
                        </div>
                        <div class="mb-3">
                            <label for="dob" class="form-label">Date of Birth</label>
                            <input type="date" class="form-control" id="dob" name="dob" value="2000-01-01">
                        </div>
                        <div class="mb-3">
                            <label for="major" class="form-label">Major</label>
                            <input type="text" class="form-control" id="major" name="major" value="Computer Science">
                        </div>
                        <div class="mb-3">
                            <label for="yearLevel" class="form-label">Year Level</label>
                            <select class="form-select" id="yearLevel" name="yearLevel">
                                <option value="1">1st Year</option>
                                <option value="2">2nd Year</option>
                                <option value="3" selected>3rd Year</option>
                                <option value="4">4th Year</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Change Password Modal -->
    <div class="modal fade" id="changePasswordModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Change Password</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="change-password" method="POST">
                        <div class="mb-3">
                            <label for="currentPassword" class="form-label">Current Password</label>
                            <input type="password" class="form-control" id="currentPassword" name="currentPassword">
                        </div>
                        <div class="mb-3">
                            <label for="newPassword" class="form-label">New Password</label>
                            <input type="password" class="form-control" id="newPassword" name="newPassword">
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">Confirm New Password</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword">
                        </div>
                        <button type="submit" class="btn btn-primary">Change Password</button>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Change Photo Modal -->
    <div class="modal fade" id="changePhotoModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Change Profile Photo</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="text-center mb-4">
                        <img src="https://via.placeholder.com/150" class="rounded-circle mb-3" alt="Current Photo">
                    </div>
                    <form>
                        <div class="mb-3">
                            <label for="profilePhoto" class="form-label">Upload New Photo</label>
                            <input type="file" class="form-control" id="profilePhoto" accept="image/*">
                        </div>
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            Recommended image size: 150x150 pixels. Maximum file size: 2MB.
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary">Upload Photo</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</body>
</html> 
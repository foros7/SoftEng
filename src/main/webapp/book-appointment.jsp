<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment - Appointment Management System</title>
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
                        <a class="nav-link active" href="book-appointment.jsp">
                            <i class="fas fa-calendar-plus"></i> Book Appointment
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="my-appointments.jsp">
                            <i class="fas fa-calendar-alt"></i> My Appointments
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="profile.jsp">
                            <i class="fas fa-user"></i> Profile
                        </a>
                    </li>
                    <li class="nav-item mt-auto">
                        <a class="nav-link" href="logout">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 ms-auto main-content">
                <!-- Topbar -->
                <div class="topbar d-flex justify-content-between align-items-center">
                    <h4 class="mb-0">Book New Appointment</h4>
                    <div class="d-flex align-items-center">
                        <span class="me-3"><i class="fas fa-bell"></i></span>
                        <span><i class="fas fa-user-circle"></i></span>
                    </div>
                </div>

                <!-- Appointment Form -->
                <div class="row">
                    <div class="col-lg-8">
                        <div class="card">
                            <div class="card-header">
                                <h6 class="m-0 font-weight-bold">Appointment Details</h6>
                            </div>
                            <div class="card-body">
                                <% if (request.getAttribute("error") != null) { %>
                                    <div class="alert alert-danger">
                                        <%= request.getAttribute("error") %>
                                    </div>
                                <% } %>
                                <form action="book-appointment" method="POST">
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="advisor" class="form-label">Select Advisor</label>
                                            <select class="form-select" id="advisor" name="advisor" required>
                                                <option value="">Choose an advisor...</option>
                                                <option value="1">Dr. Smith - Academic Advisor</option>
                                                <option value="2">Dr. Johnson - Course Planning</option>
                                                <option value="3">Dr. Williams - Career Counseling</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="appointmentType" class="form-label">Appointment Type</label>
                                            <select class="form-select" id="appointmentType" name="appointmentType" required>
                                                <option value="">Select type...</option>
                                                <option value="academic">Academic Advising</option>
                                                <option value="course">Course Planning</option>
                                                <option value="career">Career Counseling</option>
                                                <option value="other">Other</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="date" class="form-label">Preferred Date</label>
                                            <input type="date" class="form-control" id="date" name="date" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="time" class="form-label">Preferred Time</label>
                                            <select class="form-select" id="time" name="time" required>
                                                <option value="">Select time...</option>
                                                <option value="09:00">9:00 AM</option>
                                                <option value="10:00">10:00 AM</option>
                                                <option value="11:00">11:00 AM</option>
                                                <option value="14:00">2:00 PM</option>
                                                <option value="15:00">3:00 PM</option>
                                                <option value="16:00">4:00 PM</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="reason" class="form-label">Reason for Appointment</label>
                                        <textarea class="form-control" id="reason" name="reason" rows="4" required
                                            placeholder="Please provide details about the purpose of your appointment..."></textarea>
                                    </div>

                                    <div class="mb-3">
                                        <label for="additionalNotes" class="form-label">Additional Notes (Optional)</label>
                                        <textarea class="form-control" id="additionalNotes" name="additionalNotes" rows="3"
                                            placeholder="Any additional information you'd like to share..."></textarea>
                                    </div>

                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-calendar-check me-2"></i>Book Appointment
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-4">
                        <!-- Advisor Information -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h6 class="m-0 font-weight-bold">Advisor Information</h6>
                            </div>
                            <div class="card-body">
                                <div class="text-center mb-3">
                                    <img src="https://via.placeholder.com/150" class="rounded-circle mb-3" alt="Advisor">
                                    <h5 class="mb-1">Dr. Smith</h5>
                                    <p class="text-muted mb-3">Academic Advisor</p>
                                </div>
                                <div class="mb-3">
                                    <h6 class="font-weight-bold">Office Hours</h6>
                                    <p class="mb-1">Monday - Friday</p>
                                    <p class="mb-1">9:00 AM - 5:00 PM</p>
                                </div>
                                <div class="mb-3">
                                    <h6 class="font-weight-bold">Contact</h6>
                                    <p class="mb-1"><i class="fas fa-envelope me-2"></i>dr.smith@university.edu</p>
                                    <p class="mb-1"><i class="fas fa-phone me-2"></i>(555) 123-4567</p>
                                </div>
                            </div>
                        </div>

                        <!-- Appointment Guidelines -->
                        <div class="card">
                            <div class="card-header">
                                <h6 class="m-0 font-weight-bold">Appointment Guidelines</h6>
                            </div>
                            <div class="card-body">
                                <ul class="list-unstyled mb-0">
                                    <li class="mb-2">
                                        <i class="fas fa-check-circle text-success me-2"></i>
                                        Appointments are 30 minutes long
                                    </li>
                                    <li class="mb-2">
                                        <i class="fas fa-check-circle text-success me-2"></i>
                                        Please arrive 5 minutes early
                                    </li>
                                    <li class="mb-2">
                                        <i class="fas fa-check-circle text-success me-2"></i>
                                        Bring any relevant documents
                                    </li>
                                    <li class="mb-2">
                                        <i class="fas fa-check-circle text-success me-2"></i>
                                        Cancellations require 24-hour notice
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        // Set minimum date to today
        document.getElementById('date').min = new Date().toISOString().split('T')[0];
        
        // Update available time slots based on selected date
        document.getElementById('date').addEventListener('change', function() {
            // Here you would typically make an AJAX call to get available slots
            // For now, we'll just show all slots
        });
    </script>
</body>
</html> 
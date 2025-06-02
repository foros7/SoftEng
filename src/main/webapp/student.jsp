<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thesis Project Dashboard</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --success-color: #4cc9f0;
            --warning-color: #f72585;
            --light-color: #f8f9fa;
            --dark-color: #212529;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f5f7fb;
        }

        .sidebar {
            background: linear-gradient(180deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            min-height: 100vh;
            padding: 20px;
            color: white;
        }

        .sidebar-brand {
            padding: 20px 0;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
        }

        .sidebar-brand h2 {
            font-size: 24px;
            font-weight: 600;
            margin: 0;
        }

        .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 12px 20px;
            border-radius: 8px;
            margin-bottom: 5px;
            transition: all 0.3s ease;
        }

        .nav-link:hover, .nav-link.active {
            color: white;
            background-color: rgba(255, 255, 255, 0.1);
        }

        .nav-link i {
            width: 24px;
            text-align: center;
            margin-right: 10px;
        }

        .main-content {
            padding: 30px;
        }

        .topbar {
            background: white;
            padding: 15px 30px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }

        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card-header {
            background: white;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            padding: 20px;
        }

        .card-body {
            padding: 20px;
        }

        .stats-card {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
        }

        .stats-card .icon {
            font-size: 2.5rem;
            opacity: 0.8;
        }

        .stats-card .number {
            font-size: 2rem;
            font-weight: 600;
        }

        .stats-card .label {
            font-size: 0.9rem;
            opacity: 0.8;
        }

        .action-btn {
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .form-control {
            border-radius: 8px;
            padding: 12px;
            border: 1px solid #e0e0e0;
        }

        .form-control:focus {
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1);
            border-color: var(--primary-color);
        }

        .table {
            border-radius: 10px;
            overflow: hidden;
        }

        .table th {
            background-color: #f8f9fa;
            font-weight: 600;
        }

        .badge {
            padding: 8px 12px;
            border-radius: 6px;
            font-weight: 500;
        }

        .professor-info {
            background: linear-gradient(45deg, #4cc9f0, #4361ee);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .professor-info img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            border: 3px solid white;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 px-0 position-fixed sidebar">
                <div class="sidebar-brand">
                    <h2><i class="fas fa-graduation-cap me-2"></i>Thesis</h2>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link active" href="#">
                            <i class="fas fa-home"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#bookAppointmentModal">
                            <i class="fas fa-calendar-plus"></i> Book Meeting
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#updateProgressModal">
                            <i class="fas fa-tasks"></i> Update Progress
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-file-alt"></i> Documents
                        </a>
                    </li>
                    <li class="nav-item mt-auto">
                        <a class="nav-link" href="login.jsp">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 ms-auto main-content">
                <!-- Topbar -->
                <div class="topbar d-flex justify-content-between align-items-center">
                    <h4 class="mb-0">Welcome, <%= session.getAttribute("username") %></h4>
                    <div class="d-flex align-items-center">
                        <div class="dropdown me-3">
                            <button class="btn btn-link text-dark" type="button" id="notificationsDropdown" data-bs-toggle="dropdown">
                                <i class="fas fa-bell"></i>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                    2
                                </span>
                            </button>
                            <div class="dropdown-menu dropdown-menu-end">
                                <h6 class="dropdown-header">Notifications</h6>
                                <a class="dropdown-item" href="#">Meeting scheduled for tomorrow</a>
                                <a class="dropdown-item" href="#">New feedback received</a>
                            </div>
                        </div>
                        <div class="dropdown">
                            <button class="btn btn-link text-dark" type="button" id="profileDropdown" data-bs-toggle="dropdown">
                                <img src="https://via.placeholder.com/40" class="rounded-circle" alt="Profile">
                            </button>
                            <div class="dropdown-menu dropdown-menu-end">
                                <a class="dropdown-item" href="#"><i class="fas fa-user me-2"></i>Profile</a>
                                <a class="dropdown-item" href="#"><i class="fas fa-cog me-2"></i>Settings</a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="login.jsp"><i class="fas fa-sign-out-alt me-2"></i>Logout</a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Professor Info -->
                <div class="professor-info mb-4">
                    <div class="row align-items-center">
                        <div class="col-md-2 text-center">
                            <img src="https://via.placeholder.com/80" alt="Professor" class="img-fluid">
                        </div>
                        <div class="col-md-10">
                            <h4>Dr. John Smith</h4>
                            <p class="mb-0">Thesis Supervisor</p>
                            <p class="mb-0"><i class="fas fa-envelope me-2"></i>john.smith@university.edu</p>
                            <p class="mb-0"><i class="fas fa-phone me-2"></i>+30 123 456 7890</p>
                        </div>
                    </div>
                </div>

                <!-- Stats Cards -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="card stats-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="number">75%</div>
                                        <div class="label">Project Progress</div>
                                    </div>
                                    <div class="icon">
                                        <i class="fas fa-chart-line"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card stats-card" style="background: linear-gradient(45deg, #4cc9f0, #4895ef);">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="number">3</div>
                                        <div class="label">Upcoming Meetings</div>
                                    </div>
                                    <div class="icon">
                                        <i class="fas fa-calendar-check"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card stats-card" style="background: linear-gradient(45deg, #f72585, #b5179e);">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="number">2</div>
                                        <div class="label">Pending Tasks</div>
                                    </div>
                                    <div class="icon">
                                        <i class="fas fa-tasks"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Main Content Area -->
                <div class="row">
                    <!-- Project Progress -->
                    <div class="col-lg-8">
                        <div class="card mb-4">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Project Details</h5>
                                <button class="btn btn-primary btn-sm action-btn" data-bs-toggle="modal" data-bs-target="#updateProgressModal">
                                    <i class="fas fa-plus me-2"></i>Update Progress
                                </button>
                            </div>
                            <div class="card-body">
                                <div class="progress mb-4" style="height: 25px;">
                                    <div class="progress-bar bg-primary" role="progressbar" style="width: 75%;" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100">75%</div>
                                </div>
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Topic</th>
                                                <th>Language</th>
                                                <th>Technologies</th>
                                                <th>Progress</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>AI-Powered Student Management System</td>
                                                <td>Java</td>
                                                <td>Spring Boot, MySQL</td>
                                                <td><span class="badge bg-warning">In Progress</span></td>
                                                <td>
                                                    <button class="btn btn-sm btn-outline-primary">View</button>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Upcoming Meetings -->
                    <div class="col-lg-4">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">Upcoming Meetings</h5>
                            </div>
                            <div class="card-body">
                                <div class="d-flex align-items-center mb-3">
                                    <div class="flex-shrink-0">
                                        <div class="bg-primary text-white rounded p-2 text-center" style="width: 50px;">
                                            <div class="small">MAR</div>
                                            <div class="fw-bold">15</div>
                                        </div>
                                    </div>
                                    <div class="flex-grow-1 ms-3">
                                        <h6 class="mb-0">Progress Review</h6>
                                        <small class="text-muted">10:00 AM - 11:00 AM</small>
                                    </div>
                                </div>
                                <div class="d-flex align-items-center mb-3">
                                    <div class="flex-shrink-0">
                                        <div class="bg-success text-white rounded p-2 text-center" style="width: 50px;">
                                            <div class="small">MAR</div>
                                            <div class="fw-bold">22</div>
                                        </div>
                                    </div>
                                    <div class="flex-grow-1 ms-3">
                                        <h6 class="mb-0">Implementation Discussion</h6>
                                        <small class="text-muted">2:00 PM - 3:00 PM</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Book Appointment Modal -->
    <div class="modal fade" id="bookAppointmentModal" tabindex="-1" aria-labelledby="bookAppointmentModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="bookAppointmentModalLabel">Book Meeting with Supervisor</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="StudentServlet" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="makeAppointment">
                        <div class="mb-3">
                            <label for="meetingDate" class="form-label">Preferred Date</label>
                            <input type="date" class="form-control" id="meetingDate" name="meetingDate" required>
                        </div>
                        <div class="mb-3">
                            <label for="meetingTime" class="form-label">Preferred Time</label>
                            <select class="form-select" id="meetingTime" name="meetingTime" required>
                                <option value="">Select a time</option>
                                <option value="09:00">9:00 AM</option>
                                <option value="10:00">10:00 AM</option>
                                <option value="11:00">11:00 AM</option>
                                <option value="14:00">2:00 PM</option>
                                <option value="15:00">3:00 PM</option>
                                <option value="16:00">4:00 PM</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="meetingDuration" class="form-label">Duration</label>
                            <select class="form-select" id="meetingDuration" name="meetingDuration" required>
                                <option value="30">30 minutes</option>
                                <option value="60">1 hour</option>
                                <option value="90">1.5 hours</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="meetingPurpose" class="form-label">Purpose of Meeting</label>
                            <textarea class="form-control" id="meetingPurpose" name="meetingPurpose" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Book Meeting</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Update Progress Modal -->
    <div class="modal fade" id="updateProgressModal" tabindex="-1" aria-labelledby="updateProgressModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="updateProgressModalLabel">Update Project Progress</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="StudentServlet" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="uploadAssignment">
                        <div class="mb-3">
                            <label for="topic" class="form-label">Topic</label>
                            <input type="text" class="form-control" id="topic" name="topic" required>
                        </div>
                        <div class="mb-3">
                            <label for="language" class="form-label">Programming Language</label>
                            <input type="text" class="form-control" id="language" name="language" required>
                        </div>
                        <div class="mb-3">
                            <label for="technologies" class="form-label">Technologies Used</label>
                            <input type="text" class="form-control" id="technologies" name="technologies" required>
                        </div>
                        <div class="mb-3">
                            <label for="progress" class="form-label">Progress</label>
                            <select class="form-select" id="progress" name="progress" required>
                                <option value="Not Started">Not Started</option>
                                <option value="In Progress">In Progress</option>
                                <option value="Completed">Completed</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Update Progress</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script>
        // Set minimum date for meeting booking to today
        document.getElementById('meetingDate').min = new Date().toISOString().split('T')[0];

        // Handle form submissions
        document.querySelectorAll('form').forEach(form => {
            form.addEventListener('submit', function(e) {
                e.preventDefault();
                const action = this.querySelector('input[name="action"]').value;
                
                if (action === 'makeAppointment') {
                    // Add your appointment booking logic here
                    console.log('Booking appointment...');
                    this.submit();
                } else if (action === 'uploadAssignment') {
                    // Add your progress update logic here
                    console.log('Updating progress...');
                    this.submit();
                }
            });
        });

        // Handle notification clicks
        document.querySelectorAll('.dropdown-item').forEach(item => {
            item.addEventListener('click', function(e) {
                e.preventDefault();
                console.log('Notification clicked:', this.textContent);
            });
        });
    </script>
</body>
</html> 
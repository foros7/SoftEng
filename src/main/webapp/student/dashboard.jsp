<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Student Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .sidebar {
                min-height: 100vh;
                background-color: #f8f9fa;
                padding: 20px;
            }
            .main-content {
                padding: 20px;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-3 col-lg-2 sidebar">
                    <h3 class="mb-4">Student Portal</h3>
                    <div class="list-group">
                        <a href="#" class="list-group-item list-group-item-action active">Dashboard</a>
                        <a href="#" class="list-group-item list-group-item-action">My Assignments</a>
                        <a href="#" class="list-group-item list-group-item-action">Schedule Appointment</a>
                        <a href="#" class="list-group-item list-group-item-action">View Appointments</a>
                        <a href="../login.jsp" class="list-group-item list-group-item-action text-danger">Logout</a>
                    </div>
                </div>

                <!-- Main Content -->
                <div class="col-md-9 col-lg-10 main-content">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2>Welcome, ${sessionScope.user.name}</h2>
                        <span class="badge bg-primary">Student</span>
                    </div>

                    <!-- Quick Stats -->
                    <div class="row mb-4">
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-body">
                                    <h5 class="card-title">Active Assignments</h5>
                                    <p class="card-text display-4">3</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-body">
                                    <h5 class="card-title">Upcoming Appointments</h5>
                                    <p class="card-text display-4">2</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-body">
                                    <h5 class="card-title">Completed Assignments</h5>
                                    <p class="card-text display-4">5</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Activity -->
                    <div class="card">
                        <div class="card-header">
                            Recent Activity
                        </div>
                        <div class="card-body">
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item">Assignment "Web Development" due in 3 days</li>
                                <li class="list-group-item">Appointment with Dr. Smith scheduled for tomorrow</li>
                                <li class="list-group-item">Assignment "Database Design" marked as completed</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html> 
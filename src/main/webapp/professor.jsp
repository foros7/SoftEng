<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Professor Dashboard</title>
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
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 px-0 position-fixed sidebar">
                <div class="sidebar-brand">
                    <h2><i class="fas fa-chalkboard-teacher me-2"></i>Professor</h2>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link active" href="#">
                            <i class="fas fa-home"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-calendar-plus"></i> Create Appointment
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-marker"></i> Mark Assignment
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <i class="fas fa-file-alt"></i> Generate Report
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
                    <h4 class="mb-0">Welcome, ${sessionScope.username}</h4>
                    <div class="d-flex align-items-center">
                        <div class="dropdown me-3">
                            <button class="btn btn-link text-dark" type="button" id="notificationsDropdown" data-bs-toggle="dropdown">
                                <i class="fas fa-bell"></i>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                    1
                                </span>
                            </button>
                            <div class="dropdown-menu dropdown-menu-end">
                                <h6 class="dropdown-header">Notifications</h6>
                                <a class="dropdown-item" href="#">New assignment submitted</a>
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
                
                <!-- Debug Information -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Debug Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3">
                                <p><strong>Username:</strong> ${sessionScope.username}</p>
                            </div>
                            <div class="col-md-3">
                                <p><strong>Supervised Count:</strong> ${supervisedCount != null ? supervisedCount : '0'}</p>
                            </div>
                            <div class="col-md-3">
                                <p><strong>Pending Assignments:</strong> ${pendingAssignments != null ? pendingAssignments : '0'}</p>
                            </div>
                            <div class="col-md-3">
                                <p><strong>Appointments:</strong> ${appointmentsCount != null ? appointmentsCount : '0'}</p>
                            </div>
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
                                        <div class="number">${supervisedCount != null ? supervisedCount : '0'}</div>
                                        <div class="label">Supervised Projects</div>
                                    </div>
                                    <div class="icon">
                                        <i class="fas fa-users"></i>
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
                                        <div class="number">${pendingAssignments != null ? pendingAssignments : '0'}</div>
                                        <div class="label">Pending Assignments</div>
                                    </div>
                                    <div class="icon">
                                        <i class="fas fa-tasks"></i>
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
                                        <div class="number">${appointmentsCount != null ? appointmentsCount : '0'}</div>
                                        <div class="label">Upcoming Appointments</div>
                                    </div>
                                    <div class="icon">
                                        <i class="fas fa-calendar-check"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Supervised Projects Table -->
                <div class="card mb-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Supervised Projects</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty supervisedAssignments}">
                                <div class="text-center py-4">
                                    <i class="fas fa-folder-open fa-3x text-muted mb-3"></i>
                                    <p class="text-muted">No supervised assignments found.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Student</th>
                                                <th>Topic</th>
                                                <th>Language</th>
                                                <th>Progress</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${supervisedAssignments}" var="assignment">
                                                <tr>
                                                    <td>${assignment.studentName != null ? assignment.studentName : 'Unknown Student'}</td>
                                                    <td>${assignment.topic}</td>
                                                    <td>${assignment.language}</td>
                                                    <td>
                                                        <span class="badge bg-${assignment.progress == 'Completed' ? 'success' : (assignment.progress == 'In Progress' ? 'warning' : 'secondary')}">
                                                            ${assignment.progress}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#markAssignmentModal${assignment.id}">Mark</button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <!-- Mark Assignment Modals -->
                <c:forEach items="${supervisedAssignments}" var="assignment">
                    <div class="modal fade" id="markAssignmentModal${assignment.id}" tabindex="-1" aria-labelledby="markAssignmentModalLabel${assignment.id}" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="markAssignmentModalLabel${assignment.id}">Mark Assignment</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <form action="ProfessorServlet" method="post">
                                    <div class="modal-body">
                                        <input type="hidden" name="action" value="markAssignment">
                                        <input type="hidden" name="assignmentId" value="${assignment.id}">
                                        
                                        <div class="mb-3">
                                            <label class="form-label"><strong>Student:</strong> ${assignment.studentName}</label>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label"><strong>Topic:</strong> ${assignment.topic}</label>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label"><strong>Language:</strong> ${assignment.language}</label>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label"><strong>Technologies:</strong> ${assignment.technologies}</label>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label"><strong>Current Progress:</strong> 
                                                <span class="badge bg-${assignment.progress == 'Completed' ? 'success' : (assignment.progress == 'In Progress' ? 'warning' : 'secondary')}">
                                                    ${assignment.progress}
                                                </span>
                                            </label>
                                        </div>
                                        
                                        <hr>
                                        
                                        <div class="mb-3">
                                            <label for="grade${assignment.id}" class="form-label">Grade (optional)</label>
                                            <select class="form-select" id="grade${assignment.id}" name="grade">
                                                <option value="">Select Grade</option>
                                                <option value="A">A - Excellent</option>
                                                <option value="B">B - Very Good</option>
                                                <option value="C">C - Good</option>
                                                <option value="D">D - Satisfactory</option>
                                                <option value="F">F - Fail</option>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label for="comments${assignment.id}" class="form-label">Comments/Feedback</label>
                                            <textarea class="form-control" id="comments${assignment.id}" name="comments" rows="4" placeholder="Provide feedback to the student..."></textarea>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                        <button type="submit" class="btn btn-success">Mark as Completed</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                
                <!-- Quick Actions -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">Quick Actions</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <form action="ProfessorServlet" method="post">
                                            <input type="hidden" name="action" value="createAppointments">
                                            <button type="submit" class="btn btn-primary action-btn w-100">
                                                <i class="fas fa-calendar-plus me-2"></i>Create Appointments
                                            </button>
                                        </form>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <form action="ProfessorServlet" method="post">
                                            <input type="hidden" name="action" value="markAssignment">
                                            <button type="submit" class="btn btn-success action-btn w-100">
                                                <i class="fas fa-marker me-2"></i>Mark Assignments
                                            </button>
                                        </form>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <form action="ProfessorServlet" method="post">
                                            <input type="hidden" name="action" value="getReports">
                                            <button type="submit" class="btn btn-info action-btn w-100">
                                                <i class="fas fa-file-alt me-2"></i>Generate Reports
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js"></script>
</body>
</html> 
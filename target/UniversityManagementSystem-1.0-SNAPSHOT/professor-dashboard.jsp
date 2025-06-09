<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }

        .sidebar {
            background: linear-gradient(180deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            height: 100vh;
            padding: 20px;
            color: white;
            position: fixed;
            width: 250px;
            top: 0;
            left: 0;
            z-index: 1000;
            overflow-y: auto;
            overflow-x: hidden;
        }

        .sidebar::-webkit-scrollbar {
            width: 6px;
        }

        .sidebar::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.1);
        }

        .sidebar::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.3);
            border-radius: 3px;
        }

        .sidebar::-webkit-scrollbar-thumb:hover {
            background: rgba(255, 255, 255, 0.5);
        }

        .sidebar-brand {
            padding: 15px 0;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
            flex-shrink: 0;
        }

        .sidebar-brand h2 {
            font-size: 22px;
            font-weight: 600;
            margin: 0;
        }

        .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 10px 15px;
            border-radius: 8px;
            margin-bottom: 3px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: flex;
            align-items: center;
            font-size: 14px;
        }

        .nav-link:hover, .nav-link.active {
            color: white;
            background-color: rgba(255, 255, 255, 0.1);
        }

        .nav-link i {
            width: 20px;
            text-align: center;
            margin-right: 10px;
            font-size: 14px;
        }

        .main-content {
            margin-left: 250px;
            padding: 15px;
            min-height: 100vh;
            max-height: 100vh;
            overflow-y: auto;
            overflow-x: hidden;
            width: calc(100vw - 250px);
            box-sizing: border-box;
        }

        .topbar {
            background: white;
            padding: 15px 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            margin-bottom: 20px;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            transition: transform 0.3s ease;
            margin-bottom: 15px;
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 200px;
            }
            
            .main-content {
                margin-left: 200px;
                padding: 10px;
                width: calc(100vw - 200px);
            }
        }

        @media (max-width: 576px) {
            .sidebar {
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }
            
            .sidebar.show {
                transform: translateX(0);
            }
            
            .main-content {
                margin-left: 0;
                padding: 10px;
                width: 100vw;
            }
        }

        /* Force content to fit */
        .container-fluid {
            padding: 0;
            margin: 0;
        }

        .row {
            margin: 0;
        }

        .col-md-8, .col-md-4, .col-xl-3, .col-md-6 {
            padding-left: 7px;
            padding-right: 7px;
        }

        .card:hover {
            transform: translateY(-2px);
        }

        .stats-card {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
        }

        .stats-card.primary {
            background: linear-gradient(45deg, #4361ee, #3f37c9);
        }

        .stats-card.success {
            background: linear-gradient(45deg, #4cc9f0, #4895ef);
        }

        .stats-card.warning {
            background: linear-gradient(45deg, #f72585, #b5179e);
        }

        .stats-card.info {
            background: linear-gradient(45deg, #4cc9f0, #4361ee);
        }

        .stats-icon {
            font-size: 2rem;
            opacity: 0.8;
        }

        .btn-action {
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 0.875rem;
            transition: all 0.3s ease;
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .table th {
            background-color: #f8f9fa;
            font-weight: 600;
            border: none;
        }

        .table td {
            border: none;
            border-top: 1px solid #e9ecef;
            vertical-align: middle;
        }

        .badge {
            padding: 6px 12px;
            border-radius: 6px;
            font-weight: 500;
        }

        .modal-header {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(67, 97, 238, 0.25);
        }

        .progress-badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .progress-not-started {
            background-color: #ffeaa7;
            color: #2d3436;
        }

        .progress-in-progress {
            background-color: #74b9ff;
            color: white;
        }

        .progress-completed {
            background-color: #00b894;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="sidebar-brand">
                    <h2><i class="fas fa-chalkboard-teacher me-2"></i>Professor</h2>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link active" href="professor-dashboard">
                            <i class="fas fa-home"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="professor-appointments">
                            <i class="fas fa-calendar-check"></i> My Appointments
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#createAppointmentModal">
                            <i class="fas fa-calendar-plus"></i> Create Appointment
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#markAssignmentModal">
                            <i class="fas fa-clipboard-check"></i> Grade Assignment
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#generateReportModal">
                            <i class="fas fa-chart-bar"></i> Generate Report
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
            <div class="main-content">
                <!-- Topbar -->
                <div class="topbar d-flex justify-content-between align-items-center">
                    <h4 class="mb-0">Welcome, ${sessionScope.username}</h4>
                    <div class="d-flex align-items-center">
                        <div class="dropdown me-3">
                            <button class="btn btn-outline-primary position-relative" type="button" id="notificationDropdown" data-bs-toggle="dropdown">
                                <i class="fas fa-bell"></i>
                                <c:if test="${notificationCount > 0}">
                                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                        ${notificationCount}
                                    </span>
                                </c:if>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" style="width: 450px; max-height: 400px; overflow-y: auto;">
                                <li class="dropdown-header">
                                    <strong>Notifications</strong>
                                    <c:if test="${notificationCount > 0}">
                                        <span class="badge bg-primary ms-2">${notificationCount}</span>
                                    </c:if>
                                </li>
                                <c:choose>
                                    <c:when test="${not empty notifications}">
                                        <c:forEach var="notification" items="${notifications}" begin="0" end="4">
                                            <li class="notification-item px-3 py-2" style="border-bottom: 1px solid #eee;">
                                                <div class="fw-bold text-truncate">${notification.title}</div>
                                                <div class="small text-muted text-truncate mb-2">${notification.message}</div>
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <div class="small text-muted">
                                                        <fmt:formatDate value="${notification.createdAt}" pattern="MMM dd, HH:mm" />
                                                    </div>
                                                    <c:if test="${notification.type == 'appointment_request'}">
                                                        <div class="btn-group" role="group">
                                                            <button type="button" class="btn btn-success btn-sm" 
                                                                    onclick="handleNotificationAction('accept', '${notification.id}', '${notification.relatedId}')">
                                                                <i class="fas fa-check"></i> Accept
                                                            </button>
                                                            <button type="button" class="btn btn-danger btn-sm" 
                                                                    onclick="handleNotificationAction('decline', '${notification.id}', '${notification.relatedId}')">
                                                                <i class="fas fa-times"></i> Decline
                                                            </button>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </li>
                                        </c:forEach>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item text-center" href="#">View All Notifications</a></li>
                                    </c:when>
                                    <c:otherwise>
                                        <li><span class="dropdown-item text-muted">No new notifications</span></li>
                                    </c:otherwise>
                                </c:choose>
                            </ul>
                        </div>
                        <span><i class="fas fa-user-circle"></i></span>
                    </div>
                </div>

                <!-- Stats Cards -->
                <div class="row">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card primary h-100">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col">
                                        <div class="text-xs font-weight-bold text-uppercase mb-1" style="color: rgba(255,255,255,0.8);">
                                            Supervised Projects</div>
                                        <div class="h5 mb-0 font-weight-bold">${supervisedCount}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-users stats-icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card success h-100">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col">
                                        <div class="text-xs font-weight-bold text-uppercase mb-1" style="color: rgba(255,255,255,0.8);">
                                            Pending Reviews</div>
                                        <div class="h5 mb-0 font-weight-bold">${pendingAssignments}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-tasks stats-icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card info h-100">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col">
                                        <div class="text-xs font-weight-bold text-uppercase mb-1" style="color: rgba(255,255,255,0.8);">
                                            Appointments Today</div>
                                        <div class="h5 mb-0 font-weight-bold">${appointmentsCount}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-calendar-check stats-icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card warning h-100">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col">
                                        <div class="text-xs font-weight-bold text-uppercase mb-1" style="color: rgba(255,255,255,0.8);">
                                            Office Hours</div>
                                        <div class="h5 mb-0 font-weight-bold">4</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-clock stats-icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Supervised Projects Table -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h6 class="m-0 font-weight-bold">Supervised Projects</h6>
                        <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#createAppointmentModal">
                            <i class="fas fa-plus me-1"></i>New Appointment
                        </button>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Student</th>
                                        <th>Topic</th>
                                        <th>Language</th>
                                        <th>Progress</th>
                                        <th>File</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty supervisedAssignments}">
                                            <c:forEach items="${supervisedAssignments}" var="assignment">
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div class="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center" style="width: 32px; height: 32px; font-size: 0.875rem;">
                                                                ${fn:substring(assignment.studentName, 0, 1)}
                                                            </div>
                                                            <div class="ms-2">
                                                                <div class="fw-bold">${assignment.studentName}</div>
                                                                <small class="text-muted">ID: ${assignment.studentId}</small>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div class="fw-bold">${assignment.topic}</div>
                                                        <small class="text-muted">
                                                            Started: <fmt:formatDate value="${assignment.startDate}" pattern="MMM dd, yyyy"/><br>
                                                            <span class="badge bg-secondary">${assignment.language}</span>
                                                            <c:if test="${not empty assignment.technologies}">
                                                                | ${assignment.technologies}
                                                            </c:if>
                                                        </small>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-info">${assignment.language}</span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${assignment.progress == 'Not Started'}">
                                                                <span class="progress-badge progress-not-started">Not Started</span>
                                                            </c:when>
                                                            <c:when test="${assignment.progress == 'In Progress'}">
                                                                <span class="progress-badge progress-in-progress">In Progress</span>
                                                            </c:when>
                                                            <c:when test="${assignment.progress == 'Completed'}">
                                                                <span class="progress-badge progress-completed">Completed</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="progress-badge progress-not-started">${assignment.progress}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${assignment.hasFile()}">
                                                                <div class="d-flex align-items-center">
                                                                    <i class="fas fa-file text-success me-2"></i>
                                                                    <div>
                                                                        <div class="fw-bold">${assignment.fileName}</div>
                                                                        <small class="text-muted">
                                                                            ${assignment.formattedFileSize}
                                                                            <c:if test="${assignment.fileUploadedAt != null}">
                                                                                | <fmt:formatDate value="${assignment.fileUploadedAt}" pattern="MMM dd, yyyy"/>
                                                                            </c:if>
                                                                        </small>
                                                                    </div>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">No file uploaded</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <c:if test="${assignment.hasFile()}">
                                                                <a href="download-assignment-file?assignmentId=${assignment.id}" 
                                                                   class="btn btn-outline-success btn-sm" title="Download File">
                                                                    <i class="fas fa-download"></i>
                                                                </a>
                                                            </c:if>
                                                            <button type="button" class="btn btn-outline-primary btn-sm grade-btn" 
                                                                    data-assignment-id="${assignment.id}" 
                                                                    data-assignment-topic="${assignment.topic}" 
                                                                    data-student-name="${assignment.studentName}"
                                                                    data-has-file="${assignment.hasFile()}"
                                                                    data-file-name="${assignment.fileName}"
                                                                    data-bs-toggle="modal" data-bs-target="#markAssignmentModal"
                                                                    title="Grade Assignment">
                                                                <i class="fas fa-edit"></i>
                                                            </button>
                                                            <button type="button" class="btn btn-outline-info btn-sm view-details-btn" 
                                                                    data-assignment-id="${assignment.id}" 
                                                                    data-assignment-topic="${assignment.topic}" 
                                                                    data-student-name="${assignment.studentName}"
                                                                    data-technologies="${assignment.technologies}"
                                                                    data-has-file="${assignment.hasFile()}"
                                                                    data-file-name="${assignment.fileName}"
                                                                    title="View Details">
                                                                <i class="fas fa-eye"></i>
                                                            </button>
                                                            <button type="button" class="btn btn-outline-success btn-sm complete-btn" 
                                                                    data-assignment-id="${assignment.id}"
                                                                    title="Mark Complete">
                                                                <i class="fas fa-check"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6" class="text-center text-muted py-4">
                                                    <i class="fas fa-inbox fa-2x mb-2"></i><br>
                                                    No supervised projects found
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h6 class="m-0 font-weight-bold">Quick Actions</h6>
                            </div>
                            <div class="card-body">
                                <div class="d-grid gap-2">
                                    <a href="professor-appointments" class="btn btn-success">
                                        <i class="fas fa-calendar-check me-2"></i>View My Appointments
                                    </a>
                                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createAppointmentModal">
                                        <i class="fas fa-calendar-plus me-2"></i>Schedule Office Hours
                                    </button>
                                    <button class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#generateReportModal">
                                        <i class="fas fa-chart-bar me-2"></i>Generate Progress Report
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h6 class="m-0 font-weight-bold">Recent Activity</h6>
                            </div>
                            <div class="card-body">
                                <div class="list-group list-group-flush">
                                    <div class="list-group-item d-flex align-items-center">
                                        <div class="rounded-circle bg-success text-white d-flex align-items-center justify-content-center me-3" style="width: 32px; height: 32px;">
                                            <i class="fas fa-check fa-sm"></i>
                                        </div>
                                        <div>
                                            <div class="fw-bold">Assignment Graded</div>
                                            <small class="text-muted">John Smith - Web Development</small>
                                        </div>
                                    </div>
                                    <div class="list-group-item d-flex align-items-center">
                                        <div class="rounded-circle bg-info text-white d-flex align-items-center justify-content-center me-3" style="width: 32px; height: 32px;">
                                            <i class="fas fa-calendar fa-sm"></i>
                                        </div>
                                        <div>
                                            <div class="fw-bold">Appointment Scheduled</div>
                                            <small class="text-muted">Sarah Johnson - Tomorrow 2:00 PM</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Create Appointment Modal -->
    <div class="modal fade" id="createAppointmentModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Create Appointment Slot</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="professor-dashboard" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="createAppointments">
                        <div class="mb-3">
                            <label for="appointmentDate" class="form-label">Date</label>
                            <input type="date" class="form-control" id="appointmentDate" name="appointmentDate" required>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <label for="startTime" class="form-label">Start Time</label>
                                <input type="time" class="form-control" id="startTime" name="startTime" required>
                            </div>
                            <div class="col-md-6">
                                <label for="endTime" class="form-label">End Time</label>
                                <input type="time" class="form-control" id="endTime" name="endTime" required>
                            </div>
                        </div>
                        <div class="mb-3 mt-3">
                            <label for="appointmentType" class="form-label">Type</label>
                            <select class="form-select" id="appointmentType" name="appointmentType" required>
                                <option value="">Select Type</option>
                                <option value="Office Hours">Office Hours</option>
                                <option value="Project Review">Project Review</option>
                                <option value="Academic Advising">Academic Advising</option>
                                <option value="Thesis Meeting">Thesis Meeting</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="appointmentNotes" class="form-label">Notes (Optional)</label>
                            <textarea class="form-control" id="appointmentNotes" name="appointmentNotes" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Create Appointment</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Mark Assignment Modal -->
    <div class="modal fade" id="markAssignmentModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Grade Assignment</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="professor-dashboard" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="markAssignment">
                        <input type="hidden" id="assignmentId" name="assignmentId">
                        <div class="mb-3">
                            <label class="form-label">Assignment</label>
                            <div id="assignmentInfo" class="form-control-plaintext bg-light p-2 rounded"></div>
                        </div>
                        <div class="mb-3" id="fileInfoSection" style="display: none;">
                            <label class="form-label">Submitted File</label>
                            <div class="d-flex align-items-center bg-light p-2 rounded">
                                <i class="fas fa-file text-success me-2"></i>
                                <div class="flex-grow-1">
                                    <div class="fw-bold" id="fileInfoName">-</div>
                                    <small class="text-muted" id="fileInfoDetails">-</small>
                                </div>
                                <a id="fileDownloadBtn" href="#" class="btn btn-sm btn-outline-success ms-2" title="Download File">
                                    <i class="fas fa-download"></i> Download
                                </a>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <label for="grade" class="form-label">Grade</label>
                                <select class="form-select" id="grade" name="grade" required>
                                    <option value="">Select Grade</option>
                                    <option value="A+">A+ (90-100)</option>
                                    <option value="A">A (85-89)</option>
                                    <option value="A-">A- (80-84)</option>
                                    <option value="B+">B+ (75-79)</option>
                                    <option value="B">B (70-74)</option>
                                    <option value="B-">B- (65-69)</option>
                                    <option value="C+">C+ (60-64)</option>
                                    <option value="C">C (55-59)</option>
                                    <option value="F">F (Below 55)</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="status" class="form-label">Status</label>
                                <select class="form-select" id="status" name="status" required>
                                    <option value="">Select Status</option>
                                    <option value="Completed">Completed</option>
                                    <option value="Needs Revision">Needs Revision</option>
                                    <option value="In Progress">In Progress</option>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3 mt-3">
                            <label for="comments" class="form-label">Comments & Feedback</label>
                            <textarea class="form-control" id="comments" name="comments" rows="4" 
                                      placeholder="Provide detailed feedback for the student..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Grade</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Generate Report Modal -->
    <div class="modal fade" id="generateReportModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Generate Progress Report</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="professor-dashboard" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="getReports">
                        <div class="mb-3">
                            <label for="reportType" class="form-label">Report Type</label>
                            <select class="form-select" id="reportType" name="reportType" required>
                                <option value="">Select Report Type</option>
                                <option value="student_progress">Student Progress Summary</option>
                                <option value="assignment_overview">Assignment Overview</option>
                                <option value="grading_summary">Grading Summary</option>
                                <option value="monthly_report">Monthly Report</option>
                            </select>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <label for="startDate" class="form-label">Start Date</label>
                                <input type="date" class="form-control" id="startDate" name="startDate">
                            </div>
                            <div class="col-md-6">
                                <label for="endDate" class="form-label">End Date</label>
                                <input type="date" class="form-control" id="endDate" name="endDate">
                            </div>
                        </div>
                        <div class="mb-3 mt-3">
                            <label for="includeStudents" class="form-label">Include Students</label>
                            <select class="form-select" id="includeStudents" name="includeStudents">
                                <option value="all">All Students</option>
                                <option value="active">Active Projects Only</option>
                                <option value="completed">Completed Projects Only</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Generate Report</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Assignment Details Modal -->
    <div class="modal fade" id="assignmentDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Assignment Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Student Information</h6>
                            <div class="bg-light p-3 rounded">
                                <div class="fw-bold" id="detailStudentName">-</div>
                                <small class="text-muted" id="detailStudentId">Student ID: -</small>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <h6>Assignment Information</h6>
                            <div class="bg-light p-3 rounded">
                                <div class="fw-bold" id="detailAssignmentTopic">-</div>
                                <small class="text-muted" id="detailAssignmentDetails">-</small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row mt-3">
                        <div class="col-md-6">
                            <h6>Technologies Used</h6>
                            <div class="bg-light p-3 rounded">
                                <span id="detailTechnologies">-</span>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <h6>Progress Status</h6>
                            <div class="bg-light p-3 rounded">
                                <span id="detailProgress" class="badge">-</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mt-3" id="detailFileSection" style="display: none;">
                        <h6>Submitted File</h6>
                        <div class="bg-light p-3 rounded d-flex align-items-center">
                            <i class="fas fa-file text-success me-2"></i>
                            <div class="flex-grow-1">
                                <div class="fw-bold" id="detailFileName">-</div>
                                <small class="text-muted" id="detailFileInfo">-</small>
                            </div>
                            <a id="detailFileDownload" href="#" class="btn btn-sm btn-success ms-2">
                                <i class="fas fa-download"></i> Download
                            </a>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="gradeFromDetailsBtn">Grade Assignment</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openMarkModal(assignmentId, topic, studentName, hasFile, fileName, fileSize, fileDate) {
            document.getElementById('assignmentId').value = assignmentId;
            document.getElementById('assignmentInfo').innerHTML = 
                '<strong>' + topic + '</strong><br><small>Student: ' + studentName + '</small>';
            
            // Show file information if file exists
            const fileSection = document.getElementById('fileInfoSection');
            if (hasFile && hasFile !== 'false') {
                document.getElementById('fileInfoName').textContent = fileName || 'Unknown file';
                document.getElementById('fileInfoDetails').textContent = (fileSize || 'Unknown size') + 
                    (fileDate ? ' | Uploaded: ' + fileDate : '');
                document.getElementById('fileDownloadBtn').href = 'download-assignment-file?assignmentId=' + assignmentId;
                fileSection.style.display = 'block';
            } else {
                fileSection.style.display = 'none';
            }
        }
        
        function openDetailsModal(assignmentData) {
            document.getElementById('detailStudentName').textContent = assignmentData.studentName;
            document.getElementById('detailStudentId').textContent = 'Student ID: ' + assignmentData.studentId;
            document.getElementById('detailAssignmentTopic').textContent = assignmentData.topic;
            document.getElementById('detailAssignmentDetails').textContent = 'Language: ' + assignmentData.language;
            document.getElementById('detailTechnologies').textContent = assignmentData.technologies || 'Not specified';
            
            // Set progress badge
            const progressBadge = document.getElementById('detailProgress');
            progressBadge.textContent = assignmentData.progress;
            progressBadge.className = 'badge progress-badge progress-' + assignmentData.progress.toLowerCase().replace(' ', '-');
            
            // Show file section if file exists
            const fileSection = document.getElementById('detailFileSection');
            if (assignmentData.hasFile && assignmentData.hasFile !== 'false') {
                document.getElementById('detailFileName').textContent = assignmentData.fileName;
                document.getElementById('detailFileInfo').textContent = 'File size: ' + (assignmentData.fileSize || 'Unknown');
                document.getElementById('detailFileDownload').href = 'download-assignment-file?assignmentId=' + assignmentData.assignmentId;
                fileSection.style.display = 'block';
            } else {
                fileSection.style.display = 'none';
            }
            
            // Set up grade button to open grade modal
            document.getElementById('gradeFromDetailsBtn').onclick = function() {
                const detailsModal = bootstrap.Modal.getInstance(document.getElementById('assignmentDetailsModal'));
                detailsModal.hide();
                setTimeout(() => {
                    openMarkModal(assignmentData.assignmentId, assignmentData.topic, assignmentData.studentName, 
                                assignmentData.hasFile, assignmentData.fileName);
                    const gradeModal = new bootstrap.Modal(document.getElementById('markAssignmentModal'));
                    gradeModal.show();
                }, 300);
            };
            
            const modal = new bootstrap.Modal(document.getElementById('assignmentDetailsModal'));
            modal.show();
        }

        function markAsCompleted(assignmentId) {
            if (confirm('Mark this assignment as completed?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'professor-dashboard';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'markAssignment';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'assignmentId';
                idInput.value = assignmentId;
                
                const statusInput = document.createElement('input');
                statusInput.type = 'hidden';
                statusInput.name = 'status';
                statusInput.value = 'Completed';
                
                form.appendChild(actionInput);
                form.appendChild(idInput);
                form.appendChild(statusInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }

        // Set default dates
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('appointmentDate').value = today;
            
            const startDate = document.getElementById('startDate');
            const endDate = document.getElementById('endDate');
            if (startDate) startDate.value = today;
            if (endDate) {
                const nextMonth = new Date();
                nextMonth.setMonth(nextMonth.getMonth() + 1);
                endDate.value = nextMonth.toISOString().split('T')[0];
            }

            // Add event listeners for grade buttons
            document.querySelectorAll('.grade-btn').forEach(button => {
                button.addEventListener('click', function() {
                    const assignmentId = this.dataset.assignmentId;
                    const topic = this.dataset.assignmentTopic;
                    const studentName = this.dataset.studentName;
                    const hasFile = this.dataset.hasFile;
                    const fileName = this.dataset.fileName;
                    openMarkModal(assignmentId, topic, studentName, hasFile, fileName);
                });
            });

            // Add event listeners for view details buttons
            document.querySelectorAll('.view-details-btn').forEach(button => {
                button.addEventListener('click', function() {
                    const assignmentData = {
                        assignmentId: this.dataset.assignmentId,
                        topic: this.dataset.assignmentTopic,
                        studentName: this.dataset.studentName,
                        studentId: this.closest('tr').querySelector('small').textContent.replace('ID: ', ''),
                        language: this.closest('tr').querySelector('.badge').textContent,
                        technologies: this.dataset.technologies,
                        progress: this.closest('tr').querySelector('.progress-badge').textContent,
                        hasFile: this.dataset.hasFile,
                        fileName: this.dataset.fileName
                    };
                    openDetailsModal(assignmentData);
                });
            });

            // Add event listeners for complete buttons
            document.querySelectorAll('.complete-btn').forEach(button => {
                button.addEventListener('click', function() {
                    const assignmentId = this.dataset.assignmentId;
                    markAsCompleted(assignmentId);
                });
            });
        });

        // Handle notification accept/decline actions
        function handleNotificationAction(action, notificationId, appointmentId) {
            console.log('handleNotificationAction called:', action, notificationId, appointmentId);
            
            if (confirm('Are you sure you want to ' + action + ' this appointment request?')) {
                console.log('User confirmed action');
                
                fetch('notification-action', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=' + encodeURIComponent(action) + '&notificationId=' + encodeURIComponent(notificationId) + '&appointmentId=' + encodeURIComponent(appointmentId)
                })
                .then(response => {
                    console.log('Response status:', response.status);
                    console.log('Response headers:', response.headers);
                    return response.text(); // Get as text first to debug
                })
                .then(responseText => {
                    console.log('Raw response:', responseText);
                    
                    try {
                        const data = JSON.parse(responseText);
                        console.log('Parsed response:', data);
                        
                        if (data.success) {
                            // Show success message
                            const alertDiv = document.createElement('div');
                            alertDiv.className = 'alert alert-success alert-dismissible fade show position-fixed';
                            alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
                            alertDiv.innerHTML = `
                                <strong>Success!</strong> ${data.message}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            `;
                            document.body.appendChild(alertDiv);
                            
                            // Auto-hide after 3 seconds
                            setTimeout(() => {
                                alertDiv.remove();
                            }, 3000);
                            
                            // Reload the page to update notifications
                            setTimeout(() => {
                                window.location.reload();
                            }, 1500);
                        } else {
                            alert('Error: ' + data.message);
                        }
                    } catch (parseError) {
                        console.error('JSON parse error:', parseError);
                        alert('Server response was not valid JSON: ' + responseText);
                    }
                })
                .catch(error => {
                    console.error('Fetch error:', error);
                    alert('An error occurred while processing the request: ' + error.message);
                });
            }
        }
    </script>
</body>
</html> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<%
    // If no appointments are loaded, redirect to view-appointments servlet
    if (request.getAttribute("appointments") == null) {
        response.sendRedirect("view-appointments");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments - Student Dashboard</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #28a745;
            --secondary-color: #20a142;
            --success-color: #4cc9f0;
            --warning-color: #ffc107;
            --info-color: #0dcaf0;
            --danger-color: #dc3545;
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

        .card:hover {
            transform: translateY(-2px);
        }

        .card-header {
            background: transparent;
            border-bottom: 1px solid #e9ecef;
            font-weight: 600;
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

        .status-pending {
            background-color: #ffc107;
            color: #212529;
        }

        .status-confirmed {
            background-color: #28a745;
            color: white;
        }

        .status-cancelled {
            background-color: #dc3545;
            color: white;
        }

        .status-completed {
            background-color: #6c757d;
            color: white;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }

        .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }

        .text-primary {
            color: var(--primary-color) !important;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
        }

        .container-fluid {
            padding: 0;
            margin: 0;
        }

        .row {
            margin: 0;
        }

        .col-md-8, .col-md-4, .col-md-3, .col-md-2 {
            padding-left: 7px;
            padding-right: 7px;
        }

        .appointment-card {
            transition: all 0.3s ease;
        }

        .appointment-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .appointment-type-badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            background-color: var(--info-color);
            color: white;
        }

        /* Table responsive adjustments */
        .table-responsive {
            max-width: 100%;
            overflow-x: auto;
        }

        /* Responsive table adjustments */
        @media (max-width: 1200px) {
            .table th, .table td {
                font-size: 0.85rem;
                padding: 0.6rem 0.4rem;
            }
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="sidebar-brand">
                    <h2><i class="fas fa-user-graduate me-2"></i>Student</h2>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="student-dashboard">
                            <i class="fas fa-tachometer-alt"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="book-appointment">
                            <i class="fas fa-calendar-plus"></i> Book Appointment
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="my-appointments.jsp">
                            <i class="fas fa-calendar-alt"></i> My Appointments
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
                    <div class="d-flex align-items-center">
                        <button class="btn btn-outline-secondary d-md-none me-3" id="sidebarToggle">
                            <i class="fas fa-bars"></i>
                        </button>
                        <div>
                            <h4 class="mb-0">My Appointments</h4>
                            <p class="text-muted mb-0">View and manage your scheduled appointments</p>
                        </div>
                    </div>
                    <div class="d-flex align-items-center">
                        <span class="me-3"><i class="fas fa-bell"></i></span>
                        <span><i class="fas fa-user-circle"></i></span>
                    </div>
                </div>

                <!-- Filter Card -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h6 class="m-0 font-weight-bold text-primary">Filter Appointments</h6>
                    </div>
                    <div class="card-body">
                        <form action="view-appointments" method="get" class="row g-3">
                            <div class="col-md-3">
                                <label for="status" class="form-label">Status</label>
                                <select name="status" id="status" class="form-select">
                                    <option value="">All Status</option>
                                    <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Pending</option>
                                    <option value="confirmed" ${param.status == 'confirmed' ? 'selected' : ''}>Confirmed</option>
                                    <option value="completed" ${param.status == 'completed' ? 'selected' : ''}>Completed</option>
                                    <option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="dateRange" class="form-label">Date Range</label>
                                <select name="dateRange" id="dateRange" class="form-select">
                                    <option value="">All Dates</option>
                                    <option value="today" ${param.dateRange == 'today' ? 'selected' : ''}>Today</option>
                                    <option value="week" ${param.dateRange == 'week' ? 'selected' : ''}>This Week</option>
                                    <option value="month" ${param.dateRange == 'month' ? 'selected' : ''}>This Month</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="search" class="form-label">Search</label>
                                <input type="text" name="search" id="search" class="form-control" placeholder="Search by advisor, type, or reason..." value="${param.search}">
                            </div>
                            <div class="col-md-2">
                                <label class="form-label">&nbsp;</label>
                                <button type="submit" class="btn btn-primary w-100 btn-action">
                                    <i class="fas fa-search me-2"></i>Filter
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-triangle me-2"></i>${error}
                    </div>
                </c:if>

                <!-- Appointments List -->
                <div class="row">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h6 class="m-0 font-weight-bold text-primary">
                                    <i class="fas fa-calendar-alt me-2"></i>All Appointments
                                </h6>
                                <span class="badge bg-primary">${fn:length(appointments)} Total</span>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${empty appointments}">
                                        <div class="text-center py-4">
                                            <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                                            <h5 class="text-muted">No appointments found</h5>
                                            <p class="text-muted">You haven't scheduled any appointments yet.</p>
                                            <a href="book-appointment" class="btn btn-primary btn-action">
                                                <i class="fas fa-calendar-plus me-2"></i>Book Your First Appointment
                                            </a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="table-responsive">
                                            <table class="table table-hover">
                                                <thead>
                                                    <tr>
                                                        <th>Date & Time</th>
                                                        <th>Advisor</th>
                                                        <th>Type</th>
                                                        <th>Status</th>
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${appointments}" var="appointment">
                                                        <tr>
                                                            <td>
                                                                <div class="fw-bold">${appointment.date}</div>
                                                                <small class="text-muted">${appointment.time}</small>
                                                            </td>
                                                            <td>
                                                                <div class="fw-bold">${appointment.advisorName != null ? appointment.advisorName : 'Unknown Advisor'}</div>
                                                                <small class="text-muted">${appointment.advisorTitle != null ? appointment.advisorTitle : ''}</small>
                                                            </td>
                                                            <td>
                                                                <span class="appointment-type-badge">
                                                                    ${appointment.appointmentType}
                                                                </span>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${appointment.status == 'pending'}">
                                                                        <span class="badge status-pending">
                                                                            <i class="fas fa-clock me-1"></i>Pending
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${appointment.status == 'confirmed'}">
                                                                        <span class="badge status-confirmed">
                                                                            <i class="fas fa-check me-1"></i>Confirmed
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${appointment.status == 'completed'}">
                                                                        <span class="badge status-completed">
                                                                            <i class="fas fa-check-circle me-1"></i>Completed
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${appointment.status == 'cancelled'}">
                                                                        <span class="badge status-cancelled">
                                                                            <i class="fas fa-times me-1"></i>Cancelled
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-secondary">${appointment.status}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <button class="btn btn-sm btn-outline-primary btn-action" 
                                                                        onclick="viewAppointmentDetails(${appointment.id})"
                                                                        data-bs-toggle="modal" 
                                                                        data-bs-target="#appointmentModal${appointment.id}">
                                                                    <i class="fas fa-eye"></i> View
                                                                </button>
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
                    </div>

                    <div class="col-md-4">
                        <!-- Quick Actions -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h6 class="m-0 font-weight-bold text-primary">Quick Actions</h6>
                            </div>
                            <div class="card-body">
                                <div class="d-grid gap-2">
                                    <a href="book-appointment" class="btn btn-primary btn-action">
                                        <i class="fas fa-calendar-plus me-2"></i>Book New Appointment
                                    </a>
                                    <a href="student-dashboard" class="btn btn-outline-primary btn-action">
                                        <i class="fas fa-tachometer-alt me-2"></i>Back to Dashboard
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Appointment Statistics -->
                        <div class="card">
                            <div class="card-header">
                                <h6 class="m-0 font-weight-bold text-primary">Appointment Statistics</h6>
                            </div>
                            <div class="card-body">
                                <c:set var="totalCount" value="${fn:length(appointments)}" />
                                <c:set var="pendingCount" value="0" />
                                <c:set var="confirmedCount" value="0" />
                                <c:set var="completedCount" value="0" />
                                <c:set var="cancelledCount" value="0" />
                                
                                <c:forEach var="appointment" items="${appointments}">
                                    <c:choose>
                                        <c:when test="${appointment.status == 'pending'}">
                                            <c:set var="pendingCount" value="${pendingCount + 1}" />
                                        </c:when>
                                        <c:when test="${appointment.status == 'confirmed'}">
                                            <c:set var="confirmedCount" value="${confirmedCount + 1}" />
                                        </c:when>
                                        <c:when test="${appointment.status == 'completed'}">
                                            <c:set var="completedCount" value="${completedCount + 1}" />
                                        </c:when>
                                        <c:when test="${appointment.status == 'cancelled'}">
                                            <c:set var="cancelledCount" value="${cancelledCount + 1}" />
                                        </c:when>
                                    </c:choose>
                                </c:forEach>

                                <div class="row text-center">
                                    <div class="col-6 mb-3">
                                        <h4 class="text-warning">${pendingCount}</h4>
                                        <small class="text-muted">Pending</small>
                                    </div>
                                    <div class="col-6 mb-3">
                                        <h4 class="text-success">${confirmedCount}</h4>
                                        <small class="text-muted">Confirmed</small>
                                    </div>
                                    <div class="col-6">
                                        <h4 class="text-secondary">${completedCount}</h4>
                                        <small class="text-muted">Completed</small>
                                    </div>
                                    <div class="col-6">
                                        <h4 class="text-danger">${cancelledCount}</h4>
                                        <small class="text-muted">Cancelled</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Appointment Detail Modals -->
    <c:forEach items="${appointments}" var="appointment">
        <div class="modal fade" id="appointmentModal${appointment.id}" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header" style="background: linear-gradient(45deg, var(--primary-color), var(--secondary-color)); color: white;">
                        <h5 class="modal-title">
                            <i class="fas fa-calendar-alt me-2"></i>Appointment Details
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row mb-3">
                            <div class="col-6">
                                <strong>Date:</strong><br>
                                <span class="text-muted">${appointment.date}</span>
                            </div>
                            <div class="col-6">
                                <strong>Time:</strong><br>
                                <span class="text-muted">${appointment.time}</span>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-12">
                                <strong>Advisor:</strong><br>
                                <span class="text-muted">${appointment.advisorName != null ? appointment.advisorName : 'Unknown Advisor'}</span>
                            </div>
                        </div>
                        <div class="row mb-3">
                            <div class="col-6">
                                <strong>Type:</strong><br>
                                <span class="appointment-type-badge">${appointment.appointmentType}</span>
                            </div>
                            <div class="col-6">
                                <strong>Status:</strong><br>
                                <c:choose>
                                    <c:when test="${appointment.status == 'pending'}">
                                        <span class="badge status-pending">Pending</span>
                                    </c:when>
                                    <c:when test="${appointment.status == 'confirmed'}">
                                        <span class="badge status-confirmed">Confirmed</span>
                                    </c:when>
                                    <c:when test="${appointment.status == 'completed'}">
                                        <span class="badge status-completed">Completed</span>
                                    </c:when>
                                    <c:when test="${appointment.status == 'cancelled'}">
                                        <span class="badge status-cancelled">Cancelled</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">${appointment.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="mb-3">
                            <strong>Reason:</strong><br>
                            <span class="text-muted">${appointment.reason}</span>
                        </div>
                        <c:if test="${not empty appointment.additionalNotes}">
                            <div class="mb-3">
                                <strong>Additional Notes:</strong><br>
                                <span class="text-muted">${appointment.additionalNotes}</span>
                            </div>
                        </c:if>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        // Mobile sidebar toggle
        document.getElementById('sidebarToggle').addEventListener('click', function() {
            document.querySelector('.sidebar').classList.toggle('show');
        });

        // Function to view appointment details
        function viewAppointmentDetails(appointmentId) {
            // Modal is handled by Bootstrap data attributes
            console.log('Viewing appointment:', appointmentId);
        }
    </script>
</body>
</html> 
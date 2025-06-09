<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard</title>
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

        .stats-card {
            color: white;
        }

        .stats-card.primary {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
        }

        .stats-card.success {
            background: linear-gradient(45deg, var(--success-color), #4895ef);
        }

        .stats-card.warning {
            background: linear-gradient(45deg, var(--warning-color), #fd7e14);
        }

        .stats-card.info {
            background: linear-gradient(45deg, var(--info-color), #0ea5e9);
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
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
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

        /* Compact table styles */
        .table-sm td, .table-sm th {
            padding: 0.5rem;
            font-size: 0.875rem;
        }

        /* Compact stats cards */
        .stats-card .card-body {
            padding: 1rem;
        }

        .stats-card .h5 {
            font-size: 1.5rem;
        }

        /* Ensure no horizontal overflow */
        .table-responsive {
            max-width: 100%;
            overflow-x: auto;
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

        /* Responsive table adjustments */
        @media (max-width: 1200px) {
            .table th, .table td {
                font-size: 0.8rem;
                padding: 0.5rem 0.3rem;
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
                        <a class="nav-link active" href="student-dashboard">
                            <i class="fas fa-tachometer-alt"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="book-appointment">
                            <i class="fas fa-calendar-plus"></i> Book Appointment
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="my-appointments.jsp">
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
                            <h4 class="mb-0">Welcome, ${sessionScope.fullName != null ? sessionScope.fullName : sessionScope.username}</h4>
                            <p class="text-muted mb-0">Student Dashboard</p>
                        </div>
                    </div>
                    <div class="d-flex align-items-center">
                        <span class="me-3"><i class="fas fa-bell"></i></span>
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
                                        <div class="text-xs font-weight-bold text-white text-uppercase mb-1">
                                            Total Assignments</div>
                                        <div class="h5 mb-0 font-weight-bold text-white">${totalAssignments != null ? totalAssignments : 0}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-tasks stats-icon text-white"></i>
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
                                        <div class="text-xs font-weight-bold text-white text-uppercase mb-1">
                                            Completed Assignments</div>
                                        <div class="h5 mb-0 font-weight-bold text-white">${completedAssignments != null ? completedAssignments : 0}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-check-circle stats-icon text-white"></i>
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
                                        <div class="text-xs font-weight-bold text-white text-uppercase mb-1">
                                            Upcoming Appointments</div>
                                        <div class="h5 mb-0 font-weight-bold text-white">${upcomingAppointments != null ? upcomingAppointments : 0}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-calendar-check stats-icon text-white"></i>
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
                                        <div class="text-xs font-weight-bold text-white text-uppercase mb-1">
                                            In Progress</div>
                                        <div class="h5 mb-0 font-weight-bold text-white">
                                            <c:set var="inProgress" value="0" />
                                            <c:forEach var="assignment" items="${assignments}">
                                                <c:if test="${assignment.progress eq 'In Progress'}">
                                                    <c:set var="inProgress" value="${inProgress + 1}" />
                                                </c:if>
                                            </c:forEach>
                                            ${inProgress}
                                        </div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-clock stats-icon text-white"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Appointments -->
                <div class="card">
                    <div class="card-header">
                        <h6 class="m-0 font-weight-bold text-primary">Recent Appointments</h6>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Time</th>
                                        <th>Advisor</th>
                                        <th>Type</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty appointments}">
                                            <c:forEach var="appointment" items="${appointments}">
                                                <tr>
                                                    <td>${appointment.date}</td>
                                                    <td>${appointment.time}</td>
                                                    <td>${appointment.advisorName != null ? appointment.advisorName : appointment.advisorId}</td>
                                                    <td>${appointment.appointmentType}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${appointment.status == 'pending'}">
                                                                <span class="badge status-pending">Pending</span>
                                                            </c:when>
                                                            <c:when test="${appointment.status == 'confirmed'}">
                                                                <span class="badge status-confirmed">Confirmed</span>
                                                            </c:when>
                                                            <c:when test="${appointment.status == 'cancelled'}">
                                                                <span class="badge status-cancelled">Cancelled</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">${appointment.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <button class="btn btn-sm btn-outline-primary btn-action" 
                                                                onclick="viewAppointment(${appointment.id})">
                                                            <i class="fas fa-eye"></i> View
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6" class="text-center text-muted">No appointments found</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                        <c:if test="${not empty appointments}">
                            <div class="text-center mt-3">
                                <a href="my-appointments.jsp" class="btn btn-outline-primary">View All Appointments</a>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Assignments & Quick Actions -->
                <div class="row">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header">
                                <h6 class="m-0 font-weight-bold text-primary">Recent Assignments</h6>
                            </div>
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Topic</th>
                                                <th>Language</th>
                                                <th>Progress</th>
                                                <th>File</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${not empty assignments}">
                                                    <c:forEach var="assignment" items="${assignments}" begin="0" end="4">
                                                        <tr>
                                                            <td>
                                                                <div class="fw-bold">${assignment.topic}</div>
                                                                <small class="text-muted">${assignment.startDate}</small>
                                                            </td>
                                                            <td><span class="badge bg-info">${assignment.language}</span></td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${assignment.progress == 'Not Started'}">
                                                                        <span class="badge progress-not-started">Not Started</span>
                                                                    </c:when>
                                                                    <c:when test="${assignment.progress == 'In Progress'}">
                                                                        <span class="badge progress-in-progress">In Progress</span>
                                                                    </c:when>
                                                                    <c:when test="${assignment.progress == 'Completed'}">
                                                                        <span class="badge progress-completed">Completed</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-secondary">${assignment.progress}</span>
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
                                                                                <small class="text-muted">${assignment.formattedFileSize}</small>
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
                                                                    <c:choose>
                                                                        <c:when test="${assignment.hasFile()}">
                                                                            <a href="download-assignment-file?assignmentId=${assignment.id}" 
                                                                               class="btn btn-sm btn-outline-success" title="Download File">
                                                                                <i class="fas fa-download"></i>
                                                                            </a>
                                                                            <button class="btn btn-sm btn-outline-primary upload-btn" 
                                                                                    data-assignment-id="${assignment.id}" 
                                                                                    data-assignment-topic="${assignment.topic}"
                                                                                    data-action="replace"
                                                                                    title="Replace File">
                                                                                <i class="fas fa-sync"></i>
                                                                            </button>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <button class="btn btn-sm btn-outline-primary upload-btn" 
                                                                                    data-assignment-id="${assignment.id}" 
                                                                                    data-assignment-topic="${assignment.topic}"
                                                                                    data-action="upload"
                                                                                    title="Upload File">
                                                                                <i class="fas fa-upload"></i>
                                                                            </button>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                    <button class="btn btn-sm btn-outline-info view-assignment-btn" 
                                                                            data-assignment-id="${assignment.id}"
                                                                            title="View Details">
                                                                        <i class="fas fa-eye"></i>
                                                                    </button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <td colspan="5" class="text-center text-muted">No assignments found</td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-header">
                                <h6 class="m-0 font-weight-bold text-primary">Quick Actions</h6>
                            </div>
                            <div class="card-body">
                                <div class="d-grid gap-2">
                                    <a href="book-appointment" class="btn btn-primary btn-action">
                                        <i class="fas fa-calendar-plus me-2"></i>Book New Appointment
                                    </a>
                                    <a href="my-appointments.jsp" class="btn btn-outline-primary btn-action">
                                        <i class="fas fa-calendar-alt me-2"></i>View All Appointments
                                    </a>
                                </div>
                            </div>
                        </div>

                        <c:if test="${not empty professors}">
                            <div class="card">
                                <div class="card-header">
                                    <h6 class="m-0 font-weight-bold text-primary">Available Advisors</h6>
                                </div>
                                <div class="card-body">
                                    <div class="list-group">
                                        <c:forEach var="professor" items="${professors}" begin="0" end="2">
                                            <div class="list-group-item">
                                                <div class="d-flex w-100 justify-content-between">
                                                    <h6 class="mb-1">${professor.name}</h6>
                                                    <small class="text-success"><i class="fas fa-circle"></i> Available</small>
                                                </div>
                                                <p class="mb-1 text-muted">Academic Advisor</p>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script>
        function viewAppointment(appointmentId) {
            // Redirect to appointment details or show modal
            window.location.href = 'my-appointments.jsp?highlight=' + appointmentId;
        }

        // Add some interactivity
        $(document).ready(function() {
            // Tooltip for stats cards
            $('[data-bs-toggle="tooltip"]').tooltip();
            
            // Mobile sidebar toggle
            $('#sidebarToggle').click(function() {
                $('.sidebar').toggleClass('show');
            });
            
            // Close sidebar when clicking outside on mobile
            $(document).click(function(e) {
                if ($(window).width() <= 576) {
                    if (!$(e.target).closest('.sidebar, #sidebarToggle').length) {
                        $('.sidebar').removeClass('show');
                    }
                }
            });
            
            // Auto-refresh dashboard every 5 minutes
            setInterval(function() {
                location.reload();
            }, 300000);
        
        // File upload functions
        function openUploadModal(assignmentId, assignmentTopic) {
            document.getElementById('fileUploadAssignmentId').value = assignmentId;
            document.getElementById('fileUploadModalLabel').textContent = 'Upload File for: ' + assignmentTopic;
            document.getElementById('currentFileName').style.display = 'none';
            document.getElementById('fileUploadButton').textContent = 'Upload File';
            document.getElementById('fileUploadForm').reset();
            var modal = new bootstrap.Modal(document.getElementById('fileUploadModal'));
            modal.show();
        }
        
        function openReplaceFileModal(assignmentId, assignmentTopic) {
            document.getElementById('fileUploadAssignmentId').value = assignmentId;
            document.getElementById('fileUploadModalLabel').textContent = 'Replace File for: ' + assignmentTopic;
            document.getElementById('currentFileName').style.display = 'block';
            document.getElementById('fileUploadButton').textContent = 'Replace File';
            document.getElementById('fileUploadForm').reset();
            var modal = new bootstrap.Modal(document.getElementById('fileUploadModal'));
            modal.show();
        }
        
        // Event delegation for upload buttons
        $(document).on('click', '.upload-btn', function() {
            const assignmentId = $(this).data('assignment-id');
            const assignmentTopic = $(this).data('assignment-topic');
            const action = $(this).data('action');
            
            if (action === 'replace') {
                openReplaceFileModal(assignmentId, assignmentTopic);
            } else {
                openUploadModal(assignmentId, assignmentTopic);
            }
        });
        
        // Event delegation for view assignment buttons
        $(document).on('click', '.view-assignment-btn', function() {
            const assignmentId = $(this).data('assignment-id');
            viewAssignmentDetails(assignmentId);
        });
        
        function viewAssignmentDetails(assignmentId) {
            // This could open a detailed view modal or redirect to assignment details page
            console.log('Viewing assignment details for ID:', assignmentId);
        }
        
        // Handle file upload form submission
        document.addEventListener('DOMContentLoaded', function() {
            const fileUploadForm = document.getElementById('fileUploadForm');
            if (fileUploadForm) {
                fileUploadForm.addEventListener('submit', function(e) {
                    const fileInput = document.getElementById('assignmentFile');
                    if (!fileInput.value) {
                        e.preventDefault();
                        alert('Please select a file to upload.');
                        return false;
                    }
                    
                    // Show loading state
                    const submitBtn = document.getElementById('fileUploadButton');
                    const originalText = submitBtn.textContent;
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Uploading...';
                    
                    // Reset on completion (this would be handled by page reload)
                    setTimeout(() => {
                        submitBtn.disabled = false;
                        submitBtn.textContent = originalText;
                    }, 30000); // 30 second timeout
                });
            }
        });
        
        // Handle success/error messages from URL parameters
        $(document).ready(function() {
            const urlParams = new URLSearchParams(window.location.search);
            const success = urlParams.get('success');
            const error = urlParams.get('error');
            
            if (success === 'file_uploaded') {
                showAlert('File uploaded successfully!', 'success');
            } else if (error) {
                let errorMessage = 'An error occurred.';
                switch(error) {
                    case 'file_too_large':
                        errorMessage = 'File is too large. Maximum size is 10MB.';
                        break;
                    case 'invalid_file_type':
                        errorMessage = 'Invalid file type. Please upload PDF, DOC, TXT, ZIP, or code files.';
                        break;
                    case 'no_file_selected':
                        errorMessage = 'Please select a file to upload.';
                        break;
                    case 'permission_denied':
                        errorMessage = 'You don\'t have permission to upload files for this assignment.';
                        break;
                    case 'upload_failed':
                        errorMessage = 'File upload failed. Please try again.';
                        break;
                }
                showAlert(errorMessage, 'danger');
            }
        });
        
        function showAlert(message, type) {
            const alertDiv = document.createElement('div');
            alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
            alertDiv.innerHTML = `
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;
            
            const container = document.querySelector('.main-content');
            container.insertBefore(alertDiv, container.firstChild);
            
            // Auto-dismiss after 5 seconds
            setTimeout(() => {
                alertDiv.remove();
            }, 5000);
        }
        
        });
    </script>

    <!-- File Upload Modal -->
    <div class="modal fade" id="fileUploadModal" tabindex="-1" aria-labelledby="fileUploadModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="fileUploadModalLabel">Upload Assignment File</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="fileUploadForm" action="upload-assignment-file" method="post" enctype="multipart/form-data">
                    <div class="modal-body">
                        <input type="hidden" id="fileUploadAssignmentId" name="assignmentId">
                        
                        <div id="currentFileName" class="alert alert-info" style="display: none;">
                            <i class="fas fa-info-circle"></i> This will replace the existing file.
                        </div>
                        
                        <div class="mb-3">
                            <label for="assignmentFile" class="form-label">Select File</label>
                            <input type="file" class="form-control" id="assignmentFile" name="assignmentFile" 
                                   accept=".pdf,.doc,.docx,.txt,.zip,.rar,.java,.py,.cpp,.c,.js,.html,.css" required>
                            <div class="form-text">
                                Supported formats: PDF, DOC, DOCX, TXT, ZIP, RAR, Java, Python, C/C++, JavaScript, HTML, CSS<br>
                                Maximum file size: 10MB
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <small class="text-muted">
                                <i class="fas fa-shield-alt"></i> Files are securely stored and only accessible to you and your supervisor.
                            </small>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" id="fileUploadButton" class="btn btn-primary">Upload File</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html> 
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Database Viewer - Secretary</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #6f42c1;
            --secondary-color: #5a32a3;
            --success-color: #198754;
            --warning-color: #fd7e14;
            --info-color: #0dcaf0;
            --danger-color: #dc3545;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f5f7fb;
        }

        .navbar {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .main-container {
            padding: 30px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .section-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
            border: none;
            overflow: hidden;
        }

        .section-header {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 20px 30px;
            border: none;
            font-weight: 600;
            font-size: 1.2rem;
        }

        .section-body {
            padding: 30px;
        }

        .table {
            margin-bottom: 0;
        }

        .table th {
            background-color: #f8f9fa;
            border-top: none;
            font-weight: 600;
            color: var(--primary-color);
            padding: 15px;
        }

        .table td {
            padding: 12px 15px;
            vertical-align: middle;
        }

        .badge {
            font-size: 0.75rem;
            padding: 0.5em 0.75em;
        }

        .btn-floating {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            border: none;
            color: white;
            box-shadow: 0 4px 12px rgba(0,0,0,0.3);
            font-size: 1.5rem;
            z-index: 1000;
            transition: all 0.3s ease;
        }

        .btn-floating:hover {
            transform: scale(1.1);
            box-shadow: 0 6px 20px rgba(0,0,0,0.4);
        }

        .stats-bar {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
            margin: 0;
        }

        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
        }

        .nav-pills .nav-link {
            border-radius: 25px;
            margin-right: 10px;
            font-weight: 500;
        }

        .nav-pills .nav-link.active {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="secretary-dashboard">
                <i class="fas fa-database me-2"></i>Database Viewer
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="secretary-dashboard">
                    <i class="fas fa-arrow-left me-1"></i>Back to Dashboard
                </a>
                <a class="nav-link" href="UserManagementServlet?action=manageUsers">
                    <i class="fas fa-users-cog me-1"></i>User Management
                </a>
            </div>
        </div>
    </nav>

    <div class="main-container">
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <strong>Database Error:</strong> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Quick Stats -->
        <div class="stats-bar">
            <div class="row">
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number" id="userCount">0</div>
                        <div class="stat-label">Total Users</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number" id="assignmentCount">0</div>
                        <div class="stat-label">Projects</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number" id="appointmentCount">0</div>
                        <div class="stat-label">Appointments</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number" id="lastUpdate">Now</div>
                        <div class="stat-label">Last Updated</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Navigation Pills -->
        <ul class="nav nav-pills mb-4" id="databaseTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="users-tab" data-bs-toggle="pill" data-bs-target="#users" type="button" role="tab">
                    <i class="fas fa-users me-2"></i>Users
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="assignments-tab" data-bs-toggle="pill" data-bs-target="#assignments" type="button" role="tab">
                    <i class="fas fa-project-diagram me-2"></i>Projects
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="appointments-tab" data-bs-toggle="pill" data-bs-target="#appointments" type="button" role="tab">
                    <i class="fas fa-calendar-alt me-2"></i>Appointments
                </button>
            </li>
        </ul>

        <!-- Tab Content -->
        <div class="tab-content" id="databaseTabContent">
            <!-- Users Tab -->
            <div class="tab-pane fade show active" id="users" role="tabpanel">
                <div class="section-card">
                    <div class="section-header">
                        <i class="fas fa-users me-2"></i>System Users
                    </div>
                    <div class="section-body">
                        <c:choose>
                            <c:when test="${not empty users}">
                                <div class="table-responsive">
                                    ${users}
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-users"></i>
                                    <h5>No Users Found</h5>
                                    <p>There are currently no users in the database.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Projects Tab -->
            <div class="tab-pane fade" id="assignments" role="tabpanel">
                <div class="section-card">
                    <div class="section-header">
                        <i class="fas fa-project-diagram me-2"></i>Student Projects
                    </div>
                    <div class="section-body">
                        <c:choose>
                            <c:when test="${not empty assignments}">
                                <div class="table-responsive">
                                    ${assignments}
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-project-diagram"></i>
                                    <h5>No Projects Found</h5>
                                    <p>There are currently no projects in the database.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Appointments Tab -->
            <div class="tab-pane fade" id="appointments" role="tabpanel">
                <div class="section-card">
                    <div class="section-header">
                        <i class="fas fa-calendar-alt me-2"></i>Student Appointments
                    </div>
                    <div class="section-body">
                        <c:choose>
                            <c:when test="${not empty appointments}">
                                <div class="table-responsive">
                                    ${appointments}
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-calendar-alt"></i>
                                    <h5>No Appointments Found</h5>
                                    <p>There are currently no appointments in the database.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Floating Action Button -->
    <button class="btn btn-floating" onclick="refreshData()" title="Refresh Data">
        <i class="fas fa-sync-alt"></i>
    </button>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            updateStats();
            updateLastUpdateTime();
        });

        function updateStats() {
            // Count rows in each table
            const userRows = document.querySelectorAll('#users tbody tr').length;
            const assignmentRows = document.querySelectorAll('#assignments tbody tr').length;
            const appointmentRows = document.querySelectorAll('#appointments tbody tr').length;

            document.getElementById('userCount').textContent = userRows;
            document.getElementById('assignmentCount').textContent = assignmentRows;
            document.getElementById('appointmentCount').textContent = appointmentRows;
        }

        function updateLastUpdateTime() {
            const now = new Date();
            const timeString = now.toLocaleTimeString();
            document.getElementById('lastUpdate').textContent = timeString;
        }

        function refreshData() {
            // Animate the refresh button
            const btn = document.querySelector('.btn-floating i');
            btn.style.animation = 'spin 1s linear infinite';
            
            // Reload the page to get fresh data
            setTimeout(() => {
                window.location.reload();
            }, 500);
        }

        // Add custom CSS animation for spin
        const style = document.createElement('style');
        style.textContent = `
            @keyframes spin {
                from { transform: rotate(0deg); }
                to { transform: rotate(360deg); }
            }
        `;
        document.head.appendChild(style);

        // Auto-refresh every 30 seconds
        setInterval(() => {
            updateLastUpdateTime();
        }, 30000);
    </script>
</body>
</html> 
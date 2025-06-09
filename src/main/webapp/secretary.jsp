<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secretary Dashboard</title>
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
            color: white;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
        }

        .stats-card.primary {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
        }

        .stats-card.success {
            background: linear-gradient(45deg, var(--success-color), #20c997);
        }

        .stats-card.warning {
            background: linear-gradient(45deg, var(--warning-color), #ffc107);
        }

        .stats-card.info {
            background: linear-gradient(45deg, var(--info-color), #0dcaf0);
        }

        .stats-icon {
            font-size: 2rem;
            opacity: 0.8;
        }

        .btn-action {
            padding: 12px 24px;
            border-radius: 8px;
            font-size: 0.875rem;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            margin: 5px;
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .btn-primary-custom {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
        }

        .btn-success-custom {
            background: linear-gradient(45deg, var(--success-color), #20c997);
            color: white;
        }

        .btn-warning-custom {
            background: linear-gradient(45deg, var(--warning-color), #ffc107);
            color: white;
        }

        .btn-info-custom {
            background: linear-gradient(45deg, var(--info-color), #0dcaf0);
            color: white;
        }

        .btn-danger-custom {
            background: linear-gradient(45deg, var(--danger-color), #e83e8c);
            color: white;
        }

        .btn-secondary-custom {
            background: linear-gradient(45deg, #6c757d, #495057);
            color: white;
        }

        .action-card {
            text-align: center;
            padding: 30px 20px;
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .action-icon {
            font-size: 3rem;
            margin-bottom: 20px;
            color: var(--primary-color);
        }

        .action-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 15px;
            color: var(--dark-color);
        }

        .action-description {
            color: #6c757d;
            margin-bottom: 20px;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="sidebar-brand">
                    <h2><i class="fas fa-user-shield me-2"></i>Secretary</h2>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link active" href="secretary-dashboard">
                            <i class="fas fa-tachometer-alt"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="UserManagementServlet?action=manageUsers">
                            <i class="fas fa-users-cog"></i> User Management
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="SecretaryServlet?action=viewDatabase">
                            <i class="fas fa-database"></i> Database Viewer
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="setup-test-data">
                            <i class="fas fa-cogs"></i> Setup Test Data
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="diagnostic">
                            <i class="fas fa-stethoscope"></i> System Diagnostics
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
            <div class="main-content">
                <!-- Topbar -->
                <div class="topbar d-flex justify-content-between align-items-center">
                    <div>
                        <h4 class="mb-0">Welcome, <%= session.getAttribute("username") %>!</h4>
                        <small class="text-muted">Secretary Dashboard - Administrative Control Panel</small>
                    </div>
                    <div class="d-flex align-items-center">
                        <span class="me-3"><i class="fas fa-bell"></i></span>
                        <span><i class="fas fa-user-circle"></i></span>
                    </div>
                </div>

                <!-- Stats Cards -->
                <div class="row mb-4">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card primary h-100">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col">
                                        <div class="text-xs font-weight-bold text-white text-uppercase mb-1">
                                            Total Users</div>
                                        <div class="h5 mb-0 font-weight-bold text-white" id="totalUsers">-</div>
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
                                        <div class="text-xs font-weight-bold text-white text-uppercase mb-1">
                                            Students</div>
                                        <div class="h5 mb-0 font-weight-bold text-white" id="totalStudents">-</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-user-graduate stats-icon"></i>
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
                                            Professors</div>
                                        <div class="h5 mb-0 font-weight-bold text-white" id="totalProfessors">-</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-chalkboard-teacher stats-icon"></i>
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
                                            Assignments</div>
                                        <div class="h5 mb-0 font-weight-bold text-white" id="totalAssignments">-</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-tasks stats-icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Main Action Cards -->
                <div class="row">
                    <!-- User Management Card -->
                    <div class="col-lg-4 col-md-6 mb-4">
                        <div class="card action-card h-100">
                            <div class="card-body">
                                <div class="action-icon">
                                    <i class="fas fa-users-cog"></i>
                                </div>
                                <div class="action-title">User Management</div>
                                <div class="action-description">
                                    Complete user management system. Create, edit, delete, and manage all user accounts with a modern interface.
                                </div>
                                <a href="UserManagementServlet?action=manageUsers" class="btn btn-action btn-success-custom">
                                    <i class="fas fa-cog me-2"></i>Manage Users
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Database Viewer Card -->
                    <div class="col-lg-4 col-md-6 mb-4">
                        <div class="card action-card h-100">
                            <div class="card-body">
                                <div class="action-icon">
                                    <i class="fas fa-database"></i>
                                </div>
                                <div class="action-title">Database Viewer</div>
                                <div class="action-description">
                                    View and browse all database tables. See users, assignments, appointments and all data in the system.
                                </div>
                                <a href="SecretaryServlet?action=viewDatabase" class="btn btn-action btn-primary-custom">
                                    <i class="fas fa-eye me-2"></i>View Database
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Actions Card -->
                    <div class="col-lg-4 col-md-6 mb-4">
                        <div class="card action-card h-100">
                            <div class="card-body">
                                <div class="action-icon">
                                    <i class="fas fa-bolt"></i>
                                </div>
                                <div class="action-title">Quick Actions</div>
                                <div class="action-description">
                                    Quick administrative actions for managing the system and setting up test data.
                                </div>
                                <div class="d-grid gap-2">
                                    <a href="sample-data" class="btn btn-action btn-info-custom">
                                        <i class="fas fa-seedling me-2"></i>Generate Sample Data
                                    </a>
                                    <a href="debug-users" class="btn btn-action btn-secondary-custom">
                                        <i class="fas fa-bug me-2"></i>Debug Users
                                    </a>
                                    <a href="setup-test-data" class="btn btn-action btn-warning-custom">
                                        <i class="fas fa-plus me-2"></i>Setup Test Data
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- System Diagnostics Card -->
                    <div class="col-lg-4 col-md-6 mb-4">
                        <div class="card action-card h-100">
                            <div class="card-body">
                                <div class="action-icon">
                                    <i class="fas fa-stethoscope"></i>
                                </div>
                                <div class="action-title">System Diagnostics</div>
                                <div class="action-description">
                                    Check database connectivity, view system status, and troubleshoot any issues.
                                </div>
                                <a href="diagnostic" class="btn btn-action btn-info-custom">
                                    <i class="fas fa-heartbeat me-2"></i>Run Diagnostics
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Clear Data Card -->
                    <div class="col-lg-4 col-md-6 mb-4">
                        <div class="card action-card h-100">
                            <div class="card-body">
                                <div class="action-icon">
                                    <i class="fas fa-trash-alt"></i>
                                </div>
                                <div class="action-title">Clear Database</div>
                                <div class="action-description">
                                    Clear all test data from the database. Use with caution - this action cannot be undone!
                                </div>
                                <button onclick="clearDatabase()" class="btn btn-action btn-danger-custom">
                                    <i class="fas fa-exclamation-triangle me-2"></i>Clear Data
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Backup & Export Card -->
                    <div class="col-lg-4 col-md-6 mb-4">
                        <div class="card action-card h-100">
                            <div class="card-body">
                                <div class="action-icon">
                                    <i class="fas fa-download"></i>
                                </div>
                                <div class="action-title">Export Data</div>
                                <div class="action-description">
                                    Export user data, assignments, and appointments to CSV format for backup or analysis.
                                </div>
                                <button onclick="exportData()" class="btn btn-action btn-primary-custom">
                                    <i class="fas fa-file-export me-2"></i>Export CSV
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Activity -->
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h6 class="m-0 font-weight-bold"><i class="fas fa-history me-2"></i>Recent Activity</h6>
                            </div>
                            <div class="card-body" id="recentActivity">
                                <div class="text-center text-muted">
                                    <i class="fas fa-spinner fa-spin"></i> Loading recent activity...
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Load statistics when page loads
        document.addEventListener('DOMContentLoaded', function() {
            loadStatistics();
            loadRecentActivity();
        });

        function loadStatistics() {
            fetch('SecretaryServlet?action=getStats')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('totalUsers').textContent = data.totalUsers || 0;
                    document.getElementById('totalStudents').textContent = data.totalStudents || 0;
                    document.getElementById('totalProfessors').textContent = data.totalProfessors || 0;
                    document.getElementById('totalAssignments').textContent = data.totalAssignments || 0;
                })
                .catch(error => {
                    console.error('Error loading statistics:', error);
                });
        }

        function loadRecentActivity() {
            // Simulate recent activity data
            const activities = [
                {
                    icon: 'fa-user-plus',
                    color: 'text-success',
                    action: 'New user registered',
                    details: 'Student account created for John Smith',
                    time: '2 hours ago'
                },
                {
                    icon: 'fa-edit',
                    color: 'text-warning',
                    action: 'Profile updated',
                    details: 'Professor Dr. Jane Anderson updated contact info',
                    time: '4 hours ago'
                },
                {
                    icon: 'fa-database',
                    color: 'text-info',
                    action: 'Database accessed',
                    details: 'Secretary viewed user database',
                    time: '6 hours ago'
                }
            ];

            const activityHtml = activities.map(activity => `
                <div class="list-group-item d-flex justify-content-between align-items-center">
                    <div>
                        <i class="fas ${activity.icon} ${activity.color} me-2"></i>
                        <strong>${activity.action}:</strong> ${activity.details}
                    </div>
                    <small class="text-muted">${activity.time}</small>
                </div>
            `).join('');

            document.getElementById('recentActivity').innerHTML = 
                '<div class="list-group list-group-flush">' + activityHtml + '</div>';
        }

        function clearDatabase() {
            if (confirm('Are you sure you want to clear ALL data from the database? This action cannot be undone!')) {
                if (confirm('This will delete all users, assignments, and appointments. Are you absolutely sure?')) {
                    fetch('SecretaryServlet', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'action=clearDatabase'
                    })
                    .then(response => response.text())
                    .then(result => {
                        alert('Database cleared successfully');
                        loadStatistics();
                    })
                    .catch(error => {
                        console.error('Error clearing database:', error);
                        alert('Error clearing database');
                    });
                }
            }
        }

        function exportData() {
            if (confirm('Export all data to CSV files?')) {
                window.open('SecretaryServlet?action=exportData', '_blank');
            }
        }
    </script>
</body>
</html> 
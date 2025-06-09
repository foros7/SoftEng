<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Secretary Dashboard</title>
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

        .header-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
            padding: 30px;
            border: none;
        }

        .stats-card {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 30px;
            text-align: center;
        }

        .stats-number {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0;
        }

        .stats-label {
            font-size: 1rem;
            opacity: 0.9;
        }

        .users-table-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border: none;
            overflow: hidden;
        }

        .table {
            margin-bottom: 0;
        }

        .table th {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
            border: none;
            font-weight: 600;
            padding: 15px;
        }

        .table td {
            padding: 15px;
            vertical-align: middle;
            border-color: #f1f3f4;
        }

        .badge {
            font-size: 0.75rem;
            padding: 0.5em 0.75em;
        }

        .btn-action {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
            border: none;
            margin: 2px;
            transition: all 0.3s ease;
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .search-container {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .modal-content {
            border-radius: 15px;
            border: none;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }

        .modal-header {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
            border-radius: 15px 15px 0 0;
            border: none;
        }

        .form-floating {
            margin-bottom: 20px;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(111, 66, 193, 0.25);
        }

        .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(111, 66, 193, 0.25);
        }

        .loading-spinner {
            text-align: center;
            padding: 50px;
            color: var(--primary-color);
        }

        .empty-state {
            text-align: center;
            padding: 50px;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            margin-right: 10px;
        }

        .table-row:hover {
            background-color: #f8f9fa;
        }

        .alert {
            border-radius: 10px;
            border: none;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="secretary-dashboard">
                <i class="fas fa-users-cog me-2"></i>User Management
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="secretary-dashboard">
                    <i class="fas fa-arrow-left me-1"></i>Back to Dashboard
                </a>
                <a class="nav-link" href="SecretaryServlet?action=viewDatabase">
                    <i class="fas fa-database me-1"></i>Database Viewer
                </a>
            </div>
        </div>
    </nav>

    <div class="main-container">
        <!-- Header -->
        <div class="header-card">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h2 class="mb-1"><i class="fas fa-users-cog me-2 text-primary"></i>User Management System</h2>
                    <p class="text-muted mb-0">Manage all system users with complete CRUD operations</p>
                </div>
                <div class="col-md-4 text-end">
                    <button class="btn btn-primary btn-lg" onclick="showAddUserModal()">
                        <i class="fas fa-plus me-2"></i>Add New User
                    </button>
                </div>
            </div>
        </div>

        <!-- Statistics -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number" id="totalUsersCount">0</div>
                    <div class="stats-label">Total Users</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card bg-success">
                    <div class="stats-number" id="studentsCount">0</div>
                    <div class="stats-label">Students</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card bg-warning">
                    <div class="stats-number" id="professorsCount">0</div>
                    <div class="stats-label">Professors</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card bg-info">
                    <div class="stats-number" id="secretariesCount">0</div>
                    <div class="stats-label">Secretaries</div>
                </div>
            </div>
        </div>

        <!-- Search and Filters -->
        <div class="search-container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                        <input type="text" class="form-control" id="searchInput" placeholder="Search by username, name, email...">
                    </div>
                </div>
                <div class="col-md-3">
                    <select class="form-select" id="filterByType">
                        <option value="">All User Types</option>
                        <option value="student">Students</option>
                        <option value="professor">Professors</option>
                        <option value="secretary">Secretaries</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <button class="btn btn-outline-primary" onclick="refreshUsers()">
                        <i class="fas fa-sync-alt me-2"></i>Refresh
                    </button>
                </div>
            </div>
        </div>

        <!-- Alert Container -->
        <div id="alertContainer"></div>

        <!-- Users Table -->
        <div class="users-table-card">
            <div id="usersTableContainer">
                <div class="loading-spinner">
                    <i class="fas fa-spinner fa-spin fa-3x"></i>
                    <p class="mt-3">Loading users...</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Add/Edit User Modal -->
    <div class="modal fade" id="userModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitle">
                        <i class="fas fa-user-plus me-2"></i>Add New User
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="userForm">
                        <input type="hidden" id="userId" name="id">
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="username" name="username" required>
                                    <label for="username">Username</label>
                                </div>
                            </div>
                            <div class="col-md-6" id="passwordGroup">
                                <div class="form-floating">
                                    <input type="password" class="form-control" id="password" name="password" required>
                                    <label for="password">Password</label>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="name" name="name" required>
                                    <label for="name">Full Name</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <select class="form-select" id="userType" name="userType" required>
                                        <option value="">Select User Type</option>
                                        <option value="student">Student</option>
                                        <option value="professor">Professor</option>
                                        <option value="secretary">Secretary</option>
                                    </select>
                                    <label for="userType">User Type</label>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="email" class="form-control" id="email" name="email">
                                    <label for="email">Email Address</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="tel" class="form-control" id="phone" name="phone">
                                    <label for="phone">Phone Number</label>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="saveUserBtn" onclick="saveUser()">
                        <i class="fas fa-save me-2"></i>Save User
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        let users = [];
        let filteredUsers = [];
        const userModal = new bootstrap.Modal(document.getElementById('userModal'));

        // Load users when page loads
        document.addEventListener('DOMContentLoaded', function() {
            loadUsers();
            setupEventListeners();
        });

        function setupEventListeners() {
            document.getElementById('searchInput').addEventListener('input', filterUsers);
            document.getElementById('filterByType').addEventListener('change', filterUsers);
        }

        function loadUsers() {
            fetch('UserManagementServlet?action=list')
                .then(response => response.json())
                .then(data => {
                    users = data;
                    filteredUsers = [...users];
                    updateStatistics();
                    renderUsersTable();
                })
                .catch(error => {
                    console.error('Error loading users:', error);
                    showAlert('Error loading users: ' + error.message, 'danger');
                });
        }

        function updateStatistics() {
            const total = users.length;
            const students = users.filter(u => u.userType === 'student').length;
            const professors = users.filter(u => u.userType === 'professor').length;
            const secretaries = users.filter(u => u.userType === 'secretary').length;

            document.getElementById('totalUsersCount').textContent = total;
            document.getElementById('studentsCount').textContent = students;
            document.getElementById('professorsCount').textContent = professors;
            document.getElementById('secretariesCount').textContent = secretaries;
        }

        function renderUsersTable() {
            const container = document.getElementById('usersTableContainer');
            
            if (filteredUsers.length === 0) {
                container.innerHTML = 
                    '<div class="empty-state">' +
                        '<i class="fas fa-users"></i>' +
                        '<h5>No Users Found</h5>' +
                        '<p>No users match your current filters.</p>' +
                    '</div>';
                return;
            }

            let tableHtml = 
                '<div class="table-responsive">' +
                    '<table class="table table-hover">' +
                        '<thead>' +
                            '<tr>' +
                                '<th>User</th>' +
                                '<th>Username</th>' +
                                '<th>Type</th>' +
                                '<th>Email</th>' +
                                '<th>Phone</th>' +
                                '<th>Created</th>' +
                                '<th>Actions</th>' +
                            '</tr>' +
                        '</thead>' +
                        '<tbody>';

            filteredUsers.forEach(function(user) {
                tableHtml += 
                    '<tr class="table-row">' +
                        '<td>' +
                            '<div class="d-flex align-items-center">' +
                                '<div class="user-avatar">' +
                                    (user.name ? user.name.charAt(0).toUpperCase() : 'U') +
                                '</div>' +
                                '<div>' +
                                    '<div class="fw-bold">' + (user.name || 'No Name') + '</div>' +
                                    '<small class="text-muted">ID: ' + user.id + '</small>' +
                                '</div>' +
                            '</div>' +
                        '</td>' +
                        '<td><code>' + user.username + '</code></td>' +
                        '<td><span class="badge bg-' + getUserTypeBadgeColor(user.userType) + '">' + user.userType + '</span></td>' +
                        '<td>' + (user.email || '<span class="text-muted">No email</span>') + '</td>' +
                        '<td>' + (user.phone || '<span class="text-muted">No phone</span>') + '</td>' +
                        '<td><small>' + formatDate(user.createdAt) + '</small></td>' +
                        '<td>' +
                            '<button class="btn btn-sm btn-outline-primary btn-action" onclick="editUser(' + user.id + ')" title="Edit User">' +
                                '<i class="fas fa-edit"></i>' +
                            '</button>';
                
                if (user.userType !== 'secretary') {
                    tableHtml += 
                        '<button class="btn btn-sm btn-outline-danger btn-action" onclick="deleteUser(' + user.id + ')" title="Delete User">' +
                            '<i class="fas fa-trash"></i>' +
                        '</button>';
                }
                
                tableHtml += '</td></tr>';
            });

            tableHtml += '</tbody></table></div>';
            container.innerHTML = tableHtml;
        }

        function getUserTypeBadgeColor(userType) {
            switch (userType?.toLowerCase()) {
                case 'student': return 'primary';
                case 'professor': return 'warning';
                case 'secretary': return 'success';
                default: return 'secondary';
            }
        }

        function formatDate(dateString) {
            if (!dateString) return 'Unknown';
            const date = new Date(dateString);
            return date.toLocaleDateString() + ' ' + date.toLocaleTimeString();
        }

        function filterUsers() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const typeFilter = document.getElementById('filterByType').value;

            filteredUsers = users.filter(user => {
                const matchesSearch = !searchTerm || 
                    user.username.toLowerCase().includes(searchTerm) ||
                    (user.name && user.name.toLowerCase().includes(searchTerm)) ||
                    (user.email && user.email.toLowerCase().includes(searchTerm));
                
                const matchesType = !typeFilter || user.userType === typeFilter;
                
                return matchesSearch && matchesType;
            });

            renderUsersTable();
        }

        function showAddUserModal() {
            document.getElementById('modalTitle').innerHTML = '<i class="fas fa-user-plus me-2"></i>Add New User';
            document.getElementById('userForm').reset();
            document.getElementById('userId').value = '';
            document.getElementById('passwordGroup').style.display = 'block';
            document.getElementById('password').required = true;
            userModal.show();
        }

        function editUser(userId) {
            const user = users.find(u => u.id === userId);
            if (!user) return;

            document.getElementById('modalTitle').innerHTML = '<i class="fas fa-user-edit me-2"></i>Edit User';
            document.getElementById('userId').value = user.id;
            document.getElementById('username').value = user.username;
            document.getElementById('name').value = user.name || '';
            document.getElementById('userType').value = user.userType;
            document.getElementById('email').value = user.email || '';
            document.getElementById('phone').value = user.phone || '';
            
            // Hide password field for editing
            document.getElementById('passwordGroup').style.display = 'none';
            document.getElementById('password').required = false;
            
            userModal.show();
        }

        function saveUser() {
            const form = document.getElementById('userForm');
            const formData = new FormData(form);
            
            const userId = formData.get('id');
            const action = userId ? 'update' : 'create';
            
            const saveBtn = document.getElementById('saveUserBtn');
            saveBtn.disabled = true;
            saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Saving...';

            fetch('UserManagementServlet', {
                method: 'POST',
                body: new URLSearchParams({
                    action: action,
                    id: formData.get('id'),
                    username: formData.get('username'),
                    password: formData.get('password'),
                    name: formData.get('name'),
                    userType: formData.get('userType'),
                    email: formData.get('email'),
                    phone: formData.get('phone')
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success !== false) {
                    showAlert(`User ${action === 'create' ? 'created' : 'updated'} successfully!`, 'success');
                    userModal.hide();
                    loadUsers();
                } else {
                    showAlert('Error: ' + (data.error || 'Failed to save user'), 'danger');
                }
            })
            .catch(error => {
                console.error('Error saving user:', error);
                showAlert('Error saving user: ' + error.message, 'danger');
            })
            .finally(() => {
                saveBtn.disabled = false;
                saveBtn.innerHTML = '<i class="fas fa-save me-2"></i>Save User';
            });
        }

        function deleteUser(userId) {
            const user = users.find(u => u.id === userId);
            if (!user) return;

            if (confirm(`Are you sure you want to delete user "${user.username}"?\n\nThis action cannot be undone!`)) {
                fetch('UserManagementServlet', {
                    method: 'POST',
                    body: new URLSearchParams({
                        action: 'delete',
                        id: userId
                    })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showAlert('User deleted successfully!', 'success');
                        loadUsers();
                    } else {
                        showAlert('Error deleting user', 'danger');
                    }
                })
                .catch(error => {
                    console.error('Error deleting user:', error);
                    showAlert('Error deleting user: ' + error.message, 'danger');
                });
            }
        }

        function refreshUsers() {
            document.getElementById('searchInput').value = '';
            document.getElementById('filterByType').value = '';
            loadUsers();
        }

        function showAlert(message, type) {
            const alertContainer = document.getElementById('alertContainer');
            const alertId = 'alert-' + Date.now();
            
            const alert = 
                '<div class="alert alert-' + type + ' alert-dismissible fade show" role="alert" id="' + alertId + '">' +
                    '<i class="fas fa-' + (type === 'success' ? 'check-circle' : 'exclamation-triangle') + ' me-2"></i>' +
                    message +
                    '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>' +
                '</div>';
            
            alertContainer.innerHTML = alert;
            
            // Auto-hide after 5 seconds
            setTimeout(() => {
                const alertElement = document.getElementById(alertId);
                if (alertElement) {
                    bootstrap.Alert.getOrCreateInstance(alertElement).close();
                }
            }, 5000);
        }
    </script>
</body>
</html> 
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments - Appointment Management System</title>
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
                        <a class="nav-link" href="book-appointment.jsp">
                            <i class="fas fa-calendar-plus"></i> Book Appointment
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="my-appointments.jsp">
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
                    <h4 class="mb-0">My Appointments</h4>
                    <div class="d-flex align-items-center">
                        <span class="me-3"><i class="fas fa-bell"></i></span>
                        <span><i class="fas fa-user-circle"></i></span>
                    </div>
                </div>

                <!-- Filters -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form class="row g-3" action="view-appointments" method="GET">
                            <div class="col-md-3">
                                <label for="status" class="form-label">Status</label>
                                <select class="form-select" id="status">
                                    <option value="">All Status</option>
                                    <option value="upcoming">Upcoming</option>
                                    <option value="completed">Completed</option>
                                    <option value="cancelled">Cancelled</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="dateRange" class="form-label">Date Range</label>
                                <select class="form-select" id="dateRange">
                                    <option value="">All Time</option>
                                    <option value="today">Today</option>
                                    <option value="week">This Week</option>
                                    <option value="month">This Month</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="search" class="form-label">Search</label>
                                <input type="text" class="form-control" id="search" placeholder="Search appointments...">
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fas fa-filter me-2"></i>Filter
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Appointments List -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h6 class="m-0 font-weight-bold">Appointments</h6>
                        <a href="book-appointment.jsp" class="btn btn-primary btn-sm">
                            <i class="fas fa-plus me-2"></i>New Appointment
                        </a>
                    </div>
                    <div class="card-body">
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
                                    <% 
                                    List<ViewAppointmentsServlet.Appointment> appointments = 
                                        (List<ViewAppointmentsServlet.Appointment>) request.getAttribute("appointments");
                                    if (appointments != null && !appointments.isEmpty()) {
                                        for (ViewAppointmentsServlet.Appointment appointment : appointments) {
                                    %>
                                    <tr>
                                        <td>
                                            <div class="d-flex flex-column">
                                                <span class="fw-bold"><%= appointment.getDate() %></span>
                                                <span class="text-muted"><%= appointment.getTime() %></span>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://via.placeholder.com/40" class="rounded-circle me-2" alt="Advisor">
                                                <div>
                                                    <div class="fw-bold"><%= appointment.getAdvisorName() %></div>
                                                    <div class="text-muted small"><%= appointment.getAdvisorTitle() %></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td><%= appointment.getAppointmentType() %></td>
                                        <td>
                                            <span class="badge bg-<%= 
                                                appointment.getStatus().equals("confirmed") ? "success" :
                                                appointment.getStatus().equals("pending") ? "warning" :
                                                appointment.getStatus().equals("completed") ? "secondary" : "danger"
                                            %>">
                                                <%= appointment.getStatus().substring(0, 1).toUpperCase() + 
                                                   appointment.getStatus().substring(1) %>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="btn-group">
                                                <button class="btn btn-sm btn-outline-primary" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#viewModal"
                                                        data-appointment-id="<%= appointment.getId() %>"
                                                        data-appointment-date="<%= appointment.getDate() %>"
                                                        data-appointment-time="<%= appointment.getTime() %>"
                                                        data-advisor-name="<%= appointment.getAdvisorName() %>"
                                                        data-advisor-title="<%= appointment.getAdvisorTitle() %>"
                                                        data-appointment-type="<%= appointment.getAppointmentType() %>"
                                                        data-reason="<%= appointment.getReason() %>"
                                                        data-status="<%= appointment.getStatus() %>"
                                                        data-notes="<%= appointment.getAdditionalNotes() %>">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <% if (!appointment.getStatus().equals("completed")) { %>
                                                <button class="btn btn-sm btn-outline-danger">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                                <% } else { %>
                                                <button class="btn btn-sm btn-outline-success">
                                                    <i class="fas fa-redo"></i>
                                                </button>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                                    <% 
                                        }
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="5" class="text-center">No appointments found</td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <nav class="mt-4">
                            <ul class="pagination justify-content-center">
                                <li class="page-item disabled">
                                    <a class="page-link" href="#" tabindex="-1">Previous</a>
                                </li>
                                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                                <li class="page-item"><a class="page-link" href="#">3</a></li>
                                <li class="page-item">
                                    <a class="page-link" href="#">Next</a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- View Appointment Modal -->
    <div class="modal fade" id="viewModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Appointment Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-4">
                        <h6 class="font-weight-bold">Date & Time</h6>
                        <p class="mb-0">March 20, 2024</p>
                        <p class="text-muted">10:00 AM - 10:30 AM</p>
                    </div>
                    <div class="mb-4">
                        <h6 class="font-weight-bold">Advisor</h6>
                        <div class="d-flex align-items-center">
                            <img src="https://via.placeholder.com/50" class="rounded-circle me-3" alt="Advisor">
                            <div>
                                <p class="mb-0">Dr. Smith</p>
                                <p class="text-muted mb-0">Academic Advisor</p>
                            </div>
                        </div>
                    </div>
                    <div class="mb-4">
                        <h6 class="font-weight-bold">Appointment Type</h6>
                        <p class="mb-0">Academic Advising</p>
                    </div>
                    <div class="mb-4">
                        <h6 class="font-weight-bold">Reason</h6>
                        <p class="mb-0">Discussion about course selection for next semester and academic progress.</p>
                    </div>
                    <div class="mb-4">
                        <h6 class="font-weight-bold">Status</h6>
                        <span class="badge bg-success">Confirmed</span>
                    </div>
                    <div>
                        <h6 class="font-weight-bold">Additional Notes</h6>
                        <p class="mb-0">Please bring your current transcript and course plan.</p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-danger">Cancel Appointment</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        // Handle appointment view modal
        document.querySelectorAll('[data-bs-target="#viewModal"]').forEach(button => {
            button.addEventListener('click', function() {
                const modal = document.querySelector('#viewModal');
                modal.querySelector('.modal-body').innerHTML = `
                    <div class="mb-4">
                        <h6 class="font-weight-bold">Date & Time</h6>
                        <p class="mb-0">${this.dataset.appointmentDate}</p>
                        <p class="text-muted">${this.dataset.appointmentTime}</p>
                    </div>
                    <div class="mb-4">
                        <h6 class="font-weight-bold">Advisor</h6>
                        <div class="d-flex align-items-center">
                            <img src="https://via.placeholder.com/50" class="rounded-circle me-3" alt="Advisor">
                            <div>
                                <p class="mb-0">${this.dataset.advisorName}</p>
                                <p class="text-muted mb-0">${this.dataset.advisorTitle}</p>
                            </div>
                        </div>
                    </div>
                    <div class="mb-4">
                        <h6 class="font-weight-bold">Appointment Type</h6>
                        <p class="mb-0">${this.dataset.appointmentType}</p>
                    </div>
                    <div class="mb-4">
                        <h6 class="font-weight-bold">Reason</h6>
                        <p class="mb-0">${this.dataset.reason}</p>
                    </div>
                    <div class="mb-4">
                        <h6 class="font-weight-bold">Status</h6>
                        <span class="badge bg-${this.dataset.status === 'confirmed' ? 'success' : 
                                            this.dataset.status === 'pending' ? 'warning' : 
                                            this.dataset.status === 'completed' ? 'secondary' : 'danger'}">
                            ${this.dataset.status.charAt(0).toUpperCase() + this.dataset.status.slice(1)}
                        </span>
                    </div>
                    <div>
                        <h6 class="font-weight-bold">Additional Notes</h6>
                        <p class="mb-0">${this.dataset.notes || 'No additional notes'}</p>
                    </div>
                `;

                // Update cancel button visibility
                const cancelButton = modal.querySelector('.btn-danger');
                if (cancelButton) {
                    cancelButton.style.display = this.dataset.status === 'completed' ? 'none' : 'inline-block';
                }
            });
        });
    </script>
</body>
</html> 
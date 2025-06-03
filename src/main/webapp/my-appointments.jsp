<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Appointments</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .appointment-card {
            margin-bottom: 20px;
        }
        .status-pending {
            color: #ffc107;
        }
        .status-approved {
            color: #28a745;
        }
        .status-rejected {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <h2>My Appointments</h2>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <!-- Filter Form -->
        <form action="view-appointments" method="get" class="mb-4">
            <div class="row">
                <div class="col-md-3">
                    <select name="status" class="form-control">
                        <option value="">All Status</option>
                        <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Pending</option>
                        <option value="approved" ${param.status == 'approved' ? 'selected' : ''}>Approved</option>
                        <option value="rejected" ${param.status == 'rejected' ? 'selected' : ''}>Rejected</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select name="dateRange" class="form-control">
                        <option value="">All Dates</option>
                        <option value="today" ${param.dateRange == 'today' ? 'selected' : ''}>Today</option>
                        <option value="week" ${param.dateRange == 'week' ? 'selected' : ''}>This Week</option>
                        <option value="month" ${param.dateRange == 'month' ? 'selected' : ''}>This Month</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <input type="text" name="search" class="form-control" placeholder="Search..." value="${param.search}">
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary">Filter</button>
                </div>
            </div>
        </form>

        <!-- Appointments List -->
        <c:if test="${empty appointments}">
            <div class="alert alert-info">No appointments found.</div>
        </c:if>

        <c:forEach items="${appointments}" var="appointment">
            <div class="card appointment-card">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-8">
                            <h5 class="card-title">${appointment.appointmentType}</h5>
                            <p class="card-text">
                                <strong>Advisor:</strong> ${appointment.advisorTitle} ${appointment.advisorName}<br>
                                <strong>Date:</strong> ${appointment.date}<br>
                                <strong>Time:</strong> ${appointment.time}<br>
                                <strong>Reason:</strong> ${appointment.reason}<br>
                                <c:if test="${not empty appointment.additionalNotes}">
                                    <strong>Additional Notes:</strong> ${appointment.additionalNotes}
                                </c:if>
                            </p>
                        </div>
                        <div class="col-md-4 text-right">
                            <span class="badge badge-${appointment.status == 'pending' ? 'warning' : appointment.status == 'approved' ? 'success' : 'danger'}">
                                ${appointment.status}
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>

        <div class="mt-3">
            <a href="student.jsp" class="btn btn-secondary">Back to Dashboard</a>
            <a href="book-appointment.jsp" class="btn btn-primary">Book New Appointment</a>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html> 
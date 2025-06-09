<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Appointments - Professor Dashboard</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- FullCalendar CSS -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">
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
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
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

        .sidebar-brand {
            padding: 15px 0;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
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

        .calendar-container {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            min-height: 600px;
            width: 100%;
        }

        .calendar-grid {
            border: 1px solid #e0e6ed;
            border-radius: 8px;
            overflow: hidden;
        }

        .calendar-header {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
        }

        .calendar-day-header {
            padding: 10px 8px;
            text-align: center;
            font-weight: 600;
            color: white;
            font-size: 0.875rem;
            border-right: 1px solid rgba(255,255,255,0.2);
        }

        .calendar-day-header:last-child {
            border-right: none;
        }

        .calendar-body {
            background: white;
        }

        .calendar-week {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            border-bottom: 1px solid #e0e6ed;
        }

        .calendar-week:last-child {
            border-bottom: none;
        }

        .calendar-day {
            min-height: 120px;
            padding: 8px;
            border-right: 1px solid #e0e6ed;
            position: relative;
            background: white;
        }

        .calendar-day:last-child {
            border-right: none;
        }

        .calendar-day.other-month {
            background: #f8f9fa;
            color: #6c757d;
        }

        .calendar-day.today {
            background: rgba(67, 97, 238, 0.05);
            border: 2px solid var(--primary-color);
        }

        .day-number {
            font-weight: 600;
            font-size: 0.875rem;
            margin-bottom: 5px;
            color: #333;
        }

        .other-month .day-number {
            color: #999;
        }

        .today .day-number {
            color: var(--primary-color);
            font-weight: 700;
        }

        .day-appointments {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }

        .appointment-item {
            background: var(--primary-color);
            color: white;
            padding: 3px 6px;
            border-radius: 4px;
            font-size: 0.75rem;
            line-height: 1.2;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .appointment-item:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }

        .appointment-item.status-pending {
            background: #ffc107;
            color: #333;
        }

        .appointment-item.status-confirmed {
            background: #28a745;
            color: white;
        }

        .appointment-item.status-completed {
            background: #6c757d;
            color: white;
        }

        .appointment-item.status-cancelled {
            background: #dc3545;
            color: white;
        }

        .appointment-time {
            font-weight: 600;
            font-size: 0.7rem;
        }

        .appointment-title {
            font-weight: 500;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .appointment-type {
            font-size: 0.65rem;
            opacity: 0.9;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        @media (max-width: 768px) {
            .calendar-day {
                min-height: 80px;
                padding: 4px;
            }
            
            .appointment-item {
                padding: 2px 4px;
                font-size: 0.65rem;
            }
            
            .appointment-type {
                display: none;
            }
        }

        .fc-toolbar {
            margin-bottom: 20px !important;
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

        .fc-button-primary {
            background-color: var(--primary-color) !important;
            border-color: var(--primary-color) !important;
            border-radius: 6px !important;
        }

        .fc-button-primary:not(:disabled):active,
        .fc-button-primary:not(:disabled).fc-button-active {
            background-color: var(--secondary-color) !important;
            border-color: var(--secondary-color) !important;
        }

        .fc-event {
            border-radius: 5px !important;
            padding: 2px 5px !important;
            font-size: 0.85rem !important;
        }

        .appointment-item {
            border-left: 4px solid var(--primary-color);
            transition: all 0.3s ease;
        }

        .appointment-item:hover {
            background-color: rgba(67, 97, 238, 0.05);
            transform: translateX(2px);
        }

        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-confirmed {
            background-color: #d1ecf1;
            color: #0c5460;
        }

        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }

        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }

        .btn-action {
            border-radius: 25px;
            padding: 10px 20px;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        .filter-chip {
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 20px;
            padding: 8px 16px;
            margin: 0 5px 10px 0;
            font-size: 0.85rem;
            transition: all 0.3s ease;
        }

        .filter-chip:hover {
            background: var(--secondary-color);
            transform: scale(1.05);
        }

        .filter-chip.active {
            background: var(--secondary-color);
            box-shadow: 0 2px 10px rgba(63, 55, 201, 0.3);
        }

        .appointment-type-badge {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .time-display {
            background: rgba(67, 97, 238, 0.1);
            color: var(--primary-color);
            padding: 4px 8px;
            border-radius: 6px;
            font-weight: 600;
            display: inline-block;
            margin-bottom: 5px;
            font-size: 0.875rem;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="sidebar-brand">
                    <h2><i class="fas fa-calendar-alt me-2"></i>Appointments</h2>
                </div>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="professor-dashboard">
                            <i class="fas fa-home"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="professor-appointments">
                            <i class="fas fa-calendar-check"></i> My Appointments
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#createAppointmentModal">
                            <i class="fas fa-calendar-plus"></i> Create Appointment
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#bulkActionsModal">
                            <i class="fas fa-tasks"></i> Bulk Actions
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
                    <div>
                        <h4 class="mb-0">
                            <i class="fas fa-calendar-alt me-2 text-primary"></i>My Appointments
                        </h4>
                        <p class="text-muted mb-0">Manage your schedule and student meetings</p>
                    </div>
                    <div class="d-flex align-items-center">
                        <button class="btn btn-outline-secondary d-md-none me-3" id="sidebarToggle">
                            <i class="fas fa-bars"></i>
                        </button>
                        <span class="me-3"><i class="fas fa-bell"></i></span>
                        <span><i class="fas fa-user-circle"></i></span>
                    </div>
                </div>

                <!-- Error/Success Messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Stats Cards -->
                <div class="row">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card primary h-100">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col">
                                        <div class="text-xs font-weight-bold text-uppercase mb-1" style="color: rgba(255,255,255,0.8);">
                                            Total Appointments</div>
                                        <div class="h5 mb-0 font-weight-bold">${totalAppointments}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-calendar-alt stats-icon"></i>
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
                                            Pending</div>
                                        <div class="h5 mb-0 font-weight-bold">${pendingCount}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-clock stats-icon"></i>
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
                                            Confirmed</div>
                                        <div class="h5 mb-0 font-weight-bold">${confirmedCount}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-check-circle stats-icon"></i>
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
                                            Completed</div>
                                        <div class="h5 mb-0 font-weight-bold">${completedCount}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-calendar-check stats-icon"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Calendar and Appointments Layout -->
                <div class="row">
                                    <!-- Calendar View -->
                <div class="col-lg-8">
                    <div class="card calendar-container">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="mb-0 fw-bold">Calendar View</h6>
                            <div class="btn-group" role="group">
                                <a href="professor-appointments?month=${currentMonth - 1}&year=${currentYear}" class="btn btn-outline-primary btn-sm">
                                    <i class="fas fa-chevron-left"></i> Previous
                                </a>
                                <span class="btn btn-primary btn-sm">${currentMonthName} ${currentYear}</span>
                                <a href="professor-appointments?month=${currentMonth + 1}&year=${currentYear}" class="btn btn-outline-primary btn-sm">
                                    Next <i class="fas fa-chevron-right"></i>
                                </a>
                            </div>
                        </div>
                        
                        <!-- Calendar Grid -->
                        <div class="calendar-grid">
                            <!-- Day Headers -->
                            <div class="calendar-header">
                                <div class="calendar-day-header">Sun</div>
                                <div class="calendar-day-header">Mon</div>
                                <div class="calendar-day-header">Tue</div>
                                <div class="calendar-day-header">Wed</div>
                                <div class="calendar-day-header">Thu</div>
                                <div class="calendar-day-header">Fri</div>
                                <div class="calendar-day-header">Sat</div>
                            </div>
                            
                            <!-- Calendar Days -->
                            <div class="calendar-body">
                                <c:forEach var="week" items="${calendarWeeks}">
                                    <div class="calendar-week">
                                        <c:forEach var="day" items="${week.days}">
                                            <div class="calendar-day ${day.isCurrentMonth ? '' : 'other-month'} ${day.isToday ? 'today' : ''}">
                                                <div class="day-number">${day.dayNumber}</div>
                                                <div class="day-appointments">
                                                    <c:forEach var="appointment" items="${day.appointments}">
                                                        <div class="appointment-item status-${appointment.status}" 
                                                             title="${appointment.studentName} - ${appointment.reason}">
                                                            <div class="appointment-time">${appointment.time}</div>
                                                            <div class="appointment-title">${appointment.studentName}</div>
                                                            <div class="appointment-type">${appointment.appointmentType}</div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>

                    <!-- Sidebar with Today's Appointments and Quick Actions -->
                    <div class="col-lg-4">
                        <!-- Today's Appointments -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h6 class="mb-0 fw-bold">
                                    <i class="fas fa-clock me-2 text-primary"></i>Today's Appointments
                                </h6>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty todayAppointments}">
                                        <c:forEach var="appointment" items="${todayAppointments}">
                                            <div class="appointment-item card mb-3">
                                                <div class="card-body p-3">
                                                    <div class="time-display">${appointment.time}</div>
                                                    <h6 class="mb-2">${appointment.studentName}</h6>
                                                    <span class="appointment-type-badge">${appointment.appointmentType}</span>
                                                    <p class="text-muted mb-2 small">${appointment.reason}</p>
                                                    <span class="status-badge status-${appointment.status}">${appointment.status}</span>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-4">
                                            <i class="fas fa-calendar-day fa-3x text-muted mb-3"></i>
                                            <p class="text-muted">No appointments scheduled for today</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Quick Actions -->
                        <div class="card mb-4">
                            <div class="card-header">
                                <h6 class="mb-0 fw-bold">
                                    <i class="fas fa-bolt me-2 text-primary"></i>Quick Actions
                                </h6>
                            </div>
                            <div class="card-body">
                                <div class="d-grid gap-2">
                                    <button class="btn btn-primary btn-action" data-bs-toggle="modal" data-bs-target="#createAppointmentModal">
                                        <i class="fas fa-calendar-plus me-2"></i>Create Appointment
                                    </button>
                                    <button class="btn btn-outline-secondary btn-action" onclick="exportCalendar()">
                                        <i class="fas fa-download me-2"></i>Export Calendar
                                    </button>
                                    <button class="btn btn-outline-info btn-action" onclick="filterByStatus('pending')">
                                        <i class="fas fa-filter me-2"></i>View Pending
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Filters -->
                        <div class="card">
                            <div class="card-header">
                                <h6 class="mb-0 fw-bold">
                                    <i class="fas fa-filter me-2 text-primary"></i>Filters
                                </h6>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label class="form-label small fw-bold">Status</label>
                                    <div>
                                        <button class="filter-chip active" onclick="filterAppointments('all')" id="filter-all">All</button>
                                        <button class="filter-chip" onclick="filterAppointments('pending')" id="filter-pending">Pending</button>
                                        <button class="filter-chip" onclick="filterAppointments('confirmed')" id="filter-confirmed">Confirmed</button>
                                        <button class="filter-chip" onclick="filterAppointments('completed')" id="filter-completed">Completed</button>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label small fw-bold">Type</label>
                                    <div>
                                        <button class="filter-chip active" onclick="filterByType('all')" id="type-all">All Types</button>
                                        <button class="filter-chip" onclick="filterByType('Thesis Meeting')" id="type-thesis">Thesis</button>
                                        <button class="filter-chip" onclick="filterByType('Academic Advising')" id="type-advising">Advising</button>
                                        <button class="filter-chip" onclick="filterByType('Office Hours')" id="type-office">Office Hours</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Upcoming Appointments -->
                <div class="card mt-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h6 class="mb-0 fw-bold">
                            <i class="fas fa-calendar-week me-2 text-primary"></i>Upcoming Appointments
                        </h6>
                        <div class="btn-group" role="group">
                            <button type="button" class="btn btn-outline-primary btn-sm" onclick="bulkAction('confirmed')">
                                <i class="fas fa-check me-1"></i>Bulk Confirm
                            </button>
                            <button type="button" class="btn btn-outline-danger btn-sm" onclick="bulkAction('cancelled')">
                                <i class="fas fa-times me-1"></i>Bulk Cancel
                            </button>
                        </div>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty upcomingAppointments}">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>
                                                    <input type="checkbox" id="selectAllAppointments" onchange="toggleSelectAll()">
                                                </th>
                                                <th>Date & Time</th>
                                                <th>Student</th>
                                                <th>Type</th>
                                                <th>Reason</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="appointment" items="${upcomingAppointments}">
                                                <tr class="appointment-row" data-status="${appointment.status}" data-type="${appointment.appointmentType}">
                                                    <td>
                                                        <input type="checkbox" class="appointment-checkbox" value="${appointment.id}">
                                                    </td>
                                                    <td>
                                                        <div class="fw-bold">${appointment.date}</div>
                                                        <small class="text-muted">${appointment.time}</small>
                                                    </td>
                                                    <td>${appointment.studentName}</td>
                                                    <td>
                                                        <span class="appointment-type-badge">${appointment.appointmentType}</span>
                                                    </td>
                                                    <td class="text-truncate" style="max-width: 200px;" title="${appointment.reason}">
                                                        ${appointment.reason}
                                                    </td>
                                                    <td>
                                                        <span class="status-badge status-${appointment.status}">${appointment.status}</span>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <button class="btn btn-sm btn-outline-primary" 
                                                                    onclick="viewAppointmentDetails('${appointment.id}')"
                                                                    data-bs-toggle="modal" 
                                                                    data-bs-target="#appointmentDetailModal">
                                                                <i class="fas fa-eye"></i>
                                                            </button>
                                                            <c:if test="${appointment.status == 'pending'}">
                                                                <button class="btn btn-sm btn-success" 
                                                                        onclick="updateAppointmentStatus('${appointment.id}', 'confirmed')">
                                                                    <i class="fas fa-check"></i>
                                                                </button>
                                                                <button class="btn btn-sm btn-danger" 
                                                                        onclick="updateAppointmentStatus('${appointment.id}', 'cancelled')">
                                                                    <i class="fas fa-times"></i>
                                                                </button>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-calendar-times fa-4x text-muted mb-4"></i>
                                    <h6 class="text-muted">No upcoming appointments</h6>
                                    <p class="text-muted">All your appointments are up to date!</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Appointment Detail Modal -->
    <div class="modal fade" id="appointmentDetailModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header" style="background: linear-gradient(45deg, var(--primary-color), var(--secondary-color)); color: white;">
                    <h5 class="modal-title">
                        <i class="fas fa-calendar-alt me-2"></i>Appointment Details
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="appointmentDetailContent">
                    <!-- Content will be loaded dynamically -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="saveAppointmentNotes()">Save Notes</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Global variables
        let allAppointments = [];
        let currentFilter = 'all';
        let currentTypeFilter = 'all';

        // Filter appointments by status
        function filterAppointments(status) {
            currentFilter = status;
            applyFilters();
            updateFilterButtons(status);
        }

        // Filter appointments by type
        function filterByType(type) {
            currentTypeFilter = type;
            applyFilters();
            updateTypeFilterButtons(type);
        }

        // Apply both filters
        function applyFilters() {
            const rows = document.querySelectorAll('.appointment-row');
            rows.forEach(row => {
                const appointmentStatus = row.getAttribute('data-status');
                const appointmentType = row.getAttribute('data-type');
                
                const statusMatch = currentFilter === 'all' || appointmentStatus === currentFilter;
                const typeMatch = currentTypeFilter === 'all' || appointmentType === currentTypeFilter;
                
                if (statusMatch && typeMatch) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        // Update filter button states
        function updateFilterButtons(activeFilter) {
            document.querySelectorAll('.filter-chip').forEach(chip => {
                chip.classList.remove('active');
            });
            document.getElementById('filter-' + activeFilter).classList.add('active');
        }

        // Update type filter button states
        function updateTypeFilterButtons(activeType) {
            const typeButtons = document.querySelectorAll('[onclick*="filterByType"]');
            typeButtons.forEach(button => {
                button.classList.remove('active');
            });
            
            if (activeType === 'all') {
                document.getElementById('type-all').classList.add('active');
            } else {
                typeButtons.forEach(button => {
                    if (button.onclick.toString().includes("'" + activeType + "'")) {
                        button.classList.add('active');
                    }
                });
            }
        }

        // Update appointment status
        function updateAppointmentStatus(appointmentId, newStatus) {
            if (confirm('Are you sure you want to update this appointment status to ' + newStatus + '?')) {
                fetch('professor-appointments', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `action=updateStatus&appointmentId=${appointmentId}&status=${newStatus}`
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload(); // Refresh page to show updated status
                    } else {
                        alert('Error updating appointment: ' + (data.error || 'Unknown error'));
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error updating appointment');
                });
            }
        }

        // View appointment details
        function viewAppointmentDetails(appointmentId) {
            fetch(`professor-appointments?action=getDetails&appointmentId=${appointmentId}`)
                .then(response => response.text())
                .then(html => {
                    document.getElementById('appointmentDetailContent').innerHTML = html;
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('appointmentDetailContent').innerHTML = 
                        '<div class="alert alert-danger">Error loading appointment details</div>';
                });
        }

        // Toggle select all checkboxes
        function toggleSelectAll() {
            const selectAll = document.getElementById('selectAllAppointments');
            const checkboxes = document.querySelectorAll('.appointment-checkbox');
            
            checkboxes.forEach(checkbox => {
                checkbox.checked = selectAll.checked;
            });
        }

        // Bulk actions
        function bulkAction(action) {
            const selectedCheckboxes = document.querySelectorAll('.appointment-checkbox:checked');
            
            if (selectedCheckboxes.length === 0) {
                alert('Please select at least one appointment');
                return;
            }

            const appointmentIds = Array.from(selectedCheckboxes).map(cb => cb.value);
            
            if (confirm(`Are you sure you want to ${action} ${appointmentIds.length} appointment(s)?`)) {
                fetch('professor-appointments', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `action=bulkUpdate&appointmentIds=${appointmentIds.join(',')}&status=${action}`
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload(); // Refresh page to show updated statuses
                    } else {
                        alert('Error updating appointments: ' + (data.error || 'Unknown error'));
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error updating appointments');
                });
            }
        }

        // Export calendar (placeholder)
        function exportCalendar() {
            // Simple export functionality - could be enhanced
            window.open('professor-appointments?action=export', '_blank');
        }

        // Save appointment notes
        function saveAppointmentNotes() {
            const modal = document.getElementById('appointmentDetailModal');
            const appointmentId = modal.getAttribute('data-appointment-id');
            const notes = document.getElementById('appointmentNotes')?.value || '';
            
            fetch('professor-appointments', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=addNotes&appointmentId=${appointmentId}&notes=${encodeURIComponent(notes)}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Notes saved successfully');
                    location.reload();
                } else {
                    alert('Error saving notes: ' + (data.error || 'Unknown error'));
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error saving notes');
            });
        }

        // Sidebar toggle for mobile
        document.addEventListener('DOMContentLoaded', function() {
            const sidebarToggle = document.getElementById('sidebarToggle');
            const sidebar = document.querySelector('.sidebar');
            
            if (sidebarToggle && sidebar) {
                sidebarToggle.addEventListener('click', function() {
                    sidebar.classList.toggle('show');
                });
            }
        });

        // Quick filter by status from quick actions
        function filterByStatus(status) {
            filterAppointments(status);
        }
    </script>




</body>
</html> 
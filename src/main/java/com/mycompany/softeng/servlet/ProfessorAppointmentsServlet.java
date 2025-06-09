package com.mycompany.softeng.servlet;

import com.mycompany.softeng.model.Appointment;
import com.mycompany.softeng.model.CalendarDay;
import com.mycompany.softeng.model.CalendarWeek;
import com.mycompany.softeng.util.DatabaseUtil;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import com.google.gson.Gson;
import java.io.PrintWriter;

public class ProfessorAppointmentsServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ProfessorAppointmentsServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("getCalendarData".equals(action)) {
            // Return JSON data for calendar
            handleCalendarDataRequest(request, response, username);
            return;
        } else if ("getDetails".equals(action)) {
            // Return appointment details HTML
            handleGetAppointmentDetails(request, response, username);
            return;
        } else if ("export".equals(action)) {
            // Export calendar data
            handleExportCalendar(request, response, username);
            return;
        }

        try {
            // Check if user is a professor
            if (!isProfessor(username)) {
                LOGGER.warning("User is not a professor: " + username);
                request.setAttribute("appointments", new ArrayList<>());
                request.setAttribute("todayAppointments", new ArrayList<>());
                request.setAttribute("upcomingAppointments", new ArrayList<>());
                request.setAttribute("calendarWeeks", new ArrayList<>());
            } else {
                // Get month and year parameters for calendar navigation
                String monthParam = request.getParameter("month");
                String yearParam = request.getParameter("year");

                Calendar cal = Calendar.getInstance();
                int currentMonth = cal.get(Calendar.MONTH) + 1; // Calendar months are 0-based
                int currentYear = cal.get(Calendar.YEAR);

                if (monthParam != null && yearParam != null) {
                    try {
                        currentMonth = Integer.parseInt(monthParam);
                        currentYear = Integer.parseInt(yearParam);

                        // Handle month overflow/underflow
                        if (currentMonth < 1) {
                            currentMonth = 12;
                            currentYear--;
                        } else if (currentMonth > 12) {
                            currentMonth = 1;
                            currentYear++;
                        }
                    } catch (NumberFormatException e) {
                        // Use default current month/year if parsing fails
                    }
                }

                // Load all appointments for this professor
                List<Appointment> allAppointments = getProfessorAppointments(username);
                List<Appointment> todayAppointments = getTodayAppointments(username);
                List<Appointment> upcomingAppointments = getUpcomingAppointments(username);

                // Generate calendar data
                List<CalendarWeek> calendarWeeks = generateCalendarWeeks(currentMonth, currentYear, allAppointments);
                String[] monthNames = { "January", "February", "March", "April", "May", "June",
                        "July", "August", "September", "October", "November", "December" };

                // Calculate statistics
                long pendingCount = allAppointments.stream().filter(a -> "pending".equals(a.getStatus())).count();
                long confirmedCount = allAppointments.stream().filter(a -> "confirmed".equals(a.getStatus())).count();
                long completedCount = allAppointments.stream().filter(a -> "completed".equals(a.getStatus())).count();

                request.setAttribute("appointments", allAppointments);
                request.setAttribute("todayAppointments", todayAppointments);
                request.setAttribute("upcomingAppointments", upcomingAppointments);
                request.setAttribute("totalAppointments", allAppointments.size());
                request.setAttribute("pendingCount", pendingCount);
                request.setAttribute("confirmedCount", confirmedCount);
                request.setAttribute("completedCount", completedCount);

                // Calendar attributes
                request.setAttribute("calendarWeeks", calendarWeeks);
                request.setAttribute("currentMonth", currentMonth);
                request.setAttribute("currentYear", currentYear);
                request.setAttribute("currentMonthName", monthNames[currentMonth - 1]);

                LOGGER.info("Professor appointments loaded for: " + username + " with " + allAppointments.size()
                        + " total appointments");
            }

        } catch (SQLException e) {
            LOGGER.severe("Database error: " + e.getMessage());
            request.setAttribute("appointments", new ArrayList<>());
            request.setAttribute("error", "Failed to load appointments: " + e.getMessage());
        }

        request.getRequestDispatcher("professor-appointments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            switch (action != null ? action : "") {
                case "updateStatus":
                    handleUpdateAppointmentStatus(request, response);
                    break;
                case "addNotes":
                    handleAddNotes(request, response);
                    break;
                case "bulkUpdate":
                    handleBulkUpdate(request, response);
                    break;
                default:
                    LOGGER.warning("Unknown action: " + action);
            }
        } catch (SQLException e) {
            LOGGER.severe("Database error: " + e.getMessage());
            response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }
    }

    private List<CalendarWeek> generateCalendarWeeks(int month, int year, List<Appointment> appointments) {
        List<CalendarWeek> weeks = new ArrayList<>();
        Calendar cal = Calendar.getInstance();

        // Create a map of date string to appointments for quick lookup
        Map<String, List<Appointment>> appointmentsByDate = new HashMap<>();
        for (Appointment apt : appointments) {
            String dateKey = apt.getDate(); // Assuming format YYYY-MM-DD
            appointmentsByDate.computeIfAbsent(dateKey, k -> new ArrayList<>()).add(apt);
        }

        // Set calendar to the first day of the month
        cal.set(year, month - 1, 1); // Calendar months are 0-based

        // Find the first day of the calendar grid (might be from previous month)
        int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
        int daysToGoBack = (dayOfWeek - Calendar.SUNDAY) % 7;
        cal.add(Calendar.DAY_OF_MONTH, -daysToGoBack);

        // Get today's date for comparison
        Calendar today = Calendar.getInstance();

        // Generate 6 weeks to cover the entire month view
        for (int week = 0; week < 6; week++) {
            CalendarWeek calendarWeek = new CalendarWeek();

            for (int day = 0; day < 7; day++) {
                CalendarDay calendarDay = new CalendarDay();
                calendarDay.setDayNumber(cal.get(Calendar.DAY_OF_MONTH));
                calendarDay.setCurrentMonth(cal.get(Calendar.MONTH) == month - 1);

                // Check if this is today
                boolean isToday = cal.get(Calendar.YEAR) == today.get(Calendar.YEAR) &&
                        cal.get(Calendar.MONTH) == today.get(Calendar.MONTH) &&
                        cal.get(Calendar.DAY_OF_MONTH) == today.get(Calendar.DAY_OF_MONTH);
                calendarDay.setToday(isToday);

                // Format date for lookup (YYYY-MM-DD)
                String dateKey = String.format("%04d-%02d-%02d",
                        cal.get(Calendar.YEAR),
                        cal.get(Calendar.MONTH) + 1,
                        cal.get(Calendar.DAY_OF_MONTH));

                // Add appointments for this date
                List<Appointment> dayAppointments = appointmentsByDate.get(dateKey);
                if (dayAppointments != null) {
                    calendarDay.setAppointments(dayAppointments);
                }

                calendarWeek.addDay(calendarDay);
                cal.add(Calendar.DAY_OF_MONTH, 1);
            }

            weeks.add(calendarWeek);
        }

        return weeks;
    }

    private void handleCalendarDataRequest(HttpServletRequest request, HttpServletResponse response, String username)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            List<Appointment> appointments = getProfessorAppointments(username);

            // Convert appointments to calendar events format
            List<CalendarEvent> events = new ArrayList<>();
            for (Appointment apt : appointments) {
                CalendarEvent event = new CalendarEvent();
                event.id = apt.getId();
                event.title = apt.getAppointmentType() + " - " + apt.getStudentName();
                event.start = apt.getDate() + "T" + apt.getTime();
                event.backgroundColor = getStatusColor(apt.getStatus());
                event.borderColor = getStatusColor(apt.getStatus());
                event.textColor = "#ffffff";
                event.extendedProps = new EventProps();
                event.extendedProps.studentName = apt.getStudentName();
                event.extendedProps.reason = apt.getReason();
                event.extendedProps.status = apt.getStatus();
                event.extendedProps.appointmentType = apt.getAppointmentType();
                events.add(event);
            }

            Gson gson = new Gson();
            String jsonResponse = gson.toJson(events);

            PrintWriter out = response.getWriter();
            out.print(jsonResponse);
            out.flush();

        } catch (SQLException e) {
            LOGGER.severe("Error fetching calendar data: " + e.getMessage());
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    private void handleGetAppointmentDetails(HttpServletRequest request, HttpServletResponse response, String username)
            throws IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        String appointmentIdStr = request.getParameter("appointmentId");
        if (appointmentIdStr == null) {
            response.getWriter().write("<div class=\"alert alert-danger\">Appointment ID is required</div>");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(appointmentIdStr);
            Appointment appointment = getAppointmentById(appointmentId);

            if (appointment == null) {
                response.getWriter().write("<div class=\"alert alert-danger\">Appointment not found</div>");
                return;
            }

            // Generate appointment details HTML
            StringBuilder html = new StringBuilder();
            html.append("<div class=\"row\">");
            html.append("<div class=\"col-md-6\">");
            html.append("<h6><i class=\"fas fa-user me-2\"></i>Student Information</h6>");
            html.append("<p><strong>Name:</strong> ").append(appointment.getStudentName()).append("</p>");
            html.append("</div>");
            html.append("<div class=\"col-md-6\">");
            html.append("<h6><i class=\"fas fa-calendar me-2\"></i>Appointment Details</h6>");
            html.append("<p><strong>Date:</strong> ").append(appointment.getDate()).append("</p>");
            html.append("<p><strong>Time:</strong> ").append(appointment.getTime()).append("</p>");
            html.append("<p><strong>Type:</strong> ").append(appointment.getAppointmentType()).append("</p>");
            html.append("<p><strong>Status:</strong> <span class=\"status-badge status-")
                    .append(appointment.getStatus()).append("\">").append(appointment.getStatus())
                    .append("</span></p>");
            html.append("</div>");
            html.append("</div>");
            html.append("<div class=\"row mt-3\">");
            html.append("<div class=\"col-12\">");
            html.append("<h6><i class=\"fas fa-comment me-2\"></i>Reason</h6>");
            html.append("<p>").append(appointment.getReason()).append("</p>");
            html.append("</div>");
            html.append("</div>");
            html.append("<div class=\"row mt-3\">");
            html.append("<div class=\"col-12\">");
            html.append("<h6><i class=\"fas fa-sticky-note me-2\"></i>Notes</h6>");
            html.append(
                    "<textarea class=\"form-control\" id=\"appointmentNotes\" rows=\"3\" placeholder=\"Add notes about this appointment...\">")
                    .append(appointment.getAdditionalNotes() != null ? appointment.getAdditionalNotes() : "")
                    .append("</textarea>");
            html.append("</div>");
            html.append("</div>");

            // Set appointment ID for the modal
            html.append(
                    "<script>document.getElementById('appointmentDetailModal').setAttribute('data-appointment-id', '")
                    .append(appointmentId).append("');</script>");

            response.getWriter().write(html.toString());

        } catch (NumberFormatException e) {
            response.getWriter().write("<div class=\"alert alert-danger\">Invalid appointment ID</div>");
        } catch (SQLException e) {
            LOGGER.severe("Database error: " + e.getMessage());
            response.getWriter().write("<div class=\"alert alert-danger\">Error loading appointment details</div>");
        }
    }

    private void handleExportCalendar(HttpServletRequest request, HttpServletResponse response, String username)
            throws IOException {
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"professor_appointments.csv\"");

        try {
            if (!isProfessor(username)) {
                response.getWriter().write("Error: Professor not found");
                return;
            }

            List<Appointment> appointments = getProfessorAppointments(username);
            PrintWriter writer = response.getWriter();

            // CSV Header
            writer.println("Date,Time,Student Name,Type,Reason,Status");

            // CSV Data
            for (Appointment apt : appointments) {
                writer.printf("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"%n",
                        apt.getDate(),
                        apt.getTime(),
                        apt.getStudentName(),
                        apt.getAppointmentType(),
                        apt.getReason().replace("\"", "\"\""), // Escape quotes
                        apt.getStatus());
            }

        } catch (SQLException e) {
            LOGGER.severe("Database error: " + e.getMessage());
            response.getWriter().write("Error: Failed to export appointments");
        }
    }

    private void handleUpdateAppointmentStatus(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String appointmentId = request.getParameter("appointmentId");
        String status = request.getParameter("status");

        String sql = "UPDATE appointments SET status = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, Integer.parseInt(appointmentId));

            int rowsUpdated = stmt.executeUpdate();

            response.setContentType("application/json");
            if (rowsUpdated > 0) {
                response.getWriter().write("{\"success\": true}");
            } else {
                response.getWriter().write("{\"success\": false, \"error\": \"No rows updated\"}");
            }
        }
    }

    private void handleAddNotes(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String appointmentId = request.getParameter("appointmentId");
        String notes = request.getParameter("notes");

        String sql = "UPDATE appointments SET additional_notes = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, notes);
            stmt.setInt(2, Integer.parseInt(appointmentId));

            int rowsUpdated = stmt.executeUpdate();

            response.setContentType("application/json");
            if (rowsUpdated > 0) {
                response.getWriter().write("{\"success\": true}");
            } else {
                response.getWriter().write("{\"success\": false, \"error\": \"No rows updated\"}");
            }
        }
    }

    private void handleBulkUpdate(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String appointmentIdsParam = request.getParameter("appointmentIds");
        String status = request.getParameter("status");

        if (appointmentIdsParam == null || appointmentIdsParam.trim().isEmpty()) {
            response.getWriter().write("{\"success\": false, \"error\": \"No appointments selected\"}");
            return;
        }

        String[] appointmentIds = appointmentIdsParam.split(",");

        String sql = "UPDATE appointments SET status = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            conn.setAutoCommit(false);

            for (String id : appointmentIds) {
                stmt.setString(1, status);
                stmt.setInt(2, Integer.parseInt(id));
                stmt.addBatch();
            }

            int[] results = stmt.executeBatch();
            conn.commit();

            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true, \"updated\": " + results.length + "}");

        } catch (SQLException e) {
            response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }
    }

    private List<Appointment> getProfessorAppointments(String professorUsername) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.*, u.name as student_name, u.username as student_username " +
                "FROM appointments a " +
                "LEFT JOIN users u ON a.student_username = u.username " +
                "WHERE a.advisor_id = ? " +
                "ORDER BY a.appointment_date DESC, a.appointment_time DESC";

        LOGGER.info("Searching for appointments with advisor_id: " + professorUsername);

        // Debug: Check if any appointments exist at all
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement debugStmt = conn.prepareStatement("SELECT COUNT(*) as total FROM appointments")) {
            try (ResultSet debugRs = debugStmt.executeQuery()) {
                if (debugRs.next()) {
                    LOGGER.info("Total appointments in database: " + debugRs.getInt("total"));
                }
            }
        }

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, professorUsername);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setId(rs.getInt("id"));
                    appointment.setStudentUsername(rs.getString("student_username"));
                    appointment.setStudentName(
                            rs.getString("student_name") != null ? rs.getString("student_name") : "Unknown Student");
                    appointment.setAppointmentType(rs.getString("appointment_type"));
                    appointment.setDate(rs.getString("appointment_date"));
                    appointment.setTime(rs.getString("appointment_time"));
                    appointment.setReason(rs.getString("reason"));
                    appointment.setStatus(rs.getString("status"));
                    appointment.setAdditionalNotes(rs.getString("additional_notes"));
                    appointments.add(appointment);
                    LOGGER.info("Found appointment: " + appointment.getStudentName() + " - " + appointment.getDate());
                }
            }
        }
        LOGGER.info("Total appointments found for " + professorUsername + ": " + appointments.size());
        return appointments;
    }

    private List<Appointment> getTodayAppointments(String professorUsername) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.*, u.name as student_name, u.username as student_username " +
                "FROM appointments a " +
                "LEFT JOIN users u ON a.student_username = u.username " +
                "WHERE a.advisor_id = ? AND a.appointment_date = CURDATE() " +
                "ORDER BY a.appointment_time";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, professorUsername);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setId(rs.getInt("id"));
                    appointment.setStudentUsername(rs.getString("student_username"));
                    appointment.setStudentName(
                            rs.getString("student_name") != null ? rs.getString("student_name") : "Unknown Student");
                    appointment.setAppointmentType(rs.getString("appointment_type"));
                    appointment.setDate(rs.getString("appointment_date"));
                    appointment.setTime(rs.getString("appointment_time"));
                    appointment.setReason(rs.getString("reason"));
                    appointment.setStatus(rs.getString("status"));
                    appointment.setAdditionalNotes(rs.getString("additional_notes"));
                    appointments.add(appointment);
                }
            }
        }
        return appointments;
    }

    private List<Appointment> getUpcomingAppointments(String professorUsername) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.*, u.name as student_name, u.username as student_username " +
                "FROM appointments a " +
                "LEFT JOIN users u ON a.student_username = u.username " +
                "WHERE a.advisor_id = ? AND a.appointment_date > CURDATE() " +
                "ORDER BY a.appointment_date, a.appointment_time " +
                "LIMIT 10";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, professorUsername);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setId(rs.getInt("id"));
                    appointment.setStudentUsername(rs.getString("student_username"));
                    appointment.setStudentName(
                            rs.getString("student_name") != null ? rs.getString("student_name") : "Unknown Student");
                    appointment.setAppointmentType(rs.getString("appointment_type"));
                    appointment.setDate(rs.getString("appointment_date"));
                    appointment.setTime(rs.getString("appointment_time"));
                    appointment.setReason(rs.getString("reason"));
                    appointment.setStatus(rs.getString("status"));
                    appointment.setAdditionalNotes(rs.getString("additional_notes"));
                    appointments.add(appointment);
                }
            }
        }
        return appointments;
    }

    private Appointment getAppointmentById(int appointmentId) throws SQLException {
        String sql = "SELECT a.*, u.name as student_name, u.username as student_username " +
                "FROM appointments a " +
                "LEFT JOIN users u ON a.student_username = u.username " +
                "WHERE a.id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, appointmentId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setId(rs.getInt("id"));
                    appointment.setStudentUsername(rs.getString("student_username"));
                    appointment.setStudentName(
                            rs.getString("student_name") != null ? rs.getString("student_name") : "Unknown Student");
                    appointment.setAppointmentType(rs.getString("appointment_type"));
                    appointment.setDate(rs.getString("appointment_date"));
                    appointment.setTime(rs.getString("appointment_time"));
                    appointment.setReason(rs.getString("reason"));
                    appointment.setStatus(rs.getString("status"));
                    appointment.setAdditionalNotes(rs.getString("additional_notes"));
                    return appointment;
                }
            }
        }
        return null;
    }

    private boolean isProfessor(String username) throws SQLException {
        String sql = "SELECT id FROM users WHERE username = ? AND user_type = 'professor'";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    private int getProfessorIdFromUsername(String username) throws SQLException {
        String sql = "SELECT id FROM users WHERE username = ? AND user_type = 'professor'";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        }
        return -1;
    }

    private String getStatusColor(String status) {
        switch (status) {
            case "pending":
                return "#ffc107";
            case "confirmed":
                return "#28a745";
            case "completed":
                return "#6c757d";
            case "cancelled":
                return "#dc3545";
            default:
                return "#007bff";
        }
    }

    // Inner classes for JSON serialization
    private static class CalendarEvent {
        public int id;
        public String title;
        public String start;
        public String backgroundColor;
        public String borderColor;
        public String textColor;
        public EventProps extendedProps;
    }

    private static class EventProps {
        public String studentName;
        public String reason;
        public String status;
        public String appointmentType;
    }
}
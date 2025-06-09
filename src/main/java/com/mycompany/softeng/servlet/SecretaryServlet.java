package com.mycompany.softeng.servlet;

import com.mycompany.softeng.util.DatabaseUtil;
import com.mycompany.softeng.dao.UserDAO;
import com.mycompany.softeng.dao.AssignmentDAO;
import com.mycompany.softeng.dao.AppointmentDAO;
import com.mycompany.softeng.model.User;
import com.mycompany.softeng.model.Assignment;
import com.mycompany.softeng.model.Appointment;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.List;

public class SecretaryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if (action == null) {
            // Forward to secretary.jsp to display the dashboard
            request.getRequestDispatcher("secretary.jsp").forward(request, response);
            return;
        }

        switch (action) {
            case "getStats":
                sendStatistics(response);
                break;
            case "viewDatabase":
                showDatabaseView(request, response);
                break;
            case "exportData":
                exportDataToCSV(response);
                break;
            default:
                request.getRequestDispatcher("secretary.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        switch (action) {
            case "clearDatabase":
                clearDatabaseData(response);
                break;
            default:
                response.sendRedirect("secretary-dashboard");
        }
    }

    private void sendStatistics(HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            int totalUsers = 0;
            int totalStudents = 0;
            int totalProfessors = 0;
            int totalProjects = 0;

            // Get statistics from database using DatabaseUtil
            try (Connection conn = DatabaseUtil.getConnection()) {
                // Count total users
                try (PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM users")) {
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next())
                        totalUsers = rs.getInt(1);
                }

                // Count students
                try (PreparedStatement stmt = conn
                        .prepareStatement("SELECT COUNT(*) FROM users WHERE user_type = 'student'")) {
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next())
                        totalStudents = rs.getInt(1);
                }

                // Count professors
                try (PreparedStatement stmt = conn
                        .prepareStatement("SELECT COUNT(*) FROM users WHERE user_type = 'professor'")) {
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next())
                        totalProfessors = rs.getInt(1);
                }

                // Count projects
                try (PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM projects")) {
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next())
                        totalProjects = rs.getInt(1);
                }

            } catch (SQLException e) {
                e.printStackTrace();
                // Return error in JSON format
                out.print("{");
                out.print("\"error\": \"Database connection error: " + e.getMessage() + "\",");
                out.print("\"totalUsers\": 0,");
                out.print("\"totalStudents\": 0,");
                out.print("\"totalProfessors\": 0,");
                out.print("\"totalAssignments\": 0");
                out.print("}");
                return;
            }

            // Send JSON response
            out.print("{");
            out.print("\"totalUsers\": " + totalUsers + ",");
            out.print("\"totalStudents\": " + totalStudents + ",");
            out.print("\"totalProfessors\": " + totalProfessors + ",");
            out.print("\"totalAssignments\": " + totalProjects);
            out.print("}");
        }
    }

    private void showDatabaseView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set all database data as request attributes
        try (Connection conn = DatabaseUtil.getConnection()) {

            // Get all users
            try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users ORDER BY id")) {
                ResultSet rs = stmt.executeQuery();
                request.setAttribute("users", convertUsersResultSet(rs));
            }

            // Get all projects
            try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM assignments ORDER BY id")) {
                ResultSet rs = stmt.executeQuery();
                request.setAttribute("assignments", convertProjectsResultSet(rs));
            }

            // Get all appointments
            try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM appointments ORDER BY id")) {
                ResultSet rs = stmt.executeQuery();
                request.setAttribute("appointments", convertAppointmentsResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database connection error: " + e.getMessage());
        }

        request.getRequestDispatcher("database-view.jsp").forward(request, response);
    }

    private String convertUsersResultSet(ResultSet rs) throws SQLException {
        StringBuilder html = new StringBuilder();
        html.append("<table class='table table-striped table-hover'>");
        html.append("<thead class='table-dark'>");
        html.append(
                "<tr><th>ID</th><th>Username</th><th>User Type</th><th>Name</th><th>Email</th><th>Phone</th><th>Created At</th></tr>");
        html.append("</thead><tbody>");

        boolean hasData = false;
        while (rs.next()) {
            hasData = true;
            html.append("<tr>");
            html.append("<td>").append(rs.getInt("id")).append("</td>");
            html.append("<td>").append(escapeHtml(rs.getString("username"))).append("</td>");
            html.append("<td><span class='badge bg-").append(getUserTypeBadgeColor(rs.getString("user_type")))
                    .append("'>")
                    .append(escapeHtml(rs.getString("user_type"))).append("</span></td>");
            html.append("<td>").append(escapeHtml(rs.getString("name"))).append("</td>");
            html.append("<td>").append(escapeHtml(rs.getString("email"))).append("</td>");
            html.append("<td>").append(escapeHtml(rs.getString("phone"))).append("</td>");
            html.append("<td>").append(rs.getTimestamp("created_at")).append("</td>");
            html.append("</tr>");
        }

        if (!hasData) {
            html.append("<tr><td colspan='7' class='text-center text-muted'>No users found in database</td></tr>");
        }

        html.append("</tbody></table>");
        return html.toString();
    }

    private String convertProjectsResultSet(ResultSet rs) throws SQLException {
        StringBuilder html = new StringBuilder();
        html.append("<table class='table table-striped table-hover'>");
        html.append("<thead class='table-dark'>");
        html.append(
                "<tr><th>ID</th><th>Topic</th><th>Start Date</th><th>Language</th><th>Technologies</th><th>Progress</th><th>Student ID</th><th>Supervisor ID</th></tr>");
        html.append("</thead><tbody>");

        boolean hasData = false;
        while (rs.next()) {
            hasData = true;
            html.append("<tr>");
            html.append("<td>").append(rs.getInt("id")).append("</td>");
            html.append("<td>").append(escapeHtml(rs.getString("topic"))).append("</td>");
            html.append("<td>").append(rs.getDate("start_date")).append("</td>");
            html.append("<td>").append(escapeHtml(rs.getString("language"))).append("</td>");
            html.append("<td>").append(escapeHtml(rs.getString("technologies"))).append("</td>");
            html.append("<td><span class='badge bg-").append(getProgressBadgeColor(rs.getString("progress")))
                    .append("'>")
                    .append(escapeHtml(rs.getString("progress"))).append("</span></td>");
            html.append("<td>").append(rs.getInt("student_id")).append("</td>");
            html.append("<td>").append(rs.getInt("supervisor_id")).append("</td>");
            html.append("</tr>");
        }

        if (!hasData) {
            html.append("<tr><td colspan='8' class='text-center text-muted'>No projects found in database</td></tr>");
        }

        html.append("</tbody></table>");
        return html.toString();
    }

    private String convertAppointmentsResultSet(ResultSet rs) throws SQLException {
        StringBuilder html = new StringBuilder();
        html.append("<table class='table table-striped table-hover'>");
        html.append("<thead class='table-dark'>");
        html.append(
                "<tr><th>ID</th><th>Student Username</th><th>Advisor ID</th><th>Type</th><th>Date</th><th>Time</th><th>Reason</th><th>Status</th></tr>");
        html.append("</thead><tbody>");

        boolean hasData = false;
        while (rs.next()) {
            hasData = true;
            html.append("<tr>");
            html.append("<td>").append(rs.getInt("id")).append("</td>");
            html.append("<td>").append(escapeHtml(rs.getString("student_username"))).append("</td>");
            html.append("<td>").append(escapeHtml(rs.getString("advisor_id"))).append("</td>");
            html.append("<td>").append(escapeHtml(rs.getString("appointment_type"))).append("</td>");
            html.append("<td>").append(rs.getDate("appointment_date")).append("</td>");
            html.append("<td>").append(rs.getTime("appointment_time")).append("</td>");
            html.append("<td>").append(escapeHtml(rs.getString("reason"))).append("</td>");
            html.append("<td><span class='badge bg-").append(getStatusBadgeColor(rs.getString("status"))).append("'>")
                    .append(escapeHtml(rs.getString("status"))).append("</span></td>");
            html.append("</tr>");
        }

        if (!hasData) {
            html.append(
                    "<tr><td colspan='8' class='text-center text-muted'>No appointments found in database</td></tr>");
        }

        html.append("</tbody></table>");
        return html.toString();
    }

    private String getUserTypeBadgeColor(String userType) {
        switch (userType.toLowerCase()) {
            case "student":
                return "primary";
            case "professor":
                return "warning";
            case "secretary":
                return "success";
            default:
                return "secondary";
        }
    }

    private String getProgressBadgeColor(String progress) {
        switch (progress.toLowerCase()) {
            case "completed":
                return "success";
            case "in progress":
                return "primary";
            case "not started":
                return "warning";
            default:
                return "secondary";
        }
    }

    private String getStatusBadgeColor(String status) {
        switch (status.toLowerCase()) {
            case "confirmed":
                return "success";
            case "pending":
                return "warning";
            case "cancelled":
                return "danger";
            default:
                return "secondary";
        }
    }

    private void clearDatabaseData(HttpServletResponse response) throws IOException {
        response.setContentType("text/plain");

        try (Connection conn = DatabaseUtil.getConnection();
                PrintWriter out = response.getWriter()) {

            // Disable foreign key checks
            conn.createStatement().execute("SET FOREIGN_KEY_CHECKS = 0");

            // Clear all tables
            conn.createStatement().execute("DELETE FROM appointments");
            conn.createStatement().execute("DELETE FROM projects");
            conn.createStatement().execute("DELETE FROM users WHERE user_type != 'secretary'");

            // Reset auto increment
            conn.createStatement().execute("ALTER TABLE appointments AUTO_INCREMENT = 1");
            conn.createStatement().execute("ALTER TABLE projects AUTO_INCREMENT = 1");

            // Re-enable foreign key checks
            conn.createStatement().execute("SET FOREIGN_KEY_CHECKS = 1");

            out.print("Database cleared successfully");

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().print("Error clearing database: " + e.getMessage());
        }
    }

    private void exportDataToCSV(HttpServletResponse response) throws IOException {
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"database_export.csv\"");

        try (Connection conn = DatabaseUtil.getConnection()) {

            StringBuilder csv = new StringBuilder();

            // Export users
            csv.append("=== USERS ===\n");
            csv.append("ID,Username,User Type,Name,Email,Phone,Created At\n");

            try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users ORDER BY id")) {
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    csv.append(rs.getInt("id")).append(",");
                    csv.append("\"").append(rs.getString("username")).append("\",");
                    csv.append("\"").append(rs.getString("user_type")).append("\",");
                    csv.append("\"").append(rs.getString("name")).append("\",");
                    csv.append("\"").append(rs.getString("email")).append("\",");
                    csv.append("\"").append(rs.getString("phone")).append("\",");
                    csv.append("\"").append(rs.getTimestamp("created_at")).append("\"\n");
                }
            }

            csv.append("\n=== PROJECTS ===\n");
            csv.append("ID,Topic,Start Date,Language,Technologies,Progress,Student ID,Supervisor ID,Created At\n");

            try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM projects ORDER BY id")) {
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    csv.append(rs.getInt("id")).append(",");
                    csv.append("\"").append(rs.getString("topic")).append("\",");
                    csv.append("\"").append(rs.getDate("start_date")).append("\",");
                    csv.append("\"").append(rs.getString("language")).append("\",");
                    csv.append("\"").append(rs.getString("technologies")).append("\",");
                    csv.append("\"").append(rs.getString("progress")).append("\",");
                    csv.append(rs.getInt("student_id")).append(",");
                    csv.append(rs.getInt("supervisor_id")).append(",");
                    csv.append("\"").append(rs.getTimestamp("created_at")).append("\"\n");
                }
            }

            csv.append("\n=== APPOINTMENTS ===\n");
            csv.append("ID,Student Username,Advisor ID,Type,Date,Time,Reason,Additional Notes,Status,Created At\n");

            try (PreparedStatement stmt = conn.prepareStatement("SELECT * FROM appointments ORDER BY id")) {
                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    csv.append(rs.getInt("id")).append(",");
                    csv.append("\"").append(rs.getString("student_username")).append("\",");
                    csv.append("\"").append(rs.getString("advisor_id")).append("\",");
                    csv.append("\"").append(rs.getString("appointment_type")).append("\",");
                    csv.append("\"").append(rs.getDate("appointment_date")).append("\",");
                    csv.append("\"").append(rs.getTime("appointment_time")).append("\",");
                    csv.append("\"").append(rs.getString("reason")).append("\",");
                    csv.append("\"")
                            .append(rs.getString("additional_notes") != null ? rs.getString("additional_notes") : "")
                            .append("\",");
                    csv.append("\"").append(rs.getString("status")).append("\",");
                    csv.append("\"").append(rs.getTimestamp("created_at")).append("\"\n");
                }
            }

            // Return CSV content
            response.getWriter().print(csv.toString());

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().print("Error exporting data: " + e.getMessage());
        }
    }

    private String escapeHtml(String str) {
        if (str == null)
            return "";
        return str.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }
}
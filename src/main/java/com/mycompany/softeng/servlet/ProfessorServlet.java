package com.mycompany.softeng.servlet;

import com.mycompany.softeng.model.Professor;
import com.mycompany.softeng.model.Assignment;
import com.mycompany.softeng.dao.AssignmentDAO;
import com.mycompany.softeng.util.DatabaseUtil;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;
import java.util.logging.Logger;

@WebServlet({ "/professor-dashboard", "/ProfessorServlet" })
public class ProfessorServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ProfessorServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");

        LOGGER.info("ProfessorServlet.doGet called");
        LOGGER.info("Session ID: " + session.getId());
        LOGGER.info("Username from session: " + username);
        LOGGER.info("Role from session: " + role);

        if (username == null) {
            LOGGER.warning("Username is null, redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }

        LOGGER.info("Professor dashboard access for: " + username);

        try {
            // Get professor ID
            int professorId = getProfessorIdFromUsername(username);

            if (professorId == -1) {
                LOGGER.warning("Professor ID not found for username: " + username);
                request.setAttribute("supervisedCount", 0);
                request.setAttribute("pendingAssignments", 0);
                request.setAttribute("appointmentsCount", 0);
                request.setAttribute("supervisedAssignments", new ArrayList<>());
            } else {
                // Get supervised assignments
                List<Assignment> supervisedAssignments = getSupervisedAssignments(professorId);

                // Add student names to assignments
                for (Assignment assignment : supervisedAssignments) {
                    String studentName = getStudentNameById(assignment.getStudentId());
                    assignment.setStudentName(studentName);
                }

                // Calculate statistics
                int supervisedCount = supervisedAssignments.size();
                int pendingAssignments = (int) supervisedAssignments.stream()
                        .filter(a -> "Not Started".equals(a.getProgress()) || "In Progress".equals(a.getProgress()))
                        .count();
                int appointmentsCount = 3; // Placeholder - implement actual count later

                // Set attributes
                request.setAttribute("supervisedCount", supervisedCount);
                request.setAttribute("pendingAssignments", pendingAssignments);
                request.setAttribute("appointmentsCount", appointmentsCount);
                request.setAttribute("supervisedAssignments", supervisedAssignments);

                LOGGER.info("Professor dashboard loaded for: " + username + " with " + supervisedCount
                        + " supervised assignments");
            }

        } catch (SQLException e) {
            LOGGER.severe("Database error: " + e.getMessage());
            request.setAttribute("supervisedCount", 0);
            request.setAttribute("pendingAssignments", 0);
            request.setAttribute("appointmentsCount", 0);
            request.setAttribute("supervisedAssignments", new ArrayList<>());
        }

        request.getRequestDispatcher("professor-dashboard.jsp").forward(request, response);
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

        try {
            switch (action != null ? action : "") {
                case "createAppointments":
                    handleCreateAppointments(request, username);
                    break;
                case "markAssignment":
                    handleMarkAssignment(request, username);
                    break;
                case "getReports":
                    handleGenerateReports(request, username);
                    break;
                default:
                    LOGGER.warning("Unknown action: " + action);
            }
        } catch (SQLException e) {
            LOGGER.severe("Database error: " + e.getMessage());
        }

        // Redirect back to dashboard (GET request)
        response.sendRedirect("professor-dashboard");
    }

    private void handleCreateAppointments(HttpServletRequest request, String username) throws SQLException {
        // For now, just log the action - could be expanded to create appointment slots
        LOGGER.info("Professor " + username + " initiated appointment creation");

        // Future implementation could include:
        // - Create available time slots
        // - Set office hours
        // - Bulk appointment management
    }

    private void handleMarkAssignment(HttpServletRequest request, String username) throws SQLException {
        String assignmentIdStr = request.getParameter("assignmentId");
        String grade = request.getParameter("grade");
        String comments = request.getParameter("comments");

        if (assignmentIdStr != null) {
            int assignmentId = Integer.parseInt(assignmentIdStr);

            // For now, we'll mark it as completed with a comment
            // In a full implementation, you'd add grade and comments fields to the
            // assignments table
            String sql = "UPDATE assignments SET progress = 'Completed' WHERE id = ? AND supervisor_id = (SELECT id FROM users WHERE username = ? AND user_type = 'professor')";

            try (Connection conn = DatabaseUtil.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, assignmentId);
                stmt.setString(2, username);

                int updated = stmt.executeUpdate();
                if (updated > 0) {
                    LOGGER.info("Assignment " + assignmentId + " marked as completed by professor " + username);

                    // Log the marking action (could be stored in a separate grading table)
                    logAssignmentGrading(assignmentId, username, grade, comments);
                } else {
                    LOGGER.warning("Failed to mark assignment " + assignmentId + " - not supervised by " + username);
                }
            }
        }
    }

    private void handleGenerateReports(HttpServletRequest request, String username) throws SQLException {
        // Generate a simple progress report for all supervised assignments
        int professorId = getProfessorIdFromUsername(username);

        if (professorId != -1) {
            List<Assignment> supervisedAssignments = getSupervisedAssignments(professorId);

            // Calculate statistics
            long completed = supervisedAssignments.stream().filter(a -> "Completed".equals(a.getProgress())).count();
            long inProgress = supervisedAssignments.stream().filter(a -> "In Progress".equals(a.getProgress())).count();
            long notStarted = supervisedAssignments.stream().filter(a -> "Not Started".equals(a.getProgress())).count();

            LOGGER.info("Report generated for professor " + username + ": " +
                    completed + " completed, " + inProgress + " in progress, " + notStarted + " not started");

            // In a full implementation, this could generate a PDF report or return
            // structured data
        }
    }

    private void logAssignmentGrading(int assignmentId, String professorUsername, String grade, String comments) {
        // Log the grading action - in a full system this would go to a grading/feedback
        // table
        LOGGER.info("Assignment " + assignmentId + " graded by " + professorUsername +
                (grade != null ? " with grade: " + grade : "") +
                (comments != null ? " with comments: " + comments : ""));
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

    private List<Assignment> getSupervisedAssignments(int professorId) throws SQLException {
        List<Assignment> assignments = new ArrayList<>();
        String sql = "SELECT * FROM assignments WHERE supervisor_id = ? ORDER BY start_date DESC";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, professorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Assignment assignment = new Assignment();
                    assignment.setId(rs.getInt("id"));
                    assignment.setTopic(rs.getString("topic"));
                    assignment.setStartDate(rs.getDate("start_date"));
                    assignment.setLanguage(rs.getString("language"));
                    assignment.setTechnologies(rs.getString("technologies"));
                    assignment.setProgress(rs.getString("progress"));
                    assignment.setStudentId(rs.getInt("student_id"));
                    assignment.setSupervisorId(rs.getInt("supervisor_id"));
                    assignment.setCreatedAt(rs.getTimestamp("created_at"));
                    assignments.add(assignment);
                }
            }
        }
        return assignments;
    }

    private String getStudentNameById(int studentId) throws SQLException {
        String sql = "SELECT name FROM users WHERE id = ? AND user_type = 'student'";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("name");
                }
            }
        }
        return "Unknown Student";
    }
}
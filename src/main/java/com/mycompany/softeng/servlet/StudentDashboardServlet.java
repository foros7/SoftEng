package com.mycompany.softeng.servlet;

import com.mycompany.softeng.dao.AppointmentDAO;
import com.mycompany.softeng.dao.AssignmentDAO;
import com.mycompany.softeng.model.Appointment;
import com.mycompany.softeng.model.Assignment;
import com.mycompany.softeng.util.DatabaseUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet("/student-dashboard")
public class StudentDashboardServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(StudentDashboardServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            LOGGER.info("Processing request for username: " + username);

            // Test database connection first
            if (!DatabaseUtil.testConnection()) {
                LOGGER.warning("Database connection not available. Using empty data.");
                setEmptyData(request, username);
                request.getRequestDispatcher("student.jsp").forward(request, response);
                return;
            }

            // Get student ID from username
            int studentId = getStudentIdFromUsername(username);
            LOGGER.info("Retrieved student ID: " + studentId + " for username: " + username);

            if (studentId == -1) {
                LOGGER.warning("No student found for username: " + username + ". Using empty data.");
                setEmptyData(request, username);
                request.getRequestDispatcher("student.jsp").forward(request, response);
                return;
            }

            // Get student's assignments
            AssignmentDAO assignmentDAO = new AssignmentDAO();
            List<Assignment> assignments = assignmentDAO.getByStudentId(studentId);
            LOGGER.info("Found " + assignments.size() + " assignments for student ID: " + studentId);

            // Log each assignment
            for (Assignment assignment : assignments) {
                LOGGER.info("Assignment: ID=" + assignment.getId() +
                        ", Topic=" + assignment.getTopic() +
                        ", StudentID=" + assignment.getStudentId());
            }

            // Get appointments for the student
            AppointmentDAO appointmentDAO = new AppointmentDAO();
            List<Appointment> appointments = appointmentDAO.getAppointmentsByStudent(username);
            LOGGER.info("Found " + appointments.size() + " appointments");

            // Calculate overall progress
            double overallProgress = calculateOverallProgress(assignments);
            LOGGER.info("Overall progress: " + overallProgress);

            // Set attributes for JSP
            request.setAttribute("assignments", assignments);
            request.setAttribute("appointments", appointments);
            request.setAttribute("overallProgress", overallProgress);
            request.setAttribute("pendingTasks", countPendingTasks(assignments));
            request.setAttribute("username", username);

            // Forward to student dashboard
            request.getRequestDispatcher("student.jsp").forward(request, response);

        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Database error, using empty data: " + e.getMessage());
            setEmptyData(request, username);
            request.getRequestDispatcher("student.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error", e);
            setEmptyData(request, username);
            request.getRequestDispatcher("student.jsp").forward(request, response);
        }
    }

    private void setEmptyData(HttpServletRequest request, String username) {
        request.setAttribute("assignments", new ArrayList<Assignment>());
        request.setAttribute("appointments", new ArrayList<Appointment>());
        request.setAttribute("overallProgress", 0.0);
        request.setAttribute("pendingTasks", 0);
        request.setAttribute("username", username);
    }

    private int getStudentIdFromUsername(String username) throws SQLException {
        String sql = "SELECT id FROM users WHERE username = ? AND user_type = 'student'";
        LOGGER.info("Looking up student ID for username: " + username);
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    LOGGER.info("Found student ID: " + id + " for username: " + username);
                    return id;
                } else {
                    LOGGER.warning("No student found with username: " + username);
                }
            }
        }
        return -1;
    }

    private double calculateOverallProgress(List<Assignment> assignments) {
        if (assignments.isEmpty()) {
            return 0.0;
        }

        double totalProgress = 0.0;
        for (Assignment assignment : assignments) {
            if ("Completed".equals(assignment.getProgress())) {
                totalProgress += 100.0;
            } else if ("In Progress".equals(assignment.getProgress())) {
                totalProgress += 50.0;
            }
        }

        return totalProgress / assignments.size();
    }

    private int countPendingTasks(List<Assignment> assignments) {
        return (int) assignments.stream()
                .filter(a -> "Not Started".equals(a.getProgress()) || "In Progress".equals(a.getProgress()))
                .count();
    }
}
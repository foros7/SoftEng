package com.mycompany.softeng.servlet;

import com.mycompany.softeng.dao.AssignmentDAO;
import com.mycompany.softeng.dao.AppointmentDAO;
import com.mycompany.softeng.model.Assignment;
import com.mycompany.softeng.model.Appointment;
import com.mycompany.softeng.util.DatabaseUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet("/StudentServlet")
public class StudentServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(StudentServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String action = request.getParameter("action");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Test database connection first
            if (!DatabaseUtil.testConnection()) {
                LOGGER.warning("Database connection not available. Skipping action: " + action);
                response.sendRedirect("student-dashboard?error=Database not available");
                return;
            }

            if ("uploadAssignment".equals(action)) {
                handleUploadAssignment(request, username);
            } else if ("makeAppointment".equals(action)) {
                handleMakeAppointment(request, username);
            }

            // Redirect back to dashboard
            response.sendRedirect("student-dashboard");

        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Database error during action: " + action + " - " + e.getMessage());
            response.sendRedirect("student-dashboard?error=Database error");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error during action: " + action, e);
            response.sendRedirect("student-dashboard?error=Unexpected error");
        }
    }

    private void handleUploadAssignment(HttpServletRequest request, String username) throws SQLException {
        String topic = request.getParameter("topic");
        String language = request.getParameter("language");
        String technologies = request.getParameter("technologies");
        String progress = request.getParameter("progress");

        // Get student ID
        int studentId = getStudentIdFromUsername(username);

        if (studentId != -1) {
            Assignment assignment = new Assignment(topic, new Date(), language, technologies, progress, studentId);

            AssignmentDAO assignmentDAO = new AssignmentDAO();
            assignmentDAO.create(assignment);

            LOGGER.info("Assignment created for student: " + username);
        } else {
            LOGGER.warning("Could not create assignment - student ID not found for: " + username);
        }
    }

    private void handleMakeAppointment(HttpServletRequest request, String username) throws SQLException {
        String meetingDate = request.getParameter("meetingDate");
        String meetingTime = request.getParameter("meetingTime");
        String meetingDuration = request.getParameter("meetingDuration");
        String meetingPurpose = request.getParameter("meetingPurpose");

        Appointment appointment = new Appointment();
        appointment.setStudentUsername(username);
        appointment.setAdvisorId("2"); // Default to professor1
        appointment.setAppointmentType("Thesis Meeting");
        appointment.setDate(meetingDate);
        appointment.setTime(meetingTime);
        appointment.setReason(meetingPurpose);
        appointment.setStatus("pending");

        AppointmentDAO appointmentDAO = new AppointmentDAO();
        appointmentDAO.create(appointment);

        LOGGER.info("Appointment created for student: " + username);
    }

    private int getStudentIdFromUsername(String username) throws SQLException {
        String sql = "SELECT id FROM users WHERE username = ? AND role = 'student'";
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
}
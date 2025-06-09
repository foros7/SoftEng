package com.mycompany.softeng.servlet;

import com.mycompany.softeng.dao.NotificationDAO;
import com.mycompany.softeng.util.DatabaseUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class NotificationActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(NotificationActionServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set response content type
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"User not logged in\"}");
            return;
        }

        String action = request.getParameter("action");
        String notificationIdStr = request.getParameter("notificationId");
        String appointmentIdStr = request.getParameter("appointmentId");

        LOGGER.info("Notification action request - Action: " + action + ", NotificationId: " + notificationIdStr
                + ", AppointmentId: " + appointmentIdStr + ", User: " + username);

        if (notificationIdStr == null || appointmentIdStr == null || action == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Missing parameters\"}");
            return;
        }

        try {
            int notificationId = Integer.parseInt(notificationIdStr);
            int appointmentId = Integer.parseInt(appointmentIdStr);

            if ("accept".equals(action)) {
                acceptAppointment(appointmentId, notificationId, username);
                response.getWriter().write("{\"success\": true, \"message\": \"Appointment accepted successfully\"}");
            } else if ("decline".equals(action)) {
                declineAppointment(appointmentId, notificationId, username);
                response.getWriter().write("{\"success\": true, \"message\": \"Appointment declined successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"Invalid action\"}");
            }

        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid ID format", e);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid ID format\"}");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during notification action", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"Database error: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error during notification action", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter()
                    .write("{\"success\": false, \"message\": \"Unexpected error: " + e.getMessage() + "\"}");
        }
    }

    private void acceptAppointment(int appointmentId, int notificationId, String username) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection()) {
            conn.setAutoCommit(false);

            try {
                // Update appointment status to confirmed
                String updateAppointmentSql = "UPDATE appointments SET status = 'confirmed' WHERE id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(updateAppointmentSql)) {
                    stmt.setInt(1, appointmentId);
                    stmt.executeUpdate();
                }

                // Mark notification as read
                NotificationDAO notificationDAO = new NotificationDAO();
                notificationDAO.markAsRead(notificationId);

                // Create a confirmation notification for the student
                createStudentNotification(conn, appointmentId, "accepted");

                conn.commit();
                LOGGER.info("Appointment " + appointmentId + " accepted by " + username);

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    private void declineAppointment(int appointmentId, int notificationId, String username) throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection()) {
            conn.setAutoCommit(false);

            try {
                // Update appointment status to cancelled
                String updateAppointmentSql = "UPDATE appointments SET status = 'cancelled' WHERE id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(updateAppointmentSql)) {
                    stmt.setInt(1, appointmentId);
                    stmt.executeUpdate();
                }

                // Mark notification as read
                NotificationDAO notificationDAO = new NotificationDAO();
                notificationDAO.markAsRead(notificationId);

                // Create a notification for the student
                createStudentNotification(conn, appointmentId, "declined");

                conn.commit();
                LOGGER.info("Appointment " + appointmentId + " declined by " + username);

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        }
    }

    private void createStudentNotification(Connection conn, int appointmentId, String action) throws SQLException {
        // Get appointment details and student username
        String getAppointmentSql = "SELECT student_username, appointment_date, appointment_time, appointment_type FROM appointments WHERE id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(getAppointmentSql)) {
            stmt.setInt(1, appointmentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String studentUsername = rs.getString("student_username");
                    String appointmentDate = rs.getString("appointment_date");
                    String appointmentTime = rs.getString("appointment_time");
                    String appointmentType = rs.getString("appointment_type");

                    String title = "Appointment " + (action.equals("accepted") ? "Confirmed" : "Declined");
                    String message = String.format("Your %s appointment on %s at %s has been %s by your advisor.",
                            appointmentType, appointmentDate, appointmentTime, action);

                    String notificationSql = "INSERT INTO notifications (recipient_username, title, message, type, related_id, is_read) VALUES (?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement notifStmt = conn.prepareStatement(notificationSql)) {
                        notifStmt.setString(1, studentUsername);
                        notifStmt.setString(2, title);
                        notifStmt.setString(3, message);
                        notifStmt.setString(4, "appointment_response");
                        notifStmt.setString(5, String.valueOf(appointmentId));
                        notifStmt.setBoolean(6, false);
                        notifStmt.executeUpdate();
                    }
                }
            }
        }
    }
}
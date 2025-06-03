package com.mycompany.softeng.dao;

import com.mycompany.softeng.model.Appointment;
import com.mycompany.softeng.util.DatabaseUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AppointmentDAO {
    private static final Logger LOGGER = Logger.getLogger(AppointmentDAO.class.getName());

    public List<Appointment> getAppointmentsByStudent(String studentUsername) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.*, u.name as student_name " +
                "FROM appointments a " +
                "JOIN users u ON a.student_username = u.username " +
                "WHERE a.student_username = ? " +
                "ORDER BY a.appointment_date, a.appointment_time";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, studentUsername);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setId(rs.getInt("id"));
                    appointment.setStudentUsername(rs.getString("student_username"));
                    appointment.setAdvisorId(rs.getString("advisor_id"));
                    appointment.setAppointmentType(rs.getString("appointment_type"));
                    appointment.setDate(rs.getDate("appointment_date").toString());
                    appointment.setTime(rs.getTime("appointment_time").toString());
                    appointment.setReason(rs.getString("reason"));
                    appointment.setAdditionalNotes(rs.getString("additional_notes"));
                    appointment.setStatus(rs.getString("status"));
                    appointment.setCreatedAt(rs.getTimestamp("created_at"));
                    appointments.add(appointment);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting appointments for student: " + studentUsername, e);
            throw e;
        }
        return appointments;
    }

    public void create(Appointment appointment) throws SQLException {
        String sql = "INSERT INTO appointments (student_username, advisor_id, appointment_type, " +
                "appointment_date, appointment_time, reason, additional_notes, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, appointment.getStudentUsername());
            pstmt.setString(2, appointment.getAdvisorId());
            pstmt.setString(3, appointment.getAppointmentType());
            pstmt.setString(4, appointment.getDate());
            pstmt.setString(5, appointment.getTime());
            pstmt.setString(6, appointment.getReason());
            pstmt.setString(7, appointment.getAdditionalNotes());
            pstmt.setString(8, appointment.getStatus());

            pstmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating appointment", e);
            throw e;
        }
    }

    public void updateStatus(int appointmentId, String status) throws SQLException {
        String sql = "UPDATE appointments SET status = ? WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setInt(2, appointmentId);

            pstmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating appointment status", e);
            throw e;
        }
    }
}
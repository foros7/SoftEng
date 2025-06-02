package com.mycompany.softeng.dao;

import com.mycompany.softeng.model.Appointment;
import com.mycompany.softeng.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {

    public void create(Appointment appointment) throws SQLException {
        String sql = "INSERT INTO appointments (assignment_id, day_time, duration, purpose, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, appointment.getAssignmentId());
            stmt.setTimestamp(2, new Timestamp(appointment.getDayTime().getTime()));
            stmt.setInt(3, appointment.getDuration());
            stmt.setString(4, appointment.getPurpose());
            stmt.setString(5, appointment.getStatus());

            stmt.executeUpdate();

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    appointment.setId(generatedKeys.getInt(1));
                }
            }
        }
    }

    public Appointment getById(int id) throws SQLException {
        String sql = "SELECT * FROM appointments WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractAppointmentFromResultSet(rs);
                }
            }
        }
        return null;
    }

    public List<Appointment> getByAssignmentId(int assignmentId) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT * FROM appointments WHERE assignment_id = ? ORDER BY day_time";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, assignmentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    appointments.add(extractAppointmentFromResultSet(rs));
                }
            }
        }
        return appointments;
    }

    public List<Appointment> getUpcomingAppointments() throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT * FROM appointments WHERE day_time > NOW() AND status = 'scheduled' ORDER BY day_time";
        try (Connection conn = DatabaseUtil.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                appointments.add(extractAppointmentFromResultSet(rs));
            }
        }
        return appointments;
    }

    public void update(Appointment appointment) throws SQLException {
        String sql = "UPDATE appointments SET assignment_id = ?, day_time = ?, duration = ?, purpose = ?, status = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, appointment.getAssignmentId());
            stmt.setTimestamp(2, new Timestamp(appointment.getDayTime().getTime()));
            stmt.setInt(3, appointment.getDuration());
            stmt.setString(4, appointment.getPurpose());
            stmt.setString(5, appointment.getStatus());
            stmt.setInt(6, appointment.getId());

            stmt.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM appointments WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    private Appointment extractAppointmentFromResultSet(ResultSet rs) throws SQLException {
        Appointment appointment = new Appointment();
        appointment.setId(rs.getInt("id"));
        appointment.setAssignmentId(rs.getInt("assignment_id"));
        appointment.setDayTime(rs.getTimestamp("day_time"));
        appointment.setDuration(rs.getInt("duration"));
        appointment.setPurpose(rs.getString("purpose"));
        appointment.setStatus(rs.getString("status"));
        appointment.setCreatedAt(rs.getTimestamp("created_at"));
        return appointment;
    }
}
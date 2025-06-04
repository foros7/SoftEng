package com.mycompany.softeng.dao;

import com.mycompany.softeng.model.Assignment;
import com.mycompany.softeng.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AssignmentDAO {
    private static final Logger LOGGER = Logger.getLogger(AssignmentDAO.class.getName());

    public AssignmentDAO() {
    }

    public void create(Assignment assignment) throws SQLException {
        String sql = "INSERT INTO assignments (topic, start_date, language, technologies, progress, student_id, supervisor_id) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, assignment.getTopic());
            stmt.setDate(2, new java.sql.Date(assignment.getStartDate().getTime()));
            stmt.setString(3, assignment.getLanguage());
            stmt.setString(4, assignment.getTechnologies());
            stmt.setString(5, assignment.getProgress());
            stmt.setInt(6, assignment.getStudentId());
            stmt.setInt(7, assignment.getSupervisorId());

            stmt.executeUpdate();

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    assignment.setId(generatedKeys.getInt(1));
                }
            }
        }
    }

    public Assignment getById(int id) throws SQLException {
        String sql = "SELECT * FROM assignments WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractAssignmentFromResultSet(rs);
                }
            }
        }
        return null;
    }

    public List<Assignment> getByStudentId(int studentId) throws SQLException {
        List<Assignment> assignments = new ArrayList<>();
        String sql = "SELECT * FROM assignments WHERE student_id = ? ORDER BY start_date DESC";
        LOGGER.info("Retrieving assignments for student ID: " + studentId);

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Assignment assignment = extractAssignmentFromResultSet(rs);
                    LOGGER.info("Found assignment: ID=" + assignment.getId() +
                            ", Topic=" + assignment.getTopic() +
                            ", StudentID=" + assignment.getStudentId());
                    assignments.add(assignment);
                }
            }
        }
        LOGGER.info("Total assignments found: " + assignments.size());
        return assignments;
    }

    public void update(Assignment assignment) throws SQLException {
        String sql = "UPDATE assignments SET topic = ?, start_date = ?, language = ?, technologies = ?, progress = ?, supervisor_id = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, assignment.getTopic());
            stmt.setDate(2, new java.sql.Date(assignment.getStartDate().getTime()));
            stmt.setString(3, assignment.getLanguage());
            stmt.setString(4, assignment.getTechnologies());
            stmt.setString(5, assignment.getProgress());
            stmt.setInt(6, assignment.getSupervisorId());
            stmt.setInt(7, assignment.getId());

            stmt.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM assignments WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    private Assignment extractAssignmentFromResultSet(ResultSet rs) throws SQLException {
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
        return assignment;
    }
}
package com.mycompany.softeng.dao;

import com.mycompany.softeng.model.Assignment;
import com.mycompany.softeng.util.DatabaseConfig;
import com.mycompany.softeng.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AssignmentDAO implements BaseDAO<Assignment> {

    @Override
    public Assignment create(Assignment assignment) throws Exception {
        String sql = "INSERT INTO " + DatabaseConfig.ASSIGNMENTS_TABLE +
                " (topic, start_date, language, technologies, progress, student_id) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, assignment.getTopic());
            pstmt.setDate(2, new java.sql.Date(assignment.getStartDate().getTime()));
            pstmt.setString(3, assignment.getLanguage());
            pstmt.setString(4, assignment.getTechnologies());
            pstmt.setString(5, assignment.getProgress());
            pstmt.setInt(6, assignment.getStudentId());

            pstmt.executeUpdate();

            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    assignment.setId(rs.getInt(1));
                }
            }

            return assignment;
        }
    }

    @Override
    public Assignment getById(int id) throws Exception {
        String sql = "SELECT * FROM " + DatabaseConfig.ASSIGNMENTS_TABLE + " WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractAssignmentFromResultSet(rs);
                }
            }
        }
        return null;
    }

    @Override
    public List<Assignment> getAll() throws Exception {
        List<Assignment> assignments = new ArrayList<>();
        String sql = "SELECT * FROM " + DatabaseConfig.ASSIGNMENTS_TABLE;

        try (Connection conn = DatabaseUtil.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                assignments.add(extractAssignmentFromResultSet(rs));
            }
        }
        return assignments;
    }

    @Override
    public Assignment update(Assignment assignment) throws Exception {
        String sql = "UPDATE " + DatabaseConfig.ASSIGNMENTS_TABLE +
                " SET topic = ?, start_date = ?, language = ?, technologies = ?, " +
                "progress = ?, student_id = ? WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, assignment.getTopic());
            pstmt.setDate(2, new java.sql.Date(assignment.getStartDate().getTime()));
            pstmt.setString(3, assignment.getLanguage());
            pstmt.setString(4, assignment.getTechnologies());
            pstmt.setString(5, assignment.getProgress());
            pstmt.setInt(6, assignment.getStudentId());
            pstmt.setInt(7, assignment.getId());

            pstmt.executeUpdate();
            return assignment;
        }
    }

    @Override
    public boolean delete(int id) throws Exception {
        String sql = "DELETE FROM " + DatabaseConfig.ASSIGNMENTS_TABLE + " WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    public List<Assignment> getByStudentId(int studentId) throws Exception {
        List<Assignment> assignments = new ArrayList<>();
        String sql = "SELECT * FROM " + DatabaseConfig.ASSIGNMENTS_TABLE + " WHERE student_id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, studentId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    assignments.add(extractAssignmentFromResultSet(rs));
                }
            }
        }
        return assignments;
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
        return assignment;
    }
}
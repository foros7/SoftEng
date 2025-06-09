package com.mycompany.softeng.servlet;

import com.mycompany.softeng.dao.AppointmentDAO;
import com.mycompany.softeng.dao.AssignmentDAO;
import com.mycompany.softeng.model.Appointment;
import com.mycompany.softeng.model.Assignment;
import com.mycompany.softeng.util.DatabaseUtil;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class InsertTestDataServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try (Connection conn = DatabaseUtil.getConnection()) {
            out.println("<html><body>");
            out.println("<h1>Inserting Test Data</h1>");

            // Insert test student
            int studentId = insertTestStudent(conn, out);
            if (studentId == -1) {
                out.println("<p>Error: Could not insert test student</p>");
                return;
            }

            // Insert test assignment
            int assignmentId = insertTestAssignment(conn, studentId, out);
            if (assignmentId == -1) {
                out.println("<p>Error: Could not insert test assignment</p>");
                return;
            }

            // Insert test appointment
            insertTestAppointment(conn, assignmentId, out);

            out.println("<p>Test data inserted successfully!</p>");
            out.println("<p><a href='student-dashboard'>Go to Dashboard</a></p>");
            out.println("</body></html>");

        } catch (SQLException e) {
            out.println("<h1>Error</h1>");
            out.println("<pre>" + e.getMessage() + "</pre>");
            e.printStackTrace(out);
        }
    }

    private int insertTestStudent(Connection conn, PrintWriter out) throws SQLException {
        // First check if student already exists
        String checkSql = "SELECT id FROM users WHERE username = ?";
        try (PreparedStatement stmt = conn.prepareStatement(checkSql)) {
            stmt.setString(1, "student1");
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    out.println("<p>Test student already exists with ID: " + id + "</p>");
                    return id;
                }
            }
        }

        // Insert new student
        String sql = "INSERT INTO users (username, password, user_type, name, email) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, "student1");
            stmt.setString(2, "password123");
            stmt.setString(3, "student");
            stmt.setString(4, "John Student");
            stmt.setString(5, "student@example.com");

            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    int id = rs.getInt(1);
                    out.println("<p>Created test student with ID: " + id + "</p>");
                    return id;
                }
            }
        }
        return -1;
    }

    private int insertTestAssignment(Connection conn, int studentId, PrintWriter out) throws SQLException {
        // First check if assignment already exists
        String checkSql = "SELECT id FROM assignments WHERE student_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(checkSql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    out.println("<p>Test assignment already exists with ID: " + id + "</p>");
                    return id;
                }
            }
        }

        // Insert new assignment
        String sql = "INSERT INTO assignments (topic, start_date, language, technologies, progress, student_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, "Web Development Project");
            stmt.setDate(2, new java.sql.Date(new Date().getTime()));
            stmt.setString(3, "Java");
            stmt.setString(4, "Spring Boot, MySQL");
            stmt.setString(5, "In Progress");
            stmt.setInt(6, studentId);

            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    int id = rs.getInt(1);
                    out.println("<p>Created test assignment with ID: " + id + "</p>");
                    return id;
                }
            }
        }
        return -1;
    }

    private void insertTestAppointment(Connection conn, int assignmentId, PrintWriter out) throws SQLException {
        // First check if appointment already exists
        String checkSql = "SELECT id FROM appointments WHERE assignment_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(checkSql)) {
            stmt.setInt(1, assignmentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int id = rs.getInt("id");
                    out.println("<p>Test appointment already exists with ID: " + id + "</p>");
                    return;
                }
            }
        }

        // Insert new appointment
        String sql = "INSERT INTO appointments (assignment_id, day_time, duration, purpose, status) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, assignmentId);
            stmt.setTimestamp(2, new java.sql.Timestamp(System.currentTimeMillis() + 86400000)); // tomorrow
            stmt.setInt(3, 60);
            stmt.setString(4, "Project Progress Review");
            stmt.setString(5, "scheduled");

            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    int id = rs.getInt(1);
                    out.println("<p>Created test appointment with ID: " + id + "</p>");
                }
            }
        }
    }
}
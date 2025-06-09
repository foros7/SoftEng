package com.mycompany.softeng.servlet;

import com.mycompany.softeng.util.DatabaseUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

public class SampleDataServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String userRole = (String) session.getAttribute("role");

        // Check if user is logged in and is a secretary
        if (username == null || !"secretary".equals(userRole)) {
            response.sendRedirect("login.jsp");
            return;
        }

        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            out.println("<html><head><title>Sample Data Generator</title></head><body>");
            out.println("<h2>Sample Data Generator</h2>");
            out.println("<p><a href='secretary-dashboard'>Back to Dashboard</a></p>");

            try {
                populateSampleData();
                out.println(
                        "<div style='color: green; background: #e8f5e8; padding: 10px; border-radius: 5px; margin: 20px 0;'>");
                out.println("<h3>✓ Sample Data Created Successfully!</h3>");
                out.println("<p>The following sample data has been added to your database:</p>");
                out.println("<ul>");
                out.println("<li><strong>3 Students:</strong> john_doe, jane_smith, mike_wilson</li>");
                out.println("<li><strong>2 Professors:</strong> prof_johnson, prof_davis</li>");
                out.println("<li><strong>1 Secretary:</strong> mary_jane (password: password123)</li>");
                out.println("<li><strong>3 Projects:</strong> Web Development, Mobile App, Data Analytics</li>");
                out.println("<li><strong>4 Appointments:</strong> Various consultation meetings</li>");
                out.println("</ul>");
                out.println(
                        "<p><strong>🔑 Test Login:</strong> Username: <code>mary_jane</code>, Password: <code>password123</code></p>");
                out.println(
                        "<p>You can now view this data in the <a href='SecretaryServlet?action=viewDatabase'>Database Viewer</a></p>");
                out.println("</div>");
            } catch (SQLException e) {
                out.println(
                        "<div style='color: red; background: #f8e8e8; padding: 10px; border-radius: 5px; margin: 20px 0;'>");
                out.println("<h3>✗ Error Creating Sample Data</h3>");
                out.println("<p>Error: " + e.getMessage() + "</p>");
                out.println("</div>");
                e.printStackTrace();
            }

            out.println("</body></html>");
        }
    }

    private void populateSampleData() throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection()) {

            // Insert sample students
            String insertUser = "INSERT INTO users (username, password, user_type, name, email, phone) VALUES (?, ?, ?, ?, ?, ?)";

            try (PreparedStatement stmt = conn.prepareStatement(insertUser)) {
                // Students
                stmt.setString(1, "john_doe");
                stmt.setString(2, "password123");
                stmt.setString(3, "student");
                stmt.setString(4, "John Doe");
                stmt.setString(5, "john.doe@university.edu");
                stmt.setString(6, "555-0101");
                stmt.executeUpdate();

                stmt.setString(1, "jane_smith");
                stmt.setString(2, "password123");
                stmt.setString(3, "student");
                stmt.setString(4, "Jane Smith");
                stmt.setString(5, "jane.smith@university.edu");
                stmt.setString(6, "555-0102");
                stmt.executeUpdate();

                stmt.setString(1, "mike_wilson");
                stmt.setString(2, "password123");
                stmt.setString(3, "student");
                stmt.setString(4, "Mike Wilson");
                stmt.setString(5, "mike.wilson@university.edu");
                stmt.setString(6, "555-0103");
                stmt.executeUpdate();

                // Professors
                stmt.setString(1, "prof_johnson");
                stmt.setString(2, "password123");
                stmt.setString(3, "professor");
                stmt.setString(4, "Dr. Robert Johnson");
                stmt.setString(5, "r.johnson@university.edu");
                stmt.setString(6, "555-0201");
                stmt.executeUpdate();

                stmt.setString(1, "prof_davis");
                stmt.setString(2, "password123");
                stmt.setString(3, "professor");
                stmt.setString(4, "Dr. Sarah Davis");
                stmt.setString(5, "s.davis@university.edu");
                stmt.setString(6, "555-0202");
                stmt.executeUpdate();

                // Secretary for testing
                stmt.setString(1, "mary_jane");
                stmt.setString(2, "password123");
                stmt.setString(3, "secretary");
                stmt.setString(4, "Mary Jane Watson");
                stmt.setString(5, "mary.jane@university.edu");
                stmt.setString(6, "555-0301");
                stmt.executeUpdate();
            }

            // Get user IDs for projects and appointments
            int johnId = getUserId(conn, "john_doe");
            int janeId = getUserId(conn, "jane_smith");
            int mikeId = getUserId(conn, "mike_wilson");
            int profJohnsonId = getUserId(conn, "prof_johnson");
            int profDavisId = getUserId(conn, "prof_davis");

            // Insert sample projects
            String insertProject = "INSERT INTO projects (topic, start_date, language, technologies, progress, student_id, supervisor_id) VALUES (?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement stmt = conn.prepareStatement(insertProject)) {
                stmt.setString(1, "E-Commerce Web Application");
                stmt.setDate(2, Date.valueOf("2024-01-15"));
                stmt.setString(3, "Java");
                stmt.setString(4, "Spring Boot, MySQL, React");
                stmt.setString(5, "In Progress");
                stmt.setInt(6, johnId);
                stmt.setInt(7, profJohnsonId);
                stmt.executeUpdate();

                stmt.setString(1, "Mobile Fitness Tracker");
                stmt.setDate(2, Date.valueOf("2024-02-01"));
                stmt.setString(3, "Kotlin");
                stmt.setString(4, "Android, SQLite, Firebase");
                stmt.setString(5, "Not Started");
                stmt.setInt(6, janeId);
                stmt.setInt(7, profDavisId);
                stmt.executeUpdate();

                stmt.setString(1, "Data Analytics Dashboard");
                stmt.setDate(2, Date.valueOf("2023-12-01"));
                stmt.setString(3, "Python");
                stmt.setString(4, "Django, PostgreSQL, D3.js");
                stmt.setString(5, "Completed");
                stmt.setInt(6, mikeId);
                stmt.setInt(7, profJohnsonId);
                stmt.executeUpdate();
            }

            // Insert sample appointments
            String insertAppointment = "INSERT INTO appointments (student_username, advisor_id, appointment_type, appointment_date, appointment_time, reason, additional_notes, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement stmt = conn.prepareStatement(insertAppointment)) {
                stmt.setString(1, "john_doe");
                stmt.setString(2, String.valueOf(profJohnsonId));
                stmt.setString(3, "Project Consultation");
                stmt.setDate(4, Date.valueOf("2024-03-15"));
                stmt.setTime(5, Time.valueOf("10:00:00"));
                stmt.setString(6, "Discuss project requirements and timeline");
                stmt.setString(7, "Bring project proposal document");
                stmt.setString(8, "confirmed");
                stmt.executeUpdate();

                stmt.setString(1, "jane_smith");
                stmt.setString(2, String.valueOf(profDavisId));
                stmt.setString(3, "Academic Advising");
                stmt.setDate(4, Date.valueOf("2024-03-18"));
                stmt.setTime(5, Time.valueOf("14:30:00"));
                stmt.setString(6, "Course selection for next semester");
                stmt.setString(7, "Review transcript beforehand");
                stmt.setString(8, "pending");
                stmt.executeUpdate();

                stmt.setString(1, "mike_wilson");
                stmt.setString(2, String.valueOf(profJohnsonId));
                stmt.setString(3, "Thesis Defense");
                stmt.setDate(4, Date.valueOf("2024-03-20"));
                stmt.setTime(5, Time.valueOf("09:00:00"));
                stmt.setString(6, "Final thesis presentation");
                stmt.setString(7, "Prepare slides and demonstration");
                stmt.setString(8, "confirmed");
                stmt.executeUpdate();

                stmt.setString(1, "john_doe");
                stmt.setString(2, String.valueOf(profDavisId));
                stmt.setString(3, "Career Guidance");
                stmt.setDate(4, Date.valueOf("2024-03-25"));
                stmt.setTime(5, Time.valueOf("11:00:00"));
                stmt.setString(6, "Discuss internship opportunities");
                stmt.setString(7, "Bring resume for review");
                stmt.setString(8, "pending");
                stmt.executeUpdate();
            }
        }
    }

    private int getUserId(Connection conn, String username) throws SQLException {
        String sql = "SELECT id FROM users WHERE username = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        }
        return -1; // User not found
    }
}
package com.mycompany.softeng.servlet;

import com.mycompany.softeng.util.DatabaseUtil;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Statement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/setup-test-data")
public class SetupTestDataServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try (Connection conn = DatabaseUtil.getConnection()) {
            Statement stmt = conn.createStatement();

            // Clear existing data
            stmt.executeUpdate("DELETE FROM appointments");
            stmt.executeUpdate("DELETE FROM assignments");
            stmt.executeUpdate("DELETE FROM users");

            // Insert test users
            stmt.executeUpdate(
                    "INSERT INTO users (username, password, full_name, email, phone, role, title, major, year_level) VALUES "
                            +
                            "('student1', SHA2('password123', 256), 'John Doe', 'john.doe@university.edu', '+30 123 456 7890', 'student', 'Undergraduate Student', 'Computer Science', '4th Year'), "
                            +
                            "('professor1', SHA2('prof123', 256), 'Dr. Jane Smith', 'jane.smith@university.edu', '+30 123 456 7891', 'professor', 'Professor', 'Computer Science', NULL), "
                            +
                            "('test', SHA2('test', 256), 'Test User', 'test@university.edu', '+30 123 456 7892', 'student', 'Test Student', 'Computer Science', '1st Year')");

            // Insert test assignments
            stmt.executeUpdate(
                    "INSERT INTO assignments (topic, start_date, language, technologies, progress, student_id) VALUES "
                            +
                            "('AI-Powered Student Management System', '2024-01-15', 'Java', 'Spring Boot, MySQL, Bootstrap', 'In Progress', 1), "
                            +
                            "('Machine Learning Classifier', '2024-02-01', 'Python', 'Scikit-learn, Pandas, NumPy', 'Not Started', 1)");

            // Insert test appointments
            stmt.executeUpdate(
                    "INSERT INTO appointments (student_username, advisor_id, appointment_type, appointment_date, appointment_time, reason, status) VALUES "
                            +
                            "('student1', '2', 'Thesis Meeting', '2024-12-20', '10:00:00', 'Discuss thesis progress and next steps', 'confirmed'), "
                            +
                            "('student1', '2', 'Thesis Meeting', '2024-12-25', '14:00:00', 'Review implementation details', 'pending')");

            out.println("<html><body>");
            out.println("<h2>Test Data Setup Complete!</h2>");
            out.println("<p>Test users created:</p>");
            out.println("<ul>");
            out.println("<li>Username: <strong>student1</strong>, Password: <strong>password123</strong></li>");
            out.println("<li>Username: <strong>test</strong>, Password: <strong>test</strong></li>");
            out.println("</ul>");
            out.println("<p><a href='login.jsp'>Go to Login</a></p>");
            out.println("</body></html>");

        } catch (Exception e) {
            out.println("<html><body>");
            out.println("<h2>Error setting up test data:</h2>");
            out.println("<p>" + e.getMessage() + "</p>");
            out.println("</body></html>");
            e.printStackTrace();
        }
    }
}
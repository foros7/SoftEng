package com.mycompany.softeng.servlet;

import com.mycompany.softeng.util.DatabaseUtil;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DiagnosticServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<html><head><title>Database Diagnostic</title></head><body>");
        out.println("<h1>Database Diagnostic Report</h1>");

        try (Connection conn = DatabaseUtil.getConnection();
                Statement stmt = conn.createStatement()) {

            // Show all users
            out.println("<h2>All Users:</h2>");
            out.println("<table border='1'>");
            out.println("<tr><th>ID</th><th>Username</th><th>Name</th><th>User Type</th></tr>");

            ResultSet rs = stmt
                    .executeQuery("SELECT id, username, name, user_type FROM users ORDER BY user_type, username");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("id") + "</td>");
                out.println("<td>" + rs.getString("username") + "</td>");
                out.println("<td>" + rs.getString("name") + "</td>");
                out.println("<td>" + rs.getString("user_type") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");

            // Show all appointments
            out.println("<h2>All Appointments:</h2>");
            out.println("<table border='1'>");
            out.println(
                    "<tr><th>ID</th><th>Student Username</th><th>Advisor ID</th><th>Date</th><th>Time</th><th>Status</th></tr>");

            rs = stmt.executeQuery(
                    "SELECT id, student_username, advisor_id, appointment_date, appointment_time, status FROM appointments ORDER BY appointment_date DESC");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("id") + "</td>");
                out.println("<td>" + rs.getString("student_username") + "</td>");
                out.println("<td>" + rs.getString("advisor_id") + "</td>");
                out.println("<td>" + rs.getDate("appointment_date") + "</td>");
                out.println("<td>" + rs.getTime("appointment_time") + "</td>");
                out.println("<td>" + rs.getString("status") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");

            // Show appointments for alice_johnson specifically
            out.println("<h2>Appointments for alice_johnson:</h2>");
            rs = stmt.executeQuery(
                    "SELECT COUNT(*) as count FROM appointments WHERE student_username = 'alice_johnson'");
            if (rs.next()) {
                out.println("<p>Count: " + rs.getInt("count") + "</p>");
            }

            // Show distinct student usernames in appointments
            out.println("<h2>Distinct Student Usernames in Appointments:</h2>");
            out.println("<ul>");
            rs = stmt.executeQuery("SELECT DISTINCT student_username FROM appointments");
            while (rs.next()) {
                out.println("<li>" + rs.getString("student_username") + "</li>");
            }
            out.println("</ul>");

        } catch (Exception e) {
            out.println("<h2 style='color: red;'>Error:</h2>");
            out.println("<p>" + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }

        out.println("</body></html>");
    }
}
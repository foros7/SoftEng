package com.mycompany.softeng.servlet;

import com.mycompany.softeng.util.DatabaseUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

@WebServlet("/diagnostic")
public class DiagnosticServlet extends HttpServlet {

    private void checkDatabaseConnection(PrintWriter out) {
        out.println("<h3>Database Connection Test:</h3>");
        boolean dbConnected = DatabaseUtil.testConnection();
        if (dbConnected) {
            out.println("<p style='color: green;'>✅ Database connection: SUCCESS</p>");
        } else {
            out.println("<p style='color: red;'>❌ Database connection: FAILED</p>");
            out.println("<p>Check if MySQL is running and credentials are correct in DatabaseUtil.java</p>");
        }
    }

    private void checkUsersTable(PrintWriter out) {
        out.println("<h3>Users Table Test:</h3>");
        try (Connection conn = DatabaseUtil.getConnection()) {
            Statement stmt = conn.createStatement();

            // Check if users table exists
            ResultSet rs = stmt.executeQuery("SHOW TABLES LIKE 'users'");
            if (rs.next()) {
                out.println("<p style='color: green;'>✅ Users table: EXISTS</p>");

                // Show table structure
                out.println("<h4>Table Structure:</h4>");
                rs = stmt.executeQuery("DESCRIBE users");
                out.println(
                        "<table border='1'><tr><th>Field</th><th>Type</th><th>Null</th><th>Key</th><th>Default</th><th>Extra</th></tr>");
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("Field") + "</td>");
                    out.println("<td>" + rs.getString("Type") + "</td>");
                    out.println("<td>" + rs.getString("Null") + "</td>");
                    out.println("<td>" + rs.getString("Key") + "</td>");
                    out.println("<td>" + rs.getString("Default") + "</td>");
                    out.println("<td>" + rs.getString("Extra") + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");

                // Count users
                rs = stmt.executeQuery("SELECT COUNT(*) as count FROM users");
                if (rs.next()) {
                    int userCount = rs.getInt("count");
                    out.println("<p>👥 Total users in database: " + userCount + "</p>");

                    if (userCount > 0) {
                        // Show sample users
                        rs = stmt.executeQuery("SELECT * FROM users LIMIT 5");
                        ResultSetMetaData metaData = rs.getMetaData();
                        int columnCount = metaData.getColumnCount();

                        out.println("<p>Sample users:</p><table border='1'><tr>");
                        for (int i = 1; i <= columnCount; i++) {
                            out.println("<th>" + metaData.getColumnName(i) + "</th>");
                        }
                        out.println("</tr>");

                        while (rs.next()) {
                            out.println("<tr>");
                            for (int i = 1; i <= columnCount; i++) {
                                out.println("<td>" + rs.getString(i) + "</td>");
                            }
                            out.println("</tr>");
                        }
                        out.println("</table>");
                    } else {
                        out.println(
                                "<p style='color: orange;'>⚠️ No users found in database. <a href='setup-test-data'>Click here to setup test data</a></p>");
                    }
                }
            } else {
                out.println("<p style='color: red;'>❌ Users table: NOT FOUND</p>");
            }

        } catch (Exception e) {
            out.println("<p style='color: red;'>❌ Database query error: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
    }

    private void checkPasswordHashing(HttpServletResponse response) throws IOException {
        PrintWriter out = response.getWriter();
        out.println("<h2>Password Hashing Test</h2>");

        String testPassword = "password123";
        String sql = "SELECT SHA2(?, 256) as hash";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, testPassword);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String hash = rs.getString("hash");
                    out.println("<p>Test password: " + testPassword + "</p>");
                    out.println("<p>Generated hash: " + hash + "</p>");

                    // Check if this hash exists in the database
                    String checkSql = "SELECT username FROM users WHERE password = ?";
                    try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                        checkStmt.setString(1, hash);
                        try (ResultSet checkRs = checkStmt.executeQuery()) {
                            out.println("<p>Users with this password hash:</p>");
                            out.println("<ul>");
                            while (checkRs.next()) {
                                out.println("<li>" + checkRs.getString("username") + "</li>");
                            }
                            out.println("</ul>");
                        }
                    }
                }
            }
        } catch (SQLException e) {
            out.println("<p style='color: red;'>Error checking password hash: " + e.getMessage() + "</p>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Database Diagnostic</title>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Database Diagnostic Results</h1>");

        // Check database connection
        checkDatabaseConnection(out);

        // Check users table
        checkUsersTable(out);

        // Test login functionality
        testLogin(out);

        out.println("</body>");
        out.println("</html>");
    }

    private void testLogin(PrintWriter out) {
        out.println("<h3>Login Test:</h3>");
        out.println("<p>Testing login with test/test credentials:</p>");

        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, "test");
                stmt.setString(2, "test");

                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        out.println("<p style='color: green;'>✅ Found user 'test' with password 'test'</p>");
                        out.println("<p>User details:</p>");
                        out.println("<ul>");
                        out.println("<li>ID: " + rs.getInt("id") + "</li>");
                        out.println("<li>Username: " + rs.getString("username") + "</li>");
                        out.println("<li>Name: " + rs.getString("name") + "</li>");
                        out.println("<li>User Type: " + rs.getString("user_type") + "</li>");
                        out.println("</ul>");
                    } else {
                        out.println(
                                "<p style='color: red;'>❌ No user found with username 'test' and password 'test'</p>");
                    }
                }
            }
        } catch (SQLException e) {
            out.println("<p style='color: red;'>❌ Database error: " + e.getMessage() + "</p>");
        }
    }
}
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
import java.sql.Statement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DatabaseMigrationServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(DatabaseMigrationServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Database Migration</title></head><body>");
        out.println("<h1>Database Migration for File Upload</h1>");

        try {
            // Add file upload columns to assignments table
            addFileUploadColumns();

            out.println("<div style='color: green;'>");
            out.println("<h2>✅ Migration Successful!</h2>");
            out.println("<p>File upload columns have been added to the assignments table:</p>");
            out.println("<ul>");
            out.println("<li>file_name (VARCHAR(255))</li>");
            out.println("<li>file_path (VARCHAR(500))</li>");
            out.println("<li>file_size (BIGINT)</li>");
            out.println("<li>file_uploaded_at (TIMESTAMP)</li>");
            out.println("</ul>");
            out.println("<p>Indexes have been created for better performance.</p>");
            out.println("</div>");

            out.println("<p><a href='/SoftEng/student-dashboard'>Go back to Student Dashboard</a></p>");

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Migration failed", e);

            out.println("<div style='color: red;'>");
            out.println("<h2>❌ Migration Failed</h2>");
            out.println("<p>Error: " + e.getMessage() + "</p>");

            if (e.getMessage().contains("Duplicate column name")) {
                out.println("<div style='color: orange;'>");
                out.println("<h3>⚠️ Columns may already exist</h3>");
                out.println("<p>The file upload columns might already be in the database.</p>");
                out.println("<p><a href='/SoftEng/student-dashboard'>Try going back to Student Dashboard</a></p>");
                out.println("</div>");
            }
            out.println("</div>");
        }

        out.println("</body></html>");
    }

    private void addFileUploadColumns() throws SQLException {
        try (Connection conn = DatabaseUtil.getConnection();
                Statement stmt = conn.createStatement()) {

            // Add the columns
            stmt.executeUpdate("ALTER TABLE assignments ADD COLUMN file_name VARCHAR(255) NULL");
            stmt.executeUpdate("ALTER TABLE assignments ADD COLUMN file_path VARCHAR(500) NULL");
            stmt.executeUpdate("ALTER TABLE assignments ADD COLUMN file_size BIGINT DEFAULT 0");
            stmt.executeUpdate("ALTER TABLE assignments ADD COLUMN file_uploaded_at TIMESTAMP NULL");

            // Add indexes
            stmt.executeUpdate("CREATE INDEX idx_assignments_file_name ON assignments(file_name)");
            stmt.executeUpdate("CREATE INDEX idx_assignments_file_uploaded_at ON assignments(file_uploaded_at)");

            LOGGER.info("File upload columns and indexes added successfully");
        }
    }
}
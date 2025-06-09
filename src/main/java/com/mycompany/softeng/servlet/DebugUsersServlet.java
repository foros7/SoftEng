package com.mycompany.softeng.servlet;

import com.mycompany.softeng.util.DatabaseUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

public class DebugUsersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            out.println("<html><head><title>Debug - All Users</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; margin: 40px; }");
            out.println("table { border-collapse: collapse; width: 100%; }");
            out.println("th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }");
            out.println("th { background-color: #f2f2f2; }");
            out.println("tr:nth-child(even) { background-color: #f9f9f9; }");
            out.println(".password { font-family: monospace; background: #ffffcc; }");
            out.println("</style></head><body>");
            out.println("<h2>🔍 Debug: All Users in Database</h2>");
            out.println("<p><a href='secretary-dashboard'>← Back to Secretary Dashboard</a></p>");

            try (Connection conn = DatabaseUtil.getConnection()) {
                String sql = "SELECT id, username, password, user_type, name, email, phone, created_at FROM users ORDER BY id";

                try (PreparedStatement stmt = conn.prepareStatement(sql);
                        ResultSet rs = stmt.executeQuery()) {

                    out.println("<table>");
                    out.println("<thead>");
                    out.println(
                            "<tr><th>ID</th><th>Username</th><th>Password</th><th>User Type</th><th>Name</th><th>Email</th><th>Phone</th><th>Created</th></tr>");
                    out.println("</thead><tbody>");

                    boolean hasUsers = false;
                    while (rs.next()) {
                        hasUsers = true;
                        out.println("<tr>");
                        out.println("<td>" + rs.getInt("id") + "</td>");
                        out.println("<td><strong>" + rs.getString("username") + "</strong></td>");
                        out.println("<td class='password'>" + rs.getString("password") + "</td>");
                        out.println("<td>" + rs.getString("user_type") + "</td>");
                        out.println("<td>" + (rs.getString("name") != null ? rs.getString("name") : "NULL") + "</td>");
                        out.println(
                                "<td>" + (rs.getString("email") != null ? rs.getString("email") : "NULL") + "</td>");
                        out.println(
                                "<td>" + (rs.getString("phone") != null ? rs.getString("phone") : "NULL") + "</td>");
                        out.println("<td>" + rs.getTimestamp("created_at") + "</td>");
                        out.println("</tr>");
                    }

                    if (!hasUsers) {
                        out.println(
                                "<tr><td colspan='8' style='text-align: center; color: #666;'>No users found in database</td></tr>");
                    }

                    out.println("</tbody></table>");
                }

                // Show total count
                String countSql = "SELECT COUNT(*) as total FROM users";
                try (PreparedStatement stmt = conn.prepareStatement(countSql);
                        ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        out.println("<p><strong>Total Users:</strong> " + rs.getInt("total") + "</p>");
                    }
                }

            } catch (SQLException e) {
                out.println("<div style='color: red; background: #ffeeee; padding: 20px; border-radius: 5px;'>");
                out.println("<h3>❌ Database Error</h3>");
                out.println("<p>Error: " + e.getMessage() + "</p>");
                out.println("</div>");
                e.printStackTrace();
            }

            out.println("<hr>");
            out.println("<h3>🎯 Quick Actions</h3>");
            out.println(
                    "<p><a href='sample-data' style='background: #007bff; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;'>Generate Sample Data</a></p>");
            out.println(
                    "<p><a href='UserManagementServlet?action=manageUsers' style='background: #28a745; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;'>User Management</a></p>");

            out.println("</body></html>");
        }
    }
}
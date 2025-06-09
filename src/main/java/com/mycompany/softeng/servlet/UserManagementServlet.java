package com.mycompany.softeng.servlet;

import com.mycompany.softeng.util.DatabaseUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserManagementServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(UserManagementServlet.class.getName());

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

        String action = request.getParameter("action");

        try {
            switch (action != null ? action : "list") {
                case "list":
                    handleListUsers(request, response);
                    break;
                case "get":
                    handleGetUser(request, response);
                    break;
                case "manageUsers":
                    request.getRequestDispatcher("user-management.jsp").forward(request, response);
                    break;
                default:
                    handleListUsers(request, response);
                    break;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in UserManagementServlet", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String userRole = (String) session.getAttribute("role");

        // Check if user is logged in and is a secretary
        if (username == null || !"secretary".equals(userRole)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    handleCreateUser(request, response);
                    break;
                case "update":
                    handleUpdateUser(request, response);
                    break;
                case "delete":
                    handleDeleteUser(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                    break;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in UserManagementServlet", e);
            sendJsonError(response, "Database error: " + e.getMessage());
        }
    }

    private void handleListUsers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String sql = "SELECT id, username, user_type, name, email, phone, created_at FROM users ORDER BY id";

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery();
                PrintWriter out = response.getWriter()) {

            out.print("[");
            boolean first = true;
            while (rs.next()) {
                if (!first)
                    out.print(",");
                out.print("{");
                out.print("\"id\":" + rs.getInt("id") + ",");
                out.print("\"username\":\"" + escapeJson(rs.getString("username")) + "\",");
                out.print("\"userType\":\"" + escapeJson(rs.getString("user_type")) + "\",");
                out.print("\"name\":\"" + escapeJson(rs.getString("name")) + "\",");
                out.print("\"email\":\"" + escapeJson(rs.getString("email")) + "\",");
                out.print("\"phone\":\"" + escapeJson(rs.getString("phone")) + "\",");
                out.print("\"createdAt\":\"" + rs.getTimestamp("created_at") + "\"");
                out.print("}");
                first = false;
            }
            out.print("]");
        }
    }

    private void handleGetUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int userId = Integer.parseInt(request.getParameter("id"));
        String sql = "SELECT id, username, user_type, name, email, phone, created_at FROM users WHERE id = ?";

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                PrintWriter out = response.getWriter()) {

            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    out.print("{");
                    out.print("\"id\":" + rs.getInt("id") + ",");
                    out.print("\"username\":\"" + escapeJson(rs.getString("username")) + "\",");
                    out.print("\"userType\":\"" + escapeJson(rs.getString("user_type")) + "\",");
                    out.print("\"name\":\"" + escapeJson(rs.getString("name")) + "\",");
                    out.print("\"email\":\"" + escapeJson(rs.getString("email")) + "\",");
                    out.print("\"phone\":\"" + escapeJson(rs.getString("phone")) + "\",");
                    out.print("\"createdAt\":\"" + rs.getTimestamp("created_at") + "\"");
                    out.print("}");
                } else {
                    out.print("null");
                }
            }
        }
    }

    private void handleCreateUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String userType = request.getParameter("userType");

        String sql = "INSERT INTO users (username, password, user_type, name, email, phone) VALUES (?, ?, ?, ?, ?, ?)";

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                PrintWriter out = response.getWriter()) {

            stmt.setString(1, username);
            stmt.setString(2, password); // In production, hash this password
            stmt.setString(3, userType);
            stmt.setString(4, name);
            stmt.setString(5, email);
            stmt.setString(6, phone);

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int newId = generatedKeys.getInt(1);
                        out.print("{");
                        out.print("\"success\":true,");
                        out.print("\"id\":" + newId + ",");
                        out.print("\"username\":\"" + escapeJson(username) + "\",");
                        out.print("\"userType\":\"" + escapeJson(userType) + "\",");
                        out.print("\"name\":\"" + escapeJson(name) + "\",");
                        out.print("\"email\":\"" + escapeJson(email) + "\",");
                        out.print("\"phone\":\"" + escapeJson(phone) + "\"");
                        out.print("}");
                    }
                }
            } else {
                sendJsonError(response, "Failed to create user");
            }
        }
    }

    private void handleUpdateUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int userId = Integer.parseInt(request.getParameter("id"));
        String username = request.getParameter("username");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String userType = request.getParameter("userType");

        String sql = "UPDATE users SET username = ?, user_type = ?, name = ?, email = ?, phone = ? WHERE id = ?";

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                PrintWriter out = response.getWriter()) {

            stmt.setString(1, username);
            stmt.setString(2, userType);
            stmt.setString(3, name);
            stmt.setString(4, email);
            stmt.setString(5, phone);
            stmt.setInt(6, userId);

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                out.print("{");
                out.print("\"success\":true,");
                out.print("\"id\":" + userId + ",");
                out.print("\"username\":\"" + escapeJson(username) + "\",");
                out.print("\"userType\":\"" + escapeJson(userType) + "\",");
                out.print("\"name\":\"" + escapeJson(name) + "\",");
                out.print("\"email\":\"" + escapeJson(email) + "\",");
                out.print("\"phone\":\"" + escapeJson(phone) + "\"");
                out.print("}");
            } else {
                sendJsonError(response, "Failed to update user");
            }
        }
    }

    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {

        int userId = Integer.parseInt(request.getParameter("id"));
        String sql = "DELETE FROM users WHERE id = ? AND user_type != 'secretary'"; // Don't delete secretaries

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                PrintWriter out = response.getWriter()) {

            stmt.setInt(1, userId);
            int rowsAffected = stmt.executeUpdate();

            out.print("{\"success\": " + (rowsAffected > 0) + "}");
        }
    }

    private void sendJsonError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.print("{\"success\":false,\"error\":\"" + escapeJson(message) + "\"}");
        }
    }

    private String escapeJson(String str) {
        if (str == null)
            return "";
        return str.replace("\"", "\\\"")
                .replace("\\", "\\\\")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
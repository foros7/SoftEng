<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.softeng.util.DatabaseUtil" %>
<!DOCTYPE html>
<html>
<head>
    <title>Debug Professors</title>
</head>
<body>
    <h1>Professor Users in Database</h1>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Password</th>
            <th>User Type</th>
            <th>Name</th>
            <th>Email</th>
        </tr>
        <%
        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "SELECT id, username, password, user_type, name, email FROM users WHERE user_type = 'professor' OR user_type = 'Professor'";
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("id") %></td>
                        <td><%= rs.getString("username") %></td>
                        <td><%= rs.getString("password") %></td>
                        <td><%= rs.getString("user_type") %></td>
                        <td><%= rs.getString("name") %></td>
                        <td><%= rs.getString("email") %></td>
                    </tr>
                    <%
                }
            }
        } catch (SQLException e) {
            %>
            <tr><td colspan="6">Error: <%= e.getMessage() %></td></tr>
            <%
        }
        %>
    </table>
    
    <h2>All Users</h2>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>Username</th>
            <th>User Type</th>
            <th>Name</th>
        </tr>
        <%
        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "SELECT id, username, user_type, name FROM users LIMIT 10";
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                
                while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("id") %></td>
                        <td><%= rs.getString("username") %></td>
                        <td><%= rs.getString("user_type") %></td>
                        <td><%= rs.getString("name") %></td>
                    </tr>
                    <%
                }
            }
        } catch (SQLException e) {
            %>
            <tr><td colspan="4">Error: <%= e.getMessage() %></td></tr>
            <%
        }
        %>
    </table>
</body>
</html> 
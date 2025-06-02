package com.mycompany.softeng.dao;

import com.mycompany.softeng.model.User;
import com.mycompany.softeng.util.DatabaseConfig;
import com.mycompany.softeng.util.DatabaseUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO implements BaseDAO<User> {

    @Override
    public User create(User user) throws Exception {
        String sql = "INSERT INTO " + DatabaseConfig.USERS_TABLE +
                " (username, password, user_type, name) VALUES (?, ?, ?, ?)";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getUserType());
            pstmt.setString(4, user.getName());

            pstmt.executeUpdate();

            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    user.setId(rs.getInt(1));
                }
            }

            return user;
        }
    }

    @Override
    public User getById(int id) throws Exception {
        String sql = "SELECT * FROM " + DatabaseConfig.USERS_TABLE + " WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        }
        return null;
    }

    @Override
    public List<User> getAll() throws Exception {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM " + DatabaseConfig.USERS_TABLE;

        try (Connection conn = DatabaseUtil.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                users.add(extractUserFromResultSet(rs));
            }
        }
        return users;
    }

    @Override
    public User update(User user) throws Exception {
        String sql = "UPDATE " + DatabaseConfig.USERS_TABLE +
                " SET username = ?, password = ?, user_type = ?, name = ? WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getUserType());
            pstmt.setString(4, user.getName());
            pstmt.setInt(5, user.getId());

            pstmt.executeUpdate();
            return user;
        }
    }

    @Override
    public boolean delete(int id) throws Exception {
        String sql = "DELETE FROM " + DatabaseConfig.USERS_TABLE + " WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    public User findByUsername(String username) throws Exception {
        String sql = "SELECT * FROM " + DatabaseConfig.USERS_TABLE + " WHERE username = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractUserFromResultSet(rs);
                }
            }
        }
        return null;
    }

    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setUserType(rs.getString("user_type"));
        user.setName(rs.getString("name"));
        return user;
    }
}
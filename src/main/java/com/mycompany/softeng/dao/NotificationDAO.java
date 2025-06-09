package com.mycompany.softeng.dao;

import com.mycompany.softeng.model.Notification;
import com.mycompany.softeng.util.DatabaseUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class NotificationDAO {
    private static final Logger LOGGER = Logger.getLogger(NotificationDAO.class.getName());

    public List<Notification> getUnreadNotifications(String username) throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE recipient_username = ? AND is_read = false ORDER BY created_at DESC";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Notification notification = extractNotificationFromResultSet(rs);
                    notifications.add(notification);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting unread notifications for user: " + username, e);
            throw e;
        }
        return notifications;
    }

    public List<Notification> getAllNotifications(String username) throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE recipient_username = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Notification notification = extractNotificationFromResultSet(rs);
                    notifications.add(notification);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting notifications for user: " + username, e);
            throw e;
        }
        return notifications;
    }

    public void markAsRead(int notificationId) throws SQLException {
        String sql = "UPDATE notifications SET is_read = true WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, notificationId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking notification as read: " + notificationId, e);
            throw e;
        }
    }

    public int getUnreadCount(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM notifications WHERE recipient_username = ? AND is_read = false";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting unread count for user: " + username, e);
            throw e;
        }
        return 0;
    }

    private Notification extractNotificationFromResultSet(ResultSet rs) throws SQLException {
        Notification notification = new Notification();
        notification.setId(rs.getInt("id"));
        notification.setRecipientUsername(rs.getString("recipient_username"));
        notification.setTitle(rs.getString("title"));
        notification.setMessage(rs.getString("message"));
        notification.setType(rs.getString("type"));
        notification.setRead(rs.getBoolean("is_read"));
        notification.setCreatedAt(rs.getTimestamp("created_at"));
        notification.setRelatedId(rs.getString("related_id"));
        return notification;
    }
}
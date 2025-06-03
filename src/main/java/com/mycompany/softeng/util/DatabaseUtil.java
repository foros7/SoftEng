package com.mycompany.softeng.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Logger;
import java.util.logging.Level;

public class DatabaseUtil {
    private static final Logger LOGGER = Logger.getLogger(DatabaseUtil.class.getName());

    // Database credentials
    private static final String URL = "jdbc:mysql://localhost:3306/university_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "root"; // Change this to your MySQL password

    static {
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            LOGGER.info("MySQL JDBC Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Error loading MySQL JDBC Driver", e);
            // Don't throw exception here - let the application start and handle connection
            // issues later
        }
    }

    /**
     * Get a connection to the database
     * 
     * @return Connection object
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            LOGGER.info("Database connection established successfully");
            return conn;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error connecting to database: " + e.getMessage(), e);
            throw e;
        }
    }

    /**
     * Test if database connection is available
     * 
     * @return true if connection is successful, false otherwise
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Database connection test failed: " + e.getMessage());
            return false;
        }
    }

    /**
     * Close a database connection
     * 
     * @param connection Connection to close
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                LOGGER.info("Database connection closed successfully");
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error closing database connection", e);
            }
        }
    }
}
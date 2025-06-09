package com.mycompany.softeng.servlet;

import com.mycompany.softeng.util.DatabaseUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class GetAdvisorsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(GetAdvisorsServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Advisor> advisors = getAdvisors();
            request.setAttribute("advisors", advisors);
            request.getRequestDispatcher("book-appointment.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching advisors", e);
            request.setAttribute("error", "Failed to load advisors: " + e.getMessage());
            request.getRequestDispatcher("book-appointment.jsp").forward(request, response);
        }
    }

    private List<Advisor> getAdvisors() throws SQLException {
        List<Advisor> advisors = new ArrayList<>();
        String sql = "SELECT id, username, name FROM users WHERE user_type = 'professor' ORDER BY name";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Advisor advisor = new Advisor();
                advisor.setId(rs.getString("id"));
                advisor.setUsername(rs.getString("username"));
                advisor.setName(rs.getString("name"));
                advisor.setTitle("Professor"); // Set default title
                advisors.add(advisor);
            }
        }
        return advisors;
    }

    public static class Advisor {
        private String id;
        private String username;
        private String name;
        private String title;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getUsername() {
            return username;
        }

        public void setUsername(String username) {
            this.username = username;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }
    }
}
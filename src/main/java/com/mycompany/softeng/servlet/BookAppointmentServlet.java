package com.mycompany.softeng.servlet;

import com.mycompany.softeng.dao.AppointmentDAO;
import com.mycompany.softeng.dao.UserDAO;
import com.mycompany.softeng.model.Appointment;
import com.mycompany.softeng.model.User;
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
import jakarta.servlet.http.HttpSession;

public class BookAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(BookAppointmentServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            // Load available advisors (professors)
            List<User> advisors = getAvailableAdvisors();
            request.setAttribute("advisors", advisors);

            LOGGER.info("Loaded " + advisors.size() + " advisors for appointment booking");

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error loading advisors", e);
            request.setAttribute("error", "Failed to load advisors: " + e.getMessage());
        }

        request.getRequestDispatcher("book-appointment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get form data
        String advisorId = request.getParameter("advisor");
        String appointmentType = request.getParameter("appointmentType");
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        String reason = request.getParameter("reason");
        String additionalNotes = request.getParameter("additionalNotes");

        // Validate input
        if (advisorId == null || advisorId.trim().isEmpty() ||
                appointmentType == null || appointmentType.trim().isEmpty() ||
                date == null || date.trim().isEmpty() ||
                time == null || time.trim().isEmpty() ||
                reason == null || reason.trim().isEmpty()) {

            request.setAttribute("error", "Please fill in all required fields");

            // Reload advisors for the form
            try {
                List<User> advisors = getAvailableAdvisors();
                request.setAttribute("advisors", advisors);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error reloading advisors", e);
            }

            request.getRequestDispatcher("book-appointment.jsp").forward(request, response);
            return;
        }

        try {
            // Get advisor information
            User advisor = getAdvisorById(Integer.parseInt(advisorId));
            if (advisor == null) {
                request.setAttribute("error", "Selected advisor not found");
                request.getRequestDispatcher("book-appointment.jsp").forward(request, response);
                return;
            }

            Appointment appointment = new Appointment();
            appointment.setStudentUsername(username);
            appointment.setAdvisorId(advisorId);
            appointment.setAdvisorName(advisor.getFullName());
            appointment.setAdvisorTitle(advisor.getTitle() != null ? advisor.getTitle() : "Professor");
            appointment.setAppointmentType(appointmentType);
            appointment.setDate(date);
            appointment.setTime(time);
            appointment.setReason(reason);
            appointment.setAdditionalNotes(additionalNotes != null ? additionalNotes : "");
            appointment.setStatus("pending");

            AppointmentDAO appointmentDAO = new AppointmentDAO();
            appointmentDAO.create(appointment);

            LOGGER.info("Appointment created successfully for student: " + username + " with advisor: "
                    + advisor.getFullName());

            // Redirect with success message
            response.sendRedirect("my-appointments.jsp?success=1");

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating appointment", e);
            request.setAttribute("error", "Failed to book appointment: " + e.getMessage());

            // Reload advisors for the form
            try {
                List<User> advisors = getAvailableAdvisors();
                request.setAttribute("advisors", advisors);
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error reloading advisors", ex);
            }

            request.getRequestDispatcher("book-appointment.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid advisor ID: " + advisorId, e);
            request.setAttribute("error", "Invalid advisor selected");
            request.getRequestDispatcher("book-appointment.jsp").forward(request, response);
        }
    }

    private List<User> getAvailableAdvisors() throws SQLException {
        List<User> advisors = new ArrayList<>();
        String sql = "SELECT id, username, name FROM users WHERE user_type = 'professor' ORDER BY name";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                User advisor = new User();
                advisor.setId(rs.getInt("id"));
                advisor.setUsername(rs.getString("username"));
                advisor.setFullName(rs.getString("name"));
                advisor.setTitle("Professor");
                advisors.add(advisor);
            }
        }
        return advisors;
    }

    private User getAdvisorById(int advisorId) throws SQLException {
        String sql = "SELECT id, username, name, email, phone FROM users WHERE id = ? AND user_type = 'professor'";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, advisorId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User advisor = new User();
                    advisor.setId(rs.getInt("id"));
                    advisor.setUsername(rs.getString("username"));
                    advisor.setFullName(rs.getString("name"));
                    advisor.setTitle("Professor");
                    advisor.setEmail(rs.getString("email"));
                    advisor.setPhone(rs.getString("phone"));
                    return advisor;
                }
            }
        }
        return null;
    }
}
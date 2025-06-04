package com.mycompany.softeng.servlet;

import com.mycompany.softeng.dao.AssignmentDAO;
import com.mycompany.softeng.dao.AppointmentDAO;
import com.mycompany.softeng.model.Assignment;
import com.mycompany.softeng.model.Appointment;
import com.mycompany.softeng.util.DatabaseUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet({ "/StudentServlet", "/student-dashboard" })
public class StudentServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(StudentServlet.class.getName());

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
            // Get student data
            int studentId = getStudentIdFromUsername(username);

            if (studentId != -1) {
                // Load student assignments
                List<Assignment> assignments = getStudentAssignments(studentId);

                // Add supervisor names to assignments
                for (Assignment assignment : assignments) {
                    if (assignment.getSupervisorId() > 0) {
                        String supervisorName = getProfessorNameById(assignment.getSupervisorId());
                        assignment.setStudentName(supervisorName); // Reusing field for supervisor name
                    }
                }

                // Load professors list
                List<Professor> professors = getAllProfessors();

                // Load appointments
                List<Appointment> appointments = getStudentAppointments(username);

                // Calculate statistics
                int totalAssignments = assignments.size();
                int completedAssignments = (int) assignments.stream()
                        .filter(a -> "Completed".equals(a.getProgress())).count();
                int upcomingAppointments = appointments.size();

                // Set attributes
                request.setAttribute("assignments", assignments);
                request.setAttribute("professors", professors);
                request.setAttribute("appointments", appointments);
                request.setAttribute("totalAssignments", totalAssignments);
                request.setAttribute("completedAssignments", completedAssignments);
                request.setAttribute("upcomingAppointments", upcomingAppointments);

                LOGGER.info("Student dashboard loaded for: " + username + " with " + totalAssignments + " assignments");
            } else {
                // Set empty lists if student not found
                request.setAttribute("assignments", new ArrayList<>());
                request.setAttribute("professors", new ArrayList<>());
                request.setAttribute("appointments", new ArrayList<>());
                request.setAttribute("totalAssignments", 0);
                request.setAttribute("completedAssignments", 0);
                request.setAttribute("upcomingAppointments", 0);
            }

        } catch (SQLException e) {
            LOGGER.severe("Database error: " + e.getMessage());
            request.setAttribute("assignments", new ArrayList<>());
            request.setAttribute("professors", new ArrayList<>());
            request.setAttribute("appointments", new ArrayList<>());
        }

        request.getRequestDispatcher("student-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String action = request.getParameter("action");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            if ("uploadAssignment".equals(action)) {
                handleUploadAssignment(request, username);
            } else if ("makeAppointment".equals(action)) {
                handleMakeAppointment(request, username);
            }

            // Redirect back to dashboard
            response.sendRedirect("student-dashboard");

        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Database error during action: " + action + " - " + e.getMessage());
            response.sendRedirect("student-dashboard?error=Database error");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error during action: " + action, e);
            response.sendRedirect("student-dashboard?error=Unexpected error");
        }
    }

    private void handleUploadAssignment(HttpServletRequest request, String username) throws SQLException {
        String topic = request.getParameter("topic");
        String language = request.getParameter("language");
        String technologies = request.getParameter("technologies");
        String progress = request.getParameter("progress");
        String supervisorIdStr = request.getParameter("supervisorId");
        int supervisorId = (supervisorIdStr != null && !supervisorIdStr.isEmpty()) ? Integer.parseInt(supervisorIdStr)
                : 0;

        // Get student ID
        int studentId = getStudentIdFromUsername(username);

        if (studentId != -1) {
            Assignment assignment = new Assignment(topic, new Date(), language, technologies, progress, studentId);
            assignment.setSupervisorId(supervisorId);

            AssignmentDAO assignmentDAO = new AssignmentDAO();
            assignmentDAO.create(assignment);

            LOGGER.info("Assignment created for student: " + username);
        } else {
            LOGGER.warning("Could not create assignment - student ID not found for: " + username);
        }
    }

    private void handleMakeAppointment(HttpServletRequest request, String username) throws SQLException {
        String meetingDate = request.getParameter("meetingDate");
        String meetingTime = request.getParameter("meetingTime");
        String meetingDuration = request.getParameter("meetingDuration");
        String meetingPurpose = request.getParameter("meetingPurpose");

        // Get a default professor (first professor in system)
        String advisorId = getDefaultProfessorUsername();

        Appointment appointment = new Appointment();
        appointment.setStudentUsername(username);
        appointment.setAdvisorId(advisorId);
        appointment.setAppointmentType("Academic Meeting");
        appointment.setDate(meetingDate);
        appointment.setTime(meetingTime);
        appointment.setReason(meetingPurpose);
        appointment.setAdditionalNotes("Duration: " + meetingDuration + " minutes");
        appointment.setStatus("pending");

        AppointmentDAO appointmentDAO = new AppointmentDAO();
        appointmentDAO.create(appointment);

        LOGGER.info("Appointment created for student: " + username);
    }

    private int getStudentIdFromUsername(String username) throws SQLException {
        String sql = "SELECT id FROM users WHERE username = ? AND user_type = 'student'";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        }
        return -1;
    }

    private List<Assignment> getStudentAssignments(int studentId) throws SQLException {
        List<Assignment> assignments = new ArrayList<>();
        String sql = "SELECT * FROM assignments WHERE student_id = ? ORDER BY start_date DESC";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Assignment assignment = new Assignment();
                    assignment.setId(rs.getInt("id"));
                    assignment.setTopic(rs.getString("topic"));
                    assignment.setStartDate(rs.getDate("start_date"));
                    assignment.setLanguage(rs.getString("language"));
                    assignment.setTechnologies(rs.getString("technologies"));
                    assignment.setProgress(rs.getString("progress"));
                    assignment.setStudentId(rs.getInt("student_id"));
                    assignment.setSupervisorId(rs.getInt("supervisor_id"));
                    assignment.setCreatedAt(rs.getTimestamp("created_at"));
                    assignments.add(assignment);
                }
            }
        }
        return assignments;
    }

    private List<Professor> getAllProfessors() throws SQLException {
        List<Professor> professors = new ArrayList<>();
        String sql = "SELECT id, username, name FROM users WHERE user_type = 'professor' ORDER BY name";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Professor prof = new Professor();
                    prof.setId(rs.getInt("id"));
                    prof.setUsername(rs.getString("username"));
                    prof.setName(rs.getString("name"));
                    professors.add(prof);
                }
            }
        }
        return professors;
    }

    private List<Appointment> getStudentAppointments(String username) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT * FROM appointments WHERE student_username = ? AND status != 'cancelled' ORDER BY appointment_date DESC LIMIT 5";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setId(rs.getInt("id"));
                    appointment.setStudentUsername(rs.getString("student_username"));
                    appointment.setAdvisorId(rs.getString("advisor_id"));
                    appointment.setAppointmentType(rs.getString("appointment_type"));
                    appointment.setDate(rs.getString("appointment_date"));
                    appointment.setTime(rs.getString("appointment_time"));
                    appointment.setReason(rs.getString("reason"));
                    appointment.setStatus(rs.getString("status"));
                    appointments.add(appointment);
                }
            }
        }
        return appointments;
    }

    private String getProfessorNameById(int professorId) throws SQLException {
        String sql = "SELECT name FROM users WHERE id = ? AND user_type = 'professor'";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, professorId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("name");
                }
            }
        }
        return "Unknown Professor";
    }

    private String getDefaultProfessorUsername() throws SQLException {
        String sql = "SELECT username FROM users WHERE user_type = 'professor' LIMIT 1";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("username");
                }
            }
        }
        return "prof_xavier"; // fallback
    }

    // Simple Professor class for the professors list
    public static class Professor {
        private int id;
        private String username;
        private String name;

        public int getId() {
            return id;
        }

        public void setId(int id) {
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
    }
}
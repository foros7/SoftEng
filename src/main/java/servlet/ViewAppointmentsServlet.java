package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import util.DatabaseUtil;

@WebServlet("/view-appointments")
public class ViewAppointmentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get filter parameters
        String status = request.getParameter("status");
        String dateRange = request.getParameter("dateRange");
        String search = request.getParameter("search");

        try (Connection conn = DatabaseUtil.getConnection()) {
            StringBuilder sql = new StringBuilder(
                    "SELECT a.*, u.full_name as advisor_name, u.title as advisor_title " +
                            "FROM appointments a " +
                            "JOIN users u ON a.advisor_id = u.id " +
                            "WHERE a.student_username = ? ");
            List<Object> params = new ArrayList<>();
            params.add(username);

            if (status != null && !status.isEmpty()) {
                sql.append("AND a.status = ? ");
                params.add(status);
            }

            if (dateRange != null && !dateRange.isEmpty()) {
                switch (dateRange) {
                    case "today":
                        sql.append("AND DATE(a.appointment_date) = CURDATE() ");
                        break;
                    case "week":
                        sql.append("AND YEARWEEK(a.appointment_date) = YEARWEEK(CURDATE()) ");
                        break;
                    case "month":
                        sql.append(
                                "AND MONTH(a.appointment_date) = MONTH(CURDATE()) AND YEAR(a.appointment_date) = YEAR(CURDATE()) ");
                        break;
                }
            }

            if (search != null && !search.isEmpty()) {
                sql.append("AND (u.full_name LIKE ? OR a.appointment_type LIKE ? OR a.reason LIKE ?) ");
                String searchPattern = "%" + search + "%";
                params.add(searchPattern);
                params.add(searchPattern);
                params.add(searchPattern);
            }

            sql.append("ORDER BY a.appointment_date DESC, a.appointment_time DESC");

            try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    pstmt.setObject(i + 1, params.get(i));
                }

                try (ResultSet rs = pstmt.executeQuery()) {
                    List<Appointment> appointments = new ArrayList<>();
                    while (rs.next()) {
                        Appointment appointment = new Appointment();
                        appointment.setId(rs.getInt("id"));
                        appointment.setAdvisorName(rs.getString("advisor_name"));
                        appointment.setAdvisorTitle(rs.getString("advisor_title"));
                        appointment.setAppointmentType(rs.getString("appointment_type"));
                        appointment.setDate(rs.getString("appointment_date"));
                        appointment.setTime(rs.getString("appointment_time"));
                        appointment.setReason(rs.getString("reason"));
                        appointment.setStatus(rs.getString("status"));
                        appointment.setAdditionalNotes(rs.getString("additional_notes"));
                        appointments.add(appointment);
                    }
                    request.setAttribute("appointments", appointments);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred");
        }

        request.getRequestDispatcher("my-appointments.jsp").forward(request, response);
    }

    // Inner class to represent an appointment
    public static class Appointment {
        private int id;
        private String advisorName;
        private String advisorTitle;
        private String appointmentType;
        private String date;
        private String time;
        private String reason;
        private String status;
        private String additionalNotes;

        // Getters and setters
        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getAdvisorName() {
            return advisorName;
        }

        public void setAdvisorName(String advisorName) {
            this.advisorName = advisorName;
        }

        public String getAdvisorTitle() {
            return advisorTitle;
        }

        public void setAdvisorTitle(String advisorTitle) {
            this.advisorTitle = advisorTitle;
        }

        public String getAppointmentType() {
            return appointmentType;
        }

        public void setAppointmentType(String appointmentType) {
            this.appointmentType = appointmentType;
        }

        public String getDate() {
            return date;
        }

        public void setDate(String date) {
            this.date = date;
        }

        public String getTime() {
            return time;
        }

        public void setTime(String time) {
            this.time = time;
        }

        public String getReason() {
            return reason;
        }

        public void setReason(String reason) {
            this.reason = reason;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public String getAdditionalNotes() {
            return additionalNotes;
        }

        public void setAdditionalNotes(String additionalNotes) {
            this.additionalNotes = additionalNotes;
        }
    }
}
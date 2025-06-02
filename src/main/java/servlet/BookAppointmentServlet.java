package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import util.DatabaseUtil;

@WebServlet("/book-appointment")
public class BookAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

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
        if (advisorId == null || appointmentType == null || date == null || time == null || reason == null) {
            request.setAttribute("error", "Please fill in all required fields");
            request.getRequestDispatcher("book-appointment.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "INSERT INTO appointments (student_username, advisor_id, appointment_type, appointment_date, "
                    +
                    "appointment_time, reason, additional_notes, status) VALUES (?, ?, ?, ?, ?, ?, ?, 'pending')";

            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, username);
                pstmt.setString(2, advisorId);
                pstmt.setString(3, appointmentType);
                pstmt.setString(4, date);
                pstmt.setString(5, time);
                pstmt.setString(6, reason);
                pstmt.setString(7, additionalNotes);

                int result = pstmt.executeUpdate();

                if (result > 0) {
                    // Success - redirect to my appointments page
                    response.sendRedirect("my-appointments.jsp");
                } else {
                    request.setAttribute("error", "Failed to book appointment");
                    request.getRequestDispatcher("book-appointment.jsp").forward(request, response);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred");
            request.getRequestDispatcher("book-appointment.jsp").forward(request, response);
        }
    }
}
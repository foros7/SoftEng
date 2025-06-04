package com.mycompany.softeng.servlet;

import com.mycompany.softeng.dao.AppointmentDAO;
import com.mycompany.softeng.model.Appointment;
import com.mycompany.softeng.util.DatabaseUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/book-appointment")
public class BookAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(BookAppointmentServlet.class.getName());

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
        if (advisorId == null || appointmentType == null || date == null || time == null || reason == null) {
            request.setAttribute("error", "Please fill in all required fields");
            request.getRequestDispatcher("book-appointment.jsp").forward(request, response);
            return;
        }

        try {
            Appointment appointment = new Appointment();
            appointment.setStudentUsername(username);
            appointment.setAdvisorId(advisorId);
            appointment.setAppointmentType(appointmentType);
            appointment.setDate(date);
            appointment.setTime(time);
            appointment.setReason(reason);
            appointment.setAdditionalNotes(additionalNotes);
            appointment.setStatus("pending");

            AppointmentDAO appointmentDAO = new AppointmentDAO();
            appointmentDAO.create(appointment);

            LOGGER.info("Appointment created successfully for student: " + username);
            response.sendRedirect("my-appointments.jsp");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating appointment", e);
            request.setAttribute("error", "Failed to book appointment: " + e.getMessage());
            request.getRequestDispatcher("book-appointment.jsp").forward(request, response);
        }
    }
}
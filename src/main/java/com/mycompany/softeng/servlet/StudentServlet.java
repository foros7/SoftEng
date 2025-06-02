package com.mycompany.softeng.servlet;

import com.mycompany.softeng.model.Students;
import com.mycompany.softeng.model.Assignment;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Date;

public class StudentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        Students student = new Students(username, "", username, "STU001", "pass123");

        switch (action) {
            case "uploadAssignment":
                handleUploadAssignment(request, student);
                break;
            case "makeAppointment":
                handleMakeAppointment(request, student);
                break;
            case "viewAssignments":
                student.show_assignment();
                break;
            case "viewAppointments":
                student.show_appointment();
                break;
        }

        response.sendRedirect("student.jsp?success=Action completed");
    }

    private void handleUploadAssignment(HttpServletRequest request, Students student) {
        String topic = request.getParameter("topic");
        String language = request.getParameter("language");
        String technologies = request.getParameter("technologies");

        // Convert student ID from String to int (removing "STU" prefix if present)
        int studentId = Integer.parseInt(student.getId().replaceAll("[^0-9]", ""));
        Assignment assignment = new Assignment(topic, new Date(), language, technologies, "In Progress", studentId);
        student.upload_assignment(assignment);
    }

    private void handleMakeAppointment(HttpServletRequest request, Students student) {
        student.make_appointment();
    }
}
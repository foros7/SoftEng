package com.mycompany.softeng.servlet;

import com.mycompany.softeng.model.Professor;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class ProfessorServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        Professor professor = new Professor(username, "", username, "pass123");

        switch (action) {
            case "createAppointments":
                professor.createAppointments();
                break;
            case "markAssignment":
                professor.markAssignment();
                break;
            case "getReports":
                professor.getReports();
                break;
        }

        response.sendRedirect("professor.jsp?success=Action completed");
    }
}
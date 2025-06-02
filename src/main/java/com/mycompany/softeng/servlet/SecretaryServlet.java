package com.mycompany.softeng.servlet;

import com.mycompany.softeng.model.Secretary;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class SecretaryServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        Secretary secretary = new Secretary(username, "", username, "SEC001", "pass123");

        switch (action) {
            case "createStudent":
                secretary.createStud();
                break;
            case "createProfessor":
                secretary.createProf();
                break;
            case "createAssignment":
                secretary.createAssignment();
                break;
        }

        response.sendRedirect("secretary.jsp?success=Action completed");
    }
}
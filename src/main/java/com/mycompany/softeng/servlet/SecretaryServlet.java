package com.mycompany.softeng.servlet;

import com.mycompany.softeng.model.Secretary;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet({ "/SecretaryServlet", "/secretary-dashboard" })
public class SecretaryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Forward to secretary.jsp to display the dashboard
        request.getRequestDispatcher("secretary.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

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

        response.sendRedirect("secretary-dashboard?success=Action completed");
    }
}
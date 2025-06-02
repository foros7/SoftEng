package com.mycompany.softeng.servlet;

import com.mycompany.softeng.dao.UserDAO;
import com.mycompany.softeng.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginServlet", urlPatterns = { "/login" })
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Test user bypass
        if ("test".equals(username)) {
            HttpSession session = request.getSession();
            User testUser = new User();
            testUser.setUsername("test");
            testUser.setName("Test User");
            testUser.setUserType("student"); // Default to student role
            session.setAttribute("user", testUser);
            session.setAttribute("userType", "student");
            response.sendRedirect("student.jsp");
            return;
        }

        try {
            User user = userDAO.findByUsername(username);

            if (user != null && user.getPassword().equals(password)) {
                // Create session and store user information
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userType", user.getUserType());

                // Redirect based on user type
                switch (user.getUserType().toLowerCase()) {
                    case "student":
                        response.sendRedirect("student.jsp");
                        break;
                    case "professor":
                        response.sendRedirect("professor.jsp");
                        break;
                    case "secretary":
                        response.sendRedirect("secretary.jsp");
                        break;
                    default:
                        response.sendRedirect("index.jsp");
                }
            } else {
                // Invalid credentials
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            // Log the error
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during login");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to login page
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}
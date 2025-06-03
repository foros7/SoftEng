package com.mycompany.softeng.servlet;

import com.mycompany.softeng.dao.UserDAO;
import com.mycompany.softeng.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "LoginServlet", urlPatterns = { "/login" })
public class LoginServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
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

        LOGGER.info("Login attempt - Username: " + username);

        // For testing purposes - remove in production
        if ("test".equals(username) && "test".equals(password)) {
            LOGGER.info("Using hardcoded test credentials");
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            session.setAttribute("role", "student");
            response.sendRedirect("student-dashboard");
            return;
        }

        try {
            LOGGER.info("Attempting database authentication");
            User user = userDAO.authenticate(username, password);

            if (user != null) {
                LOGGER.info("Authentication successful for user: " + username);
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", user.getRole());
                session.setAttribute("fullName", user.getFullName());

                String redirectUrl;
                switch (user.getRole().toLowerCase()) {
                    case "student":
                        redirectUrl = "student-dashboard";
                        break;
                    case "professor":
                        redirectUrl = "professor-dashboard";
                        break;
                    case "secretary":
                        redirectUrl = "secretary-dashboard";
                        break;
                    default:
                        LOGGER.warning("Invalid role for user " + username + ": " + user.getRole());
                        redirectUrl = "login.jsp";
                        break;
                }

                LOGGER.info("Redirecting to: " + redirectUrl);
                response.sendRedirect(redirectUrl);
            } else {
                LOGGER.warning("Authentication failed for user: " + username);
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during login for user: " + username, e);
            request.setAttribute("error", "An error occurred during login: " + e.getMessage());
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
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

@WebServlet("/update-profile")
public class UpdateProfileServlet extends HttpServlet {
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
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String dob = request.getParameter("dob");
        String major = request.getParameter("major");
        String yearLevel = request.getParameter("yearLevel");

        // Validate input
        if (fullName == null || email == null || phone == null || dob == null ||
                major == null || yearLevel == null) {
            request.setAttribute("error", "Please fill in all required fields");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "UPDATE users SET full_name = ?, email = ?, phone = ?, " +
                    "date_of_birth = ?, major = ?, year_level = ? WHERE username = ?";

            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, fullName);
                pstmt.setString(2, email);
                pstmt.setString(3, phone);
                pstmt.setString(4, dob);
                pstmt.setString(5, major);
                pstmt.setString(6, yearLevel);
                pstmt.setString(7, username);

                int result = pstmt.executeUpdate();

                if (result > 0) {
                    // Success - redirect to profile page
                    response.sendRedirect("profile.jsp");
                } else {
                    request.setAttribute("error", "Failed to update profile");
                    request.getRequestDispatcher("profile.jsp").forward(request, response);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error occurred");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }
}
package com.mycompany.softeng.servlet;

import com.mycompany.softeng.dao.AssignmentDAO;
import com.mycompany.softeng.model.Assignment;
import com.mycompany.softeng.util.DatabaseUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class UpdateAssignmentProgressServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(UpdateAssignmentProgressServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String assignmentId = request.getParameter("assignmentId");
        String progress = request.getParameter("progress");

        if (assignmentId == null || progress == null) {
            request.setAttribute("error", "Missing required parameters");
            request.getRequestDispatcher("student-dashboard.jsp").forward(request, response);
            return;
        }

        try {
            AssignmentDAO assignmentDAO = new AssignmentDAO();
            Assignment assignment = assignmentDAO.getById(Integer.parseInt(assignmentId));

            if (assignment == null) {
                request.setAttribute("error", "Assignment not found");
                request.getRequestDispatcher("student-dashboard.jsp").forward(request, response);
                return;
            }

            // Verify that the assignment belongs to the student
            int studentId = getStudentIdFromUsername(username);
            if (assignment.getStudentId() != studentId) {
                request.setAttribute("error", "You don't have permission to update this assignment");
                request.getRequestDispatcher("student-dashboard.jsp").forward(request, response);
                return;
            }

            // Update the progress
            assignment.setProgress(progress);
            assignmentDAO.update(assignment);

            LOGGER.info("Assignment progress updated successfully for student: " + username);
            response.sendRedirect("student-dashboard");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating assignment progress", e);
            request.setAttribute("error", "Failed to update progress: " + e.getMessage());
            request.getRequestDispatcher("student-dashboard.jsp").forward(request, response);
        }
    }

    private int getStudentIdFromUsername(String username) throws SQLException {
        String sql = "SELECT id FROM users WHERE username = ? AND user_type = 'student'";
        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        }
        return -1;
    }
}
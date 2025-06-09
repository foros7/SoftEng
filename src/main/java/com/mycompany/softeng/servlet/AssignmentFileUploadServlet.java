package com.mycompany.softeng.servlet;

import com.mycompany.softeng.dao.AssignmentDAO;
import com.mycompany.softeng.model.Assignment;
import com.mycompany.softeng.util.DatabaseUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class AssignmentFileUploadServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AssignmentFileUploadServlet.class.getName());

    // Allowed file extensions
    private static final List<String> ALLOWED_EXTENSIONS = Arrays.asList(
            ".pdf", ".doc", ".docx", ".txt", ".zip", ".rar", ".java", ".py", ".cpp", ".c", ".js", ".html", ".css");

    // Maximum file size (10MB)
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String assignmentIdStr = request.getParameter("assignmentId");
            if (assignmentIdStr == null || assignmentIdStr.trim().isEmpty()) {
                request.setAttribute("error", "Assignment ID is required");
                response.sendRedirect("student-dashboard?error=missing_assignment_id");
                return;
            }

            int assignmentId = Integer.parseInt(assignmentIdStr);

            // Verify assignment belongs to the student
            if (!verifyAssignmentOwnership(assignmentId, username)) {
                request.setAttribute("error", "You don't have permission to upload files for this assignment");
                response.sendRedirect("student-dashboard?error=permission_denied");
                return;
            }

            // Get the file part
            Part filePart = request.getPart("assignmentFile");
            if (filePart == null || filePart.getSize() == 0) {
                response.sendRedirect("student-dashboard?error=no_file_selected");
                return;
            }

            String fileName = getSubmittedFileName(filePart);
            if (fileName == null || fileName.trim().isEmpty()) {
                response.sendRedirect("student-dashboard?error=invalid_file_name");
                return;
            }

            // Validate file
            String validationError = validateFile(fileName, filePart.getSize());
            if (validationError != null) {
                response.sendRedirect("student-dashboard?error=" + validationError);
                return;
            }

            // Create uploads directory if it doesn't exist
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator
                    + "assignments";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Generate unique file name
            String fileExtension = getFileExtension(fileName);
            String uniqueFileName = assignmentId + "_" + username + "_" + UUID.randomUUID().toString() + fileExtension;
            String filePath = uploadPath + File.separator + uniqueFileName;

            // Save file
            try (InputStream fileContent = filePart.getInputStream()) {
                Path targetPath = Paths.get(filePath);
                Files.copy(fileContent, targetPath, StandardCopyOption.REPLACE_EXISTING);
            }

            // Update database
            updateAssignmentWithFile(assignmentId, fileName, filePath, filePart.getSize());

            LOGGER.info("File uploaded successfully for assignment " + assignmentId + " by user " + username);
            response.sendRedirect("student-dashboard?success=file_uploaded");

        } catch (NumberFormatException e) {
            LOGGER.log(Level.SEVERE, "Invalid assignment ID", e);
            response.sendRedirect("student-dashboard?error=invalid_assignment_id");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error uploading file", e);
            response.sendRedirect("student-dashboard?error=upload_failed");
        }
    }

    private String getSubmittedFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            for (String content : contentDisposition.split(";")) {
                if (content.trim().startsWith("filename")) {
                    return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return null;
    }

    private String validateFile(String fileName, long fileSize) {
        // Check file size
        if (fileSize > MAX_FILE_SIZE) {
            return "file_too_large";
        }

        // Check file extension
        String extension = getFileExtension(fileName).toLowerCase();
        if (!ALLOWED_EXTENSIONS.contains(extension)) {
            return "invalid_file_type";
        }

        return null; // No errors
    }

    private String getFileExtension(String fileName) {
        int lastDotIndex = fileName.lastIndexOf('.');
        return lastDotIndex > 0 ? fileName.substring(lastDotIndex) : "";
    }

    private boolean verifyAssignmentOwnership(int assignmentId, String username) throws SQLException {
        String sql = "SELECT a.id FROM assignments a " +
                "JOIN users u ON a.student_id = u.id " +
                "WHERE a.id = ? AND u.username = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, assignmentId);
            stmt.setString(2, username);

            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    private void updateAssignmentWithFile(int assignmentId, String fileName, String filePath, long fileSize)
            throws SQLException {
        String sql = "UPDATE assignments SET file_name = ?, file_path = ?, file_size = ?, file_uploaded_at = ? WHERE id = ?";

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, fileName);
            stmt.setString(2, filePath);
            stmt.setLong(3, fileSize);
            stmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            stmt.setInt(5, assignmentId);

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated == 0) {
                throw new SQLException("Failed to update assignment with file information");
            }
        }
    }
}
package com.mycompany.softeng.servlet;

import com.mycompany.softeng.util.DatabaseUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AssignmentFileDownloadServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AssignmentFileDownloadServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String userType = (String) session.getAttribute("userType");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String assignmentIdStr = request.getParameter("assignmentId");
            if (assignmentIdStr == null || assignmentIdStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Assignment ID is required");
                return;
            }

            int assignmentId = Integer.parseInt(assignmentIdStr);

            // Get file information from database
            FileInfo fileInfo = getFileInfo(assignmentId, username, userType);
            if (fileInfo == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found or access denied");
                return;
            }

            // Check if file exists on disk
            File file = new File(fileInfo.filePath);
            if (!file.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found on server");
                return;
            }

            // Set response headers
            response.setContentType(getContentType(fileInfo.fileName));
            response.setContentLengthLong(file.length());

            String encodedFileName = URLEncoder.encode(fileInfo.fileName, StandardCharsets.UTF_8);
            response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");

            // Stream the file
            try (FileInputStream fileInputStream = new FileInputStream(file);
                    OutputStream outputStream = response.getOutputStream()) {

                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
                outputStream.flush();
            }

            LOGGER.info("File downloaded: " + fileInfo.fileName + " by user: " + username);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid assignment ID");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error downloading file", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error downloading file");
        }
    }

    private FileInfo getFileInfo(int assignmentId, String username, String userType) throws SQLException {
        String sql;

        if ("professor".equals(userType)) {
            // Professors can download files from assignments they supervise
            sql = "SELECT a.file_name, a.file_path, a.file_size FROM assignments a " +
                    "JOIN users u ON a.supervisor_id = u.id " +
                    "WHERE a.id = ? AND u.username = ? AND a.file_name IS NOT NULL";
        } else {
            // Students can only download their own files
            sql = "SELECT a.file_name, a.file_path, a.file_size FROM assignments a " +
                    "JOIN users u ON a.student_id = u.id " +
                    "WHERE a.id = ? AND u.username = ? AND a.file_name IS NOT NULL";
        }

        try (Connection conn = DatabaseUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, assignmentId);
            stmt.setString(2, username);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    FileInfo fileInfo = new FileInfo();
                    fileInfo.fileName = rs.getString("file_name");
                    fileInfo.filePath = rs.getString("file_path");
                    fileInfo.fileSize = rs.getLong("file_size");
                    return fileInfo;
                }
            }
        }
        return null;
    }

    private String getContentType(String fileName) {
        String extension = getFileExtension(fileName).toLowerCase();
        switch (extension) {
            case ".pdf":
                return "application/pdf";
            case ".doc":
                return "application/msword";
            case ".docx":
                return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
            case ".txt":
                return "text/plain";
            case ".zip":
                return "application/zip";
            case ".rar":
                return "application/x-rar-compressed";
            case ".java":
                return "text/x-java-source";
            case ".py":
                return "text/x-python";
            case ".cpp":
            case ".c":
                return "text/x-c";
            case ".js":
                return "application/javascript";
            case ".html":
                return "text/html";
            case ".css":
                return "text/css";
            default:
                return "application/octet-stream";
        }
    }

    private String getFileExtension(String fileName) {
        int lastDotIndex = fileName.lastIndexOf('.');
        return lastDotIndex > 0 ? fileName.substring(lastDotIndex) : "";
    }

    private static class FileInfo {
        String fileName;
        String filePath;
        long fileSize;
    }
}
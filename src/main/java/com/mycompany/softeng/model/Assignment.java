package com.mycompany.softeng.model;

import java.util.Date;
import java.sql.Timestamp;

public class Assignment {
    private int id;
    private String topic;
    private Date startDate;
    private String language;
    private String technologies;
    private String progress;
    private int studentId;
    private int supervisorId;
    private String studentName;
    private Timestamp createdAt;

    // File upload related fields
    private String fileName;
    private String filePath;
    private long fileSize;
    private Timestamp fileUploadedAt;

    public Assignment() {
    }

    public Assignment(String topic, Date startDate, String language, String technologies, String progress,
            int studentId) {
        this.topic = topic;
        this.startDate = startDate;
        this.language = language;
        this.technologies = technologies;
        this.progress = progress;
        this.studentId = studentId;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTopic() {
        return topic;
    }

    public void setTopic(String topic) {
        this.topic = topic;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getTechnologies() {
        return technologies;
    }

    public void setTechnologies(String technologies) {
        this.technologies = technologies;
    }

    public String getProgress() {
        return progress;
    }

    public void setProgress(String progress) {
        this.progress = progress;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getSupervisorId() {
        return supervisorId;
    }

    public void setSupervisorId(int supervisorId) {
        this.supervisorId = supervisorId;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // File-related getters and setters
    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public long getFileSize() {
        return fileSize;
    }

    public void setFileSize(long fileSize) {
        this.fileSize = fileSize;
    }

    public Timestamp getFileUploadedAt() {
        return fileUploadedAt;
    }

    public void setFileUploadedAt(Timestamp fileUploadedAt) {
        this.fileUploadedAt = fileUploadedAt;
    }

    public boolean hasFile() {
        return fileName != null && !fileName.trim().isEmpty();
    }

    // Safe getter that handles null values
    public String getFileNameSafe() {
        return fileName != null ? fileName : "";
    }

    public String getFormattedFileSize() {
        if (fileSize <= 0)
            return "N/A";

        final String[] units = { "B", "KB", "MB", "GB" };
        int unitIndex = 0;
        double size = fileSize;

        while (size >= 1024 && unitIndex < units.length - 1) {
            size /= 1024;
            unitIndex++;
        }

        return String.format("%.2f %s", size, units[unitIndex]);
    }

    public void show_Proodos() {
        System.out.println("Assignment progress: " + progress);
    }

    public void show_Details() {
        System.out.println("Assignment details - Topic: " + topic + ", Language: " + language);
    }
}
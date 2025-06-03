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
    private Timestamp createdAt;

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

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public void show_Proodos() {
        System.out.println("Assignment progress: " + progress);
    }

    public void show_Details() {
        System.out.println("Assignment details - Topic: " + topic + ", Language: " + language);
    }
}
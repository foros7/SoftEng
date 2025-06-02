package com.mycompany.softeng.model;

import java.util.Date;

public class Appointment {
    private int id;
    private int assignmentId;
    private Date dayTime;
    private int duration;
    private String purpose;
    private String status;
    private Date createdAt;

    public Appointment() {
    }

    public Appointment(int assignmentId, Date dayTime, int duration, String purpose, String status) {
        this.assignmentId = assignmentId;
        this.dayTime = dayTime;
        this.duration = duration;
        this.purpose = purpose;
        this.status = status;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public Date getDayTime() {
        return dayTime;
    }

    public void setDayTime(Date dayTime) {
        this.dayTime = dayTime;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public void showDate() {
        System.out.println("Appointment date: " + dayTime);
    }

    public boolean isAvailable() {
        return status.equals("scheduled");
    }
}
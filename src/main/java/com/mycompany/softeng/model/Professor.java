package com.mycompany.softeng.model;

public class Professor extends Credentials {
    private String name;
    private String password;
    private String pass;

    public Professor() {
    }

    public Professor(String username, String password, String name, String pass) {
        super(username, password);
        this.name = name;
        this.pass = pass;
    }

    // Getters and Setters
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPass() {
        return pass;
    }

    public void setPass(String pass) {
        this.pass = pass;
    }

    public boolean Verify() {
        return true; // Verification logic
    }

    public void createAppointments() {
        System.out.println("Professor " + name + " created appointments");
    }

    public void markAssignment() {
        System.out.println("Professor " + name + " marked assignment");
    }

    public void getReports() {
        System.out.println("Professor " + name + " generated reports");
    }
}
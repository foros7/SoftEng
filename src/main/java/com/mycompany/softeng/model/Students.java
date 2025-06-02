package com.mycompany.softeng.model;

import java.util.List;
import java.util.ArrayList;

public class Students extends Credentials {
    private String name;
    private String id;
    private String pass;

    public Students() {
    }

    public Students(String username, String password, String name, String id, String pass) {
        super(username, password);
        this.name = name;
        this.id = id;
        this.pass = pass;
    }

    // Getters and Setters
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPass() {
        return pass;
    }

    public void setPass(String pass) {
        this.pass = pass;
    }

    public void upload_assignment() {
        System.out.println("Student " + name + " uploaded assignment");
    }

    public void make_appointment() {
        System.out.println("Student " + name + " made appointment");
    }

    public void upload_assignment(Assignment assignment) {
        System.out.println("Assignment uploaded: " + assignment.getTopic());
    }

    public boolean Verify() {
        return true; // Verification logic
    }

    public void show_assignment() {
        System.out.println("Showing assignments for student: " + name);
    }

    public void show_appointment() {
        System.out.println("Showing appointments for student: " + name);
    }
}
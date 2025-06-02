package com.mycompany.softeng.model;

public class Secretary extends Credentials {
    private String name;
    private String id;
    private String pass;

    public Secretary() {
    }

    public Secretary(String username, String password, String name, String id, String pass) {
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

    public void createStud() {
        System.out.println("Secretary " + name + " created student");
    }

    public void createProf() {
        System.out.println("Secretary " + name + " created professor");
    }

    public void createAssignment() {
        System.out.println("Secretary " + name + " created assignment");
    }

    public boolean Verify() {
        return true; // Verification logic
    }
}
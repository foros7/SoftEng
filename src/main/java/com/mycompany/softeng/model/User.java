package com.mycompany.softeng.model;

public class User {
    private int id;
    private String username;
    private String password;
    private String userType;
    private String name;

    public User() {
    }

    public User(String username, String password, String userType, String name) {
        this.username = username;
        this.password = password;
        this.userType = userType;
        this.name = name;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUserType() {
        return userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
package com.MahalBooking.Model;

import java.sql.Timestamp;

public class User {

    private int id;
    private String name;
    private String mobile;
    private String email;
    private String password;

    // Additional fields (Admin/User Management support)
    private Timestamp createdAt;
    private boolean isActive;

    // No-argument constructor (mandatory)
    public User() {
    }

    // Constructor for registration/login
    public User(int id, String name, String mobile, String email, String password) {
        this.id = id;
        this.name = name;
        this.mobile = mobile;
        this.email = email;
        this.password = password;
    }

    // Full constructor (optional – admin usage)
    public User(int id, String name, String mobile, String email, String password,
                Timestamp createdAt, boolean isActive) {
        this.id = id;
        this.name = name;
        this.mobile = mobile;
        this.email = email;
        this.password = password;
        this.createdAt = createdAt;
        this.isActive = isActive;
    }

    // ================= GETTERS & SETTERS =================

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getEmail() {
        return email;
    }
 
    public void setEmail(String email) {
        this.email = email;
    }

    // Password (required for login)
    public String getPassword() {
        return password;
    }
 
    public void setPassword(String password) {
        this.password = password;
    }

    // ================= ADMIN / AUDIT FIELDS =================

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        this.isActive = active;
    }
}

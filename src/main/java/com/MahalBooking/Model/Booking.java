package com.MahalBooking.Model;

import java.sql.Date;
import java.sql.Timestamp;

public class Booking {
    private int id;
    private int userId;
    private int venueId;
    private String venueName;
    private String venueLocation;
    private Date fromDate;
    private Date toDate;
    private double totalAmount;
    private String status;
    private String paymentStatus;
    private Timestamp paymentDate;
    private Timestamp createdAt;
    private String userName;
    private boolean reviewSubmitted;
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public int getVenueId() {
        return venueId;
    }
    
    public void setVenueId(int venueId) {
        this.venueId = venueId;
    }
    
    public String getVenueName() {
        return venueName;
    }
    
    public void setVenueName(String venueName) {
        this.venueName = venueName;
    }
    
    public String getVenueLocation() {
        return venueLocation;
    }
    
    public void setVenueLocation(String venueLocation) {
        this.venueLocation = venueLocation;
    }
    
    public Date getFromDate() {
        return fromDate;
    }
    
    public void setFromDate(Date fromDate) {
        this.fromDate = fromDate;
    }
    
    public Date getToDate() {
        return toDate;
    }
    
    public void setToDate(Date toDate) {
        this.toDate = toDate;
    }
    
    public double getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
    public Timestamp getPaymentDate() {
        return paymentDate;
    }
    
    public void setPaymentDate(Timestamp paymentDate) {
        this.paymentDate = paymentDate;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public boolean isReviewSubmitted() {
        return reviewSubmitted;
    }

    public void setReviewSubmitted(boolean reviewSubmitted) {
        this.reviewSubmitted = reviewSubmitted;
    }

    // Helper method to calculate total days
    public int getTotalDays() {
        if (fromDate != null && toDate != null) {
            long diff = toDate.getTime() - fromDate.getTime();
            return (int) (diff / (1000 * 60 * 60 * 24)) + 1;
        }
        return 0;
    }
}

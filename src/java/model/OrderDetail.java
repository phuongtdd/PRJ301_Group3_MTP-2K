package model;

import java.io.Serializable;
import java.util.Date;

public class OrderDetail implements Serializable {
    private int orderID;
    private Date orderDate;
    private double amount;
    private String status;

    // User information
    private int userID;
    private String userName;
    private String userEmail;
    private String userFullName;

    // Payment information
    private int paymentID;
    private String paymentName;

    // Premium package information
    private int premiumID;
    private String packageName;
    private int duration;

    // Calculated expiry date
    private Date expiryDate;

    public OrderDetail() {
    }

    // Constructor with all fields
    public OrderDetail(int orderID, Date orderDate, double amount, String status,
            int userID, String userName, String userEmail, String userFullName,
            int paymentID, String paymentName,
            int premiumID, String packageName, int duration,
            Date expiryDate) {
        this.orderID = orderID;
        this.orderDate = orderDate;
        this.amount = amount;
        this.status = status;
        this.userID = userID;
        this.userName = userName;
        this.userEmail = userEmail;
        this.userFullName = userFullName;
        this.paymentID = paymentID;
        this.paymentName = paymentName;
        this.premiumID = premiumID;
        this.packageName = packageName;
        this.duration = duration;
        this.expiryDate = expiryDate;
    }

    // Getters and Setters
    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getUserFullName() {
        return userFullName;
    }

    public void setUserFullName(String userFullName) {
        this.userFullName = userFullName;
    }

    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public String getPaymentName() {
        return paymentName;
    }

    public void setPaymentName(String paymentName) {
        this.paymentName = paymentName;
    }

    public int getPremiumID() {
        return premiumID;
    }

    public void setPremiumID(int premiumID) {
        this.premiumID = premiumID;
    }

    public String getPackageName() {
        return packageName;
    }

    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }
}

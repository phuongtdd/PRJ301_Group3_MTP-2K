/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author HP
 */
import java.io.Serializable;
import java.util.Date;

public class Orders implements Serializable {

    private int orderID;
    private Date orderDate;
    private double amount;
    private String status;
    private int userID;
    private int paymentID;
    private int premiumID;

    public Orders() {
    }

    public Orders(int orderID, Date orderDate, double amount, String status, int userID, int paymentID, int premiumID) {
        this.orderID = orderID;
        this.orderDate = orderDate;
        this.amount = amount;
        this.status = status;
        this.userID = userID;
        this.paymentID = paymentID;
        this.premiumID = premiumID;
    }

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

    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public int getPremiumID() {
        return premiumID;
    }

    public void setPremiumID(int premiumID) {
        this.premiumID = premiumID;
    }
}

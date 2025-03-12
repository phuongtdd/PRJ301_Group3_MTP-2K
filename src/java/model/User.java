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
import java.util.List;

public class User implements Serializable {

    private int userID;
    private String userName;
    private String password;
    private String email;
    private String fullName;
    private String phone;
    private String address;
    private Date createdAt;
    private Date premiumExpiry;

    public User() {
    }

    public User(int userID, String userName, String password, String email, String fullName, String phone, String address, Date createdAt, Date premiumExpiry) {
        this.userID = userID;
        this.userName = userName;
        this.password = password;
        this.email = email;
        this.fullName = fullName;
        this.phone = phone;
        this.address = address;
        this.createdAt = createdAt;
        this.premiumExpiry = premiumExpiry;
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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getPremiumExpiry() {
        return premiumExpiry;
    }

    public void setPremiumExpiry(Date premiumExpiry) {
        this.premiumExpiry = premiumExpiry;
    }

    @Override
    public String toString() {
        return "User{" + "userID=" + userID + ", userName=" + userName + ", password=" + password + ", email=" + email + ", fullName=" + fullName + ", phone=" + phone + ", address=" + address + ", createdAt=" + createdAt + ", premiumExpiry=" + premiumExpiry + '}';
    }
}

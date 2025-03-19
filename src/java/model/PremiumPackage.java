package model;

import java.io.Serializable;

public class PremiumPackage implements Serializable {
    private int premiumID;
    private String name;
    private double price;
    private int duration;

    public PremiumPackage() {
    }

    public PremiumPackage(int premiumID, String name, double price, int duration) {
        this.premiumID = premiumID;
        this.name = name;
        this.price = price;
        this.duration = duration;
    }

    public int getPremiumID() {
        return premiumID;
    }

    public void setPremiumID(int premiumID) {
        this.premiumID = premiumID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }
}

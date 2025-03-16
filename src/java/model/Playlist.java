/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.util.Date;

/**
 *
 * @author HP
 */
class Playlist implements Serializable {

    private int playlistID;
    private int userID;
    private String title;
    private int quantity;
    private Date createdAt;
    private String imageUrl;
    private String description;

    public Playlist() {
    }

    public Playlist(int playlistID, int userID, String title, int quantity, Date createdAt, String imageUrl, String description) {
        this.playlistID = playlistID;
        this.userID = userID;
        this.title = title;
        this.quantity = quantity;
        this.createdAt = createdAt;
        this.imageUrl = imageUrl;
        this.description = description;
    }
    
    
    
    public int getPlaylistID() {
        return playlistID;
    }

    public void setPlaylistID(int playlistID) {
        this.playlistID = playlistID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "Playlist{" + "playlistID=" + playlistID + ", userID=" + userID + ", title=" + title + ", quantity=" + quantity + ", createdAt=" + createdAt + ", imageUrl=" + imageUrl + ", description=" + description + '}';
    }
    
    
}

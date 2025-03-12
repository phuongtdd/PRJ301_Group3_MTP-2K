/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;

/**
 *
 * @author HP
 */
public class Artist implements Serializable {

    private int artistID;
    private String name;
    private String gender;
    private String description;
    private String imageUrl;

    public Artist() {
    }

    public Artist(int artistID, String name, String gender, String description, String imageUrl) {
        this.artistID = artistID;
        this.name = name;
        this.gender = gender;
        this.description = description;
        this.imageUrl = imageUrl;
    }

    public int getArtistID() {
        return artistID;
    }

    public void setArtistID(int artistID) {
        this.artistID = artistID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    @Override
    public String toString() {
        return "Artist{" + "artistID=" + artistID + ", name=" + name + ", gender=" + gender + ", description=" + description + ", imageUrl=" + imageUrl + '}';
    }

}

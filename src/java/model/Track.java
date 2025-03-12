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

public class Track implements Serializable {

    private int trackID;
    private String title;
    private Date releaseDate;
    private String imageUrl;
    private String fileUrl;
    private String description;

    public Track() {
    }

    public Track(int trackID, String title, Date releaseDate, String imageUrl, String fileUrl, String description) {
        this.trackID = trackID;
        this.title = title;
        this.releaseDate = releaseDate;
        this.imageUrl = imageUrl;
        this.fileUrl = fileUrl;
        this.description = description;
    }

    public int getTrackID() {
        return trackID;
    }

    public void setTrackID(int trackID) {
        this.trackID = trackID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Date getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(Date releaseDate) {
        this.releaseDate = releaseDate;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getFileUrl() {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}

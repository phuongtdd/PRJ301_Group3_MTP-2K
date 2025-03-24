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
public class Album implements Serializable {

    private int albumID;
    private String title;
    private Date releaseDate;
    private String description;
    private int artistID;
    private String imageUrl;
    private int trackID;

    public Album() {
    }

    public Album(int albumID, String title, Date releaseDate, String description, int artistID, String imageUrl) {
        this.albumID = albumID;
        this.title = title;
        this.releaseDate = releaseDate;
        this.description = description;
        this.artistID = artistID;
        this.imageUrl = imageUrl;
    }

    public Album(int albumID, String title, Date releaseDate, String description, int artistID, String imageUrl, int trackID) {
        this.albumID = albumID;
        this.title = title;
        this.releaseDate = releaseDate;
        this.description = description;
        this.artistID = artistID;
        this.imageUrl = imageUrl;
        this.trackID = trackID;
    }

    public int getAlbumID() {
        return albumID;
    }

    public void setAlbumID(int albumID) {
        this.albumID = albumID;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getArtistID() {
        return artistID;
    }

    public void setArtistID(int artistID) {
        this.artistID = artistID;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getTrackID() {
        return trackID;
    }

    public void setTrackID(int trackID) {
        this.trackID = trackID;
    }

    @Override
    public String toString() {
        return "Album{" + "albumID=" + albumID + ", title=" + title + ", releaseDate=" + releaseDate + ", description=" + description + ", artistID=" + artistID + ", imageUrl=" + imageUrl + ", trackID=" + trackID + '}';
    }

}

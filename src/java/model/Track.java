package model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import model.Artist;
import model.Genre;

public class Track implements Serializable {

    private int trackID;
    private String title;
    private Date releaseDate;
    private String imageUrl;
    private String fileUrl;
    private String description;
    private int record;
    private List<Genre> genres;
    private List<Artist> artists;

    public Track() {
    }

    public Track(int trackID, String title, Date releaseDate, String imageUrl, String fileUrl, String description, int record) {
        this.trackID = trackID;
        this.title = title;
        this.releaseDate = releaseDate;
        this.imageUrl = imageUrl;
        this.fileUrl = fileUrl;
        this.description = description;
        this.record = record;
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

    public int getRecord() {
        return record;
    }

    public void setRecord(int record) {
        this.record = record;
    }
    
    public List<Genre> getGenres() {
        return genres;
    }
    
    public void setGenres(List<Genre> genres) {
        this.genres = genres;
    }
    
    public List<Artist> getArtists() {
        return artists;
    }
    
    public void setArtists(List<Artist> artists) {
        this.artists = artists;
    }

    @Override
    public String toString() {
        return "Track{" + "trackID=" + trackID + ", title=" + title + ", releaseDate=" + releaseDate + ", imageUrl=" + imageUrl + ", fileUrl=" + fileUrl + ", description=" + description + ", record=" + record + '}';
    }

}

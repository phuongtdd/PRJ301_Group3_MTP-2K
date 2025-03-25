/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.List;

/**
 *
 * @author HP
 */
public class Playlist implements Serializable {

    private int playlistID;
    private int userID;
    private String title;
    private Timestamp createdAt;
    private int trackCount;
    private List<Track> tracks;

    public Playlist() {
    }

    public Playlist(int playlistID, int userID, String title, Timestamp createdAt, int trackCount) {
        this.playlistID = playlistID;
        this.userID = userID;
        this.title = title;
        this.createdAt = createdAt;
        this.trackCount = trackCount;
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

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getTrackCount() {
        return trackCount;
    }

    public void setTrackCount(int trackCount) {
        this.trackCount = trackCount;
    }

    public List<Track> getTracks() {
        return tracks;
    }

    public void setTracks(List<Track> tracks) {
        this.tracks = tracks;
    }

    @Override
    public String toString() {
        return "Playlist{" + "playlistID=" + playlistID + ", userID=" + userID + ", title=" + title + ", createdAt="
                + createdAt + ", trackCount=" + trackCount + ", tracks=" + tracks + '}';
    }

}

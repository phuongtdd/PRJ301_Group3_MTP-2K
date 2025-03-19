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
public class Track_Genre implements Serializable {

    private int trackID;
    private int genreID;

    public Track_Genre() {
    }

    public Track_Genre(int trackID, int genreID) {
        this.trackID = trackID;
        this.genreID = genreID;
    }

    public int getTrackID() {
        return trackID;
    }

    public void setTrackID(int trackID) {
        this.trackID = trackID;
    }

    public int getGenreID() {
        return genreID;
    }

    public void setGenreID(int genreID) {
        this.genreID = genreID;
    }
}

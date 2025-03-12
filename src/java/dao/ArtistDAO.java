/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import connect.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.*;

/**
 *
 * @author HP
 */
public class ArtistDAO {

    private Connection conn;

    public ArtistDAO() {
        this.conn = DBConnection.getConnection();
        if (this.conn == null) {
            System.out.println("❌ Lỗi: Không thể kết nối database trong LibraryDAO!");
        } else {
            System.out.println("✅ LibraryDAO đã kết nối database thành công!");
        }
    }

    //Lấy danh sách artists
    public List<Artist> getArtists() {
        List<Artist> artists = new ArrayList<>();
        String query = "SELECT * FROM Artists";
        try (PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                artists.add(new Artist(
                        rs.getInt("artistID"),
                        rs.getString("name"),
                        rs.getString("gender"),
                        rs.getString("description"),
                        rs.getString("image_url")));
            }

        } catch (SQLException ex) {
            Logger.getLogger(ArtistDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return artists;
    }

    //Lấy danh sách album
    public List<Album> getAlbums() {
        List<Album> albums = new ArrayList<>();
        String query = "SELECT * FROM Albums";
        try (PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                albums.add(new Album(
                        rs.getInt("albumID"),
                        rs.getString("title"),
                        rs.getDate("releaseDate"),
                        rs.getString("description"),
                        rs.getInt("artistID"),
                        rs.getString("image_url")));
            }

        } catch (SQLException ex) {
            Logger.getLogger(ArtistDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return albums;
    }

    public static void main(String[] args) {
        ArtistDAO dao = new ArtistDAO();
        List<Album> albums = dao.getAlbums();

        if (albums.isEmpty()) {
            System.out.println("Không có sách nào trong database.");
        } else {
            for (Album a : albums) {
                System.out.println(a.toString());
            }
        }
    }
}

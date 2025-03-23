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
 * @author MTP-2K
 */
public class AlbumDAO {

    private Connection conn;

    public AlbumDAO() {
        this.conn = DBConnection.getConnection();
        if (this.conn == null) {
            System.out.println("❌ Lỗi: Không thể kết nối database trong AlbumDAO!");
        } else {
            System.out.println("✅ AlbumDAO đã kết nối database thành công!");
        }
    }

    /**
     * Lấy thông tin album dựa vào ID
     * @param albumId ID của album cần tìm
     * @return Album object nếu tìm thấy, null nếu không tìm thấy hoặc có lỗi
     */
    public Album getAlbumById(int albumId) {
        String query = "SELECT * FROM Albums WHERE albumID = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, albumId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Album album = new Album();
                    album.setAlbumID(rs.getInt("albumID"));
                    album.setTitle(rs.getString("title"));
                    album.setReleaseDate(rs.getDate("releaseDate"));
                    album.setDescription(rs.getString("description"));
                    album.setArtistID(rs.getInt("artistID"));
                    album.setImageUrl(rs.getString("image_url"));
                    return album;
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(AlbumDAO.class.getName())
                  .log(Level.SEVERE, "Error getting album by ID: {0}", e.getMessage());
        }
        return null;
    }

    /**
     * Cập nhật thông tin album
     * @param album Album object chứa thông tin cần cập nhật
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateAlbum(Album album) {
        String query = "UPDATE Albums SET title = ?, releaseDate = ?, description = ?, artistID = ?";
        
        // Nếu có URL ảnh mới, cập nhật URL ảnh
        if (album.getImageUrl() != null && !album.getImageUrl().trim().isEmpty()) {
            query += ", image_url = ?";
        }
        
        query += " WHERE albumID = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, album.getTitle());
            
            // Xử lý ngày phát hành
            if (album.getReleaseDate() != null) {
                ps.setDate(2, new java.sql.Date(album.getReleaseDate().getTime()));
            } else {
                ps.setNull(2, java.sql.Types.DATE);
            }
            
            // Xử lý mô tả
            if (album.getDescription() != null) {
                ps.setString(3, album.getDescription());
            } else {
                ps.setNull(3, java.sql.Types.VARCHAR);
            }
            
            ps.setInt(4, album.getArtistID());
            
            // Nếu có URL ảnh mới
            if (album.getImageUrl() != null && !album.getImageUrl().trim().isEmpty()) {
                ps.setString(5, album.getImageUrl());
                ps.setInt(6, album.getAlbumID());
            } else {
                ps.setInt(5, album.getAlbumID());
            }
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            Logger.getLogger(AlbumDAO.class.getName())
                  .log(Level.SEVERE, "Error updating album: {0}", e.getMessage());
            return false;
        }
    }

    /**
     * Xóa album khỏi cơ sở dữ liệu
     * @param albumId ID của album cần xóa
     * @return true nếu xóa thành công, false nếu thất bại
     */
    public boolean deleteAlbum(int albumId) {
        String query = "DELETE FROM Albums WHERE albumID = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, albumId);
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            Logger.getLogger(AlbumDAO.class.getName())
                  .log(Level.SEVERE, "Error deleting album: {0}", e.getMessage());
            return false;
        }
    }
    
    /**
     * Lấy tất cả album từ cơ sở dữ liệu
     * @return Danh sách tất cả album
     */
    public List<Album> getAllAlbums() {
        List<Album> albums = new ArrayList<>();
        String query = "SELECT * FROM Albums";
        
        try (PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Album album = new Album();
                album.setAlbumID(rs.getInt("albumID"));
                album.setTitle(rs.getString("title"));
                album.setReleaseDate(rs.getDate("releaseDate"));
                album.setDescription(rs.getString("description"));
                album.setArtistID(rs.getInt("artistID"));
                album.setImageUrl(rs.getString("image_url"));
                albums.add(album);
            }
        } catch (SQLException e) {
            Logger.getLogger(AlbumDAO.class.getName())
                  .log(Level.SEVERE, "Error getting all albums: {0}", e.getMessage());
        }
        return albums;
    }
    
    /**
     * Thêm album mới vào cơ sở dữ liệu
     * @param album Album object chứa thông tin cần thêm
     * @return ID của album mới nếu thêm thành công, -1 nếu thất bại
     */
    public int addAlbum(Album album) {
        String query = "INSERT INTO Albums (title, releaseDate, description, artistID, image_url) VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, album.getTitle());
            
            // Xử lý ngày phát hành
            if (album.getReleaseDate() != null) {
                ps.setDate(2, new java.sql.Date(album.getReleaseDate().getTime()));
            } else {
                ps.setNull(2, java.sql.Types.DATE);
            }
            
            // Xử lý mô tả
            if (album.getDescription() != null) {
                ps.setString(3, album.getDescription());
            } else {
                ps.setNull(3, java.sql.Types.VARCHAR);
            }
            
            ps.setInt(4, album.getArtistID());
            
            // Xử lý URL ảnh
            if (album.getImageUrl() != null) {
                ps.setString(5, album.getImageUrl());
            } else {
                ps.setNull(5, java.sql.Types.VARCHAR);
            }
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(AlbumDAO.class.getName())
                  .log(Level.SEVERE, "Error adding album: {0}", e.getMessage());
        }
        return -1;
    }
} 
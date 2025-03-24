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
import java.util.stream.Collectors;
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
     *
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
     *
     * @param album Album object chứa thông tin cần cập nhật
     * @param trackIDs List<Integer> chứa danh sách các track ID cần cập nhật
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updateAlbum(Album album, List<Integer> trackIDs) {
        PreparedStatement psDeleteTracks = null;
        PreparedStatement psInsertTracks = null;

        // 1. Cập nhật thông tin album
        String query = "UPDATE Albums SET title = ?, releaseDate = ?, description = ?, artistID = ?";
        if (album.getImageUrl() != null && !album.getImageUrl().trim().isEmpty()) {
            query += ", image_url = ?";
        }
        query += " WHERE albumID = ?";
        try(PreparedStatement ps = conn.prepareStatement(query)) {

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
            if (album.getImageUrl() != null && !album.getImageUrl().trim().isEmpty()) {
                ps.setString(5, album.getImageUrl());
                ps.setInt(6, album.getAlbumID());
            } else {
                ps.setInt(5, album.getAlbumID());
            }

            ps.executeUpdate();

            // 2. Xóa tất cả các track cũ của album
            psDeleteTracks = conn.prepareStatement("DELETE FROM Album_Track WHERE albumID = ?");
            psDeleteTracks.setInt(1, album.getAlbumID());
            psDeleteTracks.executeUpdate();

            // 3. Thêm các track mới
            if (trackIDs != null && !trackIDs.isEmpty()) {
                psInsertTracks = conn.prepareStatement("INSERT INTO Album_Track (albumID, trackID) VALUES (?, ?)");
                for (Integer trackID : trackIDs) {
                    psInsertTracks.setInt(1, album.getAlbumID());
                    psInsertTracks.setInt(2, trackID);
                    psInsertTracks.addBatch();
                }
                psInsertTracks.executeBatch();
            }

            return true;

        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback(); // Rollback nếu có lỗi
                }
            } catch (SQLException ex) {
                Logger.getLogger(AlbumDAO.class.getName())
                        .log(Level.SEVERE, "Error rolling back transaction: {0}", ex.getMessage());
            }
            Logger.getLogger(AlbumDAO.class.getName())
                    .log(Level.SEVERE, "Error updating album: {0}", e.getMessage());
            return false;

        } finally  {
            try(PreparedStatement ps = conn.prepareStatement(query)) {
                if (ps != null) {
                    ps.close();
                }
                if (psDeleteTracks != null) {
                    psDeleteTracks.close();
                }
                if (psInsertTracks != null) {
                    psInsertTracks.close();
                }
                if (conn != null) {
                    conn.setAutoCommit(true); // Reset auto-commit
                    conn.close();
                }
            } catch (SQLException e) {
                Logger.getLogger(AlbumDAO.class.getName())
                        .log(Level.SEVERE, "Error closing resources: {0}", e.getMessage());
            }
        }
    }

    /**
     * Xóa album khỏi cơ sở dữ liệu
     *
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
     *
     * @return Danh sách tất cả album
     */
    public List<Album> getAllAlbums() {
        List<Album> albums = new ArrayList<>();
        String query = "SELECT * FROM Albums";

        try (PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {

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
     *
     * @param album Album object chứa thông tin cần thêm
     * @return ID của album mới nếu thêm thành công, -1 nếu thất bại
     */
    public boolean addAlbum(String title, Date releaseDate, String description, int artistID,
            String imageUrl, List<Integer> trackIDs) {
        String query = "{CALL CreateAlbum(?, ?, ?, ?, ?, ?)}";

        try (CallableStatement cs = conn.prepareCall(query)) {
            // Set các tham số cho stored procedure
            cs.setString(1, title);

            // Xử lý ngày phát hành
            if (releaseDate != null) {
                cs.setDate(2, new java.sql.Date(releaseDate.getTime()));
            } else {
                cs.setNull(2, java.sql.Types.DATE);
            }

            // Xử lý mô tả
            if (description != null && !description.trim().isEmpty()) {
                cs.setString(3, description);
            } else {
                cs.setNull(3, java.sql.Types.NVARCHAR);
            }

            cs.setInt(4, artistID);

            // Xử lý URL ảnh
            if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                cs.setString(5, imageUrl);
            } else {
                cs.setNull(5, java.sql.Types.NVARCHAR);
            }

            // Chuyển List<Integer> thành chuỗi các trackID ngăn cách bởi dấu phẩy
            String trackIDsString = "";
            if (trackIDs != null && !trackIDs.isEmpty()) {
                trackIDsString = trackIDs.stream()
                        .map(String::valueOf)
                        .collect(Collectors.joining(","));
            }
            cs.setString(6, trackIDsString);

            // Thực thi stored procedure
            cs.execute();
            return true;

        } catch (SQLException e) {
            Logger.getLogger(AlbumDAO.class.getName())
                    .log(Level.SEVERE, "Error adding album: {0}", e.getMessage());
            return false;
        }
    }
}

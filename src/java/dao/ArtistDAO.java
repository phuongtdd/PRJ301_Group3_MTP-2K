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

    //Tìm kiếm album theo tên và nghệ sĩ
    public List<Album> searchAlbums(String searchTerm, String artistFilter) {
        List<Album> albums = new ArrayList<>();
        StringBuilder queryBuilder = new StringBuilder();
        // JOIN với bảng Artists để lấy thông tin nghệ sĩ
        queryBuilder.append("SELECT a.*, ar.name as artist_name ")
                   .append("FROM Albums a ")
                   .append("LEFT JOIN Artists ar ON a.artistID = ar.artistID ")
                   .append("WHERE 1=1");
        
        List<Object> params = new ArrayList<>();
        
        // Tìm kiếm theo tên album, mô tả hoặc tên nghệ sĩ
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            String searchPattern = "%" + searchTerm.trim() + "%";
            queryBuilder.append(" AND (LOWER(a.title) LIKE LOWER(?) ")
                       .append("OR LOWER(a.description) LIKE LOWER(?) ")
                       .append("OR LOWER(ar.name) LIKE LOWER(?))");
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        // Lọc theo nghệ sĩ
        if (artistFilter != null && !artistFilter.trim().isEmpty()) {
            try {
                int artistId = Integer.parseInt(artistFilter.trim());
                queryBuilder.append(" AND a.artistID = ?");
                params.add(artistId);
            } catch (NumberFormatException e) {
                Logger.getLogger(ArtistDAO.class.getName())
                      .log(Level.WARNING, "Invalid artist ID format: {0}", artistFilter);
            }
        }
        
        // Sắp xếp kết quả: Album mới nhất lên đầu
        queryBuilder.append(" ORDER BY a.releaseDate DESC, a.title ASC");
        
        try (PreparedStatement stmt = conn.prepareStatement(queryBuilder.toString())) {
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    stmt.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    stmt.setInt(i + 1, (Integer) param);
                }
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Album album = new Album(
                        rs.getInt("albumID"),
                        rs.getString("title"),
                        rs.getDate("releaseDate"),
                        rs.getString("description"),
                        rs.getInt("artistID"),
                        rs.getString("image_url")
                    );
                    // Thêm tên nghệ sĩ vào thuộc tính description
                    // String artistName = rs.getString("artist_name");
                    // if (artistName != null) {
                    //     album.setDescription(album.getDescription() + " - Artist: " + artistName);
                    // }
                    albums.add(album);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ArtistDAO.class.getName())
                  .log(Level.SEVERE, "Error searching albums: {0}", ex.getMessage());
        }
        return albums;
    }

    public List<Artist> searchArtists(String searchTerm) {
        List<Artist> artists = new ArrayList<>();
        String query = "SELECT * FROM Artists WHERE LOWER(name) LIKE LOWER(?)";

        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, "%" + searchTerm.trim() + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Artist artist = new Artist();
                    artist.setArtistID(rs.getInt("artistID"));
                    artist.setName(rs.getString("name"));
                    artist.setDescription(rs.getString("description"));
                    artist.setGender(rs.getString("gender"));
                    artist.setImageUrl(rs.getString("image_url"));
                    artists.add(artist);
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(ArtistDAO.class.getName())
                  .log(Level.SEVERE, "Error searching artists: {0}", e.getMessage());
        }
        return artists;
    }

    public int addNewArtist(String name, String gender, String description, String imageUrl) {
        String query = "INSERT INTO Artists (name, gender, description, image_url) VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name);
            ps.setString(2, gender);
            ps.setString(3, description);
            ps.setString(4, imageUrl);
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(ArtistDAO.class.getName())
                  .log(Level.SEVERE, "Error adding new artist: {0}", e.getMessage());
        }
        return -1;
    }

    public boolean deleteArtist(int artistId) {
        boolean autoCommit = false;
        try {
            // Save current auto-commit state
            autoCommit = conn.getAutoCommit();
            // Disable auto-commit to start transaction
            conn.setAutoCommit(false);
            
            // First delete all albums of this artist
            String deleteAlbumsQuery = "DELETE FROM Albums WHERE artistID = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteAlbumsQuery)) {
                ps.setInt(1, artistId);
                ps.executeUpdate();
            }
            
            // Then delete the artist
            String deleteArtistQuery = "DELETE FROM Artists WHERE artistID = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteArtistQuery)) {
                ps.setInt(1, artistId);
                int affectedRows = ps.executeUpdate();
                
                // If everything is successful, commit the transaction
                conn.commit();
                return affectedRows > 0;
            }
        } catch (SQLException e) {
            try {
                // If there's any error, rollback the transaction
                conn.rollback();
            } catch (SQLException ex) {
                Logger.getLogger(ArtistDAO.class.getName())
                      .log(Level.SEVERE, "Error rolling back transaction: {0}", ex.getMessage());
            }
            Logger.getLogger(ArtistDAO.class.getName())
                  .log(Level.SEVERE, "Error deleting artist and albums: {0}", e.getMessage());
            return false;
        } finally {
            try {
                // Restore original auto-commit state
                conn.setAutoCommit(autoCommit);
            } catch (SQLException e) {
                Logger.getLogger(ArtistDAO.class.getName())
                      .log(Level.SEVERE, "Error resetting auto-commit: {0}", e.getMessage());
            }
        }
    }
    
    public boolean updateArtist(int artistId, String name, String gender, String description, String imageUrl) {
        String query = "UPDATE Artists SET name = ?, gender = ?, description = ?";
        if (imageUrl != null && !imageUrl.trim().isEmpty()) {
            query += ", image_url = ?";
        }
        query += " WHERE artistID = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, name);
            ps.setString(2, gender);
            ps.setString(3, description);
            
            if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                ps.setString(4, imageUrl);
                ps.setInt(5, artistId);
            } else {
                ps.setInt(4, artistId);
            }
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            Logger.getLogger(ArtistDAO.class.getName())
                  .log(Level.SEVERE, "Error updating artist: {0}", e.getMessage());
            return false;
        }
    }
    
    public Artist getArtistById(int artistId) {
        String query = "SELECT * FROM Artists WHERE artistID = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, artistId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Artist(
                        rs.getInt("artistID"),
                        rs.getString("name"),
                        rs.getString("gender"),
                        rs.getString("description"),
                        rs.getString("image_url")
                    );
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(ArtistDAO.class.getName())
                  .log(Level.SEVERE, "Error getting artist by ID: {0}", e.getMessage());
        }
        return null;
    }

    // Thêm album mới
    public boolean addAlbum(String title, Date releaseDate, String description, int artistID, String imageUrl) {
        String query = "INSERT INTO Albums (title, releaseDate, description, artistID, image_url) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, title);
            stmt.setDate(2, new java.sql.Date(releaseDate.getTime()));
            stmt.setString(3, description);
            stmt.setInt(4, artistID);
            stmt.setString(5, imageUrl);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            Logger.getLogger(ArtistDAO.class.getName()).log(Level.SEVERE, "Error adding album: {0}", ex.getMessage());
            return false;
        }
    }

    // Thêm album mới bằng tên nghệ sĩ (sử dụng stored procedure)
    public boolean addAlbumByArtistName(String artistName, String title, Date releaseDate, String description, String imageUrl) {
        String query = "{CALL addAlbumByArtistName(?, ?, ?, ?, ?)}";
        try (CallableStatement stmt = conn.prepareCall(query)) {
            stmt.setString(1, artistName);
            stmt.setString(2, title);
            stmt.setDate(3, new java.sql.Date(releaseDate.getTime()));
            stmt.setString(4, description);
            stmt.setString(5, imageUrl);
            
            stmt.execute();
            return true;
        } catch (SQLException ex) {
            Logger.getLogger(ArtistDAO.class.getName()).log(Level.SEVERE, "Error adding album by artist name: {0}", ex.getMessage());
            return false;
        }
    }

    public static void main(String[] args) {
        ArtistDAO dao = new ArtistDAO();
        List<Artist> albums = dao.getArtists();

        if (albums.isEmpty()) {
            System.out.println("Không có sách nào trong database.");
        } else {
            for (Artist a : albums) {
                System.out.println(a.toString());
            }
        }
    }
}

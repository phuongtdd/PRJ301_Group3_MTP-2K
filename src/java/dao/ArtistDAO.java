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

    // Lấy danh sách artists
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

    // Lấy danh sách album
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

    // Tìm kiếm album theo tên và nghệ sĩ
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
                            rs.getString("image_url"));

                    // Lấy trackID nếu có
                    try {
                        album.setTrackID(rs.getInt("trackID"));
                    } catch (SQLException e) {
                        // Nếu cột không tồn tại, giữ trackID = 0 (giá trị mặc định)
                    }

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

    // Lấy artist bằng ID
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
                            rs.getString("image_url"));
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(ArtistDAO.class.getName())
                    .log(Level.SEVERE, "Error getting artist by ID: {0}", e.getMessage());
        }
        return null;
    }

    // Lấy Album bằng ID
    public Album getAlbumById(int albumID) {
        String query = "SELECT * FROM Albums WHERE albumID = ?";

        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, albumID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Album album = new Album(
                            rs.getInt("albumID"),
                            rs.getString("title"),
                            rs.getDate("releaseDate"),
                            rs.getString("description"),
                            rs.getInt("artistID"),
                            rs.getString("image_url"));

                    // Lấy trackID nếu có
                    try {
                        album.setTrackID(rs.getInt("trackID"));
                    } catch (SQLException e) {
                        // Nếu cột không tồn tại, giữ trackID = 0 (giá trị mặc định)
                    }

                    return album;
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(ArtistDAO.class.getName())
                    .log(Level.SEVERE, "Error getting album by ID: {0}", e.getMessage());
        }
        return null;
    }

    // Thêm album mới bằng tên nghệ sĩ với trackID
//    public boolean addAlbumByArtistName(String artistName, String title, Date releaseDate, String description,
//            String imageUrl, List<Integer> trackIDs) {
//        String getArtistQuery = "SELECT artistID FROM Artists WHERE name = ?";
//        String insertAlbumQuery = "INSERT INTO Albums (title, releaseDate, description, artistID, image_url) VALUES (?, ?, ?, ?, ?)";
//        String insertAlbumTrackQuery = "INSERT INTO Album_Track (albumID, trackID) VALUES (?, ?)";
//
//        try {
//            conn.setAutoCommit(false); // Bắt đầu transaction
//
//            // 1. Lấy artistID từ tên nghệ sĩ
//            int artistID = -1;
//            try (PreparedStatement stmt = conn.prepareStatement(getArtistQuery)) {
//                stmt.setString(1, artistName);
//                try (ResultSet rs = stmt.executeQuery()) {
//                    if (rs.next()) {
//                        artistID = rs.getInt("artistID");
//                    } else {
//                        System.out.println("⚠️ Nghệ sĩ không tồn tại: " + artistName);
//                        return false;
//                    }
//                }
//            }
//
//            // 2. Chèn album mới
//            int albumID = -1;
//            try (PreparedStatement stmt = conn.prepareStatement(insertAlbumQuery, Statement.RETURN_GENERATED_KEYS)) {
//                stmt.setString(1, title);
//                stmt.setDate(2, releaseDate);
//                stmt.setString(3, description);
//                stmt.setInt(4, artistID);
//                stmt.setString(5, imageUrl);
//                stmt.executeUpdate();
//
//                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
//                    if (generatedKeys.next()) {
//                        albumID = generatedKeys.getInt(1);
//                    } else {
//                        throw new SQLException("⚠️ Không thể tạo album.");
//                    }
//                }
//            }
//
//            // 3. Liên kết album với bài hát trong bảng Album_Track
//            try (PreparedStatement stmt = conn.prepareStatement(insertAlbumTrackQuery)) {
//                stmt.setInt(1, albumID);
//                stmt.setInt(2, trackID);
//                stmt.executeUpdate();
//            }
//
//            conn.commit(); // Commit transaction
//            System.out.println("✅ Album tạo thành công với ID: " + albumID);
//            return true;
//
//        } catch (SQLException ex) {
//            try {
//                conn.rollback(); // Rollback nếu có lỗi
//                System.out.println("❌ Lỗi xảy ra, rollback transaction!");
//            } catch (SQLException rollbackEx) {
//                rollbackEx.printStackTrace();
//            }
//            ex.printStackTrace();
//            return false;
//        } finally {
//            try {
//                conn.setAutoCommit(true); // Đặt lại trạng thái mặc định
//            } catch (SQLException ex) {
//                ex.printStackTrace();
//            }
//        }
//    }

    public List<Track> searchTracksByName(String searchTerm) {
        List<Track> tracks = new ArrayList<>();
        String query = "SELECT t.*"
                + "FROM Tracks t "
                + "WHERE LOWER(t.title) LIKE LOWER(?) "
                + "ORDER BY t.title ASC";

        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, "%" + searchTerm.trim() + "%"); // Đảm bảo tìm kiếm có ký tự wildcard %

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Track track = new Track();
                    track.setTrackID(rs.getInt("trackID"));
                    track.setTitle(rs.getString("title"));
                    track.setReleaseDate(rs.getDate("releaseDate"));
                    track.setImageUrl(rs.getString("image_url"));
                    track.setFileUrl(rs.getString("file_url"));
                    track.setDescription(rs.getString("description"));
                    track.setRecord(rs.getInt("record"));
                    tracks.add(track);
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(ArtistDAO.class.getName())
                    .log(Level.SEVERE, "Error searching tracks: {0}", e.getMessage());
        }
        return tracks;
    }

    /**
     * Lấy danh sách album của một nghệ sĩ theo ID
     */
    public List<Album> getAlbumsByArtistId(int artistId) {
        List<Album> albums = new ArrayList<>();
        String query = "SELECT * FROM Albums WHERE artistID = ? ORDER BY releaseDate DESC";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, artistId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Album album = new Album(
                            rs.getInt("albumID"),
                            rs.getString("title"),
                            rs.getDate("releaseDate"),
                            rs.getString("description"),
                            rs.getInt("artistID"),
                            rs.getString("image_url"));
                    albums.add(album);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(ArtistDAO.class.getName())
                    .log(Level.SEVERE, "Error getting albums for artist ID " + artistId, ex);
        }
        return albums;
    }

    /**
     * Kiểm tra xem nghệ sĩ đã tồn tại theo tên hay chưa, nếu chưa thì tạo mới
     * 
     * @param artist Đối tượng Artist chứa thông tin cần thêm/tìm kiếm (chỉ cần
     *               name)
     * @return ID của nghệ sĩ (ID hiện có nếu đã tồn tại, ID mới nếu thêm mới)
     */
    public int changeArtist(Artist artist) {
        // Trước tiên, tìm kiếm nghệ sĩ theo tên
        String searchQuery = "SELECT artistID FROM Artists WHERE LOWER(name) = LOWER(?)";
        try (PreparedStatement ps = conn.prepareStatement(searchQuery)) {
            ps.setString(1, artist.getName().trim());

            try (ResultSet rs = ps.executeQuery()) {
                // Nếu tìm thấy nghệ sĩ, trả về ID
                if (rs.next()) {
                    return rs.getInt("artistID");
                }
            }

            // Nếu không tìm thấy, thêm nghệ sĩ mới
            String insertQuery = "INSERT INTO Artists (name) VALUES (?)";
            try (PreparedStatement insertPs = conn.prepareStatement(insertQuery, Statement.RETURN_GENERATED_KEYS)) {
                insertPs.setString(1, artist.getName().trim());

                int affectedRows = insertPs.executeUpdate();
                if (affectedRows > 0) {
                    try (ResultSet generatedKeys = insertPs.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            return generatedKeys.getInt(1);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            Logger.getLogger(ArtistDAO.class.getName())
                    .log(Level.SEVERE, "Error in changeArtist: {0}", e.getMessage());
        }
        return -1; // Trả về -1 nếu có lỗi
    }

    public static void main(String[] args) {
        ArtistDAO dao = new ArtistDAO();
        List<Track> tracks = dao.searchTracksByName("Drunk");
        for (Track t : tracks) {
            System.out.println(t.getTitle());
        }
    }
}

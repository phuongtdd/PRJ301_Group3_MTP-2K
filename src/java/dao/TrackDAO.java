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
public class TrackDAO {

    private Connection conn;

    public TrackDAO() {
        this.conn = DBConnection.getConnection();
        if (this.conn == null) {
            System.out.println("❌ Lỗi: Không thể kết nối database trong TrackDAO!");
        } else {
            System.out.println("✅ TrackDAO đã kết nối database thành công!");
        }
    }

    // Lấy tất cả tracks từ database
    public List<Track> getAllTracks() {
        List<Track> tracks = new ArrayList<>();
        String query = "SELECT * FROM Tracks";
        try (PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Track track = new Track();
                track.setTrackID(rs.getInt("trackID"));
                track.setTitle(rs.getString("title"));
                track.setReleaseDate(rs.getDate("releaseDate"));
                track.setImageUrl(rs.getString("image_url"));
                track.setFileUrl(rs.getString("file_url"));
                track.setRecord(rs.getInt("record"));

                // Get genres for this track
                track.setGenres(getGenresForTrack(track.getTrackID()));

                // Get artists for this track
                track.setArtists(getArtistsForTrack(track.getTrackID()));

                tracks.add(track);
            }
        } catch (SQLException ex) {
            Logger.getLogger(TrackDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return tracks;
    }
    // Lấy chi tiết một track theo ID
    public Track getTrackById(int trackId) {
        String query = "SELECT * FROM Tracks WHERE trackID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, trackId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Track track = new Track();
                    track.setTrackID(rs.getInt("trackID"));
                    track.setTitle(rs.getString("title"));
                    track.setReleaseDate(rs.getDate("releaseDate"));
                    track.setImageUrl(rs.getString("image_url"));
                    track.setFileUrl(rs.getString("file_url"));
                    track.setRecord(rs.getInt("record"));

                    // Get genres for this track
                    track.setGenres(getGenresForTrack(track.getTrackID()));

                    // Get artists for this track
                    track.setArtists(getArtistsForTrack(track.getTrackID()));

                    return track;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(TrackDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    // Lấy genres cho một track
    private List<Genre> getGenresForTrack(int trackId) {
        List<Genre> genres = new ArrayList<>();
        String query = "SELECT g.* FROM Genres g "
                + "JOIN Track_Genre tg ON g.genreID = tg.genreID "
                + "WHERE tg.trackID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, trackId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Genre genre = new Genre(
                            rs.getInt("genreID"),
                            rs.getString("genreName")
                    );
                    genres.add(genre);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(TrackDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return genres;
    }

    // Lấy artists cho một track
    private List<Artist> getArtistsForTrack(int trackId) {
        List<Artist> artists = new ArrayList<>();
        String query = "SELECT a.* FROM Artists a "
                + "JOIN Track_Artists ta ON a.artistID = ta.artistID "
                + "WHERE ta.trackID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, trackId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Artist artist = new Artist(
                            rs.getInt("artistID"),
                            rs.getString("name"),
                            rs.getString("gender"),
                            rs.getString("description"),
                            rs.getString("image_url")
                    );
                    artists.add(artist);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(TrackDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return artists;
    }
    // Lấy tất cả genres
    public List<Genre> getAllGenres() {
        List<Genre> genres = new ArrayList<>();
        String query = "SELECT * FROM Genres";

        try (PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Genre genre = new Genre(
                        rs.getInt("genreID"),
                        rs.getString("genreName")
                );
                genres.add(genre);
            }
        } catch (SQLException ex) {
            Logger.getLogger(TrackDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return genres;
    }

    // Thêm track mới
    public int addTrack(Track track, List<Integer> genreIds, List<Integer> artistIds) {
        String query = "INSERT INTO Tracks (title, releaseDate, image_url, file_url, record) VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, track.getTitle());
            stmt.setDate(2, track.getReleaseDate() != null ? new java.sql.Date(track.getReleaseDate().getTime()) : null);
            stmt.setString(3, track.getImageUrl());
            stmt.setString(4, track.getFileUrl());
            stmt.setInt(5, track.getRecord());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int trackId = rs.getInt(1);
                        // Add genres
                        if (genreIds != null) {
                            for (Integer genreId : genreIds) {
                                addTrackGenre(trackId, genreId);
                            }
                        }
                        // Add artists
                        if (artistIds != null) {
                            for (Integer artistId : artistIds) {
                                addTrackArtist(trackId, artistId);
                            }
                        }
                        return trackId;
                    }
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(TrackDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return -1;
    }

    // Cập nhật track
    public boolean updateTrack(Track track, List<Integer> genreIds, List<Integer> artistIds) {
        String query = "UPDATE Tracks SET title = ?, releaseDate = ?, file_url = ?, record = ?";

        if (track.getImageUrl() != null && !track.getImageUrl().isEmpty()) {
            query += ", image_url = ?";
        }

        query += " WHERE trackID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, track.getTitle());
            stmt.setDate(2, track.getReleaseDate() != null ? new java.sql.Date(track.getReleaseDate().getTime()) : null);
            stmt.setString(3, track.getFileUrl());
            stmt.setInt(4, track.getRecord());
            int paramIndex = 5;
            if (track.getImageUrl() != null && !track.getImageUrl().isEmpty()) {
                stmt.setString(paramIndex++, track.getImageUrl());
            }

            stmt.setInt(paramIndex, track.getTrackID());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                // Update genres
                if (genreIds != null) {
                    deleteTrackGenres(track.getTrackID());
                    for (Integer genreId : genreIds) {
                        addTrackGenre(track.getTrackID(), genreId);
                    }
                }
                // Update artists
                if (artistIds != null) {
                    deleteTrackArtists(track.getTrackID());
                    for (Integer artistId : artistIds) {
                        addTrackArtist(track.getTrackID(), artistId);
                    }
                }
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(TrackDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Xóa track
    public boolean deleteTrack(int trackId) {
        String query = "DELETE FROM Tracks WHERE trackID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, trackId);

            // Relations will be deleted automatically due to ON DELETE CASCADE
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(TrackDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Thêm mối quan hệ track-genre
    private boolean addTrackGenre(int trackId, int genreId) {
        String query = "INSERT INTO Track_Genre (trackID, genreID) VALUES (?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, trackId);
            stmt.setInt(2, genreId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(TrackDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Xóa mối quan hệ track-genre
    private boolean deleteTrackGenres(int trackId) {
        String query = "DELETE FROM Track_Genre WHERE trackID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, trackId);

            stmt.executeUpdate();
            return true;
        } catch (SQLException ex) {
            Logger.getLogger(TrackDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Thêm mối quan hệ track-artist
    private boolean addTrackArtist(int trackId, int artistId) {
        String query = "INSERT INTO Track_Artists (trackID, artistID) VALUES (?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, trackId);
            stmt.setInt(2, artistId);

            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            Logger.getLogger(TrackDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Xóa mối quan hệ track-artist
    private boolean deleteTrackArtists(int trackId) {
        String query = "DELETE FROM Track_Artists WHERE trackID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, trackId);

            stmt.executeUpdate();
            return true;
        } catch (SQLException ex) {
            Logger.getLogger(TrackDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Đếm tổng số tracks trong database
    public int countTotalTracks() {
        String query = "SELECT COUNT(*) FROM Tracks";
        try (PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(TrackDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    // Tìm kiếm tracks theo tên bài hát, tên artist, và genre
    public List<Track> searchTracks(String trackName, String artistName, Integer genreId, String sortBy) {
        List<Track> tracks = new ArrayList<>();
        StringBuilder query = new StringBuilder();
        query.append("SELECT DISTINCT t.* FROM Tracks t ");
        // Joins cần thiết
        if (artistName != null && !artistName.trim().isEmpty()) {
            query.append("JOIN Track_Artists ta ON t.trackID = ta.trackID ");
            query.append("JOIN Artists a ON ta.artistID = a.artistID ");
        }

        if (genreId != null) {
            query.append("JOIN Track_Genre tg ON t.trackID = tg.trackID ");
        }

        // Điều kiện WHERE
        query.append("WHERE 1=1 ");

        if (trackName != null && !trackName.trim().isEmpty()) {
            query.append("AND t.title LIKE ? ");
        }

        if (artistName != null && !artistName.trim().isEmpty()) {
            query.append("AND a.name LIKE ? ");
        }

        if (genreId != null) {
            query.append("AND tg.genreID = ? ");
        }

        // Sắp xếp
        if (sortBy != null && !sortBy.isEmpty()) {
            switch (sortBy) {
                case "name":
                    query.append("ORDER BY t.title ASC");
                    break;
                case "popularity":
                case "record":
                    query.append("ORDER BY t.record DESC");
                    break;
                case "releaseDate":
                    query.append("ORDER BY t.releaseDate DESC");
                    break;
                default:
                    query.append("ORDER BY t.trackID DESC");
                    break;
            }
        } else {
            query.append("ORDER BY t.trackID DESC");
        }

        try (PreparedStatement stmt = conn.prepareStatement(query.toString())) {
            int paramIndex = 1;

            if (trackName != null && !trackName.trim().isEmpty()) {
                stmt.setString(paramIndex++, "%" + trackName + "%");
            }

            if (artistName != null && !artistName.trim().isEmpty()) {
                stmt.setString(paramIndex++, "%" + artistName + "%");
            }

            if (genreId != null) {
                stmt.setInt(paramIndex++, genreId);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Track track = new Track();
                    track.setTrackID(rs.getInt("trackID"));
                    track.setTitle(rs.getString("title"));
                    track.setReleaseDate(rs.getDate("releaseDate"));
                    track.setImageUrl(rs.getString("image_url"));
                    track.setFileUrl(rs.getString("file_url"));
                    track.setRecord(rs.getInt("record"));

                    // Get genres for this track
                    track.setGenres(getGenresForTrack(track.getTrackID()));

                    // Get artists for this track
                    track.setArtists(getArtistsForTrack(track.getTrackID()));

                    tracks.add(track);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(TrackDAO.class.getName()).log(Level.SEVERE, "Error searching tracks", ex);
        }

        return tracks;
    }

    // Lấy tất cả tracks của một artist theo artistID
    public List<Track> getTracksByArtistId(int artistId) {
        List<Track> tracks = new ArrayList<>();
        
        String query = "SELECT t.* FROM Tracks t " +
                      "JOIN Track_Artists ta ON t.trackID = ta.trackID " +
                      "WHERE ta.artistID = ? " +
                      "ORDER BY t.releaseDate DESC";
        
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, artistId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Track track = new Track();
                    track.setTrackID(rs.getInt("trackID"));
                    track.setTitle(rs.getString("title"));
                    track.setReleaseDate(rs.getDate("releaseDate"));
                    track.setImageUrl(rs.getString("image_url"));
                    track.setFileUrl(rs.getString("file_url"));
                    track.setDescription(rs.getString("description"));
                    track.setRecord(rs.getInt("record"));
                    
                    // Get genres for this track
                    track.setGenres(getGenresForTrack(track.getTrackID()));
                    
                    // Get artists for this track
                    track.setArtists(getArtistsForTrack(track.getTrackID()));
                    
                    tracks.add(track);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(TrackDAO.class.getName()).log(Level.SEVERE, "Error getting tracks for artist: " + artistId, ex);
        }
        
        return tracks;
    }
}

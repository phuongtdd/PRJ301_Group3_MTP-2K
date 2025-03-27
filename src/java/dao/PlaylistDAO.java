package dao;

import connect.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Playlist;
import model.Track;

public class PlaylistDAO {

    private Connection conn;

    public PlaylistDAO() {
        this.conn = DBConnection.getConnection();
        if (this.conn == null) {
            System.out.println("❌ Lỗi: Không thể kết nối database trong LibraryDAO!");
        } else {
            System.out.println("✅ LibraryDAO đã kết nối database thành công!");
        }
    }

    // Create a new playlist and return the generated ID
    public int createPlaylist(int userId, String title, String description) {
        int playlistId = -1;
        String query = "INSERT INTO Playlists (userID, title, createdAt) VALUES (?, ?, GETDATE())";

        try (PreparedStatement stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, userId);
            stmt.setString(2, title);

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        playlistId = rs.getInt(1);
                    }
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(PlaylistDAO.class.getName()).log(Level.SEVERE, "Error creating playlist", ex);
            ex.printStackTrace(); // Print the stack trace to see the specific error
        }

        return playlistId;
    }

    // Add tracks to a playlist
    public boolean addTracksToPlaylist(int playlistId, List<Integer> trackIds) {
        String query = "INSERT INTO Track_Playlist (playlistID, trackID) VALUES (?, ?)";
        boolean success = true;

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            conn.setAutoCommit(false);

            for (Integer trackId : trackIds) {
                stmt.setInt(1, playlistId);
                stmt.setInt(2, trackId);
                stmt.addBatch();
            }

            int[] results = stmt.executeBatch();
            conn.commit();

            // Check if all inserts were successful
            for (int result : results) {
                if (result <= 0) {
                    success = false;
                    break;
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(PlaylistDAO.class.getName()).log(Level.SEVERE, "Error adding tracks to playlist", ex);
            try {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                Logger.getLogger(PlaylistDAO.class.getName()).log(Level.SEVERE, "Error rolling back transaction", rollbackEx);
            }
            success = false;
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException ex) {
                Logger.getLogger(PlaylistDAO.class.getName()).log(Level.SEVERE, "Error resetting auto-commit", ex);
            }
        }

        return success;
    }

    // Update the quantity of tracks in a playlist
    public boolean updatePlaylistQuantity(int playlistId) {
        return true;
    }

    // Get all playlists for a user
    public List<Playlist> getPlaylistsByUserId(int userId) {
        List<Playlist> playlists = new ArrayList<>();
        String query = "SELECT p.*, " +
                "(SELECT TOP 1 t.image_url FROM Tracks t " +
                "JOIN Track_Playlist tp ON t.trackID = tp.trackID " +
                "WHERE tp.playlistID = p.playlistID) AS track_image " +
                "FROM Playlists p WHERE p.userID = ? ORDER BY p.createdAt DESC";
        
        // Debug: Check if connection is initialized
        if (conn == null) {
            System.out.println("Database connection is null. Initializing connection...");
            conn = DBConnection.getConnection();
        }
        
        System.out.println("Fetching playlists for user ID: " + userId);

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            
            System.out.println("Executing query: " + query + " with userId = " + userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                int count = 0;
                while (rs.next()) {
                    count++;
                    Playlist playlist = new Playlist();
                    playlist.setPlaylistID(rs.getInt("playlistID"));
                    playlist.setUserID(rs.getInt("userID"));
                    playlist.setTitle(rs.getString("title"));
                    playlist.setCreatedAt(rs.getDate("createdAt"));
                    
                    // Get image from a track in the playlist or use default if none
                    String trackImage = rs.getString("track_image");
                    if (trackImage != null && !trackImage.isEmpty()) {
                        playlist.setImageUrl(trackImage);
                    } else {
                        playlist.setImageUrl("/image/playlist-image.jpg"); // Default image
                    }
                    
                    // Set default values for fields that don't exist in the database
                    playlist.setDescription(""); // Default empty description
                    
                    // Set quantity by counting tracks in the playlist
                    try {
                        int playlistId = playlist.getPlaylistID();
                        String countQuery = "SELECT COUNT(*) AS track_count FROM Track_Playlist WHERE playlistID = ?";
                        try (PreparedStatement countStmt = conn.prepareStatement(countQuery)) {
                            countStmt.setInt(1, playlistId);
                            try (ResultSet countRs = countStmt.executeQuery()) {
                                if (countRs.next()) {
                                    playlist.setQuantity(countRs.getInt("track_count"));
                                } else {
                                    playlist.setQuantity(0);
                                }
                            }
                        }
                    } catch (SQLException ex) {
                        System.out.println("Error getting track count for playlist " + playlist.getPlaylistID() + ": " + ex.getMessage());
                        playlist.setQuantity(0);
                    }

                    playlists.add(playlist);
                }
                System.out.println("Found " + count + " playlists for user ID: " + userId);
            }
        } catch (SQLException ex) {
            Logger.getLogger(PlaylistDAO.class.getName()).log(Level.SEVERE, "Error getting playlists for user", ex);
        }

        return playlists;
    }
    
    public static void main(String[] args) {
        List<Integer> l = new ArrayList<>();
        l.add(1);
        l.add(2);
        PlaylistDAO dao = new PlaylistDAO();
        dao.addTracksToPlaylist(1, l );
    }
    
    // Get tracks for a playlist
    public List<Track> getTracksForPlaylist(int playlistId) {
        List<Track> tracks = new ArrayList<>();
        String query = "SELECT t.* FROM Tracks t " +
                       "JOIN Track_Playlist tp ON t.trackID = tp.trackID " +
                       "WHERE tp.playlistID = ? " +
                       "ORDER BY t.title ASC";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, playlistId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Track track = new Track();
                    track.setTrackID(rs.getInt("trackID"));
                    track.setTitle(rs.getString("title"));
                    track.setReleaseDate(rs.getDate("releaseDate"));
                    track.setImageUrl(rs.getString("image_url"));
                    track.setFileUrl(rs.getString("file_url"));
                    track.setRecord(rs.getInt("record"));
                    track.setDescription(rs.getString("description"));
                    
                    // Get artists for this track using TrackDAO
                    TrackDAO trackDAO = new TrackDAO();
                    track.setArtists(trackDAO.getArtistsForTrack(track.getTrackID()));
                    
                    tracks.add(track);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(PlaylistDAO.class.getName()).log(Level.SEVERE, "Error getting tracks for playlist: " + playlistId, ex);
        }

        return tracks;
    }
    
    // Delete a playlist by its ID
    public boolean deletePlaylist(int playlistId, int userId) {
        boolean success = false;
        
        try {
            conn.setAutoCommit(false);
            
            // First, delete all entries in Track_Playlist for this playlist
            String deleteTracksQuery = "DELETE FROM Track_Playlist WHERE playlistID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(deleteTracksQuery)) {
                stmt.setInt(1, playlistId);
                stmt.executeUpdate();
            }
            
            // Then, delete the playlist itself, but only if it belongs to the user
            String deletePlaylistQuery = "DELETE FROM Playlists WHERE playlistID = ? AND userID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(deletePlaylistQuery)) {
                stmt.setInt(1, playlistId);
                stmt.setInt(2, userId);
                int rowsAffected = stmt.executeUpdate();
                
                // If rows were affected, the deletion was successful
                success = rowsAffected > 0;
            }
            
            conn.commit();
        } catch (SQLException ex) {
            Logger.getLogger(PlaylistDAO.class.getName()).log(Level.SEVERE, "Error deleting playlist: " + playlistId, ex);
            try {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                Logger.getLogger(PlaylistDAO.class.getName()).log(Level.SEVERE, "Error rolling back transaction", rollbackEx);
            }
        } finally {
            try {
                conn.setAutoCommit(true);
            } catch (SQLException ex) {
                Logger.getLogger(PlaylistDAO.class.getName()).log(Level.SEVERE, "Error resetting auto-commit", ex);
            }
        }
        
        return success;
    }
}

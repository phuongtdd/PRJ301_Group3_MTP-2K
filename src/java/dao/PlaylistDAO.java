package dao;

import connect.DBConnection;
import model.Playlist;
import model.Track;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PlaylistDAO {
    private Connection conn;

    public PlaylistDAO() {
        this.conn = DBConnection.getConnection();
        if (this.conn == null) {
            System.out.println("❌ Lỗi: Không thể kết nối database trong PlaylistDAO!");
        } else {
            System.out.println("✅ PlaylistDAO đã kết nối database thành công!");
        }
    }

    public List<Playlist> getPlaylistsByUserId(int userId) {
        List<Playlist> playlists = new ArrayList<>();
        String sql = "SELECT p.playlistID, p.title, p.createdAt, COUNT(tp.trackID) as trackCount " +
                    "FROM Playlists p " +
                    "LEFT JOIN Track_Playlist tp ON p.playlistID = tp.playlistID " +
                    "WHERE p.userID = ? " +
                    "GROUP BY p.playlistID, p.title, p.createdAt " +
                    "ORDER BY p.createdAt DESC";

        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Playlist playlist = new Playlist();
                playlist.setPlaylistID(rs.getInt("playlistID"));
                playlist.setTitle(rs.getString("title"));
                playlist.setCreatedAt(rs.getTimestamp("createdAt"));
                playlist.setTrackCount(rs.getInt("trackCount"));
                playlists.add(playlist);
            }
        } catch (SQLException e) {
            System.out.println("❌ Lỗi khi lấy danh sách playlist: " + e.getMessage());
        }
        return playlists;
    }

    public List<Track> getTracksInPlaylist(int playlistId) {
        List<Track> tracks = new ArrayList<>();
        String sql = "SELECT trackID, title, releaseDate, image_url, file_url, record " +
                    "FROM View_Tracks_By_Playlist " +
                    "WHERE playlistID = ? " +
                    "ORDER BY title";

        try (PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, playlistId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Track track = new Track();
                track.setTrackID(rs.getInt("trackID"));
                track.setTitle(rs.getString("title"));
                track.setReleaseDate(rs.getTimestamp("releaseDate"));
                track.setImageUrl(rs.getString("image_url"));
                track.setFileUrl(rs.getString("file_url"));
                track.setRecord(rs.getInt("record"));
                tracks.add(track);
            }
        } catch (SQLException e) {
            System.out.println("❌ Lỗi khi lấy danh sách bài hát trong playlist: " + e.getMessage());
        }
        return tracks;
    }

    public int createPlaylist(int userId, String title, List<Integer> trackIds) {
        String sql = "{call CreatePlaylist(?, ?, ?)}";
        int newPlaylistId = -1;

        try (CallableStatement st = conn.prepareCall(sql)) {
            // Convert trackIds list to comma-separated string
            String trackIdsString = trackIds != null && !trackIds.isEmpty() 
                ? String.join(",", trackIds.stream().map(String::valueOf).toList())
                : null;

            st.setInt(1, userId);
            st.setString(2, title);
            st.setString(3, trackIdsString);

            // Execute the stored procedure
            ResultSet rs = st.executeQuery();

            // Get the returned playlist ID
            if (rs.next()) {
                newPlaylistId = rs.getInt("playlistID");
                System.out.println("✅ Playlist được tạo thành công với ID: " + newPlaylistId);
            } else {
                System.out.println("❌ Không thể tạo playlist!");
            }
        } catch (SQLException e) {
            System.out.println("❌ Lỗi khi tạo playlist: " + e.getMessage());
        }

        return newPlaylistId;
    }

    public static void main(String[] args) {
        // Khởi tạo PlaylistDAO
        PlaylistDAO playlistDAO = new PlaylistDAO();
        
        // Test với userID = 1 (bạn có thể thay đổi userID này)
        int userId = 5;
        
        // Lấy danh sách playlist
        List<Playlist> playlists = playlistDAO.getPlaylistsByUserId(userId);
        
        // In kết quả
        System.out.println("\n=== DANH SÁCH PLAYLIST CỦA USER " + userId + " ===\n");
        
        if (playlists.isEmpty()) {
            System.out.println("❌ Không tìm thấy playlist nào!");
        } else {
            for (Playlist playlist : playlists) {
                System.out.println("Playlist ID: " + playlist.getPlaylistID());
                System.out.println("Tiêu đề: " + playlist.getTitle());
                System.out.println("Ngày tạo: " + playlist.getCreatedAt());
                System.out.println("Số bài hát: " + playlist.getTrackCount());
                System.out.println("\nDanh sách bài hát:");
                
                // Lấy và hiển thị danh sách bài hát trong playlist
                List<Track> tracks = playlistDAO.getTracksInPlaylist(playlist.getPlaylistID());
                if (tracks.isEmpty()) {
                    System.out.println("  ❌ Không có bài hát nào trong playlist này!");
                } else {
                    for (Track track : tracks) {
                        System.out.println("  - " + track.getTitle());
                        System.out.println("    Ngày phát hành: " + track.getReleaseDate());
                        System.out.println("    Lượt nghe: " + track.getRecord());
                        System.out.println("    ------------------------");
                    }
                }
                System.out.println("\n------------------------\n");
            }
        }
    }
}

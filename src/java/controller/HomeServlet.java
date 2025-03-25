/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import dao.ArtistDAO;
import dao.TrackDAO;
import dao.PlaylistDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpSession;
import model.Album;
import model.Artist;
import model.Track;
import model.User;
import model.Genre;
import model.Playlist;
import org.json.JSONArray;
import org.json.JSONObject;
import java.util.ArrayList;

/**
 *
 * @author HP
 */
public class HomeServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    private ArtistDAO artistDAO;
    private TrackDAO trackDAO;
    private PlaylistDAO playlistDAO;

    @Override
    public void init() throws ServletException {
        artistDAO = new ArtistDAO();
        trackDAO = new TrackDAO();
        playlistDAO = new PlaylistDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath(); // Lấy đường dẫn URL

        switch (path) {
            case "/home/search":
                List<Genre> genres = trackDAO.getAllGenres();
                // Lấy số lượng bài hát cho mỗi thể loại
                for (Genre genre : genres) {
                    int trackCount = trackDAO.countTracksByGenre(genre.getGenreID());
                    genre.setTrackCount(trackCount);
                }
                request.setAttribute("genres", genres);
                request.getRequestDispatcher("/view/home/search.jsp").forward(request, response);
                break;
            case "/home/genre":
                handleGenreView(request, response);
                break;
            case "/home/library":
                handleLibraryView(request, response);
                // request.getRequestDispatcher("/view/home/library.jsp").forward(request,
                // response);
                break;
            case "/home/create-playlist":
                handleGetTracks(request, response);
                // request.getRequestDispatcher("/view/home/create-playlist.jsp").forward(request,
                // response);
                break;
            case "/home/liked-songs":
                request.getRequestDispatcher("/view/home/likedSongs.jsp").forward(request, response);
                break;
            case "/home/topsong":
                request.getRequestDispatcher("/view/home/top_songs.jsp").forward(request, response);
                break;
            case "/home/all-artists":
                handleAllArtists(request, response);
                break;
            case "/home/all-albums":
                handleAllAlbums(request, response);
                break;
            case "/home/artist-tracks":
                handleArtistTracks(request, response);
                break;
            case "/home/artist-albums":
                handleArtistAlbums(request, response);
                break;
            case "/home/artist":
                handleArtistInfor(request, response);
                request.getRequestDispatcher("/view/home/artists.jsp").forward(request, response);
                break;
            default:
                handleViewArtist(request, response);
                handleViewAlbum(request, response);
                request.getRequestDispatcher("/view/home/home.jsp").forward(request, response);
                break;
        }

    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/home/artist".equals(path)) {
            handleArtistInfor(request, response);
            request.getRequestDispatcher("/view/home/artists.jsp").forward(request, response);
        } else if ("/home/album".equals(path)) {
            handleAlbumInfor(request, response);
            request.getRequestDispatcher("/view/home/albums.jsp").forward(request, response);
        } else if ("/home/track".equals(path)) {
            handleTrackInfo(request, response);
            request.getRequestDispatcher("/view/home/tracks.jsp").forward(request, response);
        } else if ("/home/create-playlist".equals(path)) {
            handleCreatePlaylist(request, response);
            // request.getRequestDispatcher("/view/home/create-playlist.jsp").forward(request,
            // response);
        } else {
            // Xử lý các đường dẫn khác nếu cần
            doGet(request, response);
        }
    }

    /*------------------------------------Lấy danh sách Artists-----------------------------------------------------*/
    private void handleViewArtist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ArtistDAO dao = new ArtistDAO();
        List<Artist> artists = dao.getArtists();
        request.setAttribute("artist", artists);
    }

    /*------------------------------------Lấy danh sách Albums-----------------------------------------------------*/
    private void handleViewAlbum(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ArtistDAO dao = new ArtistDAO();
        List<Album> albums = dao.getAlbums();
        request.setAttribute("album", albums);
    }

    /*-----------------------------------Lấy thông tin artist-----------------------------------------------------------*/
    private void handleArtistInfor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String artistId = request.getParameter("id");
        HttpSession session = request.getSession();

        if (artistId != null) {
            try {
                int artID = Integer.parseInt(artistId);
                Artist artist = artistDAO.getArtistById(artID);

                session.setAttribute("artistId", artID); // Lưu ID vào session

                if (artist != null) {
                    session.setAttribute("artist", artist); // Lưu thông tin artist vào session
                } else {
                    request.setAttribute("error", "Artist not found!");
                }

                TrackDAO trackDAO = new TrackDAO();
                List<Track> artistTracks = trackDAO.getTracksByArtistId(artID);
                session.setAttribute("artistTracks", artistTracks);

                List<Album> artistAlbums = artistDAO.getAlbumsByArtistId(artID);
                if (artistAlbums != null && !artistAlbums.isEmpty()) {
                    System.out.println("✅ Đã lấy " + artistAlbums.size() + " album cho nghệ sĩ ID: " + artID);
                    for (Album album : artistAlbums) {
                        System.out.println("Album: " + album.getTitle() + ", ID: " + album.getAlbumID() + ", ArtistID: "
                                + album.getArtistID());
                    }
                } else {
                    System.out.println("❌ Không có album nào cho nghệ sĩ ID: " + artID);
                }
                session.setAttribute("artistAlbums", artistAlbums);

            } catch (Exception e) {
                request.setAttribute("error", "Invalid Artist ID!");
            }
        } else {
            request.setAttribute("error", "Artist ID is required!");
        }
    }

    /*-----------------------------------Lấy thông tin album-----------------------------------------------------------*/
    private void handleAlbumInfor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String albumID = request.getParameter("id");
        HttpSession session = request.getSession();

        if (albumID != null) {
            try {
                int alID = Integer.parseInt(albumID);
                Album album = artistDAO.getAlbumById(alID);

                if (album != null) {
                    int artistID = album.getArtistID(); // Lấy ID của artist từ album
                    Artist artist = artistDAO.getArtistById(artistID); // Lấy thông tin artist

                    // Lưu đối tượng artist vào session
                    session.setAttribute("artist", artist);
                    session.setAttribute("album", album); // Lưu thông tin album vào session
                    session.setAttribute("artistId", artistID); // Lưu artistID vào session

                    // Lấy danh sách tracks của artist thông qua Track_Artists
                    TrackDAO trackDAO = new TrackDAO();
                    List<Track> albumTracks = trackDAO.getTracksByArtistId(artistID);
                    session.setAttribute("tracks", albumTracks);

                    // Lấy danh sách albums khác của cùng artist
                    List<Album> artistAlbums = artistDAO.searchAlbums(null, String.valueOf(artistID));
                    session.setAttribute("artistAlbums", artistAlbums);
                } else {
                    request.setAttribute("error", "Album not found!");
                }
            } catch (Exception e) {
                request.setAttribute("error", "Invalid Album ID!");
            }
        } else {
            request.setAttribute("error", "Album ID is required!");
        }
    }

    /*-----------------------------------Lấy thông tin track-----------------------------------------------------------*/
    private void handleTrackInfo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String trackId = request.getParameter("id");
        HttpSession session = request.getSession();

        if (trackId != null) {
            try {
                int trkID = Integer.parseInt(trackId);
                TrackDAO trackDAO = new TrackDAO();
                Track track = trackDAO.getTrackById(trkID);

                session.setAttribute("trackId", trkID); // Lưu ID vào session

                if (track != null) {
                    session.setAttribute("track", track); // Lưu thông tin track vào session

                    // Nếu track có artists, lấy artist đầu tiên để hiển thị
                    if (track.getArtists() != null && !track.getArtists().isEmpty()) {
                        Artist firstArtist = track.getArtists().get(0);
                        session.setAttribute("artist", firstArtist);

                        // Lấy danh sách albums của artist này
                        ArtistDAO artistDAO = new ArtistDAO();
                        List<Album> artistAlbums = artistDAO.searchAlbums(null,
                                String.valueOf(firstArtist.getArtistID()));
                        session.setAttribute("artistAlbums", artistAlbums);

                        // Lấy danh sách các track khác của artist này
                        List<Track> artistTracks = trackDAO.searchTracks(null, firstArtist.getName(), null,
                                "releaseDate");
                        // Loại bỏ track hiện tại khỏi danh sách
                        artistTracks.removeIf(t -> t.getTrackID() == trkID);
                        // Giới hạn số lượng track hiển thị (tối đa 3 track)
                        if (artistTracks.size() > 3) {
                            artistTracks = artistTracks.subList(0, 3);
                        }
                        session.setAttribute("artistTracks", artistTracks);
                    }
                } else {
                    request.setAttribute("error", "Track not found!");
                }
            } catch (Exception e) {
                request.setAttribute("error", "Invalid Track ID!");
            }
        } else {
            request.setAttribute("error", "Track ID is required!");
        }
    }

    /*-----------------------------------Xử lý hiển thị bài hát theo thể loại-----------------------------------------------------------*/
    private void handleGenreView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String genreId = request.getParameter("id");

        if (genreId != null) {
            try {
                int genreID = Integer.parseInt(genreId);
                Genre genre = trackDAO.getGenreById(genreID);
                if (genre != null) {
                    // Lấy danh sách bài hát theo thể loại
                    List<Track> tracks = trackDAO.searchTracks(null, null, genreID, "releaseDate");
                    request.setAttribute("selectedGenre", genre);
                    request.setAttribute("tracks", tracks);

                    // Lấy danh sách tất cả thể loại để hiển thị menu
                    List<Genre> allGenres = trackDAO.getAllGenres();
                    request.setAttribute("genres", allGenres);

                    request.getRequestDispatcher("/view/home/genre.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/home/search");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/home/search");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/home/search");
        }
    }

    /*-----------------------------------Xử lý hiển thị tất cả nghệ sĩ-----------------------------------------------------------*/
    private void handleAllArtists(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ArtistDAO dao = new ArtistDAO();
        List<Artist> artists = dao.getArtists();
        request.setAttribute("allArtists", artists);
        request.getRequestDispatcher("/view/home/all-artists.jsp").forward(request, response);
    }

    /*-----------------------------------Xử lý hiển thị tất cả album-----------------------------------------------------------*/
    private void handleAllAlbums(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ArtistDAO dao = new ArtistDAO();
        List<Album> albums = dao.getAlbums();
        request.setAttribute("allAlbums", albums);
        request.getRequestDispatcher("/view/home/all-albums.jsp").forward(request, response);
    }

    private void handleArtistTracks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Code to handle artist-tracks endpoint
        String artistId = request.getParameter("id");
        if (artistId != null) {
            try {
                int artID = Integer.parseInt(artistId);
                TrackDAO trackDAO = new TrackDAO();
                ArtistDAO artistDAO = new ArtistDAO();
                Artist artist = artistDAO.getArtistById(artID);
                List<Track> artistTracks = trackDAO.getTracksByArtistId(artID);
                request.setAttribute("artistTracks", artistTracks);
                request.setAttribute("artist", artist);
                request.getRequestDispatcher("/view/home/artist-tracks.jsp").forward(request, response);
            } catch (Exception e) {
                request.setAttribute("error", "Invalid Artist ID!");
            }
        } else {
            request.setAttribute("error", "Artist ID is required!");
        }
    }

    private void handleArtistAlbums(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Code to handle artist-albums endpoint
        String artistId = request.getParameter("id");
        if (artistId != null) {
            try {
                int artID = Integer.parseInt(artistId);
                ArtistDAO artistDAO = new ArtistDAO();
                Artist artist = artistDAO.getArtistById(artID);
                List<Album> artistAlbums = artistDAO.getAlbumsByArtistId(artID);
                request.setAttribute("artistAlbums", artistAlbums);
                request.setAttribute("artist", artist);
                request.getRequestDispatcher("/view/home/artist-albums.jsp").forward(request, response);
            } catch (Exception e) {
                request.setAttribute("error", "Invalid Artist ID!");
            }
        } else {
            request.setAttribute("error", "Artist ID is required!");
        }
    }

    /*-----------------------------------Xử lý hiển thị thư viện-----------------------------------------------------------*/
    private void handleLibraryView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId != null) {
            List<Playlist> playlists = playlistDAO.getPlaylistsByUserId(userId);
            System.out.println("✅ Đã lấy " + playlists.size() + " playlist cho user ID: " + userId);
            for (Playlist playlist : playlists) {
                System.out.println("Playlist: " + playlist.getTitle() + ", ID: " + playlist.getPlaylistID()
                        + ", TrackCount: " + playlist.getTrackCount());
            }
            request.setAttribute("playlists", playlists);
            request.getRequestDispatcher("/view/home/library.jsp").forward(request, response);
        } else {
            System.out.println("❌ Không tìm thấy user ID trong session");
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    /*-----------------------------------Xử lý hiển thị chi tiết playlist-----------------------------------------------------------*/
    private void handlePlaylistView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String playlistId = request.getParameter("id");
        HttpSession session = request.getSession();

        if (playlistId != null) {
            try {
                int plID = Integer.parseInt(playlistId);

                // Lấy thông tin playlist
                List<Playlist> playlists = playlistDAO.getPlaylistsByUserId((Integer) session.getAttribute("userId"));
                Playlist currentPlaylist = null;
                for (Playlist p : playlists) {
                    if (p.getPlaylistID() == plID) {
                        currentPlaylist = p;
                        break;
                    }
                }

                if (currentPlaylist != null) {
                    // Lấy danh sách bài hát trong playlist
                    List<Track> tracks = playlistDAO.getTracksInPlaylist(plID);

                    // Set attributes
                    request.setAttribute("playlist", currentPlaylist);
                    request.setAttribute("tracks", tracks);

                    // Forward to playlist view
                    request.getRequestDispatcher("/view/home/playlist.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/home/library");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/home/library");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/home/library");
        }
    }

    /*-----------------------------------Xử lý lấy danh sách bài hát trong playlist-----------------------------------------------------------*/
    private void handleGetPlaylistTracks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String playlistId = request.getParameter("id");

        if (playlistId != null) {
            try {
                int plID = Integer.parseInt(playlistId);
                List<Track> tracks = playlistDAO.getTracksInPlaylist(plID);

                // Convert tracks to JSON format
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < tracks.size(); i++) {
                    Track track = tracks.get(i);
                    json.append("{")
                            .append("\"trackID\":").append(track.getTrackID()).append(",")
                            .append("\"title\":\"").append(track.getTitle().replace("\"", "\\\"")).append("\",")
                            .append("\"imageUrl\":\"").append(track.getImageUrl()).append("\",")
                            .append("\"fileUrl\":\"").append(track.getFileUrl()).append("\",")
                            .append("\"record\":").append(track.getRecord())
                            .append("}");
                    if (i < tracks.size() - 1) {
                        json.append(",");
                    }
                }
                json.append("]");

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(json.toString());
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid playlist ID");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Playlist ID is required");
        }
    }

    private void handleCreatePlaylist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            // Get user ID from session
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                session.setAttribute("message", "Please login to create a playlist");
                session.setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Get playlist data from request
            String title = request.getParameter("playlistName");
            System.out.println("title: " + title);
            String trackIdsStr = request.getParameter("selectedSongsList");
            System.out.println("trackIdsStr: " + trackIdsStr);

            if (title == null || title.trim().isEmpty()) {
                session.setAttribute("message", "Playlist name is required");
                session.setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/home/create-playlist");
                return;
            }

            // Parse track IDs from comma-separated string
            List<Integer> trackIds = new ArrayList<>();
            if (trackIdsStr != null && !trackIdsStr.isEmpty()) {
                String[] trackIdArray = trackIdsStr.split(",");
                for (String trackId : trackIdArray) {
                    try {
                        trackIds.add(Integer.parseInt(trackId.trim()));
                    } catch (NumberFormatException e) {
                        // Skip invalid track IDs
                        continue;
                    }
                }
            }

            // Create playlist
            PlaylistDAO playlistDAO = new PlaylistDAO();
            int newPlaylistId = playlistDAO.createPlaylist(userId, title, trackIds);

            if (newPlaylistId > 0) {
                session.setAttribute("message", "Playlist created successfully!");
                session.setAttribute("messageType", "success");
                response.sendRedirect(request.getContextPath() + "/home/library");
            } else {
                session.setAttribute("message", "Failed to create playlist");
                session.setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/home/create-playlist");
            }

        } catch (Exception e) {
            session.setAttribute("message", "Error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/home/create-playlist");
        }
    }

    private void handleGetTracks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get all tracks from database
            List<Track> tracks = trackDAO.getAllTracks();

            // Set tracks as request attribute
            request.setAttribute("tracks", tracks);

            // Forward to create-playlist.jsp
            request.getRequestDispatcher("/view/home/create-playlist.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/view/home/create-playlist.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

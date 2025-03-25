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
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpSession;
import model.Album;
import model.Artist;
import model.Track;
import model.Genre;

/**
 *
 * @author HP
 */
public class HomeServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private ArtistDAO artistDAO;
     private TrackDAO trackDAO;

    @Override
    public void init() throws ServletException {
        artistDAO = new ArtistDAO();
        trackDAO = new TrackDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();  // Lấy đường dẫn URL

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
                request.getRequestDispatcher("/view/home/library.jsp").forward(request, response);
                break;
            case "/home/create-playlist":
                request.getRequestDispatcher("/view/home/create-playlist.jsp").forward(request, response);
                break;
            case "/home/liked-songs":
                request.getRequestDispatcher("/view/home/likedSongs.jsp").forward(request, response);
                break;
            case "/home/topsong":
                TrackDAO trackDAO = new TrackDAO();
                // Fetch top tracks
                List<Track> topTracks = trackDAO.getTopTracksByPlayCount(10); // Fetch top 8 tracks
                // Set the list of tracks as a request attribute
                request.setAttribute("topTracks", topTracks);
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
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
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
            
            // Check if this is a play count update request
            String action = request.getParameter("action");
            if ("setPlayingTrack".equals(action)) {
                try {
                    String trackIdStr = request.getParameter("trackId");
                    if (trackIdStr != null && !trackIdStr.isEmpty()) {
                        int trackId = Integer.parseInt(trackIdStr);
                        
                        // Set the session attribute to trigger the listener
                        // The PlayRecordListener will handle incrementing the play count
                        request.getSession().setAttribute("currentPlayingTrackId", trackId);
                        
                        // Return success response
                        response.setContentType("application/json");
                        response.getWriter().write("{\"success\": true}");
                        return; // Return early to avoid forwarding to JSP
                    }
                } catch (NumberFormatException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\": \"Invalid trackId format\"}");
                    return;
                }
            }
            
            // If not a play count update, forward to the JSP
            request.getRequestDispatcher("/view/home/tracks.jsp").forward(request, response);
        } else {
            // Xử lý các đường dẫn khác nếu cần
            doGet(request, response);
        }
    }


    /*------------------------------------Lấy danh sách Artists-----------------------------------------------------*/
    private void handleViewArtist(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ArtistDAO dao = new ArtistDAO();
        List<Artist> artists = dao.getArtists();
        request.setAttribute("artist", artists);
    }

    /*------------------------------------Lấy danh sách Albums-----------------------------------------------------*/
    private void handleViewAlbum(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ArtistDAO dao = new ArtistDAO();
        List<Album> albums = dao.getAlbums();
        request.setAttribute("album", albums);
    }

    /*-----------------------------------Lấy thông tin artist-----------------------------------------------------------*/
    private void handleArtistInfor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String artistId = request.getParameter("id");
        HttpSession session = request.getSession();

        // Xóa dữ liệu cũ liên quan đến artist và album
        session.removeAttribute("artistTracks");
        session.removeAttribute("artistAlbums");
        session.removeAttribute("tracks");

        if (artistId != null) {
            try {
                int artID = Integer.parseInt(artistId);
                Artist artist = artistDAO.getArtistById(artID);

                session.setAttribute("artistId", artID);  // Lưu ID vào session

                if (artist != null) {
                    session.setAttribute("artist", artist); // Lưu thông tin artist vào session
                } else {
                    request.setAttribute("error", "Artist not found!");
                }

                TrackDAO trackDAO = new TrackDAO();
// Lấy top 5 tracks có lượt nghe cao nhất của artist
                List<Track> artistTopTracks = trackDAO.getTopTracksByArtistId(artID, 5);
                session.setAttribute("artistTopTracks", artistTopTracks);

// Lấy tất cả tracks của artist
                List<Track> artistTracks = trackDAO.getTracksByArtistId(artID);
                session.setAttribute("artistTracks", artistTracks);

                List<Album> artistAlbums = artistDAO.getAlbumsByArtistId(artID);
                if (artistAlbums != null && !artistAlbums.isEmpty()) {
                    System.out.println("✅ Đã lấy " + artistAlbums.size() + " album cho nghệ sĩ ID: " + artID);
                    for (Album album : artistAlbums) {
                        System.out.println("Album: " + album.getTitle() + ", ID: " + album.getAlbumID() + ", ArtistID: " + album.getArtistID());
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

        session.removeAttribute("artistTracks");
        session.removeAttribute("artistAlbums");
        session.removeAttribute("tracks");
        session.removeAttribute("artist");
        session.removeAttribute("album");
        session.removeAttribute("artistId");

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
                    session.setAttribute("artistId", artistID);  // Lưu artistID vào session

                    // Lấy danh sách tracks của album thông qua Albums_Tracks
                    TrackDAO trackDAO = new TrackDAO();
                    List<Track> albumTracks = trackDAO.getTracksByAlbumId(alID);
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

                session.setAttribute("trackId", trkID);  // Lưu ID vào session

                if (track != null) {
                    session.setAttribute("track", track); // Lưu thông tin track vào session

                    // Nếu track có artists, lấy artist đầu tiên để hiển thị
                    if (track.getArtists() != null && !track.getArtists().isEmpty()) {
                        Artist firstArtist = track.getArtists().get(0);
                        session.setAttribute("artist", firstArtist);

                        // Lấy danh sách albums của artist này
                        ArtistDAO artistDAO = new ArtistDAO();
                        List<Album> artistAlbums = artistDAO.searchAlbums(null, String.valueOf(firstArtist.getArtistID()));
                        session.setAttribute("artistAlbums", artistAlbums);

                        // Lấy danh sách các track khác của artist này
                        List<Track> artistTracks = trackDAO.searchTracks(null, firstArtist.getName(), null, "releaseDate");
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

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

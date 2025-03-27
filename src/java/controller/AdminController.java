package controller;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import dao.AlbumDAO;
import dao.ArtistDAO;
import dao.OrderDAO;
import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.*;
import java.io.File;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.http.Part;
import java.text.SimpleDateFormat;
import java.sql.*;
import dao.TrackDAO;
import java.util.ArrayList;

/**
 *
 * @author Welcome
 */
public class AdminController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

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
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String path = request.getServletPath(); // Lấy đường dẫn URL

        if (path == null) {
            path = "/admin"; // Default action
        }
        if (action != null) {
            switch (action) {
                case "add-artist":
                    handleAddArtist(request, response);
                    break;
                case "edit-artist":
                    handleEditArtist(request, response);
                    break;
                case "delete-artist":
                    handleDeleteArtist(request, response);
                    break;
                case "get-track":
                    getTrackDetails(request, response);
                    break;
                case "delete-user":
                    handleDeleteUser(request, response);
                    break;
                case "logout":
                    handleLogout(request, response);
                    break;
                case "get-album":
                    getAlbumDetails(request, response);
                    break;
                case "delete-album":
                    handleDeleteAlbum(request, response);
                    break;
                case "get-artist-tracks":
                    getArtistTracks(request, response);
                    break;
                case "track-management":
                    handleTrackManagement(request, response);
                    break;
                case "album-management":
                    handleAlbumManagement(request, response);
                    break;
                case "artist-management":
                    handleArtistManagement(request, response);
                    break;
                case "user-management":
                    handleUserManagement(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } else {
            switch (path) {
                case "/admin":
                    handleDashboard(request, response);
                    break;
                case "/admin/usermanagement":
                    handleUserManagement(request, response);
                    break;
                case "/admin/orders":
                    handleOrderManagement(request, response);
                    break;
                case "/admin/tracks":
                    handleTrackManagement(request, response);
                    break;
                case "/admin/tracks/get-track":
                    getTrackDetails(request, response);
                    break;
                case "/admin/albums":
                    handleAlbumManagement(request, response);
                    break;
                case "/admin/artists":
                    handleArtistManagement(request, response);
                    break;
                case "/admin/artists/edit-artist":
                    handleEditArtist(request, response);
                    break;
                case "/admin/artists/delete":
                    handleDeleteArtist(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        }
    }

    private void handleDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy thông tin tổng số người dùng
        UserDAO userDAO = new UserDAO();
        List<User> users = userDAO.getAllUsers();
        int totalUsers = users.size();

        // Lấy thông tin tổng số bài hát
        TrackDAO trackDAO = new TrackDAO();
        int totalTracks = trackDAO.countTotalTracks();

        // Lấy danh sách nghệ sĩ
        ArtistDAO artistDAO = new ArtistDAO();
        List<Artist> artists = artistDAO.getArtists();
        int totalArtists = artists.size();

        // Lấy danh sách album
        AlbumDAO albumDAO = new AlbumDAO();
        List<Album> albums = albumDAO.getAllAlbums();
        int totalAlbums = albums.size();

        // Đếm số người dùng premium
        int premiumUsers = 0;
        for (User user : users) {
            if (user.getPremiumExpiry() != null) {
                premiumUsers++;
            }
        }

        // Giới hạn danh sách người dùng cho dashboard (hiển thị 10 người dùng mới nhất)
        List<User> recentUsers = users;
        if (users.size() > 10) {
            recentUsers = users.subList(0, 10);
        }

        // Đặt các thuộc tính cho JSP
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalTracks", totalTracks);
        request.setAttribute("premiumUsers", premiumUsers);
        request.setAttribute("totalAlbums", totalAlbums);
        request.setAttribute("totalArtists", totalArtists);
        request.setAttribute("users", recentUsers);
        request.setAttribute("currentPage", "dashboard");

        request.getRequestDispatcher("/view/dashboard/dashboard.jsp").forward(request, response);
    }

    private void handleUserManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserDAO dao = new UserDAO();

        String searchTerm = request.getParameter("search");
        String roleFilter = request.getParameter("role");

        List<User> users;
        if ((searchTerm != null && !searchTerm.trim().isEmpty())
                || (roleFilter != null && !roleFilter.trim().isEmpty())) {
            users = dao.searchUsers(searchTerm, roleFilter);
        } else {
            users = dao.getAllUsers();
        }

        request.setAttribute("users", users);
        request.setAttribute("currentPage", "user-management");
        request.getRequestDispatcher("/view/dashboard/user_management.jsp").forward(request, response);
    }

    private void handleOrderManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            OrderDAO orderDAO = new OrderDAO();
            List<OrderDetail> orders = orderDAO.getAllOrderDetails();

            request.setAttribute("orders", orders);
            request.setAttribute("currentPage", "order-management");
            request.getRequestDispatcher("/view/dashboard/order_management.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading orders");
        }
    }

    private void handleTrackManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        TrackDAO trackDAO = new TrackDAO();
        ArtistDAO artistDAO = new ArtistDAO();

        // Get search parameters
        String searchTerm = request.getParameter("search");
        String genreFilter = request.getParameter("genreFilter");
        String sortBy = request.getParameter("sortBy");

        // Phân trang - lấy thông tin trang hiện tại
        int page = 1;
        int tracksPerPage = 10;
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
                if (page < 1) {
                    page = 1;
                }
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        // Chuyển đổi genreFilter thành Integer nếu có
        Integer genreId = null;
        if (genreFilter != null && !genreFilter.trim().isEmpty()) {
            try {
                genreId = Integer.parseInt(genreFilter);
            } catch (NumberFormatException e) {
                // Bỏ qua lỗi nếu genreId không phải là số
            }
        }

        // Get tracks based on search criteria
        List<Track> allTracks;

        if ((searchTerm != null && !searchTerm.trim().isEmpty()) || genreId != null) {
            // Search tracks with filters
            allTracks = trackDAO.searchTracks(searchTerm, null, genreId, sortBy);
        } else {
            // Get all tracks if no search criteria
            allTracks = trackDAO.getAllTracks();
        }

        // Tính toán thông tin phân trang
        int totalTracks = allTracks.size();
        int totalPages = (int) Math.ceil((double) totalTracks / tracksPerPage);
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        // Lấy danh sách bài hát cho trang hiện tại
        int startIdx = (page - 1) * tracksPerPage;
        int endIdx = Math.min(startIdx + tracksPerPage, totalTracks);
        List<Track> tracks = (startIdx < totalTracks)
                ? allTracks.subList(startIdx, endIdx)
                : new ArrayList<Track>();

        // Get all genres for filter dropdown
        List<Genre> genres = trackDAO.getAllGenres();

        // Get all artists for the form
        List<Artist> artists = artistDAO.getArtists();

        // Set attributes for JSP
        request.setAttribute("tracks", tracks);
        request.setAttribute("genres", genres);
        request.setAttribute("artists", artists);
        request.setAttribute("currentPage", "track-management");

        // Thêm thông tin phân trang
        request.setAttribute("currentPageNum", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalTracks", totalTracks);

        request.getRequestDispatcher("/view/dashboard/track_management.jsp").forward(request, response);
    }

    private void handleAlbumManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ArtistDAO dao = new ArtistDAO();

        String searchTerm = request.getParameter("search");
        String artistFilter = request.getParameter("artistFilter");

        List<Album> albums;
        if ((searchTerm != null && !searchTerm.trim().isEmpty())
                || (artistFilter != null && !artistFilter.trim().isEmpty())) {
            albums = dao.searchAlbums(searchTerm, artistFilter);
        } else {
            albums = dao.getAlbums();
        }

        List<Artist> artists = dao.getArtists();

        request.setAttribute("albums", albums);
        request.setAttribute("artists", artists);
        request.setAttribute("currentPage", "album-management");
        request.getRequestDispatcher("/view/dashboard/album_management.jsp").forward(request, response);
    }

    private void handleArtistManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ArtistDAO dao = new ArtistDAO();

        String searchTerm = request.getParameter("search");

        List<Artist> artists;
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            artists = dao.searchArtists(searchTerm);
        } else {
            artists = dao.getArtists();
        }

        request.setAttribute("artists", artists);
        request.setAttribute("currentPage", "artist-management");
        request.getRequestDispatcher("/view/dashboard/artist_management.jsp").forward(request, response);
    }

    private void handleEditArtist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int artistId = Integer.parseInt(request.getParameter("id"));
            ArtistDAO dao = new ArtistDAO();
            Artist artist = dao.getArtistById(artistId);

            if (artist != null) {
                // Trả về dữ liệu JSON thay vì forward đến JSP
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                // Tạo JSON object
                StringBuilder json = new StringBuilder();
                json.append("{");
                json.append("\"artistID\":").append(artist.getArtistID()).append(",");
                json.append("\"name\":\"").append(escapeJson(artist.getName())).append("\",");
                json.append("\"gender\":\"").append(escapeJson(artist.getGender())).append("\",");
                json.append("\"description\":\"")
                        .append(artist.getDescription() != null ? escapeJson(artist.getDescription()) : "")
                        .append("\",");
                json.append("\"imageUrl\":\"")
                        .append(artist.getImageUrl() != null ? escapeJson(artist.getImageUrl()) : "").append("\"");
                json.append("}");

                response.getWriter().write(json.toString());
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Artist not found\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid artist ID\"}");
        }
    }

    // Helper method to escape JSON strings
    private String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    private void handleDeleteArtist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int artistId = Integer.parseInt(request.getParameter("id"));
            ArtistDAO dao = new ArtistDAO();

            if (dao.deleteArtist(artistId)) {
                response.sendRedirect(request.getContextPath() + "/admin/artists");
            } else {
                request.setAttribute("error", "Failed to delete artist");
                handleArtistManagement(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/artists");
        }
    }

    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            UserDAO userDAO = new UserDAO();
            boolean success = userDAO.deleteUser(userId);

            if (success) {
                response.sendRedirect(
                        request.getContextPath() + "/admin?action=user-management&message=delete_success");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin?action=user-management&message=delete_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin?action=user-management&message=invalid_id");
        }
    }

    // -----------------POST-----------------//
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        switch (action) {
            case "add-track":
                handleAddTrack(request, response);
                break;
            case "update-track":
                handleUpdateTrack(request, response);
                break;
            case "delete-track":
                handleDeleteTrack(request, response);
                break;
            case "add-artist":
                handleAddArtist(request, response);
                break;
            case "update-artist":
                handleUpdateArtist(request, response);
                break;
            case "delete-artist":
                handleDeleteArtist(request, response);
                break;
            case "add-album":
                handleAddAlbum(request, response);
                break;
            case "update-album":
                handleUpdateAlbum(request, response);
                break;
            case "delete-album":
                handleDeleteAlbum(request, response);
                break;
            case "logout":
                handleLogout(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    private void handleAddArtist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String name = request.getParameter("name");
            String gender = request.getParameter("gender");
            String description = request.getParameter("description");

            Part filePart = request.getPart("image");
            // Không thêm timestamp cho file hình ảnh
            String fileName = getSubmittedFileName(filePart);
            String uploadPath = getServletContext().getRealPath("image/");

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String filePath = uploadPath + fileName;
            filePart.write(filePath);

            ArtistDAO dao = new ArtistDAO();
            String imageUrl = "image/" + fileName;
            int newArtistId = dao.addNewArtist(name, gender, description, imageUrl);

            if (newArtistId != -1) {
                response.sendRedirect(request.getContextPath() + "/admin/artists");
            } else {
                request.setAttribute("error", "Failed to add artist");
                request.getRequestDispatcher("/view/dashboard/artist_management.jsp").forward(request, response);
            }

        } catch (Exception e) {
            Logger.getLogger(AdminController.class.getName())
                    .log(Level.SEVERE, "Error adding artist: {0}", e.getMessage());
            request.setAttribute("error", "Error occurred while adding artist");
            request.getRequestDispatcher("/view/dashboard/artist_management.jsp").forward(request, response);
        }
    }

    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }

    private void handleUpdateArtist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int artistId = Integer.parseInt(request.getParameter("artistId"));
            String name = request.getParameter("name");
            String gender = request.getParameter("gender");
            String description = request.getParameter("description");

            String imageUrl = null;
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                // Không thêm timestamp cho file hình ảnh
                String fileName = getSubmittedFileName(filePart);
                String uploadPath = getServletContext().getRealPath("image/");

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String filePath = uploadPath + fileName;
                filePart.write(filePath);
                imageUrl = "image/" + fileName;
            }

            ArtistDAO dao = new ArtistDAO();
            if (dao.updateArtist(artistId, name, gender, description, imageUrl)) {
                response.sendRedirect(request.getContextPath() + "/admin/artists");
            } else {
                request.setAttribute("error", "Failed to update artist");
                handleEditArtist(request, response);
            }
        } catch (Exception e) {
            Logger.getLogger(AdminController.class.getName())
                    .log(Level.SEVERE, "Error updating artist: {0}", e.getMessage());
            request.setAttribute("error", "Error occurred while updating artist");
            handleEditArtist(request, response);
        }
    }

    private void handleAddAlbum(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy các tham số từ form
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String releaseDateStr = request.getParameter("releaseDate");
            String[] trackIDStrings = request.getParameterValues("trackID[]");
            String artistParam = request.getParameter("artistID");

            // Validate các trường bắt buộc
            if (title == null || title.trim().isEmpty() ||
                    artistParam == null || artistParam.trim().isEmpty() ||
                    releaseDateStr == null || releaseDateStr.trim().isEmpty()) {

                request.setAttribute("errorMessage", "Please fill in all required fields");
                request.getRequestDispatcher("/view/dashboard/album_management.jsp").forward(request, response);
                return;
            }

            // Chuyển đổi ngày
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date utilDate = dateFormat.parse(releaseDateStr);
            java.sql.Date releaseDate = new java.sql.Date(utilDate.getTime());

            // Chuyển đổi artistID
            int artistID = Integer.parseInt(artistParam);

            // Chuyển đổi danh sách trackID
            List<Integer> trackIDs = new ArrayList<>();
            if (trackIDStrings != null) {
                for (String trackIDStr : trackIDStrings) {
                    if (trackIDStr != null && !trackIDStr.trim().isEmpty()) {
                        try {
                            trackIDs.add(Integer.parseInt(trackIDStr.trim()));
                        } catch (NumberFormatException e) {
                            Logger.getLogger(AdminController.class.getName())
                                    .log(Level.WARNING, "Invalid track ID: " + trackIDStr);
                        }
                    }
                }
            }

            // Xử lý upload ảnh
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getSubmittedFileName(filePart);
                String uploadPath = getServletContext().getRealPath("image/");

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                filePart.write(uploadPath + File.separator + fileName);
                String imageUrl = "image/" + fileName;

                // Thêm album mới
                AlbumDAO albumDAO = new AlbumDAO();
                boolean success = albumDAO.addAlbum(title, releaseDate, description, artistID, imageUrl, trackIDs);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/admin/albums");
                } else {
                    request.setAttribute("errorMessage", "Failed to add album. Please try again.");
                    request.getRequestDispatcher("/view/dashboard/album_management.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Please select an album cover image.");
                request.getRequestDispatcher("/view/dashboard/album_management.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid number format: " + e.getMessage());
            request.getRequestDispatcher("/view/dashboard/album_management.jsp").forward(request, response);
        } catch (Exception e) {
            Logger.getLogger(AdminController.class.getName())
                    .log(Level.SEVERE, "Error adding album", e);
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/view/dashboard/album_management.jsp").forward(request, response);
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Hủy session
        }
        response.sendRedirect(request.getContextPath()); // Chuyển về trang đăng nhập sau khi logout
    }

    private void handleDeleteTrack(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int trackId = Integer.parseInt(request.getParameter("trackId"));
            TrackDAO trackDAO = new TrackDAO();
            boolean success = trackDAO.deleteTrack(trackId);

            if (success) {
                // request.getSession().setAttribute("message", "Track deleted successfully");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Failed to delete track");
                request.getSession().setAttribute("messageType", "error");
            }

            response.sendRedirect(request.getContextPath() + "/admin/tracks");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid track ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error deleting track");
        }
    }

    private void handleAddTrack(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get basic track information
            String title = request.getParameter("name");

            // Parse release date if provided
            Date releaseDate = null;
            String releaseDateStr = request.getParameter("releaseDate");
            if (releaseDateStr != null && !releaseDateStr.isEmpty()) {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                releaseDate = new java.sql.Date(dateFormat.parse(releaseDateStr).getTime());
            }

            // Get record count (default to 0 if not provided)
            int record = 0;
            if (request.getParameter("record") != null && !request.getParameter("record").isEmpty()) {
                record = Integer.parseInt(request.getParameter("record"));
            }

            // Handle file upload for image
            Part imagePart = request.getPart("image");
            String originalImageName = getSubmittedFileName(imagePart);
            // Không thêm timestamp cho file hình ảnh
            String imageFileName = originalImageName;
            String imageUploadPath = getServletContext().getRealPath("image/");

            // Handle file upload for audio file
            Part audioPart = request.getPart("audioFile");
            // Không thêm timestamp cho file audio
            String audioFileName = getSubmittedFileName(audioPart);
            String audioUploadPath = getServletContext().getRealPath("music/");

            // Create directories if they don't exist
            File imageUploadDir = new File(imageUploadPath);
            if (!imageUploadDir.exists()) {
                imageUploadDir.mkdirs();
            }

            File audioUploadDir = new File(audioUploadPath);
            if (!audioUploadDir.exists()) {
                audioUploadDir.mkdirs();
            }

            // Write files to disk
            imagePart.write(imageUploadPath + File.separator + imageFileName);
            audioPart.write(audioUploadPath + File.separator + audioFileName);

            // Create relative paths for database
            String imageUrl = "image/" + imageFileName;
            String fileUrl = "music/" + audioFileName;

            // Create Track object
            Track track = new Track();
            track.setTitle(title);
            track.setReleaseDate(releaseDate);
            track.setImageUrl(imageUrl);
            track.setFileUrl(fileUrl);
            track.setRecord(record);

            // Get genres (multiple selection)
            String[] genreIds = request.getParameterValues("genres");
            List<Integer> genreIdList = new ArrayList<>();
            if (genreIds != null) {
                for (String genreId : genreIds) {
                    genreIdList.add(Integer.parseInt(genreId));
                }
            }

            // Get artists (multiple selection)
            String[] artistIds = request.getParameterValues("artists");
            List<Integer> artistIdList = new ArrayList<>();
            if (artistIds != null) {
                for (String artistId : artistIds) {
                    artistIdList.add(Integer.parseInt(artistId));
                }
            }

            // Save to database
            TrackDAO trackDAO = new TrackDAO();
            int newTrackId = trackDAO.addTrack(track, genreIdList, artistIdList);

            if (newTrackId > 0) {
                request.getSession().setAttribute("message", "Track added successfully");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Failed to add track");
                request.getSession().setAttribute("messageType", "error");
            }

            response.sendRedirect(request.getContextPath() + "/admin/tracks");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "Error: " + e.getMessage());
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/tracks");
        }
    }

    private void handleUpdateTrack(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get track ID
            int trackId = Integer.parseInt(request.getParameter("trackId"));

            // Get existing track
            TrackDAO trackDAO = new TrackDAO();
            Track track = trackDAO.getTrackById(trackId);

            if (track == null) {
                request.getSession().setAttribute("message", "Track not found");
                request.getSession().setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/tracks");
                return;
            }

            // Update basic track information
            String title = request.getParameter("name");
            track.setTitle(title);

            // Parse release date if provided
            String releaseDateStr = request.getParameter("releaseDate");
            if (releaseDateStr != null && !releaseDateStr.isEmpty()) {
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                Date releaseDate = new java.sql.Date(dateFormat.parse(releaseDateStr).getTime());
                track.setReleaseDate(releaseDate);
            }

            // Get record count (default to current value if not provided)
            if (request.getParameter("record") != null && !request.getParameter("record").isEmpty()) {
                int record = Integer.parseInt(request.getParameter("record"));
                track.setRecord(record);
            }

            // Handle file upload for image if provided
            Part imagePart = request.getPart("image");
            if (imagePart != null && imagePart.getSize() > 0) {
                // Không thêm timestamp cho file hình ảnh
                String imageFileName = getSubmittedFileName(imagePart);
                String imageUploadPath = getServletContext().getRealPath("image/");

                // Create directory if it doesn't exist
                File imageUploadDir = new File(imageUploadPath);
                if (!imageUploadDir.exists()) {
                    imageUploadDir.mkdirs();
                }

                // Write file to disk
                imagePart.write(imageUploadPath + File.separator + imageFileName);

                // Update imageUrl
                track.setImageUrl("image/" + imageFileName);
            }

            // Handle file upload for audio file if provided
            Part audioPart = request.getPart("audioFile");
            if (audioPart != null && audioPart.getSize() > 0) {
                String audioFileName = getSubmittedFileName(audioPart);
                // Không thêm timestamp cho file âm thanh
                String audioUploadPath = getServletContext().getRealPath("music/");

                // Create directory if it doesn't exist
                File audioUploadDir = new File(audioUploadPath);
                if (!audioUploadDir.exists()) {
                    audioUploadDir.mkdirs();
                }

                // Write file to disk
                audioPart.write(audioUploadPath + File.separator + audioFileName);

                // Update fileUrl
                track.setFileUrl("music/" + audioFileName);
            }

            // Get genres (multiple selection)
            String[] genreIds = request.getParameterValues("genres");
            List<Integer> genreIdList = new ArrayList<>();
            if (genreIds != null) {
                for (String genreId : genreIds) {
                    genreIdList.add(Integer.parseInt(genreId));
                }
            }

            // Get artists (multiple selection)
            String[] artistIds = request.getParameterValues("artists");
            List<Integer> artistIdList = new ArrayList<>();
            if (artistIds != null) {
                for (String artistId : artistIds) {
                    artistIdList.add(Integer.parseInt(artistId));
                }
            }

            // Update in database
            boolean success = trackDAO.updateTrack(track, genreIdList, artistIdList);

            if (success) {
                request.getSession().setAttribute("message", "Track updated successfully");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Failed to update track");
                request.getSession().setAttribute("messageType", "error");
            }

            response.sendRedirect(request.getContextPath() + "/admin/tracks");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "Error: " + e.getMessage());
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/tracks");
        }
    }

    private void handleUpdateAlbum(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy thông tin album từ request
            int albumID = Integer.parseInt(request.getParameter("albumId"));
            String title = request.getParameter("name");
            String description = request.getParameter("description");
            java.sql.Date releaseDate = null;

            // Xử lý ngày phát hành
            if (request.getParameter("releaseDate") != null && !request.getParameter("releaseDate").isEmpty()) {
                try {
                    releaseDate = java.sql.Date.valueOf(request.getParameter("releaseDate"));
                } catch (IllegalArgumentException e) {
                    request.getSession().setAttribute("message", "Invalid date format");
                    request.getSession().setAttribute("messageType", "error");
                    response.sendRedirect(request.getContextPath() + "/admin/albums");
                    return;
                }
            }

            // Xử lý upload ảnh
            Part imagePart = request.getPart("image");
            String imageUrl = null;

            if (imagePart != null && imagePart.getSize() > 0) {
                String fileName = getSubmittedFileName(imagePart);
                if (fileName != null && !fileName.isEmpty()) {
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads"
                            + File.separator + "albums";

                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    String filePath = uploadPath + File.separator + fileName;
                    imagePart.write(filePath);
                    imageUrl = "image/" + fileName;
                }
            }

            // Xử lý thông tin nghệ sĩ
            int artistID = -1;
            String artistName = null;

            if (request.getParameter("useArtistName") != null && request.getParameter("useArtistName").equals("on")) {
                artistName = request.getParameter("artist_name");
            } else {
                try {
                    artistID = Integer.parseInt(request.getParameter("artist_id"));
                } catch (NumberFormatException e) {
                    request.getSession().setAttribute("message", "Invalid artist selected");
                    request.getSession().setAttribute("messageType", "error");
                    response.sendRedirect(request.getContextPath() + "/admin/albums");
                    return;
                }
            }

            // Khởi tạo DAO
            AlbumDAO albumDAO = new AlbumDAO();
            ArtistDAO artistDAO = new ArtistDAO();

            // Xử lý nghệ sĩ mới nếu có
            if (artistName != null && !artistName.isEmpty()) {
                Artist newArtist = new Artist();
                newArtist.setName(artistName);
                artistID = artistDAO.changeArtist(newArtist);
            }

            // Lấy thông tin album hiện tại
            Album album = albumDAO.getAlbumById(albumID);
            if (album == null) {
                request.getSession().setAttribute("message", "Album not found");
                request.getSession().setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/albums");
                return;
            }

            // Cập nhật thông tin album
            album.setTitle(title);
            album.setReleaseDate(releaseDate);
            album.setDescription(description);
            if (imageUrl != null) {
                album.setImageUrl(imageUrl);
            }
            if (artistID > 0) {
                album.setArtistID(artistID);
            }

            // Xử lý danh sách track
            List<Integer> trackIDs = new ArrayList<>();
            String[] selectedTracks = request.getParameterValues("trackID[]");
            if (selectedTracks != null) {
                for (String trackID : selectedTracks) {
                    try {
                        trackIDs.add(Integer.parseInt(trackID));
                    } catch (NumberFormatException e) {
                        // Bỏ qua các giá trị không hợp lệ
                        Logger.getLogger(AdminController.class.getName())
                                .log(Level.WARNING, "Invalid track ID: {0}", trackID);
                    }
                }
            }

            // Cập nhật album và tracks trong cơ sở dữ liệu
            boolean success = albumDAO.updateAlbum(album, trackIDs);

            if (success) {
                request.getSession().setAttribute("message", "Album updated successfully");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Failed to update album");
                request.getSession().setAttribute("messageType", "error");
            }

            // Chuyển hướng về trang quản lý album
            response.sendRedirect(request.getContextPath() + "/admin/albums");

        } catch (Exception e) {
            Logger.getLogger(AdminController.class.getName())
                    .log(Level.SEVERE, "Error updating album: {0}", e.getMessage());
            request.getSession().setAttribute("message", "An error occurred: " + e.getMessage());
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/albums");
        }
    }

    private void handleDeleteAlbum(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy ID album cần xóa
            int albumID = Integer.parseInt(request.getParameter("albumId"));

            // Khởi tạo DAO và xóa album
            AlbumDAO albumDAO = new AlbumDAO();
            boolean success = albumDAO.deleteAlbum(albumID);

            if (success) {
                request.getSession().setAttribute("message", "Album deleted successfully");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Failed to delete album");
                request.getSession().setAttribute("messageType", "error");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("message", "Invalid album ID");
            request.getSession().setAttribute("messageType", "error");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "An error occurred: " + e.getMessage());
            request.getSession().setAttribute("messageType", "error");
        }

        // Chuyển hướng trở lại trang quản lý album
        response.sendRedirect(request.getContextPath() + "/admin/albums");
    }

    private void getAlbumDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            int albumId = Integer.parseInt(request.getParameter("id"));
            AlbumDAO albumDAO = new AlbumDAO();
            Album album = albumDAO.getAlbumById(albumId);

            if (album != null) {
                // Tạo JSON string thủ công
                StringBuilder jsonBuilder = new StringBuilder();
                jsonBuilder.append("{");
                jsonBuilder.append("\"albumID\":").append(album.getAlbumID()).append(",");
                jsonBuilder.append("\"title\":\"").append(escapeJson(album.getTitle())).append("\",");

                // Xử lý ngày
                if (album.getReleaseDate() != null) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    jsonBuilder.append("\"releaseDate\":\"").append(sdf.format(album.getReleaseDate())).append("\",");
                } else {
                    jsonBuilder.append("\"releaseDate\":\"\",");
                }

                // Xử lý description có thể null
                if (album.getDescription() != null) {
                    jsonBuilder.append("\"description\":\"").append(escapeJson(album.getDescription())).append("\",");
                } else {
                    jsonBuilder.append("\"description\":\"\",");
                }

                jsonBuilder.append("\"artistID\":").append(album.getArtistID()).append(",");

                // Add trackID if available
                if (album.getTrackID() > 0) {
                    jsonBuilder.append("\"trackID\":").append(album.getTrackID()).append(",");
                }

                // Xử lý imageUrl có thể null
                if (album.getImageUrl() != null) {
                    jsonBuilder.append("\"imageUrl\":\"").append(escapeJson(album.getImageUrl())).append("\"");
                } else {
                    jsonBuilder.append("\"imageUrl\":\"\"");
                }

                jsonBuilder.append("}");

                // Gửi JSON response
                out.print(jsonBuilder.toString());
                out.flush();
            } else {
                // Nếu không tìm thấy album, trả về lỗi
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\":\"Album not found\"}");
                out.flush();
            }
        } catch (NumberFormatException e) {
            // Xử lý lỗi nếu ID không phải số
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Invalid album ID format\"}");
            out.flush();
        } catch (Exception e) {
            // Xử lý các lỗi khác
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Server error: " + escapeJson(e.getMessage()) + "\"}");
            out.flush();
        }
    }

    // Phương thức này lấy chi tiết track và trả về dưới dạng JSON
    private void getTrackDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            int trackId = Integer.parseInt(request.getParameter("id"));
            TrackDAO trackDAO = new TrackDAO();
            Track track = trackDAO.getTrackById(trackId);

            if (track != null) {
                // Tạo JSON string thủ công
                StringBuilder jsonBuilder = new StringBuilder();
                jsonBuilder.append("{");
                jsonBuilder.append("\"trackID\":").append(track.getTrackID()).append(",");
                jsonBuilder.append("\"title\":\"").append(escapeJson(track.getTitle())).append("\",");

                // Xử lý ngày
                if (track.getReleaseDate() != null) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    jsonBuilder.append("\"releaseDate\":\"").append(sdf.format(track.getReleaseDate())).append("\",");
                } else {
                    jsonBuilder.append("\"releaseDate\":\"\",");
                }

                jsonBuilder.append("\"imageUrl\":\"").append(escapeJson(track.getImageUrl())).append("\",");
                jsonBuilder.append("\"fileUrl\":\"").append(escapeJson(track.getFileUrl())).append("\",");

                if (track.getDescription() != null) {
                    jsonBuilder.append("\"description\":\"").append(escapeJson(track.getDescription())).append("\",");
                } else {
                    jsonBuilder.append("\"description\":\"\",");
                }

                jsonBuilder.append("\"record\":").append(track.getRecord()).append(",");

                // Add genres
                jsonBuilder.append("\"genres\":[");
                if (track.getGenres() != null) {
                    for (int i = 0; i < track.getGenres().size(); i++) {
                        Genre genre = track.getGenres().get(i);
                        jsonBuilder.append("{");
                        jsonBuilder.append("\"genreID\":").append(genre.getGenreID()).append(",");
                        jsonBuilder.append("\"genreName\":\"").append(escapeJson(genre.getGenreName())).append("\"");
                        jsonBuilder.append("}");
                        if (i < track.getGenres().size() - 1) {
                            jsonBuilder.append(",");
                        }
                    }
                }
                jsonBuilder.append("],");

                // Add artists
                jsonBuilder.append("\"artists\":[");
                if (track.getArtists() != null) {
                    for (int i = 0; i < track.getArtists().size(); i++) {
                        Artist artist = track.getArtists().get(i);
                        jsonBuilder.append("{");
                        jsonBuilder.append("\"artistID\":").append(artist.getArtistID()).append(",");
                        jsonBuilder.append("\"name\":\"").append(escapeJson(artist.getName())).append("\"");
                        jsonBuilder.append("}");
                        if (i < track.getArtists().size() - 1) {
                            jsonBuilder.append(",");
                        }
                    }
                }
                jsonBuilder.append("]");

                jsonBuilder.append("}");

                // Gửi JSON response
                out.print(jsonBuilder.toString());
                out.flush();
            } else {
                // Nếu không tìm thấy track, trả về lỗi
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\":\"Track not found\"}");
                out.flush();
            }
        } catch (NumberFormatException e) {
            // Xử lý lỗi nếu ID không phải số
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Invalid track ID format\"}");
            out.flush();
        } catch (Exception e) {
            // Xử lý các lỗi khác
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Server error: " + escapeJson(e.getMessage()) + "\"}");
            out.flush();
        }
    }

    // Phương thức này lấy danh sách tracks của một artist và trả về dưới dạng JSON
    private void getArtistTracks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            int artistId = Integer.parseInt(request.getParameter("artistId"));
            TrackDAO trackDAO = new TrackDAO();
            List<Track> tracks = trackDAO.getTracksByArtistId(artistId);

            // Tạo JSON array
            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("[");

            for (int i = 0; i < tracks.size(); i++) {
                Track track = tracks.get(i);
                jsonBuilder.append("{");
                jsonBuilder.append("\"trackID\":").append(track.getTrackID()).append(",");
                jsonBuilder.append("\"title\":\"").append(escapeJson(track.getTitle())).append("\"");
                jsonBuilder.append("}");

                if (i < tracks.size() - 1) {
                    jsonBuilder.append(",");
                }
            }

            jsonBuilder.append("]");

            // Gửi JSON response
            out.print(jsonBuilder.toString());
            out.flush();
        } catch (NumberFormatException e) {
            // Xử lý lỗi nếu ID không phải số
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("[]");
            out.flush();
        } catch (Exception e) {
            // Xử lý các lỗi khác
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("[]");
            out.flush();
            Logger.getLogger(AdminController.class.getName()).log(Level.SEVERE, "Error getting tracks for artist", e);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

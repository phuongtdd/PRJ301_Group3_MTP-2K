package controller;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

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
        if (action == null) {
            action = "dashboard"; // Default action
        }
        switch (action) {
            case "dashboard":
                handleDashboard(request, response);
                break;
            case "user-management":
                handleUserManagement(request, response);
                break;
            case "order-management":
                handleOrderManagement(request, response);
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
            case "edit-artist":
                handleEditArtist(request, response);
                break;
            case "delete-artist":
                handleDeleteArtist(request, response);
                break;
            case "delete-user":
                handleDeleteUser(request, response);
                break;
            case "logout":
                handleLogout(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    private void handleDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("currentPage", "dashboard");
        request.getRequestDispatcher("/view/dashboard/dashboard.jsp").forward(request, response);
    }

    private void handleUserManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserDAO dao = new UserDAO();

        String searchTerm = request.getParameter("search");
        String roleFilter = request.getParameter("role");

        List<User> users;
        if ((searchTerm != null && !searchTerm.trim().isEmpty()) ||
                (roleFilter != null && !roleFilter.trim().isEmpty())) {
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

        request.setAttribute("currentPage", "track-management");
        request.getRequestDispatcher("/view/dashboard/track_management.jsp").forward(request, response);
    }

    private void handleAlbumManagement(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ArtistDAO dao = new ArtistDAO();

        String searchTerm = request.getParameter("search");
        String artistFilter = request.getParameter("artistFilter");

        List<Album> albums;
        if ((searchTerm != null && !searchTerm.trim().isEmpty()) ||
                (artistFilter != null && !artistFilter.trim().isEmpty())) {
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
                response.sendRedirect(request.getContextPath() + "/admin?action=artist-management");
            } else {
                request.setAttribute("error", "Failed to delete artist");
                handleArtistManagement(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin?action=artist-management");
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
            action = "dashboard";
        }

        switch (action) {
            case "add-artist":
                handleAddArtist(request, response);
                break;
            case "update-artist":
                handleUpdateArtist(request, response);
                break;
            case "add-album":
                handleAddAlbum(request, response);
                break;
            default:
                doGet(request, response);
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
            String fileName = System.currentTimeMillis() + "_" + getSubmittedFileName(filePart);
            String uploadPath = getServletContext().getRealPath("/uploads/artists/");

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String filePath = uploadPath + fileName;
            filePart.write(filePath);

            ArtistDAO dao = new ArtistDAO();
            String imageUrl = "uploads/artists/" + fileName;
            int newArtistId = dao.addNewArtist(name, gender, description, imageUrl);

            if (newArtistId != -1) {
                response.sendRedirect(request.getContextPath() + "/admin?action=artist-management");
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
                String fileName = System.currentTimeMillis() + "_" + getSubmittedFileName(filePart);
                String uploadPath = getServletContext().getRealPath("/uploads/artists/");

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String filePath = uploadPath + fileName;
                filePart.write(filePath);
                imageUrl = "uploads/artists/" + fileName;
            }

            ArtistDAO dao = new ArtistDAO();
            if (dao.updateArtist(artistId, name, gender, description, imageUrl)) {
                response.sendRedirect(request.getContextPath() + "/admin?action=artist-management");
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
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String releaseDateStr = request.getParameter("releaseDate");

            String artistParam = request.getParameter("artistID");
            String directArtistName = request.getParameter("directArtistName");

            if (directArtistName != null && !directArtistName.trim().isEmpty()) {
                artistParam = directArtistName;
            }

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            java.util.Date utilDate = dateFormat.parse(releaseDateStr);
            java.sql.Date releaseDate = new java.sql.Date(utilDate.getTime());

            Part filePart = request.getPart("image");
            String fileName = System.currentTimeMillis() + "_" + getSubmittedFileName(filePart);
            String uploadPath = getServletContext().getRealPath("/uploads/albums/");

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            filePart.write(uploadPath + File.separator + fileName);
            String imageUrl = "uploads/albums/" + fileName;

            ArtistDAO dao = new ArtistDAO();
            boolean success;

            try {
                int artistID = Integer.parseInt(artistParam);
                success = dao.addAlbum(title, releaseDate, description, artistID, imageUrl);
            } catch (NumberFormatException e) {
                success = dao.addAlbumByArtistName(artistParam, title, releaseDate, description, imageUrl);
            }

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin?action=album-management");
            } else {
                request.setAttribute("errorMessage", "Failed to add album. Please try again.");
                request.getRequestDispatcher("/view/dashboard/album_management.jsp").forward(request, response);
            }
        } catch (Exception e) {
            Logger.getLogger(AdminController.class.getName()).log(Level.SEVERE, "Error adding album", e);
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/view/dashboard/album_management.jsp").forward(request, response);
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Hủy session
        }
        response.sendRedirect(request.getContextPath() + "/home"); // Chuyển về trang đăng nhập sau khi logout
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

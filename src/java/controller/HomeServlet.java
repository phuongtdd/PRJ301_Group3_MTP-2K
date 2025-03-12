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
import model.Album;
import model.Artist;

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
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy danh sách Artists và Albums từ database
        handleViewArtist(request, response);
        handleViewAlbum(request, response);

        // Điều hướng đến home.jsp
        request.getRequestDispatcher("view/home/home.jsp").forward(request, response);
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

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

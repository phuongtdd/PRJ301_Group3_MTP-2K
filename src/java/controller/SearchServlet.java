package controller;

import com.google.gson.Gson;
import dao.ArtistDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.*;

@WebServlet(name = "SearchServlet", urlPatterns = {"/search"})
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String query = request.getParameter("q");
        boolean isAjax = "true".equals(request.getParameter("ajax"));
        
        System.out.println("Search query: " + query); // Debug log
        System.out.println("Is AJAX: " + isAjax); // Debug log
        
        if (query == null || query.trim().isEmpty()) {
            if (isAjax) {
                sendEmptyJsonResponse(response);
            } else {
                request.getRequestDispatcher("/view/home/search.jsp").forward(request, response);
            }
            return;
        }

        try {
            ArtistDAO dao = new ArtistDAO();
            
            // Get search results
            List<Track> tracks = dao.searchTracksByName(query);
            List<Artist> artists = dao.searchArtists(query);
            List<Album> albums = dao.searchAlbums(query, null);

            System.out.println("Found tracks: " + tracks.size()); // Debug log
            System.out.println("Found artists: " + artists.size()); // Debug log
            System.out.println("Found albums: " + albums.size()); // Debug log

            if (isAjax) {
                // Send JSON response for AJAX requests
                Map<String, Object> jsonResponse = new HashMap<>();
                jsonResponse.put("tracks", tracks);
                jsonResponse.put("artists", artists);
                jsonResponse.put("albums", albums);

                String jsonString = new Gson().toJson(jsonResponse);
                System.out.println("JSON Response: " + jsonString); // Debug log
                System.out.println("JSON Response Length: " + jsonString.length()); // Debug log

                PrintWriter out = response.getWriter();
                out.print(jsonString);
                out.flush();
            } else {
                // Forward to JSP for normal requests
                request.setAttribute("tracks", tracks);
                request.setAttribute("artists", artists);
                request.setAttribute("albums", albums);
                request.setAttribute("searchQuery", query);
                request.getRequestDispatcher("/view/home/search.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.out.println("Error in SearchServlet: " + e.getMessage()); // Debug log
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("error", "An error occurred while searching");
            PrintWriter out = response.getWriter();
            out.print(new Gson().toJson(errorResponse));
            out.flush();
        }
    }

    private void sendEmptyJsonResponse(HttpServletResponse response) throws IOException {
        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("tracks", List.of());
        jsonResponse.put("artists", List.of());
        jsonResponse.put("albums", List.of());

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(new Gson().toJson(jsonResponse));
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

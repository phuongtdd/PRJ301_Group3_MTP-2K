/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.OutputStream;
import java.io.RandomAccessFile;
import java.nio.file.Files;

/**
 *
 * @author HP
 */
@WebServlet("/music/*")
public class MusicServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String filePath = getServletContext().getRealPath("/music/") + request.getPathInfo();
        File file = new File(filePath);

        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String rangeHeader = request.getHeader("Range");
        if (rangeHeader == null) {
            // Trường hợp không có Range Request → Gửi toàn bộ file
            response.setContentType("audio/mpeg");
            response.setContentLengthLong(file.length());
            response.setHeader("Accept-Ranges", "bytes");
            Files.copy(file.toPath(), response.getOutputStream());
        } else {
            // Trường hợp có Range Request → Hỗ trợ tua nhạc
            response.setHeader("Accept-Ranges", "bytes");

            String[] range = rangeHeader.replace("bytes=", "").split("-");
            long start = Long.parseLong(range[0]);
            long end = (range.length > 1 && !range[1].isEmpty()) ? Long.parseLong(range[1]) : file.length() - 1;
            long contentLength = end - start + 1;

            response.setStatus(HttpServletResponse.SC_PARTIAL_CONTENT); // Trả về 206 Partial Content
            response.setContentType("audio/mpeg");
            response.setHeader("Content-Range", "bytes " + start + "-" + end + "/" + file.length());
            response.setContentLengthLong(contentLength);

            try (RandomAccessFile raf = new RandomAccessFile(file, "r"); OutputStream os = response.getOutputStream()) {
                raf.seek(start);
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = raf.read(buffer)) != -1 && contentLength > 0) {
                    os.write(buffer, 0, bytesRead);
                    contentLength -= bytesRead;
                }
            }
        }
    }
}

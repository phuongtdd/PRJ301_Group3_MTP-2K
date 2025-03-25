package filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.User;

@WebFilter(urlPatterns = { "/admin/*", "/admin" })
public class AdminProtectionFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code, if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        boolean isAdmin = false;

        if (isLoggedIn) {
            User user = (User) session.getAttribute("user");
            List<String> roles = user.getRoles();

            // Kiểm tra xem người dùng có role Admin không
            if (roles != null && !roles.isEmpty()) {
                isAdmin = roles.contains("Admin");
            }
        }

        // Nếu người dùng đã đăng nhập và có role Admin, cho phép truy cập
        if (isLoggedIn && isAdmin) {
            chain.doFilter(request, response);
        } else {
            // Nếu không phải Admin, chuyển hướng về trang login
            // Thêm thông báo lỗi vào session
            if (session != null) {
                session.setAttribute("messageType", "error");
            }
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/home");
        }
    }

    @Override
    public void destroy() {
        // Cleanup code, if needed
    }
}
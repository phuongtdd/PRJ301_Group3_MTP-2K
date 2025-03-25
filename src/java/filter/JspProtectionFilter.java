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

/**
 * Filter to prevent direct access to JSP files Redirects any direct JSP access
 * to the home page
 */
@WebFilter(urlPatterns = {"*.jsp"})
public class JspProtectionFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code, if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Get the requested URI
        String requestURI = httpRequest.getRequestURI();

        // Check if the request is directly for a JSP file
        if (requestURI.endsWith(".jsp")) {
            // Redirect to home page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/home");
            return;
        }

        // Continue the filter chain for non-JSP requests
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup code, if needed
    }
}

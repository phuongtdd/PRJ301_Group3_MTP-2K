/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 *
 * @author HP
 */
public class LoginServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
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
        String action = request.getParameter("action");

        if ("logout".equals(action)) {
            handleLogout(request, response);
            return;
        } else if ("forgotPassword".equals(action)) {
            // Display forgot password form
            request.getRequestDispatcher("/view/authentication/forgot_password.jsp").forward(request, response);
            return;
        } else if ("resetPassword".equals(action)) {
            // Display reset password form (after email verification)
            String email = request.getParameter("email");
            String code = request.getParameter("code");

            if (email != null && code != null) {
                request.setAttribute("email", email);
                request.setAttribute("code", code);
                request.getRequestDispatcher("/view/authentication/reset_password.jsp").forward(request, response);
                return;
            }
        }

        // Check if user has valid cookies for auto-login
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            String savedUsername = null;
            String savedPassword = null;

            for (Cookie cookie : cookies) {
                if ("username".equals(cookie.getName())) {
                    savedUsername = cookie.getValue();
                }
                if ("password".equals(cookie.getName())) {
                    savedPassword = cookie.getValue();
                }
            }

            // If both cookies exist, try to auto-login
            if (savedUsername != null && savedPassword != null) {
                UserDAO userDAO = new UserDAO();
                User user = userDAO.login(savedUsername, savedPassword);

                if (user != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user);
                    session.setAttribute("userID", user.getUserID()); // Add this line to set userID in session

                    if (user.getRoles().get(0).equals("Admin")) {
                        response.sendRedirect(request.getContextPath() + "/admin");
                    } else {
                        response.sendRedirect(request.getContextPath() + "/home");
                    }
                    return;
                }
            }
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("view/authentication/login_register.jsp");
        dispatcher.forward(request, response);
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
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("deleteAccount".equals(action)) {
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");

            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String confirmPassword = request.getParameter("confirmPassword");
            UserDAO userDAO = new UserDAO();

            // Verify password before deletion
            User verifiedUser = userDAO.login(currentUser.getUserName(), confirmPassword);

            if (verifiedUser != null) {
                if (userDAO.deleteUser(currentUser.getUserID())) {
                    session.invalidate(); // Destroy the session after successful deletion
                    response.sendRedirect(request.getContextPath() + "/login");
                } else {
                    session.setAttribute("message", "Failed to delete account!");
                    session.setAttribute("messageType", "error");
                    response.sendRedirect(request.getContextPath() + "/home");
                }
            } else {
                session.setAttribute("message", "Incorrect password!");
                session.setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else if ("register".equals(action)) {
            handleRegister(request, response);
        } else if ("forgotPassword".equals(action)) {
            handleForgotPassword(request, response);
        } else if ("verifyCode".equals(action)) {
            handleVerifyCode(request, response);
        } else if ("resetPassword".equals(action)) {
            handleResetPassword(request, response);
        } else if ("updatePassword".equals(action)) {
            handleUpdatePassword(request, response);
        } else if ("updateEmail".equals(action)) {
            handleUpdateEmail(request, response);
        } else if ("updatePhone".equals(action)) {
            handleUpdatePhone(request, response);
        } else {
            handleLogout(request, response);
        }
    }

    // ✅ Xử lý đăng nhập
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");
        UserDAO userDAO = new UserDAO();

        User user = userDAO.login(username, password);
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userID", user.getUserID()); // Add this line to set userID in session

            // If "Remember Me" is checked, create cookies
            if (remember != null && remember.equals("on")) {
                // Create username cookie
                Cookie usernameCookie = new Cookie("username", username);
                usernameCookie.setMaxAge(60 * 60 * 24 * 30); // 30 days
                usernameCookie.setPath("/");
                response.addCookie(usernameCookie);

                // Create password cookie
                Cookie passwordCookie = new Cookie("password", password);
                passwordCookie.setMaxAge(60 * 60 * 24 * 30); // 30 days
                passwordCookie.setPath("/");
                response.addCookie(passwordCookie);
            }

            if (user.getRoles().get(0).equals("Admin")) {
                response.sendRedirect(request.getContextPath() + "/admin");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            request.setAttribute("error", "Invalid username or password!");
            request.getRequestDispatcher("/view/authentication/login_register.jsp").forward(request, response);
        }
    }

    // ✅ Xử lý đăng ký
    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        User newUser = new User(0, userName, password, email, fullName, phone, null, null);
        UserDAO userDAO = new UserDAO();
        if (userDAO.register(newUser)) {
            request.setAttribute("registerSuccess", "Account created successfully! Please log in.");
            request.getRequestDispatcher("/view/authentication/login_register.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed! Try again.");
            request.getRequestDispatcher("/view/authentication/login_register.jsp").forward(request, response);
        }
    }

    // ✅ Xử lý đổi mật khẩu
    private void handleUpdatePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");

        UserDAO userDAO = new UserDAO();
        User verifiedUser = userDAO.login(currentUser.getUserName(), currentPassword);

        if (verifiedUser != null) {
            if (userDAO.updatePassword(currentUser.getUserID(), newPassword)) {
                session.setAttribute("message", "Password updated successfully!");
                session.setAttribute("messageType", "success");
            } else {
                session.setAttribute("message", "Failed to update password!");
                session.setAttribute("messageType", "error");
            }
        } else {
            session.setAttribute("message", "Current password is incorrect!");
            session.setAttribute("messageType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/home");
    }

    // ✅ Xử lý đổi email
    private void handleUpdateEmail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String newEmail = request.getParameter("newEmail");
        UserDAO userDAO = new UserDAO();

        if (userDAO.updateEmail(currentUser.getUserID(), newEmail)) {
            currentUser.setEmail(newEmail);
            session.setAttribute("user", currentUser);
            session.setAttribute("message", "Email updated successfully!");
            session.setAttribute("messageType", "success");
        } else {
            session.setAttribute("message", "Failed to update email!");
            session.setAttribute("messageType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/home");
    }

    // ✅ Xử lý đổi số điện thoại
    private void handleUpdatePhone(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String newPhone = request.getParameter("newPhone");
        UserDAO userDAO = new UserDAO();

        if (userDAO.updatePhone(currentUser.getUserID(), newPhone)) {
            currentUser.setPhone(newPhone);
            session.setAttribute("user", currentUser);
            session.setAttribute("message", "Phone number updated successfully!");
            session.setAttribute("messageType", "success");
        } else {
            session.setAttribute("message", "Failed to update phone number!");
            session.setAttribute("messageType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/home");
    }

    // ✅ Xử lý đăng xuất
    private void handleLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // Hủy session
        }

        // Delete cookies
        Cookie usernameCookie = new Cookie("username", "");
        usernameCookie.setMaxAge(0);
        usernameCookie.setPath("/");
        response.addCookie(usernameCookie);

        Cookie passwordCookie = new Cookie("password", "");
        passwordCookie.setMaxAge(0);
        passwordCookie.setPath("/");
        response.addCookie(passwordCookie);

        response.sendRedirect(request.getContextPath() + "/home"); // Chuyển về trang đăng nhập sau khi logout
    }

    // Handle forgot password request (send verification code)
    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email is required!");
            request.getRequestDispatcher("/view/authentication/forgot_password.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByEmail(email);

        if (user == null) {
            request.setAttribute("error", "Email not found in our records!");
            request.getRequestDispatcher("/view/authentication/forgot_password.jsp").forward(request, response);
            return;
        }

        // Generate verification code
        String code = service.VerificationService.generateCode(email, user.getUserID());

        // Send verification code via email
        boolean emailSent = service.EmailService.sendVerificationCode(email, code);

        if (emailSent) {
            request.setAttribute("email", email);
            request.setAttribute("message", "Verification code sent to your email!");
            request.getRequestDispatcher("/view/authentication/verify_code.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Failed to send verification code. Please try again.");
            request.getRequestDispatcher("/view/authentication/forgot_password.jsp").forward(request, response);
        }
    }

// Handle verification code validation
    private void handleVerifyCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String code = request.getParameter("code");

        if (email == null || code == null) {
            response.sendRedirect(request.getContextPath() + "/login?action=forgotPassword");
            return;
        }

        boolean isValid = service.VerificationService.verifyCode(email, code);

        if (isValid) {
            // Redirect to reset password page
            response.sendRedirect(request.getContextPath() + "/login?action=resetPassword&email=" + email + "&code=" + code);
        } else {
            request.setAttribute("email", email);
            request.setAttribute("error", "Invalid or expired verification code!");
            request.getRequestDispatcher("/view/authentication/verify_code.jsp").forward(request, response);
        }
    }

// Handle password reset
    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String code = request.getParameter("code");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (email == null || code == null) {
            response.sendRedirect(request.getContextPath() + "/login?action=forgotPassword");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("email", email);
            request.setAttribute("code", code);
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("/view/authentication/reset_password.jsp").forward(request, response);
            return;
        }

        boolean isValid = service.VerificationService.verifyCode(email, code);

        if (!isValid) {
            request.setAttribute("error", "Verification code has expired. Please request a new one.");
            request.getRequestDispatcher("/view/authentication/forgot_password.jsp").forward(request, response);
            return;
        }

        // Get user ID from verification code
        service.VerificationService.VerificationCode verificationCode = service.VerificationService.getVerificationCode(email);
        int userID = verificationCode.getUserID();

        // Update password
        UserDAO userDAO = new UserDAO();
        boolean updated = userDAO.updatePassword(userID, newPassword);

        if (updated) {
            // Remove verification code
            service.VerificationService.removeCode(email);

            request.setAttribute("message", "Password reset successful! You can now login with your new password.");
            request.getRequestDispatcher("/view/authentication/login_register.jsp").forward(request, response);
        } else {
            request.setAttribute("email", email);
            request.setAttribute("code", code);
            request.setAttribute("error", "Failed to reset password. Please try again.");
            request.getRequestDispatcher("/view/authentication/reset_password.jsp").forward(request, response);
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

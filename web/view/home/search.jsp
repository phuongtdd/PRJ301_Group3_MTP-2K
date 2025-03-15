<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Music Library</title>
        <link rel="stylesheet" href="styles.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
              rel="stylesheet">
        <style>

            /* Custom scrollbar styles */
            ::-webkit-scrollbar {
                width: 8px;
            }

            ::-webkit-scrollbar-track {
                background: rgba(2, 12, 27, 0.95);
            }

            ::-webkit-scrollbar-thumb {
                background: #64ffda;
                border-radius: 4px;
            }

            ::-webkit-scrollbar-thumb:hover {
                background: #4ad3b3;
            }
            /* Keep existing styles */
            body {
                display: flex;
                background-color: #0a192f;
                color: #e6f1ff;
                font-family: 'Poppins', sans-serif;
                margin: 0;
            }

            /* Keep all existing styles up to main-content */

            .main-content {
                margin-left: 260px;
                padding: 30px;
                width: calc(100% - 290px);
                margin-bottom: 100px;
            }

            /* Add new search bar styles */
            .search-container {
                margin-bottom: 30px;
                padding: 15px 0;
                display: flex;
                justify-content: space-between;
                align-items: center;
                background: #112240;
                border-radius: 10px;
                padding: 15px 25px;
                margin-top: -10px;
            }

            .search-bar {
                background: #283447;
                border-radius: 25px;
                padding: 12px 20px;
                display: flex;
                align-items: center;
                width: 400px;
            }

            .search-bar input {
                background: transparent;
                border: none;
                color: #e6f1ff;
                font-size: 14px;
                width: 100%;
                margin-left: 10px;
                outline: none;
            }

            .search-bar input::placeholder {
                color: #a8b2d1;
            }

            .auth-buttons {
                display: flex;
                gap: 20px;
                align-items: center;
            }

            .login-btn, .signup-btn {
                padding: 10px 25px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 14px;
                text-decoration: none;
                transition: all 0.3s ease;
            }

            .login-btn {
                background: #64ffda;
                color: #0a192f;
                border: 1px solid #64ffda;

            }

            .login-btn:hover {
                background: transparent;
                color: #64ffda;
            }

            .signup-btn {
                color: #64ffda;
                border: 1px solid #64ffda;
                background: transparent;
            }

            .signup-btn:hover {
                background: rgba(100, 255, 218, 0.1);
            }

            /* Add genre grid styles */
            .genre-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
                gap: 24px;
                margin-bottom: 40px;
            }

            .genre-card {
                background: #112240;
                border-radius: 8px;
                padding: 20px;
                position: relative;
                overflow: hidden;
                min-height: 180px;
                transition: all 0.3s ease;
            }

            .genre-card:hover {
                background: #233554;
                transform: scale(1.02);
            }

            .genre-title {
                color: #e6f1ff;
                font-size: 24px;
                font-weight: 700;
                margin: 0;
                position: relative;
                z-index: 2;
            }

            .sidebar {
                width: 240px;
                background: rgba(2, 12, 27, 0.95);
                padding: 20px;
                height: calc(100vh - 60px);
                position: fixed;
                display: flex;
                flex-direction: column;
                overflow-y: auto;
                padding-bottom: 80px;
                box-shadow: 2px 0 10px rgba(0, 0, 0, 0.3);
                backdrop-filter: blur(10px);
            }

            .logo-container {
                margin-bottom: 30px;
                text-align: center;
            }

            .logo-container img {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                box-shadow: 0 0 20px rgba(100, 255, 218, 0.2);
                transition: transform 0.3s ease;
            }

            .logo-container img:hover {
                transform: scale(1.05);
            }

            .nav-links {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .nav-links li {
                padding: 12px 15px;
                margin: 5px 0;
                border-radius: 8px;
                display: flex;
                align-items: center;
                gap: 15px;
                transition: all 0.3s ease;
            }

            .nav-links li:hover {
                background: rgba(23, 42, 69, 0.8);
                transform: translateX(5px);
            }

            .nav-links a {
                color: #a8b2d1;
                text-decoration: none;
                font-size: 14px;
                font-weight: 500;
                transition: color 0.3s ease;
                width: 100%;
            }

            .nav-links a:hover {
                color: #64ffda;
            }

            .nav-links i {
                font-size: 16px;
                width: 20px;
                text-align: center;
            }

            .footer-links {
                margin-top: auto;
                padding: 15px 0;
                border-top: 1px solid rgba(100, 255, 218, 0.1);
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 10px;
                padding-bottom: 70px;
            }

            .footer-links a {
                color: #a8b2d1;
                text-decoration: none;
                font-size: 12px;
                transition: color 0.3s ease;
                padding: 4px 0;
            }

            .footer-links a:hover {
                color: #64ffda;
            }

            .language-selector {
                display: flex;
                align-items: center;
                gap: 8px;
                color: #e6f1ff;
                padding: 8px 15px;
                border: 1px solid #64ffda;
                border-radius: 20px;
                width: fit-content;
                margin: 15px 0;
                font-size: 13px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .language-selector:hover {
                background: rgba(100, 255, 218, 0.1);
            }

            .main-content {
                margin-left: 260px;
                padding: 30px;
                width: calc(100% - 290px);
                margin-bottom: 100px;
            }

            .section-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
            }

            .section-title {
                font-size: 26px;
                color: #64ffda;
                margin: 0;
                font-weight: 600;
                letter-spacing: 0.5px;
            }

            .show-all {
                color: #64ffda;
                text-decoration: none;
                font-size: 14px;
                padding: 8px 15px;
                border: 1px solid #64ffda;
                border-radius: 20px;
                transition: all 0.3s ease;
                font-weight: 500;
            }

            .show-all:hover {
                background: rgba(100, 255, 218, 0.1);
            }

            .signup-banner {
                position: fixed;
                bottom: 0;
                left: 0;
                right: 0;
                background: linear-gradient(90deg, #0a192f, #1a365d);
                padding: 15px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                z-index: 100;
                border-top: 1px solid #64ffda;
                height: 60px;
            }

            .signup-banner .preview-text {
                color: #a8b2d1;
            }

            .preview-text h3 {
                font-size: 12px;
                text-transform: uppercase;
                margin: 0 0 8px 0;
                letter-spacing: 0.1em;
                color: #64ffda;
                font-weight: 600;
            }

            .preview-text p {
                font-size: 14px;
                margin: 0;
                font-weight: 400;
            }

            .signup-button {
                background: #64ffda;
                color: #0a192f;
                padding: 12px 32px;
                border-radius: 20px;
                text-decoration: none;
                font-weight: 600;
                font-size: 14px;
                transition: all 0.3s ease;
                letter-spacing: 0.5px;
            }

            .signup-button:hover {
                background: transparent;
                color: #64ffda;
                border: 1px solid #64ffda;
            }

            /* Keep all existing styles */

            /* Keep existing artist-section, album-section, and signup-banner styles */

            .dropdown-menu {
                margin-top: 10px;
            }

            .dropdown-item {
                display: flex;
                align-items: center;
                gap: 8px;
                color: #e6f1ff;
                text-decoration: none;
                padding: 8px;
                border-radius: 6px;
                transition: all 0.3s ease;
                font-size: 13px;
            }

            .dropdown-item:hover {
                background: rgba(100, 255, 218, 0.1);
                color: #64ffda;
            }

            .dropdown-item i {
                width: 14px;
                text-align: center;
            }

            .divider {
                height: 1px;
                background: rgba(100, 255, 218, 0.1);
                margin: 6px 0;
            }

            .user-dropdown {
                width: 180px;
            }

            .user-menu {
                position: relative;
                z-index: 1000;
            }

            .user-icon {
                position: relative;
                display: flex;
                align-items: center;
                cursor: pointer;
                color: #64ffda;
                font-size: 32px;
            }

            .user-dropdown {
                display: none;
                position: absolute;
                top: 35px;
                right: 0;
                background: #112240;
                padding: 12px;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
                text-align: left;
                width: 180px;
                border: 1px solid rgba(100, 255, 218, 0.2);
                z-index: 1001;
            }

            .user-icon.active .user-dropdown {
                display: block;
            }

            .user-dropdown p {
                margin: 6px 0;
                font-size: 13px;
                color: #e6f1ff;
                word-break: break-word;
            }

            .user-dropdown p strong {
                color: #64ffda;
                display: block;
                margin-bottom: 3px;
            }

            .logout-button {
                display: block;
                color: #ff4d4d;
                text-decoration: none;
                font-weight: 500;
                padding: 8px;
                border-radius: 6px;
                transition: all 0.3s ease;
                text-align: center;
                margin-top: 10px;
                border: 1px solid transparent;
                font-size: 13px;
            }

            .logout-button:hover {
                background: rgba(255, 77, 77, 0.1);
                border-color: #ff4d4d;
            }
            @media (max-width: 768px) {
                .sidebar {
                    width: 180px;
                }

                .main-content {
                    margin-left: 200px;
                    width: calc(100% - 230px);
                }

                .artist-section,
                .album-section {
                    grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
                }
            }

            @media (max-width: 480px) {
                .sidebar {
                    width: 100%;
                    height: auto;
                    position: relative;
                    padding-bottom: 20px;
                }

                .main-content {
                    margin-left: 0;
                    width: 100%;
                    padding: 20px;
                }

                .artist-section,
                .album-section {
                    grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
                }

                .signup-banner {
                    flex-direction: column;
                    text-align: center;
                    height: auto;
                    padding: 20px;
                }

                .signup-button {
                    margin-top: 15px;
                }
            }

            .dropdown-menu {
                margin-top: 10px;
            }

            .dropdown-item {
                display: flex;
                align-items: center;
                gap: 8px;
                color: #e6f1ff;
                text-decoration: none;
                padding: 8px;
                border-radius: 6px;
                transition: all 0.3s ease;
                font-size: 13px;
            }

            .dropdown-item:hover {
                background: rgba(100, 255, 218, 0.1);
                color: #64ffda;
            }

            .dropdown-item i {
                width: 14px;
                text-align: center;
            }

            .divider {
                height: 1px;
                background: rgba(100, 255, 218, 0.1);
                margin: 6px 0;
            }

            .user-dropdown {
                width: 180px;
            }

            /* Update modal container styles */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.7);
                /* Add these properties for centering */
                display: none;
                align-items: center;
                justify-content: center;
            }

            /* Update profile modal styles */
            .profile-modal {
                max-width: 800px !important;
                width: 90%;
                background: linear-gradient(to bottom right, #1a1a2e, #16213e) !important;
                border-radius: 20px !important;
                padding: 30px !important;
                box-shadow: 0 0 30px rgba(0, 0, 0, 0.5) !important;
                /* Remove any margin/transform that might affect centering */
                margin: 0 auto;
                position: relative;
                /* Add max-height to prevent overflow on smaller screens */
                max-height: 90vh;
                overflow-y: auto;
            }

            /* Add smooth scrollbar for overflow content */
            .profile-modal::-webkit-scrollbar {
                width: 8px;
            }

            .profile-modal::-webkit-scrollbar-track {
                background: rgba(255, 255, 255, 0.1);
                border-radius: 4px;
            }

            .profile-modal::-webkit-scrollbar-thumb {
                background: rgba(100, 255, 218, 0.3);
                border-radius: 4px;
            }

            .modal-content {
                background: #112240;
                margin: 15% auto;
                padding: 25px;
                border: 1px solid #64ffda;
                border-radius: 8px;
                width: 90%;
                max-width: 400px;
                position: relative;
            }

            .close-modal {
                position: absolute;
                right: 15px;
                top: 10px;
                color: #64ffda;
                font-size: 24px;
                cursor: pointer;
            }

            .modal-title {
                color: #64ffda;
                margin-bottom: 20px;
                font-size: 18px;
            }

            .form-group {
                margin-bottom: 15px;
            }

            .form-group label {
                display: block;
                color: #a8b2d1;
                margin-bottom: 5px;
                font-size: 14px;
            }

            .form-group input {
                width: 100%;
                padding: 10px;
                border: 1px solid #233554;
                border-radius: 4px;
                background: #0a192f;
                color: #e6f1ff;
                font-size: 14px;
            }

            .form-group input:focus {
                border-color: #64ffda;
                outline: none;
            }

            .submit-btn {
                background: #64ffda;
                color: #0a192f;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-weight: 600;
                width: 100%;
                margin-top: 10px;
            }

            .submit-btn:hover {
                background: #4ad3b3;
            }

            .error-message {
                color: #ff4d4d;
                font-size: 12px;
                margin-top: 5px;
            }

            .premium-badge {
                padding: 5px 15px;
                border-radius: 15px;
                font-size: 14px;
                font-weight: 600;
            }

            .premium {
                background: rgba(100, 255, 218, 0.1);
                color: #64ffda;
                border: 1px solid #64ffda;
            }

            .standard {
                background: rgba(255, 77, 77, 0.1);
                color: #ff4d4d;
                border: 1px solid #ff4d4d;
            }

            /* Adjust modal content for profile */
            #profileModal .modal-content {
                max-width: 600px;
            }

            #profileModal .profile-details {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 15px;
                margin-top: 20px;
            }

            #profileModal .detail-item {
                background: rgba(2, 12, 27, 0.5);
                padding: 15px;
                border-radius: 8px;
                border: 1px solid rgba(100, 255, 218, 0.1);
            }

            #profileModal .detail-item label {
                color: #64ffda;
                font-size: 12px;
                text-transform: uppercase;
                letter-spacing: 0.1em;
                display: block;
                margin-bottom: 5px;
            }

            #profileModal .detail-item p {
                color: #e6f1ff;
                margin: 0;
                font-size: 14px;
            }

            @media (max-width: 480px) {
                #profileModal .profile-details {
                    grid-template-columns: 1fr;
                }
            }

            .profile-modal-header {
                display: flex;
                align-items: center;
                gap: 30px;
                margin-bottom: 40px;
                padding-bottom: 20px;
                border-bottom: 1px solid rgba(100, 255, 218, 0.1);
            }

            .profile-avatar-large {
                width: 100px;
                height: 100px;
                background: linear-gradient(135deg, #64ffda, #0a192f);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .profile-avatar-large i {
                font-size: 40px;
                color: #fff;
            }

            .profile-title {
                flex: 1;
            }

            .profile-title h2 {
                color: #64ffda;
                margin: 0 0 10px 0;
                font-size: 28px;
            }

            .membership-badge {
                padding: 5px 15px;
                border-radius: 20px;
                font-size: 14px;
                font-weight: 500;
            }

            .membership-badge.premium {
                background: linear-gradient(135deg, rgba(100, 255, 218, 0.1), rgba(100, 255, 218, 0.2));
                color: #64ffda;
                border: 1px solid #64ffda;
            }

            .membership-badge.standard {
                background: linear-gradient(135deg, rgba(255, 77, 77, 0.1), rgba(255, 77, 77, 0.2));
                color: #ff4d4d;
                border: 1px solid #ff4d4d;
            }

            .profile-info-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
            }

            .info-card {
                background: rgba(255, 255, 255, 0.05);
                padding: 20px;
                border-radius: 15px;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .info-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            }

            .info-card i {
                font-size: 20px;
                color: #64ffda;
                margin-bottom: 10px;
            }

            .info-card label {
                display: block;
                color: #8892b0;
                font-size: 12px;
                text-transform: uppercase;
                letter-spacing: 1px;
                margin-bottom: 5px;
            }

            .info-card p {
                color: #e6f1ff;
                font-size: 16px;
                margin: 0;
                word-break: break-word;
            }

            @media (max-width: 768px) {
                .profile-modal {
                    width: 95%;
                    padding: 20px !important;
                }

                .profile-modal-header {
                    flex-direction: column;
                    text-align: center;
                    gap: 15px;
                }

                .profile-info-grid {
                    grid-template-columns: 1fr;
                }
            }

            .toast {
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 15px 25px;
                border-radius: 8px;
                z-index: 9999;
                font-size: 14px;
                font-weight: 500;
                display: none;
            }

            .toast.success {
                background: rgba(100, 255, 218, 0.9);
                color: #0a192f;
                border: 1px solid #64ffda;
            }

            .toast.error {
                background: rgba(255, 77, 77, 0.9);
                color: white;
                border: 1px solid #ff4d4d;
            }

            .toast.show {
                display: block;
                animation: fadeIn 0.3s, fadeOut 0.3s 2.7s;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            @keyframes fadeOut {
                from {
                    opacity: 1;
                }
                to {
                    opacity: 0;
                }
            }
        </style>
    </head>
    <body>
        <div id="toast" class="toast"></div>
        <script>
            window.onload = function () {
                const message = "${sessionScope.message}";
                const messageType = "${sessionScope.messageType}";

                if (message && messageType) {
                    const toast = document.getElementById('toast');
                    toast.textContent = message;
                    toast.className = `toast ${messageType}`;
                    toast.classList.add('show');

                    setTimeout(() => {
                        toast.classList.remove('show');
                    }, 3000);

            <%
                session.removeAttribute("message");
                session.removeAttribute("messageType");
            %>
                }
            }
        </script>
        <!-- Keep existing sidebar -->
        <div class="sidebar">
            <div class="logo-container">
                <img src="<%= request.getContextPath()%>/image/mtp2k-logo.png" alt="MTP-2K"
                     style="border-radius: 50%;">
            </div>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Home</a></li>
                <li><a href="${pageContext.request.contextPath}/home/search"><i class="fas fa-search"></i> Search</a></li>
                <li><a href="${pageContext.request.contextPath}/home/library"><i class="fas fa-book"></i> Your Library</a></li>
                <li style="margin-top: 24px"><a href="${pageContext.request.contextPath}/home/create-playlist    "><i class="fas fa-plus-square"></i> Create Playlist</a></li>
                <li><a href="${pageContext.request.contextPath}/home/liked-songs"><i class="fas fa-heart"></i> Liked Songs</a></li>
            </ul>
            <div class="footer-links">
                <a href="#">Legal</a>
                <a href="#">Privacy Center</a>
                <a href="#">Privacy Policy</a>
                <a href="#">Cookies</a>
                <a href="#">About Ads</a>
            </div>
        </div>

        <div class="main-content">
            <!-- Add search bar -->
            <div class="search-container">
                <div class="search-bar">
                    <i class="fas fa-search" style="color: #a8b2d1;"></i>
                    <input type="text" placeholder="What do you want to listen to?">
                </div>

                <!------------------------------- USER LOGIN -------------------------------------->
                <div class="auth-buttons">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="user-menu">
                                <div class="user-icon" onclick="this.classList.toggle('active')">
                                    <i class="fas fa-user-circle"></i>
                                    <div class="user-dropdown">
                                        <p><strong>${sessionScope.user.fullName}</strong></p>
                                        <p>${sessionScope.user.email}</p>
                                        <div class="dropdown-menu">
                                            <a href="#" class="dropdown-item"
                                               onclick="showModal('profileModal'); return false;">
                                                <i class="fas fa-user"></i> Profile
                                            </a>
                                            <a href="#" class="dropdown-item"
                                               onclick="showModal('passwordModal'); return false;">
                                                <i class="fas fa-key"></i> Change Password
                                            </a>
                                            <a href="#" class="dropdown-item"
                                               onclick="showModal('emailModal'); return false;">
                                                <i class="fas fa-envelope"></i> Change Email
                                            </a>
                                            <a href="#" class="dropdown-item"
                                               onclick="showModal('phoneModal'); return false;">
                                                <i class="fas fa-phone"></i> Change Phone Number
                                            </a>
                                            <div class="divider"></div>
                                            <a href="#" class="dropdown-item" onclick="showModal('deleteAccountModal'); return false;" style="color: #ff4d4d;">
                                                <i class="fas fa-trash-alt"></i> Delete Account
                                            </a>
                                            <div class="divider"></div>
                                            <a href="${pageContext.request.contextPath}/login?action=logout"
                                               class="logout-button">
                                                <i class="fas fa-sign-out-alt"></i> Logout
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="login-btn">Log in</a>
                            <a href="${pageContext.request.contextPath}/login?action=signup" class="signup-btn">Sign up</a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!------------------------------ USER LOGIN --------------------------------------------->

            </div>

            <div class="section-header">
                <h2 class="section-title">Browse All</h2>
            </div>

            <!-- Add genre grid -->
            <div class="genre-grid">
                <div class="genre-card" style="background-color: #4CAF50;">
                    <h3 class="genre-title">Podcasts</h3>
                </div>
                <div class="genre-card" style="background-color: #2196F3;">
                    <h3 class="genre-title">Audiobooks</h3>
                </div>
                <div class="genre-card" style="background-color: #9C27B0;">
                    <h3 class="genre-title">Made For You</h3>
                </div>
                <div class="genre-card" style="background-color: #E91E63;">
                    <h3 class="genre-title">Charts</h3>
                </div>
                <div class="genre-card" style="background-color: #FF5722;">
                    <h3 class="genre-title">New Releases</h3>
                </div>
                <div class="genre-card" style="background-color: #673AB7;">
                    <h3 class="genre-title">Discover</h3>
                </div>
                <div class="genre-card" style="background-color: #3F51B5;">
                    <h3 class="genre-title">Live Events</h3>
                </div>
                <div class="genre-card" style="background-color: #795548;">
                    <h3 class="genre-title">Hip-Hop</h3>
                </div>
                <div class="genre-card" style="background-color: #FF4081;">
                    <h3 class="genre-title">Pop</h3>
                </div>
                <div class="genre-card" style="background-color: #00BCD4;">
                    <h3 class="genre-title">Country</h3>
                </div>
            </div>



            <!-- Keep existing signup banner -->
            <c:if test="${empty sessionScope.user}">
                <div class="signup-banner">
                    <div class="preview-text">
                        <h3>Preview of MTP-2K</h3>
                        <p>Sign up to get unlimited songs and podcasts with occasional ads. No credit card needed.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/login" class="signup-button">Sign up free</a>
                </div>
            </c:if>

        </div>

        <!-- Add these modal forms before closing body tag -->
        <!-- Password Change Modal -->
        <div id="passwordModal" class="modal">
            <div class="modal-content">
                <span class="close-modal" onclick="closeModal('passwordModal')">&times;</span>
                <h2 class="modal-title">Change Password</h2>
                <form action="${pageContext.request.contextPath}/login" method="post">
                    <input type="hidden" name="action" value="updatePassword">
                    <div class="form-group">
                        <label for="currentPassword">Current Password</label>
                        <input type="password" id="currentPassword" name="currentPassword" required>
                    </div>
                    <div class="form-group">
                        <label for="newPassword">New Password</label>
                        <input type="password" id="newPassword" name="newPassword" required>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm New Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                        <span id="passwordError" class="error-message"></span>
                    </div>
                    <button type="submit" class="submit-btn" onclick="return validatePasswordForm()">Update
                        Password</button>
                </form>
            </div>
        </div>

        <!-- Email Change Modal -->
        <div id="emailModal" class="modal">
            <div class="modal-content">
                <span class="close-modal" onclick="closeModal('emailModal')">&times;</span>
                <h2 class="modal-title">Change Email</h2>
                <form action="${pageContext.request.contextPath}/login" method="post">
                    <input type="hidden" name="action" value="updateEmail">
                    <div class="form-group">
                        <label for="newEmail">New Email</label>
                        <input type="email" id="newEmail" name="newEmail" required>
                        <span id="emailError" class="error-message"></span>
                    </div>
                    <button type="submit" class="submit-btn" onclick="return validateEmailForm()">Update
                        Email</button>
                </form>
            </div>
        </div>

        <!-- Phone Change Modal -->
        <div id="phoneModal" class="modal">
            <div class="modal-content">
                <span class="close-modal" onclick="closeModal('phoneModal')">&times;</span>
                <h2 class="modal-title">Change Phone Number</h2>
                <form action="${pageContext.request.contextPath}/login" method="post">
                    <input type="hidden" name="action" value="updatePhone">
                    <div class="form-group">
                        <label for="newPhone">New Phone Number</label>
                        <input type="tel" id="newPhone" name="newPhone" pattern="[0-9]{10}" required>
                        <span id="phoneError" class="error-message"></span>
                    </div>
                    <button type="submit" class="submit-btn" onclick="return validatePhoneForm()">Update
                        Phone</button>
                </form>
            </div>
        </div>

        <!-- Add profile modal before closing body tag -->
        <div id="profileModal" class="modal">
            <div class="modal-content" style="max-width: 600px;">
                <span class="close-modal" onclick="closeModal('profileModal')">&times;</span>
                <h2 class="modal-title">Profile Information</h2>
                <div class="profile-details" style="margin-top: 20px;">
                    <div class="detail-item">
                        <label>Username</label>
                        <p>${sessionScope.user.userName}</p>
                    </div>
                    <div class="detail-item">
                        <label>Full Name</label>
                        <p>${sessionScope.user.fullName}</p>
                    </div>
                    <div class="detail-item">
                        <label>Email</label>
                        <p>${sessionScope.user.email}</p>
                    </div>
                    <div class="detail-item">
                        <label>Phone Number</label>
                        <p>${sessionScope.user.phone}</p>
                    </div>
                    <div class="detail-item">
                        <label>Member Since</label>
                        <p><fmt:formatDate value="${sessionScope.user.createdAt}" pattern="dd/MM/yyyy"/></p>
                    </div>
                    <div class="detail-item">
                        <label>Subscription Status</label>
                        <p>
                            <c:choose>
                                <c:when test="${sessionScope.user.premiumExpiry == null}">
                                    <span class="premium-badge standard">Standard Account</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="premium-badge premium">
                                        Premium until: <fmt:formatDate value="${sessionScope.user.premiumExpiry}" pattern="dd/MM/yyyy"/>
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add the delete account modal before closing body tag -->
        <div id="deleteAccountModal" class="modal">
            <div class="modal-content">
                <span class="close-modal" onclick="closeModal('deleteAccountModal')">&times;</span>
                <h2 class="modal-title" style="color: #ff4d4d;">Delete Account</h2>
                <p style="color: #e6f1ff; margin-bottom: 20px;">Are you sure you want to delete your account? This action cannot be undone.</p>
                <form action="${pageContext.request.contextPath}/login" method="post">
                    <input type="hidden" name="action" value="deleteAccount">
                    <div class="form-group">
                        <label for="confirmPassword">Enter your password to confirm</label>
                        <input type="password" id="confirmDeletePassword" name="confirmPassword" required>
                        <span id="deleteAccountError" class="error-message"></span>
                    </div>
                    <button type="submit" class="submit-btn" style="background: #ff4d4d; color: white;" onclick="return confirmDelete()">Delete Account</button>
                </form>
            </div>
        </div>

        <script>
            // Update the onclick handlers in your dropdown menu items
            document.querySelector('a[href*="change-password"]').onclick = function (e) {
                e.preventDefault();
                showModal('passwordModal');
            };

            document.querySelector('a[href*="change-email"]').onclick = function (e) {
                e.preventDefault();
                showModal('emailModal');
            };

            document.querySelector('a[href*="change-phone"]').onclick = function (e) {
                e.preventDefault();
                showModal('phoneModal');
            };

            function showModal(modalId) {
                const modal = document.getElementById(modalId);
                modal.style.display = 'flex';
            }

            function closeModal(modalId) {
                const modal = document.getElementById(modalId);
                modal.style.display = 'none';
            }

            // Form validation functions
            function validatePasswordForm() {
                const newPass = document.getElementById('newPassword').value;
                const confirmPass = document.getElementById('confirmPassword').value;
                const errorElement = document.getElementById('passwordError');

                if (newPass !== confirmPass) {
                    errorElement.textContent = 'Passwords do not match!';
                    return false;
                }
                if (newPass.length < 6) {
                    errorElement.textContent = 'Password must be at least 6 characters long!';
                    return false;
                }
                return true;
            }

            function validateEmailForm() {
                const email = document.getElementById('newEmail').value;
                const errorElement = document.getElementById('emailError');
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

                if (!emailRegex.test(email)) {
                    errorElement.textContent = 'Please enter a valid email address!';
                    return false;
                }
                return true;
            }

            function validatePhoneForm() {
                const phone = document.getElementById('newPhone').value;
                const errorElement = document.getElementById('phoneError');
                const phoneRegex = /^[0-9]{10}$/;

                if (!phoneRegex.test(phone)) {
                    errorElement.textContent = 'Please enter a valid 10-digit phone number!';
                    return false;
                }
                return true;
            }

            function confirmDelete() {
                return confirm('Are you absolutely sure you want to delete your account? This action cannot be undone.');
            }
        </script>

    </body>



</html>
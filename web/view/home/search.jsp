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
        </style>
    </head>

    <body>
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
                <!------------------------------------- LOGIN-------------------------------- -->
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
                                            <a href="${pageContext.request.contextPath}/user/profile" class="dropdown-item">
                                                <i class="fas fa-user"></i> Profile
                                            </a>
                                            <a href="${pageContext.request.contextPath}/user/change-password" class="dropdown-item">
                                                <i class="fas fa-key"></i> Change Password
                                            </a>
                                            <a href="${pageContext.request.contextPath}/user/change-email" class="dropdown-item">
                                                <i class="fas fa-envelope"></i> Change Email
                                            </a>
                                            <a href="${pageContext.request.contextPath}/user/change-phone" class="dropdown-item">
                                                <i class="fas fa-phone"></i> Change Phone Number
                                            </a>
                                            <div class="divider"></div>
                                            <a href="${pageContext.request.contextPath}/login?action=logout" class="logout-button">
                                                <i class="fas fa-sign-out-alt"></i> Logout
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="signup-btn">Sign up</a>
                            <a href="${pageContext.request.contextPath}/login" class="login-btn">Log in</a>
                        </c:otherwise>
                    </c:choose>
                </div>
                <!------------------------------------- LOGIN-------------------------------- -->

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
    </body>

</html>
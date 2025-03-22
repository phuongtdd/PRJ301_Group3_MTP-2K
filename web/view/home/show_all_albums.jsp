<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>All Albums - MTP Music</title>
                <link rel="stylesheet" href="styles.css">
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
                <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <style>
                    /* Custom scrollbar styles - Tùy chỉnh thanh cuộn */
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

                    /* Body styles - Thiết lập style cho body */
                    body {
                        display: flex;
                        background-color: #0a192f;
                        color: #e6f1ff;
                        font-family: 'Poppins', sans-serif;
                        margin: 0;
                        min-height: 100vh;
                        position: relative;
                        padding-bottom: 60px;
                    }

                    /* Sidebar styles - Thanh điều hướng bên trái */
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

                    /* Logo container styles - Phần chứa logo */
                    .logo-container {
                        margin-bottom: 30px;
                        text-align: center;
                    }

                    /* Logo image styles - Style cho hình ảnh logo */
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

                    /* Navigation links styles - Style cho menu điều hướng */
                    .nav-links {
                        list-style: none;
                        padding: 0;
                        margin: 0;
                    }

                    /* Navigation item styles - Style cho từng mục trong menu */
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

                    /* Footer links styles - Style cho phần footer */
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

                    /* Main content styles - Phần nội dung chính */
                    .main-content {
                        margin-left: 260px;
                        padding: 30px;
                        width: calc(100% - 290px);
                        margin-bottom: 100px;
                    }

                    /* Section header styles - Phần tiêu đề của section */
                    .section-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-top: 30px;
                        margin-bottom: 25px;
                    }

                    .section-title {
                        font-size: 26px;
                        color: #64ffda;
                        margin: 0;
                        font-weight: 600;
                        letter-spacing: 0.5px;
                    }

                    /* Artist grid section styles - Phần lưới hiển thị artists */
                    .album-section {
                        display: grid;
                        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                        gap: 24px;
                        margin-bottom: 40px;
                    }

                    /* Artist card styles - Style cho thẻ artist */
                    .album-card {
                        background: #112240;
                        padding: 16px;
                        border-radius: 8px;
                        transition: all 0.3s ease;
                        border: 1px solid transparent;
                    }

                    .album-card:hover {
                        background: #233554;
                        cursor: pointer;
                        border: 1px solid #64ffda;
                        transform: translateY(-5px);
                    }

                    .album-card img {
                        width: 100%;
                        aspect-ratio: 1;
                        object-fit: cover;
                        border-radius: 8px;
                        margin-bottom: 16px;
                    }

                    .card-info {
                        padding: 10px 0;
                    }

                    .card-title {
                        color: #64ffda;
                        font-size: 16px;
                        font-weight: 600;
                        margin: 0 0 8px 0;
                        letter-spacing: 0.3px;
                    }

                    .card-description {
                        color: #a8b2d1;
                        font-size: 14px;
                        margin: 0;
                        line-height: 1.4;
                        font-weight: 400;
                    }

                    /* Signup banner styles - Banner đăng ký */
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

                    /* Search Container styles */
                    .search-container {
                        margin-bottom: 30px;
                        padding: 15px 25px;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        background: #112240;
                        border-radius: 10px;
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

                    .account-icon {
                        color: #64ffda;
                        font-size: 24px;
                        cursor: pointer;
                        transition: color 0.3s ease;
                    }

                    .account-icon:hover {
                        color: #a8b2d1;
                    }

                    .auth-buttons {
                        display: flex;
                        gap: 20px;
                        align-items: center;
                    }

                    .nav-buttons {
                        display: flex;
                        gap: 20px;
                        margin: 0 20px;
                    }

                    .nav-button {
                        color: #a8b2d1;
                        text-decoration: none;
                        font-size: 14px;
                        font-weight: 500;
                        padding: 8px 15px;
                        border-radius: 20px;
                        transition: all 0.3s ease;
                        display: flex;
                        align-items: center;
                        gap: 8px;
                    }

                    .nav-button:hover {
                        color: #64ffda;
                        background: rgba(100, 255, 218, 0.1);
                    }

                    .nav-button.active {
                        color: #64ffda;
                        background: rgba(100, 255, 218, 0.1);
                        border: 1px solid #64ffda;
                    }

                    .nav-button i {
                        font-size: 16px;
                    }

                    .account-icon {
                        color: #64ffda;
                        font-size: 24px;
                        cursor: pointer;
                        transition: color 0.3s ease;
                    }

                    .account-icon:hover {
                        color: #a8b2d1;
                    }

                    .auth-buttons {
                        display: flex;
                        gap: 20px;
                        align-items: center;
                    }

                    /* Responsive styles - Style cho thiết bị di động */
                    @media (max-width: 768px) {

                        /* Tablet styles - Style cho máy tính bảng */
                        .sidebar {
                            width: 180px;
                        }

                        .main-content {
                            margin-left: 200px;
                            width: calc(100% - 230px);
                        }

                        .album-section {
                            grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
                        }
                    }

                    @media (max-width: 480px) {

                        /* Mobile styles - Style cho điện thoại */
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

                        .album-section {
                            grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
                        }
                    }
                </style>
            </head>

            <body>
                <div class="sidebar">
                    <div class="logo-container">
                        <img src="${pageContext.request.contextPath}/image/mtp2k-logo.png" alt="MTP-2K"
                            style="border-radius: 50%;">
                    </div>
                    <ul class="nav-links">
                        <li><a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Home</a></li>
                        <li><a href="${pageContext.request.contextPath}/home/search"><i class="fas fa-search"></i>
                                Search</a></li>
                        <li><a href="${pageContext.request.contextPath}/home/library"><i class="fas fa-book"></i> Your
                                Library</a></li>
                        <li style="margin-top: 24px"><a
                                href="${pageContext.request.contextPath}/home/create-playlist"><i
                                    class="fas fa-plus-square"></i> Create Playlist</a></li>
                        <li><a href="${pageContext.request.contextPath}/home/liked-songs"><i class="fas fa-heart"></i>
                                Liked Songs</a></li>
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
                    <!-- Search Container -->
                    <div class="search-container">
                        <div class="search-bar">
                            <i class="fas fa-search" style="color: #a8b2d1;"></i>
                            <input type="text" placeholder="What do you want to listen to?">
                        </div>
                        <div class="nav-buttons">
                            <a href="playlist" class="nav-button">
                                <i class="fas fa-list-ul"></i>
                                Playlist
                            </a>
                            <a href="artists" class="nav-button ">
                                <i class="fas fa-microphone-alt"></i>
                                Artists
                            </a>
                            <a href="albums" class="nav-button active">
                                <i class="fas fa-compact-disc"></i>
                                Albums
                            </a>
                        </div>
                        <div class="account-icon">
                            <i class="fas fa-user-circle"></i>
                        </div>
                    </div>
                    <div class="section-header">
                        <h2 class="section-title">All Albums</h2>
                    </div>
                    <div class="album-section">
                        <c:if test="${not empty album}">
                            <p>Có ${album.size()} albums</p>
                        </c:if>
                        <c:if test="${empty album}">
                            <p>Không có album nào</p>
                        </c:if>
                        <div class="album-card">

                            <img src="${pageContext.request.contextPath}/image/m-tp.jpg" alt="Album Cover">
                            <div class="card-info">
                                <h3 class="card-title">M-TP</h3>
                                <p class="card-description">2021 • Album</p>
                            </div>
                        </div>
                    </div>
                </div>

                <c:if test="${empty sessionScope.user}">
                    <div class="signup-banner">
                        <div class="preview-text">
                            <h3>Preview of MTP-2K</h3>
                            <p>Sign up to get unlimited songs and podcasts with occasional ads. No credit card needed.
                            </p>
                        </div>
                        <a href="${pageContext.request.contextPath}/login" class="signup-button">Sign up free</a>
                    </div>
                </c:if>
            </body>

            </html>
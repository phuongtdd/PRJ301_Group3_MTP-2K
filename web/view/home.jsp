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

            body {
                display: flex;
                background-color: #0a192f;
                color: #e6f1ff;
                font-family: 'Poppins', sans-serif;
                margin: 0;
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

            .artist-section,
            .album-section {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 24px;
                margin-bottom: 40px;
            }

            .artist-card,
            .album-card {
                background: #112240;
                padding: 16px;
                border-radius: 8px;
                transition: all 0.3s ease;
                border: 1px solid transparent;
            }

            .artist-card:hover,
            .album-card:hover {
                background: #233554;
                cursor: pointer;
                border: 1px solid #64ffda;
                transform: translateY(-5px);
            }

            .artist-card img,
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
        </style>
    </head>

    <body>
        <div class="sidebar">
            <div class="logo-container">
                <img src="<%= request.getContextPath()%>/image/mtp2k-logo.png" alt="MTP-2K"
                     style="border-radius: 50%;">
            </div>
            <ul class="nav-links">
                <li><a href="#"><i class="fas fa-home"></i> Home</a></li>
                <li><a href="#"><i class="fas fa-search"></i> Search</a></li>
                <li><a href="#"><i class="fas fa-book"></i> Your Library</a></li>
                <li style="margin-top: 24px"><a href="#"><i class="fas fa-plus-square"></i> Create Playlist</a></li>
                <li><a href="#"><i class="fas fa-heart"></i> Liked Songs</a></li>
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
            <div class="section-header">
                <h2 class="section-title">Artists</h2>
                <a href="#" class="show-all">Show All</a>
            </div>
            <div class="artist-section">
                <div class="artist-card">
                    <img src="<%= request.getContextPath()%>/image/kietlac.jpg" alt="kietlac">
                    <div class="card-info">
                        <h3 class="card-title">Kiệt Lặc</h3>
                        <p class="card-description">Vietnamese Hip-hop Artist</p>
                    </div>
                </div>
                <div class="artist-card">
                    <img src="<%= request.getContextPath()%>/image/brunomars.jpg" alt="brunomars">
                    <div class="card-info">
                        <h3 class="card-title">Bruno Mars</h3>
                        <p class="card-description">American Singer-Songwriter</p>
                    </div>
                </div>
                <div class="artist-card">
                    <img src="<%= request.getContextPath()%>/image/duongdominic.jpg" alt="duongdominic">
                    <div class="card-info">
                        <h3 class="card-title">Dương Dominic</h3>
                        <p class="card-description">Vietnamese Pop Artist</p>
                    </div>
                </div>
                <div class="artist-card">
                    <img src="<%= request.getContextPath()%>/image/hieuthu2.jpg" alt="hieuthu2">
                    <div class="card-info">
                        <h3 class="card-title">Hiếu Thứ Hai</h3>
                        <p class="card-description">Vietnamese Rapper</p>
                    </div>
                </div>
                <div class="artist-card">
                    <img src="<%= request.getContextPath()%>/image/jack.jpg" alt="jack">
                    <div class="card-info">
                        <h3 class="card-title">Jack</h3>
                        <p class="card-description">Vietnamese Pop Sensation</p>
                    </div>
                </div>
            </div>

            <div class="section-header">
                <h2 class="section-title">Albums</h2>
                <a href="#" class="show-all">Show All</a>
            </div>
            <div class="album-section">
                <div class="album-card">
                    <img src="<%= request.getContextPath()%>/image/jiso.jpg" alt="jiso">
                    <div class="card-info">
                        <h3 class="card-title">ME</h3>
                        <p class="card-description">JISOO's Solo Album</p>
                    </div>
                </div>
                <div class="album-card">
                    <img src="<%= request.getContextPath()%>/image/keshi.jpg" alt="keshi">
                    <div class="card-info">
                        <h3 class="card-title">GABRIEL</h3>
                        <p class="card-description">Keshi's Latest Album</p>
                    </div>
                </div>
                <div class="album-card">
                    <img src="<%= request.getContextPath()%>/image/rose.jpg" alt="rose">
                    <div class="card-info">
                        <h3 class="card-title">-R-</h3>
                        <p class="card-description">ROSÉ's Solo Album</p>
                    </div>
                </div>
                <div class="album-card">
                    <img src="<%= request.getContextPath()%>/image/obito.jpg" alt="obito">
                    <div class="card-info">
                        <h3 class="card-title">OBITO</h3>
                        <p class="card-description">Vietnamese Hip-hop Album</p>
                    </div>
                </div>
                <div class="album-card">
                    <img src="<%= request.getContextPath()%>/image/sontung.jpg" alt="sontung">
                    <div class="card-info">
                        <h3 class="card-title">Sky Tour</h3>
                        <p class="card-description">Sơn Tùng M-TP's Concert Album</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="signup-banner">
            <div class="preview-text">
                <h3>Preview of MTP-2K</h3>
                <p>Sign up to get unlimited songs and podcasts with occasional ads. No credit card needed.</p>
            </div>
            <a href="#" class="signup-button">Sign up free</a>
        </div>
    </body>

</html>
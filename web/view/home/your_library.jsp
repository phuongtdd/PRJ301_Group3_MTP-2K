<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Music Library</title>
        <link rel="stylesheet" href="styles.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/color-thief/2.3.0/color-thief.umd.js"></script>
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
            }

            /* Main Content Styles */
            .main-content {
                margin-left: 260px;
                padding: 30px;
                width: calc(100% - 290px);
                margin-bottom: 100px;
            }

            .section-header {
                display: flex;
                justify-content: center;
                align-items: center;
                margin-bottom: 40px;
                width: 100%;
                position: relative;
                padding: 20px 0;
            }

            .section-header h2 {
                font-size: 36px;
                color: #64ffda;
                margin: 0;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 3px;
                position: relative;
                display: inline-block;
                padding-bottom: 15px;
                text-shadow: 0 0 20px rgba(100, 255, 218, 0.3);
                transition: all 0.5s ease-in-out;
            }

            .section-header h2::before,
            .section-header h2::after {
                content: '';
                position: absolute;
                bottom: 0;
                height: 2px;
                background: #64ffda;
                transition: all 0.5s ease;
                opacity: 0;
            }

            .section-header h2::before {
                left: 50%;
                width: 0;
                transform: translateX(-50%);
            }

            .section-header h2::after {
                right: 50%;
                width: 0;
                transform: translateX(50%);
            }

            .section-header h2:hover::before,
            .section-header h2:hover::after {
                width: 50%;
                opacity: 1;
            }

            .section-header h2:hover {
                letter-spacing: 5px;
                color: #7cffe3;
            }

            .section-header::before,
            .section-header::after {
                content: '•';
                color: #64ffda;
                font-size: 24px;
                margin: 0 15px;
                opacity: 0;
                transition: all 0.5s ease;
            }

            .section-header:hover::before,
            .section-header:hover::after {
                opacity: 1;
                transform: scale(1.2);
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

            .album-section,
            .artist-section,
            .playlist-section,
            .track-section {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 24px;
                margin-bottom: 40px;
            }

            .album-card,
            .artist-card,
            .playlist-card,
            .track-card {
                background: #112240;
                padding: 16px;
                border-radius: 8px;
                transition: all 0.3s ease;
                border: 1px solid transparent;
                position: relative;
            }

            .album-card:hover,
            .artist-card:hover,
            .playlist-card:hover,
            .track-card:hover {
                background: #233554;
                cursor: pointer;
                border: 1px solid #64ffda;
                transform: translateY(-5px);
            }

            .album-card img,
            .artist-card img,
            .playlist-card img,
            .track-card img {
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

            .signup-btn {
                color: #64ffda;
                border: 1px solid #64ffda;
                background: transparent;
            }

            .signup-btn:hover {
                background: rgba(100, 255, 218, 0.1);
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

            .album-cover {
                width: 300px;
                height: 300px;
                border-radius: 8px;
                box-shadow: 0 4px 60px rgba(0, 0, 0, 0.5);
                object-fit: cover;
            }

            .album-info {
                display: flex;
                flex-direction: column;
                justify-content: flex-end;
            }

            .album-type {
                font-size: 18px;
                font-weight: 500;
                margin-bottom: 8px;
            }

            .album-title {
                font-size: 96px;
                font-weight: 800;
                margin: 8px 0;
                color: #e6f1ff;
            }

            .album-meta {
                display: flex;
                align-items: center;
                gap: 8px;
                color: #a8b2d1;
                font-size: 14px;
            }

            .artist-avatar {
                width: 20px;
                height: 20px;
                border-radius: 50%;
            }

            .track-header {
                display: grid;
                grid-template-columns: 50px 1fr 120px;
                padding: 8px 16px;
                color: #a8b2d1;
                font-size: 14px;
                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                margin-bottom: 16px;
            }

            .track-item {
                display: grid;
                grid-template-columns: 50px 1fr 120px;
                padding: 8px 16px;
                border-radius: 4px;
                transition: all 0.3s ease;
                cursor: pointer;
            }

            .track-item:hover {
                background: rgba(255, 255, 255, 0.1);
            }

            .track-number {
                color: #a8b2d1;
            }

            .track-title {
                color: #e6f1ff;
                font-weight: 500;
            }

            .track-duration {
                color: #a8b2d1;
                text-align: right;
            }

            .play-button {
                width: 56px;
                height: 56px;
                border-radius: 50%;
                background: #64ffda;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .play-button:hover {
                transform: scale(1.05);
                background: #7cffe3;
            }

            .play-button i {
                color: #0a192f;
                font-size: 24px;
            }

            .album-action-icon {
                color: #a8b2d1;
                font-size: 24px;
                cursor: pointer;
                transition: color 0.3s ease;
            }

            .album-action-icon:hover {
                color: #e6f1ff;
            }

            /* Artist Header Styles */
            .artist-header {
                display: flex;
                gap: 30px;
                padding: 30px;
                background: linear-gradient(transparent, rgba(0, 0, 0, 0.5));
                margin-bottom: 30px;
            }

            .artist-avatar {
                width: 30px;
                height: 30px;
                border-radius: 50%;
                box-shadow: 0 4px 60px rgba(0, 0, 0, 0.5);
                object-fit: cover;
            }

            .artist-info {
                display: flex;
                flex-direction: column;
                justify-content: flex-end;
            }

            .artist-type {
                font-size: 14px;
                font-weight: 500;
                margin-bottom: 8px;
                color: #e6f1ff;
            }

            .artist-name {
                font-size: 56px;
                font-weight: 700;
                margin: 8px 0;
                color: #e6f1ff;
                text-shadow: none;
            }

            .artist-stats {
                display: flex;
                align-items: center;
                gap: 8px;
                color: #a8b2d1;
                font-size: 14px;
                margin-top: 8px;
            }

            .monthly-listeners {
                color: #a8b2d1;
            }

            .artist-actions {
                display: flex;
                gap: 20px;
                align-items: center;
                padding: 24px 0;
            }

            .follow-button {
                padding: 8px 32px;
                border-radius: 20px;
                border: 1px solid #64ffda;
                background: transparent;
                color: #64ffda;
                font-weight: 600;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .follow-button:hover {
                background: rgba(100, 255, 218, 0.1);
            }

            /* Popular Tracks Section */
            .popular-tracks {
                margin: 40px 0;
            }

            .popular-tracks h2 {
                font-size: 24px;
                margin-bottom: 20px;
                color: #e6f1ff;
            }

            .track-list {
                display: flex;
                flex-direction: column;
                gap: 16px;
            }

            .track-item.popular {
                display: grid;
                grid-template-columns: 50px 1fr 100px;
                align-items: center;
                padding: 8px 16px;
                border-radius: 4px;
                transition: all 0.3s ease;
            }

            .track-item.popular:hover {
                background: rgba(255, 255, 255, 0.1);
            }

            .track-info {
                display: flex;
                align-items: center;
                gap: 16px;
            }

            .track-cover {
                width: 40px;
                height: 40px;
                border-radius: 4px;
            }

            .track-details {
                display: flex;
                flex-direction: column;
                gap: 4px;
            }

            .track-plays {
                font-size: 14px;
                color: #a8b2d1;
            }

            /* Your Library Section */
            .your-library {
                margin: 40px 0;
            }

            .your-library h2 {
                text-align: center;
                font-size: 32px;
                margin-bottom: 20px;
                color: #64ffda;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 2px;
                position: relative;
                display: inline-block;
                padding-bottom: 10px;
            }

            .your-library h2::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 50%;
                transform: translateX(-50%) scaleX(0.7);
                width: 100%;
                height: 3px;
                background: #64ffda;
                transition: transform 0.3s ease;
            }

            .your-library h2:hover::after {
                transform: translateX(-50%) scaleX(1);
            }

            .delete-button {
                position: absolute;
                top: 10px;
                right: 10px;
                background: rgba(255, 59, 48, 0.9);
                color: white;
                border: none;
                border-radius: 50%;
                width: 32px;
                height: 32px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                opacity: 0;
                transition: all 0.2s ease;
            }

            .album-card:hover .delete-button,
            .artist-card:hover .delete-button,
            .playlist-card:hover .delete-button,
            .track-card:hover .delete-button {
                opacity: 1;
            }

            .delete-button:hover {
                background: rgb(255, 59, 48);
                transform: scale(1.1);
            }

            .subsection-title {
                font-size: 180%;
                color: #64ffda;
                margin: 30px 0 20px 0;
                font-weight: 600;
                letter-spacing: 0.5px;
            }

            .album-section,
            .artist-section,
            .playlist-section,
            .track-section {
                margin-bottom: 20px;
            }
        </style>
    </head>

    <body>
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="logo-container">
                <img src="../image/mtp2k-logo.png" alt="Logo">
            </div>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Home</a></li>
                <li><a href="${pageContext.request.contextPath}/home/search"><i class="fas fa-search"></i> Search</a></li>
                <li><a href="${pageContext.request.contextPath}/home/library"><i class="fas fa-book"></i> Your Library</a></li>
                <li style="margin-top: 24px"><a href="${pageContext.request.contextPath}/home/create-playlist    "><i class="fas fa-plus-square"></i> Create Playlist</a></li>
                <li><a href="${pageContext.request.contextPath}/home/liked-songs"><i class="fas fa-heart"></i> Liked Songs</a></li>
            </ul>
            <div class="footer-links">
                <a href="#" style="color: #a8b2d1; text-decoration: none; font-size: 12px;">Legal</a>
                <a href="#" style="color: #a8b2d1; text-decoration: none; font-size: 12px;">Privacy Center</a>
                <a href="#" style="color: #a8b2d1; text-decoration: none; font-size: 12px;">Privacy Policy</a>
                <a href="#" style="color: #a8b2d1; text-decoration: none; font-size: 12px;">Cookies</a>
                <a href="#" style="color: #a8b2d1; text-decoration: none; font-size: 12px;">About us</a>
            </div>
        </div>

        <!-- Main Content -->
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
                    <a href="artists" class="nav-button">
                        <i class="fas fa-microphone-alt"></i>
                        Artists
                    </a>
                    <a href="albums" class="nav-button">
                        <i class="fas fa-compact-disc"></i>
                        Albums
                    </a>
                </div>
                <div class="account-icon">
                    <i class="fas fa-user-circle"></i>
                </div>
            </div>

            <!-- Your Library Section -->
            <div class="your-library">
                <div class="section-header">
                    <h2>Your Library</h2>
                </div>

                <!-- Artists Section -->
                <h3 class="subsection-title">Artists</h3>
                <div class="artist-section">
                    <div class="artist-card">
                        <button class="delete-button" onclick="deleteItem('artist-mtp')">
                            <i class="fas fa-trash-alt"></i>
                        </button>
                        <img src="../image/mtp-artist.jpg" alt="Artist Cover">
                        <div class="card-info">
                            <h3 class="card-title">Sơn Tùng M-TP</h3>
                            <p class="card-description">Artist</p>
                        </div>
                    </div>
                    <div class="artist-card">
                        <button class="delete-button" onclick="deleteItem('artist-jack')">
                            <i class="fas fa-trash-alt"></i>
                        </button>
                        <img src="../image/jack-artist.jpg" alt="Artist Cover">
                        <div class="card-info">
                            <h3 class="card-title">Jack</h3>
                            <p class="card-description">Artist</p>
                        </div>
                    </div>
                </div>

                <!-- Playlists Section -->
                <h3 class="subsection-title">Playlists</h3>
                <div class="playlist-section">
                    <div class="playlist-card">
                        <button class="delete-button" onclick="deleteItem('playlist-1')">
                            <i class="fas fa-trash-alt"></i>
                        </button>
                        <img src="../image/playlist-cover.jpg" alt="Playlist Cover">
                        <div class="card-info">
                            <h3 class="card-title">My Favorite Songs</h3>
                            <p class="card-description">15 bài hát • Playlist</p>
                        </div>
                    </div>
                </div>

                <!-- Albums Section -->
                <h3 class="subsection-title">Albums</h3>
                <div class="album-section">
                    <div class="album-card">
                        <button class="delete-button" onclick="deleteItem('m-tp-album')">
                            <i class="fas fa-trash-alt"></i>
                        </button>
                        <img src="../image/m-tp.jpg" alt="Album Cover">
                        <div class="card-info">
                            <h3 class="card-title">M-TP</h3>
                            <p class="card-description">2021 • Album</p>
                        </div>
                    </div>
                </div>

                <!-- Tracks Section -->
                <h3 class="subsection-title">Tracks</h3>
                <div class="track-section">
                    <div class="track-card">
                        <button class="delete-button" onclick="deleteItem('muon-roi-ma-sao-con')">
                            <i class="fas fa-trash-alt"></i>
                        </button>
                        <img src="../image/muonroimasaocon.jpg" alt="Track Cover">
                        <div class="card-info">
                            <h3 class="card-title">Muộn rồi mà sao còn</h3>
                            <p class="card-description">2022 • Track</p>
                        </div>
                    </div>
                    <div class="track-card">
                        <button class="delete-button" onclick="deleteItem('making-my-way')">
                            <i class="fas fa-trash-alt"></i>
                        </button>
                        <img src="../image/makingmyway.jpg" alt="Track Cover">
                        <div class="card-info">
                            <h3 class="card-title">Making My Way</h3>
                            <p class="card-description">2023 • Track</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function deleteItem(id) {
                if (confirm('Bạn có chắc chắn muốn xóa mục này khỏi thư viện của bạn?')) {
                    // Thực hiện gọi API để xóa item
                    console.log('Đã xóa item:', id);
                    // Sau khi xóa thành công, có thể refresh trang hoặc xóa element trực tiếp
                    const card = event.target.closest('.album-card, .artist-card, .playlist-card, .track-card');
                    card.remove();
                }
            }
        </script>
    </body>
</html> 
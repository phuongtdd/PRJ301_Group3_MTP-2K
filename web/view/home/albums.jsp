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

                .to-artists {
                    color: #64ffda;
                    text-decoration: none;
                    font-size: 14px;
                    padding: 8px 15px;
                    border: 1px solid #64ffda;
                    border-radius: 20px;
                    transition: all 0.3s ease;
                    font-weight: 500;
                }

                .to-artists:hover {
                    background: rgba(100, 255, 218, 0.1);
                }

                .album-section {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                    gap: 24px;
                    margin-bottom: 40px;
                }

                .album-card,
                .track-card {
                    background: #112240;
                    padding: 16px;
                    border-radius: 8px;
                    transition: all 0.3s ease;
                    border: 1px solid transparent;
                }

                .album-card:hover,
                .track-card:hover {
                    background: #233554;
                    cursor: pointer;
                    border: 1px solid #64ffda;
                    transform: translateY(-5px);
                }

                .album-card img,
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

                .login-btn,
                .signup-btn {
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

                .album-header {
                    display: flex;
                    gap: 30px;
                    padding: 30px;
                    background: linear-gradient(transparent, rgba(0, 0, 0, 0.5));
                    margin-bottom: 30px;
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
                    line-height: 1.1;
                }

                /* Title ngắn (dưới 12 ký tự) */
                .album-title {
                    font-size: 96px;
                }

                /* Title trung bình (12-20 ký tự) */
                .album-title[data-length="medium"] {
                    font-size: 72px;
                }

                /* Title dài (20-30 ký tự) */
                .album-title[data-length="long"] {
                    font-size: 60px;
                }

                /* Title rất dài (trên 30 ký tự) */
                .album-title[data-length="very-long"] {
                    font-size: 48px;
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

                .tracklist {
                    padding: 0 30px;
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

                .album-actions {
                    display: flex;
                    gap: 20px;
                    align-items: center;
                    margin: 24px 0;
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

                /* More-by-Artists Section */
                .more-by-Artists {
                    margin: 40px 0;
                }

                .more-by-Artists h2 {
                    font-size: 24px;
                    margin-bottom: 20px;
                    color: #e6f1ff;
                }
                .section-header {
                    background: #112240;
                    padding: 24px;
                    border-radius: 8px;
                }

                /* Tooltip styles */
                [title] {
                    position: relative;
                }

                [title]:hover:after {
                    content: attr(title);
                    position: absolute;
                    bottom: -30px;
                    left: 50%;
                    transform: translateX(-50%);
                    background: rgba(0, 0, 0, 0.8);
                    color: #fff;
                    padding: 4px 8px;
                    border-radius: 4px;
                    font-size: 12px;
                    white-space: nowrap;
                    z-index: 1;
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
                    <li>
                        <i class="fas fa-home"></i>
                        <a href="home">Home</a>
                    </li>
                    <li>
                        <i class="fas fa-search"></i>
                        <a href="search">Search</a>
                    </li>
                    <li>
                        <i class="fas fa-book"></i>
                        <a href="library">Your Library</a>
                    </li>
                    <li>
                        <i class="fas fa-plus-square"></i>
                        <a href="create-playlist">Create Playlist</a>
                    </li>
                    <li>
                        <i class="fas fa-heart"></i>
                        <a href="liked">Liked Songs</a>
                    </li>
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
                        <a href="albums" class="nav-button active">
                            <i class="fas fa-compact-disc"></i>
                            Albums
                        </a>
                    </div>
                    <div class="account-icon">
                        <i class="fas fa-user-circle"></i>
                    </div>
                </div>

                <!-- Album Details Section -->
                <div class="album-header">
                    <img src="../image/skytour.jpg" alt="Album Cover" class="album-cover">
                    <div class="album-info">
                        <span class="album-type">Album</span>
                        <h1 class="album-title">Sky Tour</h1>
                        <div class="album-meta">
                            <img src="../image/sontung.jpg" alt="Artist" class="artist-avatar">
                            <a href="#" style="color: #a8b2d1; text-decoration: none; font-size: 12px;">Sơn Tùng
                                M-TP</a>
                            <span>•</span>
                            <span>2021</span>
                            <span>•</span>
                            <span>5 songs</span>

                        </div>
                    </div>
                </div>

                <!-- Album Actions -->
                <div class="album-actions">
                    <div class="play-button">
                        <i class="fas fa-play"></i>
                    </div>
                    <i class="far fa-heart album-action-icon"></i>
                    <i class="fas fa-plus-square album-action-icon" title="Add to Your Library"></i>
                </div>

                <!-- Tracklist -->
                <div class="tracklist">
                    <div class="track-header">
                        <div>#</div>
                        <div>Title</div>
                    </div>
                    <div class="track-item">
                        <div class="track-number">1</div>
                        <div class="track-title">Chúng Ta Của Hiện Tại</div>

                    </div>
                    <div class="track-item">
                        <div class="track-number">2</div>
                        <div class="track-title">Có Chắc Yêu Là Đây</div>

                    </div>
                    <div class="track-item">
                        <div class="track-number">3</div>
                        <div class="track-title">Muộn Rồi Mà Sao Còn</div>

                    </div>
                    <div class="track-item">
                        <div class="track-number">4</div>
                        <div class="track-title">Making My Way</div>

                    </div>
                    <div class="track-item">
                        <div class="track-number">5</div>
                        <div class="track-title">There's No One At All</div>

                    </div>
                </div>
                <!-- More by Artists Section -->
                <div class="more-by-Artists">
                    <div class="section-header" style="background: rgba(255,255,255,0.03); backdrop-filter: blur(10px);">
                        <h2>More by Artists</h2>
                        <a href="#" class="to-artists">To Artists</a>
                    </div>

                    <div class="album-section">
                        <div class="album-card">
                            <img src="../image/m-tp.jpg" alt="Album Cover">
                            <div class="card-info">
                                <h3 class="card-title">M-TP</h3>
                                <p class="card-description">2021 • Album</p>
                            </div>
                        </div>
                        <div class="track-card">
                            <img src="../image/muonroimasaocon.jpg" alt="Track Cover">
                            <div class="card-info">
                                <h3 class="card-title">Muộn rồi mà sao còn</h3>
                                <p class="card-description">2022 • Track</p>
                            </div>
                        </div>
                        <div class="track-card">
                            <img src="../image/makingmyway.jpg" alt="Track Cover">
                            <div class="card-info">
                                <h3 class="card-title">Making My Way</h3>
                                <p class="card-description">2023 • Track</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Signup Banner -->
            <div class="signup-banner">
                <div class="preview-text">
                    <h3>Preview of MTP-2K</h3>
                    <p>Sign up to get unlimited songs and podcasts with occasional ads. No credit card needed.</p>
                </div>
                <a href="#" class="signup-button">Sign up free</a>
            </div>

            <script>
                function adjustTitleSize() {
                    const title = document.querySelector('.album-title');
                    const length = title.textContent.length;

                    title.removeAttribute('data-length');

                    if (length > 30) {
                        title.setAttribute('data-length', 'very-long');
                    } else if (length > 20) {
                        title.setAttribute('data-length', 'long');
                    } else if (length > 12) {
                        title.setAttribute('data-length', 'medium');
                    }
                }

                window.addEventListener('load', adjustTitleSize);
            </script>
        </body>

        </html>
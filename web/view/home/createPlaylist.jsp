<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create Playlist - MTP-2K</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
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

            /* Create Playlist Specific Styles */
            .create-playlist-container {
                background: #112240;
                border-radius: 12px;
                padding: 30px;
                margin-bottom: 30px;
                border: 1px solid rgba(100, 255, 218, 0.1);
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            }

            .playlist-form {
                display: flex;
                gap: 30px;
                margin-bottom: 30px;
            }

            .playlist-cover {
                width: 232px;
                height: 232px;
                background-color: #233554;
                border-radius: 8px;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                position: relative;
                overflow: hidden;
                border: 1px dashed #64ffda;
            }

            .playlist-cover-icon {
                font-size: 40px;
                color: #64ffda;
                margin-bottom: 10px;
            }

            .playlist-cover-text {
                font-size: 14px;
                color: #a8b2d1;
            }

            .playlist-cover-img {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                object-fit: cover;
                display: none;
            }

            .playlist-cover-img.active {
                display: block;
            }

            .playlist-cover-overlay {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(10, 25, 47, 0.7);
                display: flex;
                align-items: center;
                justify-content: center;
                opacity: 0;
                transition: opacity 0.3s;
            }

            .playlist-cover:hover .playlist-cover-overlay {
                opacity: 1;
            }

            .playlist-cover-edit {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                background-color: #64ffda;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #0a192f;
                font-size: 20px;
                border: none;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .playlist-cover-edit:hover {
                transform: scale(1.1);
            }

            .playlist-details {
                flex: 1;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-label {
                display: block;
                font-size: 14px;
                font-weight: 600;
                margin-bottom: 8px;
                color: #64ffda;
            }

            .form-input {
                width: 100%;
                padding: 12px 16px;
                background-color: #233554;
                border: 1px solid rgba(100, 255, 218, 0.3);
                border-radius: 4px;
                color: #e6f1ff;
                font-size: 16px;
                transition: border-color 0.3s;
                font-family: 'Poppins', sans-serif;
            }

            .form-input:focus {
                outline: none;
                border-color: #64ffda;
                box-shadow: 0 0 10px rgba(100, 255, 218, 0.2);
            }

            .form-textarea {
                width: 100%;
                padding: 12px 16px;
                background-color: #233554;
                border: 1px solid rgba(100, 255, 218, 0.3);
                border-radius: 4px;
                color: #e6f1ff;
                font-size: 16px;
                resize: vertical;
                min-height: 100px;
                transition: border-color 0.3s;
                font-family: 'Poppins', sans-serif;
            }

            .form-textarea:focus {
                outline: none;
                border-color: #64ffda;
                box-shadow: 0 0 10px rgba(100, 255, 218, 0.2);
            }

            .form-hint {
                font-size: 12px;
                color: #a8b2d1;
                margin-top: 4px;
            }

            .form-actions {
                display: flex;
                justify-content: flex-end;
                gap: 15px;
                margin-top: 20px;
            }

            .btn {
                padding: 12px 32px;
                border-radius: 30px;
                font-size: 14px;
                font-weight: 700;
                cursor: pointer;
                transition: all 0.3s ease;
                border: none;
                font-family: 'Poppins', sans-serif;
            }

            .btn-primary {
                background-color: #64ffda;
                color: #0a192f;
            }

            .btn-primary:hover {
                background-color: #4ad3b3;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(100, 255, 218, 0.3);
            }

            .btn-secondary {
                background-color: transparent;
                color: #64ffda;
                border: 1px solid #64ffda;
            }

            .btn-secondary:hover {
                background-color: rgba(100, 255, 218, 0.1);
                transform: translateY(-2px);
            }

            /* Search Section */
            .search-section {
                margin-bottom: 30px;
            }

            .search-container {
                position: relative;
                max-width: 500px;
                margin-bottom: 20px;
            }

            .search-icon {
                position: absolute;
                left: 16px;
                top: 50%;
                transform: translateY(-50%);
                color: #a8b2d1;
                font-size: 16px;
            }

            .search-input {
                width: 100%;
                padding: 12px 16px 12px 45px;
                background-color: #233554;
                border: 1px solid rgba(100, 255, 218, 0.3);
                border-radius: 4px;
                color: #e6f1ff;
                font-size: 16px;
                transition: all 0.3s ease;
                font-family: 'Poppins', sans-serif;
            }

            .search-input:focus {
                outline: none;
                border-color: #64ffda;
                box-shadow: 0 0 10px rgba(100, 255, 218, 0.2);
            }

            /* Song List */
            .song-list-container {
                background: #112240;
                border-radius: 12px;
                overflow: hidden;
                margin-bottom: 30px;
                border: 1px solid rgba(100, 255, 218, 0.1);
            }

            .song-list {
                width: 100%;
                border-collapse: collapse;
            }

            .song-list th {
                text-align: left;
                padding: 15px;
                border-bottom: 1px solid #233554;
                color: #64ffda;
                font-size: 14px;
                font-weight: 500;
                letter-spacing: 0.5px;
            }

            .song-list td {
                padding: 12px 15px;
                border-bottom: 1px solid #233554;
            }

            .song-list tr:hover {
                background-color: rgba(100, 255, 218, 0.05);
            }

            .song-number {
                width: 50px;
                text-align: center;
                color: #a8b2d1;
            }

            .song-info {
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .song-img {
                width: 40px;
                height: 40px;
                border-radius: 4px;
                overflow: hidden;
            }

            .song-img img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .song-details {
                display: flex;
                flex-direction: column;
            }

            .song-title {
                font-size: 14px;
                font-weight: 500;
                margin-bottom: 4px;
                color: #e6f1ff;
            }

            .song-artist {
                font-size: 12px;
                color: #a8b2d1;
            }

            .song-album {
                font-size: 14px;
                color: #a8b2d1;
            }

            .song-duration {
                font-size: 14px;
                color: #a8b2d1;
                text-align: right;
            }

            .song-actions {
                text-align: right;
            }

            .song-action-btn {
                background: none;
                border: none;
                color: #a8b2d1;
                font-size: 16px;
                cursor: pointer;
                transition: color 0.2s;
                width: 32px;
                height: 32px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .song-action-btn:hover {
                color: #64ffda;
                background-color: rgba(100, 255, 218, 0.1);
            }

            .song-action-btn.active {
                color: #64ffda;
            }

            /* Selected Songs Section */
            .selected-songs-section {
                margin-top: 40px;
            }

            .section-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .section-action {
                font-size: 14px;
                color: #64ffda;
                cursor: pointer;
                transition: color 0.2s;
                text-decoration: none;
            }

            .section-action:hover {
                text-decoration: underline;
            }

            .empty-state {
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 40px;
                background-color: #112240;
                border-radius: 8px;
                text-align: center;
                border: 1px solid rgba(100, 255, 218, 0.1);
            }

            .empty-icon {
                font-size: 40px;
                color: #64ffda;
                margin-bottom: 20px;
            }

            .empty-title {
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 10px;
                color: #e6f1ff;
            }

            .empty-text {
                font-size: 14px;
                color: #a8b2d1;
                max-width: 400px;
                margin: 0 auto;
            }

            /* Music Player */
            .music-player {
                position: fixed;
                bottom: 0;
                left: 0;
                right: 0;
                background: rgba(2, 12, 27, 0.95);
                padding: 10px 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                z-index: 100;
                border-top: 1px solid rgba(100, 255, 218, 0.2);
                height: 80px;
                backdrop-filter: blur(10px);
            }

            .now-playing {
                display: flex;
                align-items: center;
                gap: 15px;
                width: 30%;
            }

            .now-playing-img {
                width: 56px;
                height: 56px;
                border-radius: 4px;
                overflow: hidden;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
            }

            .now-playing-img img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .now-playing-info {
                display: flex;
                flex-direction: column;
            }

            .now-playing-title {
                font-size: 14px;
                font-weight: 600;
                color: #e6f1ff;
                margin-bottom: 4px;
            }

            .now-playing-artist {
                font-size: 12px;
                color: #a8b2d1;
            }

            .like-btn {
                background: none;
                border: none;
                color: #a8b2d1;
                font-size: 16px;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-left: 10px;
            }

            .like-btn:hover, .like-btn.active {
                color: #64ffda;
                transform: scale(1.1);
            }

            .player-controls {
                display: flex;
                flex-direction: column;
                align-items: center;
                width: 40%;
            }

            .control-buttons {
                display: flex;
                align-items: center;
                gap: 20px;
                margin-bottom: 10px;
            }

            .control-btn {
                background: none;
                border: none;
                color: #a8b2d1;
                font-size: 16px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .control-btn:hover {
                color: #64ffda;
                transform: scale(1.1);
            }

            .play-pause-btn {
                width: 36px;
                height: 36px;
                border-radius: 50%;
                background-color: #64ffda;
                color: #0a192f;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.3s ease;
                border: none;
            }

            .play-pause-btn:hover {
                transform: scale(1.1);
                box-shadow: 0 0 15px rgba(100, 255, 218, 0.5);
            }

            .progress-container {
                display: flex;
                align-items: center;
                width: 100%;
                gap: 10px;
            }

            .progress-time {
                font-size: 12px;
                color: #a8b2d1;
                min-width: 40px;
            }

            .progress-bar {
                flex: 1;
                height: 4px;
                background-color: #233554;
                border-radius: 2px;
                cursor: pointer;
                position: relative;
            }

            .progress {
                height: 100%;
                background-color: #64ffda;
                border-radius: 2px;
                width: 30%;
            }

            .progress-bar:hover .progress::after {
                content: '';
                position: absolute;
                right: 0;
                top: 50%;
                transform: translateY(-50%);
                width: 10px;
                height: 10px;
                border-radius: 50%;
                background-color: #64ffda;
            }

            .player-options {
                display: flex;
                align-items: center;
                gap: 15px;
                width: 30%;
                justify-content: flex-end;
            }

            .option-btn {
                background: none;
                border: none;
                color: #a8b2d1;
                font-size: 16px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .option-btn:hover {
                color: #64ffda;
                transform: scale(1.1);
            }

            .volume-control {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .volume-bar {
                width: 80px;
                height: 4px;
                background-color: #233554;
                border-radius: 2px;
                cursor: pointer;
                position: relative;
            }

            .volume-level {
                height: 100%;
                background-color: #64ffda;
                border-radius: 2px;
                width: 70%;
            }

            .volume-bar:hover .volume-level::after {
                content: '';
                position: absolute;
                right: 0;
                top: 50%;
                transform: translateY(-50%);
                width: 10px;
                height: 10px;
                border-radius: 50%;
                background-color: #64ffda;
            }

            /* File Input Styling */
            .file-input {
                display: none;
            }

            /* Responsive */
            @media (max-width: 1200px) {
                .player-options {
                    width: 20%;
                }
            }

            @media (max-width: 992px) {
                .playlist-form {
                    flex-direction: column;
                }

                .playlist-cover {
                    width: 180px;
                    height: 180px;
                    margin: 0 auto;
                }

                .song-album {
                    display: none;
                }
            }

            @media (max-width: 768px) {
                .now-playing-info {
                    display: none;
                }

                .now-playing {
                    width: 15%;
                }

                .player-controls {
                    width: 70%;
                }

                .player-options {
                    width: 15%;
                }

                .volume-bar {
                    display: none;
                }

                .song-duration {
                    display: none;
                }
            }
        </style>
    </head>

    <body>
        <div class="sidebar">
            <div class="logo-container">
                <img src="${pageContext.request.contextPath}/image/mtp2k-logo.png" alt="MTP-2K" style="border-radius: 50%;">
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
            <div class="section-header">
                <h2 class="section-title">Create Playlist</h2>
            </div>

            <div class="create-playlist-container">
                <div class="playlist-form">
                    <div class="playlist-cover" id="playlistCover">
                        <input type="file" id="coverUpload" class="file-input" accept="image/*">
                        <i class="fas fa-music playlist-cover-icon" id="defaultCoverIcon"></i>
                        <span class="playlist-cover-text" id="defaultCoverText">Choose image</span>
                        <img src="/placeholder.svg" alt="Playlist Cover" class="playlist-cover-img" id="coverPreview">
                        <div class="playlist-cover-overlay">
                            <button class="playlist-cover-edit">
                                <i class="fas fa-camera"></i>
                            </button>
                        </div>
                    </div>

                    <div class="playlist-details">
                        <div class="form-group">
                            <label for="playlistName" class="form-label">Name</label>
                            <input type="text" id="playlistName" class="form-input" placeholder="My Playlist">
                        </div>

                        <div class="form-group">
                            <label for="playlistDescription" class="form-label">Description</label>
                            <textarea id="playlistDescription" class="form-textarea" placeholder="Give your playlist a catchy description"></textarea>
                            <p class="form-hint">Add an optional description to let people know more about this playlist.</p>
                        </div>

                        <div class="form-actions">
                            <button class="btn btn-secondary" id="cancelBtn">Cancel</button>
                            <button class="btn btn-primary" id="saveBtn">Create</button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="search-section">
                <div class="section-header">
                    <h2 class="section-title">Let's find something for your playlist</h2>
                </div>

                <div class="search-container">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" class="search-input" id="searchInput" placeholder="Search for songs, artists, or albums">
                </div>

                <div class="song-list-container">
                    <table class="song-list">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Title</th>
                                <th>Album</th>
                                <th>Duration</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody id="searchResults">
                            <!-- Search results will be populated here -->
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="selected-songs-section">
                <div class="section-header">
                    <h2 class="section-title">Selected Songs</h2>
                    <a href="#" class="section-action" id="clearAllBtn">Clear all</a>
                </div>

                <div id="selectedSongsContainer">
                    <div class="empty-state" id="emptyState">
                        <i class="fas fa-music empty-icon"></i>
                        <h3 class="empty-title">No songs added yet</h3>
                        <p class="empty-text">Search for songs above and add them to your playlist.</p>
                    </div>

                    <div class="song-list-container" id="selectedSongsList" style="display: none;">
                        <table class="song-list">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Title</th>
                                    <th>Album</th>
                                    <th>Duration</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody id="selectedSongs">
                                <!-- Selected songs will be populated here -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="music-player">
            <div class="now-playing">
                <div class="now-playing-img">
                    <img id="currentSongImg" src="${pageContext.request.contextPath}/image/default-album.jpg" alt="Now Playing">
                </div>
                <div class="now-playing-info">
                    <div class="now-playing-title" id="currentSongTitle">Not Playing</div>
                    <div class="now-playing-artist" id="currentSongArtist"></div>
                </div>
                <button class="like-btn" id="likeBtn">
                    <i class="far fa-heart"></i>
                </button>
            </div>

            <div class="player-controls">
                <div class="control-buttons">
                    <button class="control-btn" id="shuffleBtn">
                        <i class="fas fa-random"></i>
                    </button>
                    <button class="control-btn" id="prevBtn">
                        <i class="fas fa-step-backward"></i>
                    </button>
                    <button class="play-pause-btn" id="playPauseBtn">
                        <i class="fas fa-play"></i>
                    </button>
                    <button class="control-btn" id="nextBtn">
                        <i class="fas fa-step-forward"></i>
                    </button>
                    <button class="control-btn" id="repeatBtn">
                        <i class="fas fa-redo"></i>
                    </button>
                </div>

                <div class="progress-container">
                    <span class="progress-time" id="currentTime">0:00</span>
                    <div class="progress-bar" id="progressBar">
                        <div class="progress" id="progress"></div>
                    </div>
                    <span class="progress-time" id="totalTime">0:00</span>
                </div>
            </div>

            <div class="player-options">
                <button class="option-btn" id="lyricsBtn">
                    <i class="fas fa-microphone-alt"></i>
                </button>
                <button class="option-btn" id="queueBtn">
                    <i class="fas fa-list"></i>
                </button>
                <div class="volume-control">
                    <button class="option-btn" id="volumeBtn">
                        <i class="fas fa-volume-up"></i>
                    </button>
                    <div class="volume-bar" id="volumeBar">
                        <div class="volume-level" id="volumeLevel"></div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Sample data for songs
            const sampleSongs = [
                {
                    id: 1,
                    title: "Blinding Lights",
                    artist: "The Weeknd",
                    album: "After Hours",
                    duration: "3:20",
                    img: "${pageContext.request.contextPath}/image/album1.jpg"
                },
                {
                    id: 2,
                    title: "Don't Start Now",
                    artist: "Dua Lipa",
                    album: "Future Nostalgia",
                    duration: "3:03",
                    img: "${pageContext.request.contextPath}/image/album2.jpg"
                },
                {
                    id: 3,
                    title: "Watermelon Sugar",
                    artist: "Harry Styles",
                    album: "Fine Line",
                    duration: "2:54",
                    img: "${pageContext.request.contextPath}/image/album3.jpg"
                },
                {
                    id: 4,
                    title: "Levitating",
                    artist: "Dua Lipa",
                    album: "Future Nostalgia",
                    duration: "3:23",
                    img: "${pageContext.request.contextPath}/image/album2.jpg"
                },
                {
                    id: 5,
                    title: "Save Your Tears",
                    artist: "The Weeknd",
                    album: "After Hours",
                    duration: "3:35",
                    img: "${pageContext.request.contextPath}/image/album1.jpg"
                },
                {
                    id: 6,
                    title: "Dynamite",
                    artist: "BTS",
                    album: "BE",
                    duration: "3:19",
                    img: "${pageContext.request.contextPath}/image/album4.jpg"
                },
                {
                    id: 7,
                    title: "Positions",
                    artist: "Ariana Grande",
                    album: "Positions",
                    duration: "2:52",
                    img: "${pageContext.request.contextPath}/image/album5.jpg"
                },
                {
                    id: 8,
                    title: "Mood",
                    artist: "24kGoldn",
                    album: "El Dorado",
                    duration: "2:21",
                    img: "${pageContext.request.contextPath}/image/album6.jpg"
                }
            ];

            // Global variables
            let selectedSongs = [];
            let searchResults = [];
            let isPlaying = false;
            let isLiked = false;

            // DOM Elements
            document.addEventListener('DOMContentLoaded', function () {
                // Playlist Cover Upload
                const playlistCover = document.getElementById('playlistCover');
                const coverUpload = document.getElementById('coverUpload');
                const coverPreview = document.getElementById('coverPreview');
                const defaultCoverIcon = document.getElementById('defaultCoverIcon');
                const defaultCoverText = document.getElementById('defaultCoverText');

                // Playlist Form
                const playlistNameInput = document.getElementById('playlistName');
                const playlistDescriptionInput = document.getElementById('playlistDescription');
                const saveBtn = document.getElementById('saveBtn');
                const cancelBtn = document.getElementById('cancelBtn');

                // Search
                const searchInput = document.getElementById('searchInput');
                const searchResultsContainer = document.getElementById('searchResults');

                // Selected Songs
                const selectedSongsContainer = document.getElementById('selectedSongsContainer');
                const emptyState = document.getElementById('emptyState');
                const selectedSongsList = document.getElementById('selectedSongsList');
                const selectedSongsBody = document.getElementById('selectedSongs');
                const clearAllBtn = document.getElementById('clearAllBtn');

                // Player Controls
                const playPauseBtn = document.getElementById('playPauseBtn');
                const playPauseIcon = playPauseBtn.querySelector('i');
                const likeBtn = document.getElementById('likeBtn');
                const likeIcon = likeBtn.querySelector('i');
                const progressBar = document.getElementById('progressBar');
                const progress = document.getElementById('progress');
                const currentTimeEl = document.getElementById('currentTime');
                const totalTimeEl = document.getElementById('totalTime');
                const volumeBar = document.getElementById('volumeBar');
                const volumeLevel = document.getElementById('volumeLevel');

                // Initialize
                init();

                // Functions
                function init() {
                    // Set up event listeners
                    playlistCover.addEventListener('click', () => coverUpload.click());
                    coverUpload.addEventListener('change', handleCoverUpload);

                    searchInput.addEventListener('input', handleSearch);

                    clearAllBtn.addEventListener('click', clearAllSelectedSongs);

                    saveBtn.addEventListener('click', savePlaylist);
                    cancelBtn.addEventListener('click', () => window.location.href = 'home');

                    // Player controls
                    playPauseBtn.addEventListener('click', togglePlayPause);
                    likeBtn.addEventListener('click', toggleLike);
                    progressBar.addEventListener('click', seekToPosition);
                    volumeBar.addEventListener('click', changeVolume);

                    // Populate initial search results
                    populateSearchResults(sampleSongs);
                }

                function handleCoverUpload(event) {
                    const file = event.target.files[0];
                    if (file) {
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            coverPreview.src = e.target.result;
                            coverPreview.classList.add('active');
                            defaultCoverIcon.style.display = 'none';
                            defaultCoverText.style.display = 'none';
                        };
                        reader.readAsDataURL(file);
                    }
                }

                function handleSearch(event) {
                    const searchTerm = event.target.value.toLowerCase();
                    if (searchTerm.length === 0) {
                        populateSearchResults(sampleSongs);
                        return;
                    }

                    const filteredSongs = sampleSongs.filter(song =>
                        song.title.toLowerCase().includes(searchTerm) ||
                                song.artist.toLowerCase().includes(searchTerm) ||
                                song.album.toLowerCase().includes(searchTerm)
                    );

                    populateSearchResults(filteredSongs);
                }

                function populateSearchResults(songs) {
                    searchResults = songs;
                    searchResultsContainer.innerHTML = '';

                    songs.forEach((song, index) => {
                        const isSelected = selectedSongs.some(s => s.id === song.id);
                        const row = createSongRow(song, index + 1, isSelected);
                        searchResultsContainer.appendChild(row);
                    });
                }

                function createSongRow(song, index, isSelected) {
                    const row = document.createElement('tr');

                    const numberCell = document.createElement('td');
                    numberCell.className = 'song-number';
                    numberCell.textContent = index;

                    const titleCell = document.createElement('td');
                    const songInfo = document.createElement('div');
                    songInfo.className = 'song-info';

                    const songImg = document.createElement('div');
                    songImg.className = 'song-img';
                    const img = document.createElement('img');
                    img.src = song.img;
                    img.alt = song.title;
                    songImg.appendChild(img);

                    const songDetails = document.createElement('div');
                    songDetails.className = 'song-details';
                    const songTitle = document.createElement('div');
                    songTitle.className = 'song-title';
                    songTitle.textContent = song.title;
                    const songArtist = document.createElement('div');
                    songArtist.className = 'song-artist';
                    songArtist.textContent = song.artist;

                    songDetails.appendChild(songTitle);
                    songDetails.appendChild(songArtist);

                    songInfo.appendChild(songImg);
                    songInfo.appendChild(songDetails);
                    titleCell.appendChild(songInfo);

                    const albumCell = document.createElement('td');
                    albumCell.className = 'song-album';
                    albumCell.textContent = song.album;

                    const durationCell = document.createElement('td');
                    durationCell.className = 'song-duration';
                    durationCell.textContent = song.duration;

                    const actionsCell = document.createElement('td');
                    actionsCell.className = 'song-actions';
                    const actionBtn = document.createElement('button');
                    actionBtn.className = `song-action-btn ${isSelected ? 'active' : ''}`;
                    actionBtn.innerHTML = isSelected ?
                            '<i class="fas fa-check"></i>' :
                            '<i class="fas fa-plus"></i>';

                    actionBtn.addEventListener('click', () => {
                        if (isSelected) {
                            removeSongFromSelection(song);
                        } else {
                            addSongToSelection(song);
                        }
                    });

                    actionsCell.appendChild(actionBtn);

                    row.appendChild(numberCell);
                    row.appendChild(titleCell);
                    row.appendChild(albumCell);
                    row.appendChild(durationCell);
                    row.appendChild(actionsCell);

                    return row;
                }

                function addSongToSelection(song) {
                    if (!selectedSongs.some(s => s.id === song.id)) {
                        selectedSongs.push(song);
                        updateSelectedSongsList();
                        populateSearchResults(searchResults); // Refresh search results to update buttons
                    }
                }

                function removeSongFromSelection(song) {
                    selectedSongs = selectedSongs.filter(s => s.id !== song.id);
                    updateSelectedSongsList();
                    populateSearchResults(searchResults); // Refresh search results to update buttons
                }

                function updateSelectedSongsList() {
                    if (selectedSongs.length === 0) {
                        emptyState.style.display = 'flex';
                        selectedSongsList.style.display = 'none';
                        return;
                    }

                    emptyState.style.display = 'none';
                    selectedSongsList.style.display = 'table';

                    selectedSongsBody.innerHTML = '';

                    selectedSongs.forEach((song, index) => {
                        const row = document.createElement('tr');

                        const numberCell = document.createElement('td');
                        numberCell.className = 'song-number';
                        numberCell.textContent = index + 1;

                        const titleCell = document.createElement('td');
                        const songInfo = document.createElement('div');
                        songInfo.className = 'song-info';

                        const songImg = document.createElement('div');
                        songImg.className = 'song-img';
                        const img = document.createElement('img');
                        img.src = song.img;
                        img.alt = song.title;
                        songImg.appendChild(img);

                        const songDetails = document.createElement('div');
                        songDetails.className = 'song-details';
                        const songTitle = document.createElement('div');
                        songTitle.className = 'song-title';
                        songTitle.textContent = song.title;
                        const songArtist = document.createElement('div');
                        songArtist.className = 'song-artist';
                        songArtist.textContent = song.artist;

                        songDetails.appendChild(songTitle);
                        songDetails.appendChild(songArtist);

                        songInfo.appendChild(songImg);
                        songInfo.appendChild(songDetails);
                        titleCell.appendChild(songInfo);

                        const albumCell = document.createElement('td');
                        albumCell.className = 'song-album';
                        albumCell.textContent = song.album;

                        const durationCell = document.createElement('td');
                        durationCell.className = 'song-duration';
                        durationCell.textContent = song.duration;

                        const actionsCell = document.createElement('td');
                        actionsCell.className = 'song-actions';
                        const removeBtn = document.createElement('button');
                        removeBtn.className = 'song-action-btn';
                        removeBtn.innerHTML = '<i class="fas fa-times"></i>';

                        removeBtn.addEventListener('click', () => {
                            removeSongFromSelection(song);
                        });

                        actionsCell.appendChild(removeBtn);

                        row.appendChild(numberCell);
                        row.appendChild(titleCell);
                        row.appendChild(albumCell);
                        row.appendChild(durationCell);
                        row.appendChild(actionsCell);

                        selectedSongsBody.appendChild(row);
                    });
                }

                function clearAllSelectedSongs() {
                    selectedSongs = [];
                    updateSelectedSongsList();
                    populateSearchResults(searchResults);
                }

                function savePlaylist() {
                    const playlistName = playlistNameInput.value.trim();
                    if (!playlistName) {
                        alert('Please enter a playlist name');
                        return;
                    }

                    if (selectedSongs.length === 0) {
                        alert('Please add at least one song to your playlist');
                        return;
                    }

                    const playlistData = {
                        name: playlistName,
                        description: playlistDescriptionInput.value.trim(),
                        coverImage: coverPreview.classList.contains('active') ? coverPreview.src : null,
                        songs: selectedSongs
                    };

                    // In a real application, you would send this data to the server
                    console.log('Playlist data:', playlistData);
                    alert('Playlist created successfully!');

                    // Redirect to the library page
                    window.location.href = 'library';
                }

                // Player functionality
                function togglePlayPause() {
                    isPlaying = !isPlaying;
                    playPauseIcon.className = isPlaying ? 'fas fa-pause' : 'fas fa-play';

                    // Simulate playback for demo
                    if (isPlaying) {
                        simulatePlayback();
                    } else {
                        stopPlaybackSimulation();
                    }
                }

                function toggleLike() {
                    isLiked = !isLiked;
                    likeIcon.className = isLiked ? 'fas fa-heart' : 'far fa-heart';
                    likeBtn.classList.toggle('active', isLiked);
                }

                function seekToPosition(event) {
                    const rect = progressBar.getBoundingClientRect();
                    const offsetX = event.clientX - rect.left;
                    const width = rect.width;
                    const percentage = offsetX / width;

                    progress.style.width = `${percentage * 100}%`;

                    // Update time display
                    const totalSeconds = 210; // 3:30 in seconds
                    const currentSeconds = Math.floor(percentage * totalSeconds);
                    currentTimeEl.textContent = formatTime(currentSeconds);
                }

                function changeVolume(event) {
                    const rect = volumeBar.getBoundingClientRect();
                    const offsetX = event.clientX - rect.left;
                    const width = rect.width;
                    const percentage = offsetX / width;

                    volumeLevel.style.width = `${percentage * 100}%`;
                }

                // Simulate playback for demo
                let playbackInterval;
                function simulatePlayback() {
                    const totalSeconds = 210; // 3:30 in seconds
                    let currentSeconds = 0;

                    // Set initial values
                    currentTimeEl.textContent = '0:00';
                    totalTimeEl.textContent = '3:30';

                    // Update progress bar every second
                    playbackInterval = setInterval(() => {
                        currentSeconds++;
                        const percentage = currentSeconds / totalSeconds;
                        progress.style.width = `${percentage * 100}%`;
                        currentTimeEl.textContent = formatTime(currentSeconds);

                        if (currentSeconds >= totalSeconds) {
                            stopPlaybackSimulation();
                            isPlaying = false;
                            playPauseIcon.className = 'fas fa-play';
                        }
                    }, 1000);
                }

                function stopPlaybackSimulation() {
                    clearInterval(playbackInterval);
                }

                function formatTime(seconds) {
                    const minutes = Math.floor(seconds / 60);
                    const secs = seconds % 60;
                    return `${minutes}:${secs.toString().padStart(2, '0')}`;
                            }
                        });
        </script>
    </body>
</html>
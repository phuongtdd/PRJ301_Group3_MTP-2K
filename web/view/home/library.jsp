<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Your Library - MTP-2K</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/library.css">
        <!-- Additional library-specific styles -->
        <style>
            .library-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
            }

            .library-filters {
                display: flex;
                gap: 15px;
                margin-bottom: 25px;
            }

            .filter-btn {
                background-color: #233554;
                color: #e6f1ff;
                border: none;
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .filter-btn:hover {
                background-color: #2c4269;
            }

            .filter-btn.active {
                background-color: #64ffda;
                color: #0a192f;
            }

            .library-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
                gap: 24px;
                margin-bottom: 40px;
            }

            .library-item {
                background-color: #112240;
                border-radius: 8px;
                overflow: hidden;
                transition: all 0.3s ease;
                cursor: pointer;
                position: relative;
                border: 1px solid rgba(100, 255, 218, 0.1);
            }

            .library-item:hover {
                background-color: #1d3a6a;
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            }

            .library-item-img {
                width: 100%;
                aspect-ratio: 1;
                overflow: hidden;
                position: relative;
            }

            .library-item-img img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.3s ease;
            }

            .library-item:hover .library-item-img img {
                transform: scale(1.05);
            }

            .library-item-overlay {
                position: absolute;
                bottom: 10px;
                right: 10px;
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .library-item:hover .library-item-overlay {
                opacity: 1;
            }

            .play-btn {
                width: 45px;
                height: 45px;
                border-radius: 50%;
                background-color: #64ffda;
                color: #0a192f;
                border: none;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 18px;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
            }

            .play-btn:hover {
                transform: scale(1.1);
                background-color: #1ed760;
            }

            .library-item-info {
                padding: 16px;
            }

            .library-item-title {
                font-size: 16px;
                font-weight: 600;
                color: #e6f1ff;
                margin-bottom: 8px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .library-item-subtitle {
                font-size: 14px;
                color: #a8b2d1;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .library-item-badge {
                position: absolute;
                top: 10px;
                left: 10px;
                background-color: rgba(10, 25, 47, 0.7);
                color: #64ffda;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 500;
                backdrop-filter: blur(5px);
            }

            .section-divider {
                margin: 40px 0;
                border-top: 1px solid rgba(100, 255, 218, 0.1);
            }

            .recent-activity {
                margin-bottom: 40px;
            }

            .activity-list {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .activity-item {
                display: flex;
                align-items: center;
                gap: 15px;
                padding: 10px;
                border-radius: 8px;
                transition: background-color 0.2s ease;
            }

            .activity-item:hover {
                background-color: rgba(100, 255, 218, 0.05);
            }

            .activity-img {
                width: 50px;
                height: 50px;
                border-radius: 4px;
                overflow: hidden;
            }

            .activity-img img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .activity-info {
                flex: 1;
            }

            .activity-title {
                font-size: 14px;
                font-weight: 500;
                color: #e6f1ff;
                margin-bottom: 4px;
            }

            .activity-subtitle {
                font-size: 12px;
                color: #a8b2d1;
            }

            .activity-time {
                font-size: 12px;
                color: #64ffda;
            }

            .create-playlist-btn {
                display: flex;
                align-items: center;
                gap: 10px;
                background-color: transparent;
                color: #64ffda;
                border: 1px solid #64ffda;
                padding: 10px 20px;
                border-radius: 30px;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .create-playlist-btn:hover {
                background-color: rgba(100, 255, 218, 0.1);
                transform: translateY(-2px);
            }

            /* Responsive adjustments for library grid */
            @media (max-width: 992px) {
                .library-grid {
                    grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
                    gap: 20px;
                }
            }

            @media (max-width: 768px) {
                .library-grid {
                    grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
                    gap: 15px;
                }

                .library-filters {
                    overflow-x: auto;
                    padding-bottom: 10px;
                    margin-bottom: 15px;
                }
            }

            @media (max-width: 576px) {
                .library-grid {
                    grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
                    gap: 10px;
                }

                .library-item-info {
                    padding: 10px;
                }

                .library-item-title {
                    font-size: 14px;
                }

                .library-item-subtitle {
                    font-size: 12px;
                }
            }

            /* Expanded Playlist/Album View Styles */
            .expanded-playlist {
                position: fixed;
                top: 0;
                left: 240px;
                right: 0;
                bottom: 90px;
                background: #0a192f;
                z-index: 1000;
                display: none;
                overflow-y: auto;
                padding: 24px;
            }

            .expanded-playlist.active {
                display: block;
            }

            .expanded-playlist-header {
                display: flex;
                gap: 24px;
                margin-bottom: 32px;
                padding: 20px;
                background: #112240;
                border-radius: 12px;
                border: 1px solid rgba(100, 255, 218, 0.1);
            }

            .playlist-cover-large {
                width: 232px;
                height: 232px;
                border-radius: 8px;
                overflow: hidden;
            }

            .playlist-cover-large img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .playlist-info-large {
                display: flex;
                flex-direction: column;
                justify-content: flex-end;
                color: #fff;
            }

            .playlist-type {
                font-size: 13px;
                font-weight: 700;
                text-transform: uppercase;
                margin-bottom: 8px;
                color: #64ffda;
                letter-spacing: 1.5px;
            }

            .playlist-title-large {
                font-size: 72px;
                font-weight: 900;
                margin: 0;
                margin-bottom: 16px;
                color: #fff;
                letter-spacing: -2px;
                line-height: 1.1;
            }

            .playlist-description {
                font-size: 14px;
                color: #a8b2d1;
                margin-bottom: 16px;
                line-height: 1.6;
                max-width: 800px;
            }

            .playlist-details-large {
                font-size: 14px;
                color: #e6f1ff;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .playlist-owner {
                font-weight: 600;
            }

            .playlist-stats {
                color: #a8b2d1;
            }

            .expanded-playlist-controls {
                padding: 24px 0;
                display: flex;
                align-items: center;
                gap: 32px;
            }

            .playlist-play-btn {
                width: 56px;
                height: 56px;
                border-radius: 50%;
                background-color: #64ffda;
                border: none;
                color: #0a192f;
                font-size: 24px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .playlist-play-btn:hover {
                transform: scale(1.1);
                background-color: #1ed760;
            }

            .playlist-songs-header {
                display: grid;
                grid-template-columns: 50px 1fr 1fr 100px;
                padding: 12px 16px;
                margin-bottom: 16px;
                color: #64ffda;
                font-size: 14px;
                font-weight: 600;
                letter-spacing: 1px;
                text-transform: uppercase;
                background: #112240;
                border-radius: 8px;
                border: 1px solid rgba(100, 255, 218, 0.1);
            }

            .playlist-songs-list {
                display: flex;
                flex-direction: column;
                gap: 1px;
            }

            .playlist-song-item {
                display: grid;
                grid-template-columns: 50px 1fr 1fr 100px;
                padding: 8px 16px;
                color: #fff;
                border-radius: 4px;
                cursor: pointer;
                transition: background-color 0.2s ease;
                min-height: 60px;
                align-items: center;
                border-bottom: 1px solid rgba(100, 255, 218, 0.1);
            }

            .playlist-song-item:hover {
                background-color: rgba(255,255,255,0.1);
            }

            .song-number {
                display: flex;
                align-items: center;
                justify-content: center;
                color: #b3b3b3;
                font-size: 14px;
                width: 100%;
                height: 100%;
            }

            .song-info {
                display: flex;
                align-items: center;
                gap: 16px;
            }

            .song-info img {
                width: 40px;
                height: 40px;
                object-fit: cover;
                border-radius: 4px;
            }

            .song-details {
                display: flex;
                flex-direction: column;
            }

            .song-title {
                color: #fff;
                margin-bottom: 4px;
            }

            .song-artist {
                color: #b3b3b3;
                font-size: 14px;
            }

            .song-album {
                color: #b3b3b3;
                display: flex;
                align-items: center;
            }

            .song-duration {
                color: #b3b3b3;
                display: flex;
                align-items: center;
                justify-content: center;
                height: 100%;
            }

            .song-duration-header {
                text-align: center;
            }

            .expanded-playlist-close {
                position: fixed;
                top: 24px;
                right: 32px;
                background: none;
                border: none;
                color: #fff;
                font-size: 24px;
                cursor: pointer;
                width: 32px;
                height: 32px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.3s ease;
            }

            .expanded-playlist-close:hover {
                background-color: rgba(255,255,255,0.1);
            }

            @media (max-width: 768px) {
                .expanded-playlist {
                    left: 0;
                }

                .playlist-cover-large {
                    width: 192px;
                    height: 192px;
                }

                .playlist-title-large {
                    font-size: 48px;
                }
            }

            body {
                margin: 0;
                padding: 0;
                font-family: 'Poppins', sans-serif;
                background-color: #0a192f;
                color: #e6f1ff;
                overflow-y: scroll !important;
            }



            .progress-tooltip {
                position: absolute;
                top: -30px;
                left: 0;
                background: #112240;
                color: #fff;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 12px;
                pointer-events: none;
                opacity: 0;
                transition: opacity 0.2s ease;
            }

            .progress-bar:hover .progress-tooltip,
            .expanded-progress-bar:hover .progress-tooltip {
                opacity: 1;
            }
        </style>

        <!-- Add base URL for JavaScript -->
        <script>
        window.contextPath = '${pageContext.request.contextPath}';
        // samleSongs là tất cả các nhạc có sẵn
        const sampleSongs = [
            {
                id: 1,
                title: "Đánh Đổi",
                artist: "OBITO",
                album: "Đánh Đổi",
                duration: "0:00",
                img: "/image/danhdoi.jpg",
                audioSrc: "/music/danhdoi.mp3",
            },
            {
                id: 2,
                title: "Thiên Lý Ơi",
                artist: "Jack",
                album: "Jack5M",
                duration: "0:00",
                img: "/image/thienlyoi.jpg",
                audioSrc: "/music/thienlyoi.mp3",
            },
            {
                id: 3,
                title: "Drunk",
                artist: "Keshi",
                album: "Keshi",
                duration: "0:00",
                img: "/image/drunk.jpg",
                audioSrc: "/music/drunk.mp3",
            },
            {
                id: 4,
                title: "Making My Way",
                artist: "Sơn Tùng",
                album: "Sky",
                duration: "0:00",
                img: "/image/makingmyway.jpg",
                audioSrc: "/music/makingmyway.mp3",
            },
            {
                id: 5,
                title: "Muộn rồi mà sao còn",
                artist: "Sơn Tùng",
                album: "Sky Tour",
                duration: "0:00",
                img: "/image/muonroimasaocon.jpg",
                audioSrc: "/music/MuonRoiMaSaoCon.mp3",
            }
        ];

        // Dữ liệu mẫu cho thư viện
        // nó sẽ lấy từ sameSongs cho playlist, ví dụ songs: [sampleSongs[0], sampleSongs[1]]
        const samplePlaylists = [
            {
                id: 1,
                title: "My Favorites",
                type: "Playlist",
                img: "/image/playlist-image.jpg",
                description: "A personal collection of all-time favorites. These songs have been with me through thick and thin, each one holding special memories and emotions.",
                songs: [sampleSongs[0], sampleSongs[1], sampleSongs[2], sampleSongs[3], sampleSongs[4]]
            },
            {
                id: 2,
                title: "Chill Vibes",
                type: "Playlist",
                img: "/image/playlist-image.jpg",
                isNew: true,
                description: "Perfect for relaxation and unwinding. Smooth melodies and gentle rhythms create a peaceful atmosphere for your quiet moments.",
                songs: [sampleSongs[1], sampleSongs[2], sampleSongs[4]]
            },
            {
                id: 3,
                title: "Late Night Drive",
                type: "Playlist",
                img: "/image/playlist-image.jpg",
                description: "Your companion for those midnight drives. A mix of atmospheric tracks that perfectly complement the quiet of the night and the open road.",
                songs: [sampleSongs[2], sampleSongs[0], sampleSongs[3]]
            },
            {
                id: 4,
                title: "Workout Mix",
                type: "Playlist",
                img: "/image/playlist-image.jpg",
                description: "High-energy tracks to fuel your workout. Keep your motivation high and your energy higher with this powerful collection of songs.",
                songs: [sampleSongs[3], sampleSongs[4], sampleSongs[1]]
            }
        ];

        // tương tự playlist
        const sampleAlbums = [
            {
                id: 5,
                title: "Sky Tour",
                type: "Album",
                artist: "Sơn Tùng",
                img: "/image/muonroimasaocon.jpg",
                description: "A groundbreaking album that showcases Sơn Tùng's unique artistry and vision. Each track tells a story of ambition, love, and personal growth.",
                songs: [sampleSongs[4]]
            },
            {
                id: 6,
                title: "Đánh Đổi",
                type: "Album",
                artist: "OBITO",
                img: "/image/danhdoi.jpg",
                description: "OBITO's masterful blend of modern sounds and emotional depth. An album that explores the complexities of life's choices and their consequences.",
                songs: [sampleSongs[0]]
            }
        ];
        </script>
    </head>

    <body>
        <div class="sidebar">
            <div class="logo-container">
                <!-- Update logo image path -->
                <img src="${pageContext.request.contextPath}/image/mtp2k-logo.png" alt="MTP-2K" style="border-radius: 50%;">
            </div>
            <ul class="nav-links">
                <li><a href="home"><i class="fas fa-home"></i> Home</a></li>
                <li><a href="${pageContext.request.contextPath}/home/search"><i class="fas fa-search"></i> Search</a></li>
                <li style="margin-top: 0px; background: rgba(100, 255, 218, 0.1);"><a href="${pageContext.request.contextPath}/home/library" style="color: #64ffda;"><i class="fas fa-book"></i> Your Library</a></li>
                <li style="margin-top: 24px;"><a href="${pageContext.request.contextPath}/home/create-playlist"><i class="fas fa-plus-square"></i> Create Playlist</a></li>
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
            <div class="library-header">
                <h2 class="section-title">Your Library</h2>
            </div>

            <div class="library-filters">
                <button class="filter-btn active">All</button>
                <button class="filter-btn">Playlists</button>
                <button class="filter-btn">Albums</button>
            </div>

            <div class="library-grid">
                <!-- Playlists -->
                <div class="library-item">
                    <div class="library-item-img">
                        <img src="${pageContext.request.contextPath}/image/playlist-image.jpg" alt="Playlist">
                        <div class="library-item-overlay">
                            <button class="play-btn">
                                <i class="fas fa-play"></i>
                            </button>
                        </div>
                    </div>
                    <div class="library-item-info">
                        <div class="library-item-title">My Favorites</div>
                        <div class="library-item-subtitle">Playlist • 24 songs</div>
                    </div>
                </div>

                <div class="library-item">
                    <div class="library-item-img">
                        <img src="${pageContext.request.contextPath}/image/playlist-image.jpg" alt="Playlist">
                        <div class="library-item-badge">New</div>
                        <div class="library-item-overlay">
                            <button class="play-btn">
                                <i class="fas fa-play"></i>
                            </button>
                        </div>
                    </div>
                    <div class="library-item-info">
                        <div class="library-item-title">Chill Vibes</div>
                        <div class="library-item-subtitle">Playlist • 18 songs</div>
                    </div>
                </div>

                <div class="library-item">
                    <div class="library-item-img">
                        <img src="${pageContext.request.contextPath}/image/playlist-image.jpg" alt="Playlist">
                        <div class="library-item-overlay">
                            <button class="play-btn">
                                <i class="fas fa-play"></i>
                            </button>
                        </div>
                    </div>
                    <div class="library-item-info">
                        <div class="library-item-title">Late Night Drive</div>
                        <div class="library-item-subtitle">Playlist • 32 songs</div>
                    </div>
                </div>

                <div class="library-item">
                    <div class="library-item-img">
                        <img src="${pageContext.request.contextPath}/image/playlist-image.jpg" alt="Playlist">
                        <div class="library-item-overlay">
                            <button class="play-btn">
                                <i class="fas fa-play"></i>
                            </button>
                        </div>
                    </div>
                    <div class="library-item-info">
                        <div class="library-item-title">Workout Mix</div>
                        <div class="library-item-subtitle">Playlist • 15 songs</div>
                    </div>
                </div>

                <!-- Albums -->
                <div class="library-item">
                    <div class="library-item-img">
                        <img src="${pageContext.request.contextPath}/image/muonroimasaocon.jpg" alt="Album">
                        <div class="library-item-overlay">
                            <button class="play-btn">
                                <i class="fas fa-play"></i>
                            </button>
                        </div>
                    </div>
                    <div class="library-item-info">
                        <div class="library-item-title">Sky Tour</div>
                        <div class="library-item-subtitle">Album • Sơn Tùng</div>
                    </div>
                </div>

                <div class="library-item">
                    <div class="library-item-img">
                        <img src="${pageContext.request.contextPath}/image/danhdoi.jpg" alt="Album">
                        <div class="library-item-overlay">
                            <button class="play-btn">
                                <i class="fas fa-play"></i>
                            </button>
                        </div>
                    </div>
                    <div class="library-item-info">
                        <div class="library-item-title">Đánh Đổi</div>
                        <div class="library-item-subtitle">Album • OBITO</div>
                    </div>
                </div>
            </div>

            <div class="section-divider"></div>

            <div class="recent-activity">
                <div class="section-header">
                    <h2 class="section-title">Recently Played</h2>
                    <a href="#" class="section-action">See All</a>
                </div>

                <div class="activity-list">
                    <div class="activity-item">
                        <div class="activity-img">
                            <img src="${pageContext.request.contextPath}/image/danhdoi.jpg" alt="Đánh Đổi">
                        </div>
                        <div class="activity-info">
                            <div class="activity-title">Đánh Đổi</div>
                            <div class="activity-subtitle">OBITO</div>
                        </div>
                    </div>

                    <div class="activity-item">
                        <div class="activity-img">
                            <img src="${pageContext.request.contextPath}/image/thienlyoi.jpg" alt="Thiên Lý Ơi">
                        </div>
                        <div class="activity-info">
                            <div class="activity-title">Thiên Lý Ơi</div>
                            <div class="activity-subtitle">Jack</div>
                        </div>
                    </div>

                    <div class="activity-item">
                        <div class="activity-img">
                            <img src="${pageContext.request.contextPath}/image/drunk.jpg" alt="Drunk">
                        </div>
                        <div class="activity-info">
                            <div class="activity-title">Drunk</div>
                            <div class="activity-subtitle">Keshi</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Music Player -->
        <div class="music-player">     
            <div class="now-playing">
                <div class="now-playing-img" id="nowPlayingImg">
                    <!-- COMMENT: Default album art image path in the image folder -->
                    <img id="currentSongImg" src="${pageContext.request.contextPath}/image/m-tp.jpg" alt="Now Playing">
                </div>
                <div class="now-playing-info">
                    <div class="now-playing-title" id="currentSongTitle">Not Playing</div>
                    <div class="now-playing-artist" id="currentSongArtist"></div>
                </div>
                <div class="now-playing-actions">
                    <button class="option-btn" id="expandBtn" title="Expand">
                        <i class="fas fa-expand-alt"></i>
                    </button>
                </div>
            </div>

            <div class="player-controls">
                <div class="control-buttons">
                    <button class="control-btn" id="shuffleBtn" title="Shuffle">
                        <i class="fas fa-random"></i>
                    </button>
                    <button class="control-btn" id="prevBtn" title="Previous">
                        <i class="fas fa-step-backward"></i>
                    </button>
                    <button class="play-pause-btn" id="playPauseBtn" title="Play/Pause">
                        <i class="fas fa-play"></i>
                    </button>
                    <button class="control-btn" id="nextBtn" title="Next">
                        <i class="fas fa-step-forward"></i>
                    </button>
                    <button class="control-btn" id="repeatBtn" title="Repeat">
                        <i class="fas fa-redo"></i>
                    </button>
                </div>

                <div class="progress-container">
                    <span class="progress-time" id="currentTime">0:00</span>
                    <div class="progress-bar" id="progressBar">
                        <div class="progress" id="progress">
                            <div class="progress-handle"></div>
                        </div>
                        <div class="progress-tooltip" id="progressTooltip">0:00</div>
                    </div>
                    <span class="progress-time" id="totalTime">0:00</span>
                </div>
            </div>

            <div class="player-options">
                <button class="option-btn" id="queueBtn" title="Queue">
                    <i class="fas fa-list"></i>
                </button>
                <div class="volume-control">
                    <button class="option-btn" id="volumeBtn" title="Volume">
                        <i class="fas fa-volume-up"></i>
                    </button>
                    <div class="volume-slider-container">
                        <div class="volume-bar" id="volumeBar">
                            <div class="volume-level" id="volumeLevel">
                                <div class="volume-handle"></div>
                            </div>
                            <div class="volume-tooltip" id="volumeTooltip">70%</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Queue Panel -->
        <div class="queue-panel" id="queuePanel">
            <div class="queue-header">
                <div class="queue-title">Queue</div>
                <button class="queue-close" id="queueCloseBtn">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="queue-content">
                <div class="queue-section">
                    <div class="queue-section-title">Now Playing</div>
                    <div id="nowPlayingQueue"></div>
                </div>
                <div class="queue-section">
                    <div class="queue-section-title">Next Up</div>
                    <div id="queueContent"></div>
                </div>
            </div>
        </div>

        <!-- Expanded Player -->
        <div class="expanded-player" id="expandedPlayer">
            <button class="expanded-close" id="expandedCloseBtn">
                <i class="fas fa-times"></i>
            </button>
            <div class="expanded-content">
                <div class="expanded-img">
                    <!-- COMMENT: Default expanded player album art image path in the image folder -->
                    <img id="expandedImg" src="${pageContext.request.contextPath}/image/m-tp.jpg" alt="Now Playing">
                </div>
                <div class="expanded-info">
                    <div class="expanded-title" id="expandedTitle">Not Playing</div>
                    <div class="expanded-artist" id="expandedArtist"></div>
                </div>
                <div class="expanded-controls">
                    <div class="expanded-progress">
                        <span class="progress-time" id="expandedCurrentTime">0:00</span>
                        <div class="expanded-progress-bar" id="expandedProgressBar">
                            <div class="expanded-progress-level" id="expandedProgress">
                                <div class="expanded-progress-handle"></div>
                            </div>
                            <div class="progress-tooltip" id="expandedProgressTooltip">0:00</div>
                        </div>
                        <span class="progress-time" id="expandedTotalTime">0:00</span>
                    </div>
                    <div class="expanded-buttons">
                        <button class="expanded-btn" id="expandedShuffleBtn" title="Shuffle">
                            <i class="fas fa-random"></i>
                        </button>
                        <button class="expanded-btn" id="expandedPrevBtn" title="Previous">
                            <i class="fas fa-step-backward"></i>
                        </button>
                        <button class="expanded-play-btn" id="expandedPlayBtn" title="Play/Pause">
                            <i class="fas fa-play"></i>
                        </button>
                        <button class="expanded-btn" id="expandedNextBtn" title="Next">
                            <i class="fas fa-step-forward"></i>
                        </button>
                        <button class="expanded-btn" id="expandedRepeatBtn" title="Repeat">
                            <i class="fas fa-redo"></i>
                        </button>
                    </div>

                    <!-- Added volume control to expanded player -->
                    <div class="expanded-volume-control">
                        <button class="expanded-btn" id="expandedVolumeBtn" title="Volume">
                            <i class="fas fa-volume-up"></i>
                        </button>
                        <div class="expanded-volume-slider-container">
                            <div class="expanded-volume-bar" id="expandedVolumeBar">
                                <div class="expanded-volume-level" id="expandedVolumeLevel">
                                    <div class="expanded-volume-handle"></div>
                                </div>
                                <div class="expanded-volume-tooltip" id="expandedVolumeTooltip">70%</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Expanded Playlist/Album View -->
        <div class="expanded-playlist" id="expandedPlaylist">
            <div class="expanded-playlist-header">
                <div class="playlist-cover-large">
                    <img id="expandedPlaylistImg" src="${pageContext.request.contextPath}/image/playlist-image.jpg" alt="Playlist">
                </div>
                <div class="playlist-info-large">
                    <div class="playlist-type" id="expandedPlaylistType">Playlist</div>
                    <h1 class="playlist-title-large" id="expandedPlaylistTitle">My Playlist</h1>
                    <div class="playlist-description" id="expandedPlaylistDescription">
                        Discover your perfect soundtrack with this carefully curated collection of songs. From energetic beats to soulful melodies, each track has been selected to create the perfect atmosphere for any moment.
                    </div>
                    <div class="playlist-details-large">
                        <span class="playlist-owner" id="expandedPlaylistOwner">Your Library</span>
                        <span class="playlist-stats" id="expandedPlaylistStats">• 24 songs</span>
                    </div>
                </div>
            </div>

            <div class="expanded-playlist-controls">
                <button class="playlist-play-btn">
                    <i class="fas fa-play"></i>
                </button>
            </div>

            <div class="expanded-playlist-content">
                <div class="playlist-songs-header">
                    <div class="song-number">#</div>
                    <div class="song-info-header">Title</div>
                    <div class="song-album-header">Album</div>
                    <div class="song-duration-header">Duration</div>
                </div>
                <div class="playlist-songs-list" id="expandedPlaylistSongs">
                    <!-- Songs will be added here dynamically -->
                </div>
            </div>

            <button class="expanded-playlist-close" id="expandedPlaylistClose">
                <i class="fas fa-times"></i>
            </button>
        </div>

        <!-- Audio Element for Music Playback -->
        <!-- COMMENT: This is the audio element that will play the music files -->
        <audio id="audioPlayer"></audio>

        <script src="${pageContext.request.contextPath}/js/library.js">
        </script>

        <!-- Additional JavaScript for library page functionality -->
        <script>
            document.addEventListener("DOMContentLoaded", () => {
                // Filter buttons functionality
                const filterButtons = document.querySelectorAll('.filter-btn');

                filterButtons.forEach(button => {
                    button.addEventListener('click', () => {
                        // Remove active class from all buttons
                        filterButtons.forEach(btn => btn.classList.remove('active'));

                        // Add active class to clicked button
                        button.classList.add('active');

                        // In a real application, you would filter the library items here
                        console.log(`Filter selected: ${button.textContent}`);
                    });
                });

                // Library item click functionality
                const libraryItems = document.querySelectorAll('.library-item');

                libraryItems.forEach(item => {
                    item.addEventListener('click', () => {
                        const title = item.querySelector('.library-item-title').textContent;
                        const subtitle = item.querySelector('.library-item-subtitle').textContent;
                    });
                });

                // Activity item click functionality
                const activityItems = document.querySelectorAll('.activity-item');

                activityItems.forEach(item => {
                    item.addEventListener('click', () => {
                        const title = item.querySelector('.activity-title').textContent;
                        const artist = item.querySelector('.activity-subtitle').textContent;
                        const imgSrc = item.querySelector('img').src;

                        // For demo purposes, update the player UI
                        document.getElementById('currentSongTitle').textContent = title;
                        document.getElementById('currentSongArtist').textContent = artist;
                        document.getElementById('currentSongImg').src = imgSrc;
                        document.getElementById('expandedImg').src = imgSrc;
                        document.getElementById('expandedTitle').textContent = title;
                        document.getElementById('expandedArtist').textContent = artist;

                        // Change play button to pause
                        const playPauseIcon = document.querySelector('#playPauseBtn i');
                        const expandedPlayIcon = document.querySelector('#expandedPlayBtn i');
                        playPauseIcon.className = 'fas fa-pause';
                        expandedPlayIcon.className = 'fas fa-pause';
                    });
                });
            });
        </script>
    </body>
</html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
                                    <a href="#" class="dropdown-item" onclick="showModal('deleteAccountModal');
                                            return false;" style="color: #ff4d4d;">
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
            </c:choose>
        </div>

        <!------------------------------- USER LOGIN -------------------------------------->

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
                        href="${pageContext.request.contextPath}/home/create-playlist    "><i
                            class="fas fa-plus-square"></i> Create Playlist</a></li>
                <li><a href="${pageContext.request.contextPath}/home/topsong"><i class="fas fa-heart"></i>
                        Top Songs</a></li>
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
        <!--------------------------------------------------- SIGNUPBANNER ----------------------------------------------------->
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

        <!-------------------------------------------------------- Music Player ----------------------------------------------------->
        <c:if test="${ not empty sessionScope.user}">

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
        </c:if>
        <!-------------------------------------------------------- Music Player ----------------------------------------------------->


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
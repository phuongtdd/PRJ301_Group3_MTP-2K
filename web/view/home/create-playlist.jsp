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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/create-playlist.css">

        <!-- Add base URL for JavaScript -->
        <script>
        window.contextPath = '${pageContext.request.contextPath}';
        // Sample data for SEARCH - Dữ liệu mẫu cho tìm kiếm
        const sampleSearchSongs = [
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
                audioSrc: "/makingmyway.mp3",
            }
        ];

// Sample data for QUEUE - Dữ liệu mẫu cho danh sách phát
        const sampleQueueSongs = [
            {
                id: 101, // ID khác với search songs để tránh trùng lặp
                title: "Muộn rồi mà sao còn",
                artist: "Sơn Tùng",
                album: "Sky Tour",
                duration: "0:00",
                img: "/image/muonroimasaocon.jpg",
                audioSrc: "/music/MuonRoiMaSaoCon.mp3",
            },
            {
                id: 102,
                title: "Đánh Đổi",
                artist: "Obito",
                album: "Đánh Đổi",
                duration: "0:00",
                img: "/image/danhdoi.jpg",
                audioSrc: "/music/danhdoi.mp3",
            },
            {
                id: 103,
                title: "drunk",
                artist: "Keshi",
                album: "Keshi",
                duration: "0:00",
                img: "/image/drunk.jpg",
                audioSrc: "/music/drunk.mp3",
            },
            {
                id: 104,
                title: "Thiên Lý Ơi",
                artist: "Jack",
                album: "Jack5M",
                duration: "0:00",
                img: "/image/thienlyoi.jpg",
                audioSrc: "/music/thienlyoi.mp3",
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
                <li><a href="${pageContext.request.contextPath}/home/library"><i class="fas fa-book"></i> Your Library</a></li>
                <li style="margin-top: 24px; background: rgba(100, 255, 218, 0.1);"><a href="${pageContext.request.contextPath}/home/create-playlist" style="color: #64ffda;"><i class="fas fa-plus-square"></i> Create Playlist</a></li>
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
                        <tbody id="searchResults"></tbody>
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

        <!-- Audio Element for Music Playback -->
        <!-- COMMENT: This is the audio element that will play the music files -->
        <audio id="audioPlayer"></audio>

        <script src="${pageContext.request.contextPath}/js/create-playlist.js">
        </script>
    </body>
</html>

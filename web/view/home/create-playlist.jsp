<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
        <c:if test="${not empty sessionScope.user}">

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

        <!-- Audio Element for Music Playback -->
        <!-- COMMENT: This is the audio element that will play the music files -->
        <audio id="audioPlayer"></audio>

        <script src="${pageContext.request.contextPath}/js/create-playlist.js">
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
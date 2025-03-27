<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ page contentType="text/html" pageEncoding="UTF-8" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>MTP-2K - Playlist</title>
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
                <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/library.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/track.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/playlist.css">
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
                                            <a href="${pageContext.request.contextPath}/premium" class="dropdown-item">
                                                <i class="fas fa-crown"></i> Premium
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

                <!------------------------------ USER LOGIN --------------------------------------------->

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
                    <!-- Playlist Header -->
                    <c:if test="${not empty sessionScope.playlistTracks}">
                        <c:set var="playlist" value="${sessionScope.currentPlaylist}" />

                        <div class="album-header">
                            <div class="album-header-bg" style="background-image: url('${playlist.imageUrl != null ? playlist.imageUrl : pageContext.request.contextPath.concat("/image/playlist-image.jpg")}');"></div>
                            <div class="album-info">
                                <div class="album-cover">
                                    <img src="${playlist.imageUrl != null ? playlist.imageUrl : pageContext.request.contextPath.concat("/image/playlist-image.jpg")}"
                                        alt="${playlist.title}">
                                </div>
                                <div class="album-details">
                                    <div class="album-type">PLAYLIST</div>
                                    <h1 class="album-title">${playlist.title}</h1>
                                    <div class="album-meta">
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.user}">
                                                <span class="album-artist">Created by
                                                    ${sessionScope.user.userName}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="album-artist">Created by User</span>
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="album-year">${sessionScope.playlistTracks.size()} songs</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Playlist Actions -->
                        <div class="album-actions">
                            <button class="play-button" id="playPlaylist">
                                <i class="fas fa-play"></i>
                                Play
                            </button>
                            <a href="${pageContext.request.contextPath}/home/library" class="back-button">
                                <i class="fas fa-arrow-left"></i>
                                Back to Library
                            </a>
                        </div>

                        <!-- Playlist Tracks -->
                        <div class="track-list">
                            <div class="track-list-header">
                                <div class="track-number">#</div>
                                <div class="track-info">TITLE</div>
                                <div class="track-album">ALBUM</div>
                                <div class="track-duration">DURATION</div>
                            </div>

                            <c:forEach var="track" items="${sessionScope.playlistTracks}" varStatus="status">
                                <div class="track-item" onclick="document.getElementById('trackForm${track.trackID}').submit();" style="cursor: pointer;">
                                    <div class="track-number">${status.index + 1}</div>
                                    <div class="track-info">
                                        <div class="track-image">
                                            <img src="${track.imageUrl}" alt="${track.title}">
                                            <div class="play-hover">
                                                <i class="fas fa-play"></i>
                                            </div>
                                        </div>
                                        <div class="track-name-artist">
                                            <div class="track-name">${track.title}</div>
                                            <div class="track-artist">
                                                <c:forEach var="artist" items="${track.artists}"
                                                    varStatus="artistStatus">
                                                    ${artist.name}<c:if test="${!artistStatus.last}">, </c:if>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="track-album">Album Name</div>
                                    <div class="track-duration">3:45</div>

                                    <!-- Hidden form for track navigation -->
                                    <form id="trackForm${track.trackID}"
                                        action="${pageContext.request.contextPath}/home/track" method="post"
                                        style="display: none;">
                                        <input type="hidden" name="id" value="${track.trackID}">
                                    </form>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>

                    <c:if test="${empty sessionScope.playlistTracks}">
                        <div class="empty-playlist">
                            <i class="fas fa-music"></i>
                            <h3>This playlist is empty</h3>
                            <p>Add some songs to get started</p>
                            <a href="${pageContext.request.contextPath}/home/create-playlist"
                                class="create-playlist-btn">
                                <i class="fas fa-plus"></i> Add Songs
                            </a>
                        </div>
                    </c:if>
                </div>

                <!--------------------------------------------------- SIGNUPBANNER ----------------------------------------------------->
                <c:if test="${empty sessionScope.userID}">
                    <div class="signup-banner">
                        <div class="preview-text">
                            <h2>Preview of MTP-2K</h2>
                            <p>Sign up to get unlimited songs and podcasts with occasional ads. No credit card needed.
                            </p>
                        </div>
                        <a href="${pageContext.request.contextPath}/register" class="signup-btn">Sign up free</a>
                    </div>
                </c:if>

                <!-- Music Player -->
                <!-- <c:if test="${not empty sessionScope.userID}">
                    <div class="music-player">
                        <div class="now-playing">
                            <div class="now-playing-img" id="nowPlayingImg">
                                <img src="${pageContext.request.contextPath}/image/default-album.jpg" alt="Album Cover">
                            </div>
                            <div class="now-playing-info">
                                <div class="track-name" id="nowPlayingTitle">Select a track</div>
                                <div class="artist-name" id="nowPlayingArtist">Artist</div>
                            </div>
                            <div class="now-playing-like">
                                <i class="far fa-heart"></i>
                            </div>
                        </div>

                        <div class="player-controls">
                            <div class="control-buttons">
                                <button class="control-btn" id="shuffleBtn">
                                    <i class="fas fa-random"></i>
                                </button>
                                <button class="control-btn" id="prevBtn">
                                    <i class="fas fa-step-backward"></i>
                                </button>
                                <button class="control-btn play-btn" id="playBtn">
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
                                <span id="currentTime">0:00</span>
                                <div class="progress-bar">
                                    <div class="progress" id="progress"></div>
                                    <div class="progress-handle" id="progressHandle"></div>
                                </div>
                                <span id="totalTime">0:00</span>
                            </div>
                        </div>

                        <div class="player-options">
                            <button class="option-btn" id="queueBtn">
                                <i class="fas fa-list"></i>
                            </button>
                            <div class="volume-container">
                                <button class="option-btn" id="volumeBtn">
                                    <i class="fas fa-volume-up"></i>
                                </button>
                                <div class="volume-slider">
                                    <div class="volume-bar">
                                        <div class="volume-level" id="volumeLevel"></div>
                                        <div class="volume-handle" id="volumeHandle"></div>
                                    </div>
                                </div>
                            </div>
                            <button class="option-btn" id="expandBtn">
                                <i class="fas fa-expand-alt"></i>
                            </button>
                        </div>
                    </div>
                </c:if>

                 Audio Player -->
                <!-- <audio id="audioPlayer"></audio>  -->

                <!-- JavaScript for player functionality -->
                <script>
                    // Toggle user dropdown
                    function toggleUserDropdown() {
                        const dropdown = document.getElementById('userDropdown');
                        dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
                    }

                    // Close dropdown when clicking outside
                    window.addEventListener('click', function (event) {
                        if (!event.target.matches('.user-icon') && !event.target.matches('.user-icon *')) {
                            const dropdown = document.getElementById('userDropdown');
                            if (dropdown.style.display === 'block') {
                                dropdown.style.display = 'none';
                            }
                        }
                    });

                    // Modal functions
                    function openModal(modalId) {
                        document.getElementById(modalId).style.display = 'block';
                    }

                    function closeModal(modalId) {
                        document.getElementById(modalId).style.display = 'none';
                    }

                    // Play track functionality
                    document.addEventListener('DOMContentLoaded', function () {
                        const trackItems = document.querySelectorAll('.track-item');
                        const audioPlayer = document.getElementById('audioPlayer');
                        const playBtn = document.getElementById('playBtn');
                        const playIcon = playBtn.querySelector('i');

                        trackItems.forEach(item => {
                            item.addEventListener('click', function () {
                                const trackId = this.querySelector('form input[name="id"]').value;
                                // Here you would fetch the track URL and play it
                                // For now, we'll just update the UI

                                // Update now playing info
                                const trackName = this.querySelector('.track-name').textContent;
                                const artistName = this.querySelector('.track-artist').textContent;
                                const imgSrc = this.querySelector('.track-image img').src;

                                document.getElementById('nowPlayingTitle').textContent = trackName;
                                document.getElementById('nowPlayingArtist').textContent = artistName;
                                document.getElementById('nowPlayingImg').querySelector('img').src = imgSrc;

                                // Update play button
                                playIcon.classList.remove('fa-play');
                                playIcon.classList.add('fa-pause');

                                // Send request to server to update play count
                                fetch(`${pageContext.request.contextPath}/home/track?action=setPlayingTrack&id=${trackId}`, {
                                    method: 'POST'
                                });
                            });
                        });

                        // Play/pause button functionality
                        playBtn.addEventListener('click', function () {
                            if (audioPlayer.paused) {
                                audioPlayer.play();
                                playIcon.classList.remove('fa-play');
                                playIcon.classList.add('fa-pause');
                            } else {
                                audioPlayer.pause();
                                playIcon.classList.remove('fa-pause');
                                playIcon.classList.add('fa-play');
                            }
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
                                <p>
                                    <fmt:formatDate value="${sessionScope.user.createdAt}" pattern="dd/MM/yyyy" />
                                </p>
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
                                                Premium until:
                                                <fmt:formatDate value="${sessionScope.user.premiumExpiry}"
                                                    pattern="dd/MM/yyyy" />
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
                        <p style="color: #e6f1ff; margin-bottom: 20px;">Are you sure you want to delete your account?
                            This action cannot be undone.</p>
                        <form action="${pageContext.request.contextPath}/login" method="post">
                            <input type="hidden" name="action" value="deleteAccount">
                            <div class="form-group">
                                <label for="confirmPassword">Enter your password to confirm</label>
                                <input type="password" id="confirmDeletePassword" name="confirmPassword" required>
                                <span id="deleteAccountError" class="error-message"></span>
                            </div>
                            <button type="submit" class="submit-btn" style="background: #ff4d4d; color: white;"
                                onclick="return confirmDelete()">Delete Account</button>
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
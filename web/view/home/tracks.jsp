<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MTP-2K</title>
        <link rel="stylesheet" href="styles.css">
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
              rel="stylesheet">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/color-thief/2.3.0/color-thief.umd.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/search.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/track.css" />

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
        <!-- Sidebar -->
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
            <!-- Add search bar -->
            <div class="search-container">
                <form action="search" method="GET" class="search-bar"
                      onsubmit="return handleSearchSubmit(event)">
                    <i class="fas fa-search" style="color: #a8b2d1;"></i>
                    <input type="text" name="q" placeholder="What do you want to listen to?"
                           oninput="searchItems(this.value)" id="searchInput">
                </form>

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
                                            <a href="#" class="dropdown-item"
                                               onclick="showModal('deleteAccountModal'); return false;"
                                               style="color: #ff4d4d;">
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
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="login-btn">Log in</a>
                            <a href="${pageContext.request.contextPath}/login?action=signup"
                               class="signup-btn">Sign up</a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-------------------------- Search Results Container ----------------------->
                <div id="searchResults" class="search-results" style="display: none;">
                    <!-- Tracks Section -->
                    <div class="search-section">
                        <h3>Songs</h3>
                        <div class="tracks-list">
                            <c:forEach items="${tracks}" var="track">
                                <div class="search-item">
                                    <img src="${track.imageUrl}" alt="${track.title}" class="search-item-img">
                                    <div class="search-item-info">
                                        <a href="track?id=${track.trackID}">${track.title}</a>
                                        <span>Song</span>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Artists Section -->
                    <div class="search-section">
                        <h3>Artists</h3>
                        <div class="artists-list">
                            <c:forEach items="${artists}" var="artist">
                                <form action="${pageContext.request.contextPath}/home/artist" method="POST"
                                      class="search-item artist-form">
                                    <input type="hidden" name="id" value="${artist.artistID}">
                                    <img src="${artist.imageUrl}" alt="${artist.name}" class="search-item-img">
                                    <div class="search-item-info">
                                        <span class="artist-name">${artist.name}</span>
                                        <span>Artist</span>
                                    </div>
                                    <button type="submit" class="full-area-button"></button>
                                </form>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Albums Section -->
                    <div class="search-section">
                        <h3>Albums</h3>
                        <div class="albums-list">
                            <c:forEach items="${albums}" var="album">
                                <form action="${pageContext.request.contextPath}/home/album" method="POST"
                                      class="search-item album-form">
                                    <input type="hidden" name="id" value="${album.albumID}">
                                    <img src="${album.imageUrl}" alt="${album.title}" class="search-item-img">
                                    <div class="search-item-info">
                                        <span class="album-title">${album.title}</span>
                                        <span>Album</span>
                                    </div>
                                    <button type="submit" class="full-area-button"></button>
                                </form>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                <!-----------------------------SearchResult------------------------------->
            </div>

            <!-- Track Details Section - Modernized -->
            <div class="album-header">
                <div class="album-header-bg">
                </div>
                <img src="${pageContext.request.contextPath}/${sessionScope.track.imageUrl}"
                     alt="${sessionScope.track.title}" class="album-cover">
                <div class="album-info">
                    <span class="album-type">Track</span>
                    <h1 class="album-title">${sessionScope.track.title}</h1>
                    <div class="album-meta">
                        <c:if test="${not empty sessionScope.track.artists}">
                            <c:forEach var="artist" items="${sessionScope.track.artists}" varStatus="status">
                                <c:if test="${status.index == 0}">
                                    <img src="${pageContext.request.contextPath}/${sessionScope.artist.imageUrl}"
                                         alt="${artist.name}" class="artist-avatar">
                                    <form action="${pageContext.request.contextPath}/home/artist" method="POST"
                                          class="artist-view-form">
                                        <input type="hidden" name="id"
                                               value="${sessionScope.track.artists[0].artistID}">
                                        <div class="view-artist-container">
                                            <span class="view-artist-text"></span>
                                            <button type="submit" class="full-area-button"></button>
                                        </div>
                                    </form>
                                </c:if>
                                <c:if test="${status.index > 0}">
                                    , <a
                                        href="${pageContext.request.contextPath}/home/artist?id=${artist.artistID}">${artist.name}</a>
                                </c:if>
                            </c:forEach>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Track Actions -->
            <div class="album-actions">
                <div class="play-button" id="playCurrentTrack" data-track-id="${sessionScope.track.trackID}"
                     data-track-title="${sessionScope.track.title}"
                     data-track-image="${sessionScope.track.imageUrl}"
                     data-track-file="${sessionScope.track.fileUrl}" data-track-artist="<c:forEach var=" artist"
                                                                                  items="${sessionScope.track.artists}" varStatus="status">${artist.name}<c:if
                             test="${!status.last}">, </c:if>
                     </c:forEach>">
                    <i class="fas fa-play"></i>
                </div>
                <div class="action-buttons-group">
                    <div class="action-button-container">
                        <div>
                            <i class="fas fa-plus-square album-action-icon"></i>
                        </div>
                        <span>Add</span>
                    </div>
                    <div class="action-button-container">
                        <div>
                            <i class="fas fa-list-ul album-action-icon"></i>
                        </div>
                        <span>Playlist</span>
                    </div>
                </div>
            </div>

            <!-- Track Info -->
            <div class="track-statistics">
                <div class="stat-item">
                    <i class="fas fa-calendar-alt"></i>
                    <div>
                        <div>
                            <fmt:formatDate value="${sessionScope.track.releaseDate}" pattern="dd.MM.yy" />
                        </div>
                        <div>Release Date</div>
                    </div>
                </div>
                <c:if test="${sessionScope.track.record > 0}">
                    <div class="stat-item">
                        <i class="fas fa-play-circle"></i>
                        <div>
                            <div>${sessionScope.track.record}</div>
                            <div>Plays</div>
                        </div>
                    </div>
                </c:if>

                <!-- Display Genres -->
                <c:if test="${not empty sessionScope.track.genres}">
                    <div class="stat-item">
                        <i class="fas fa-music"></i>
                        <div>
                            <div>
                                <c:forEach var="genre" items="${sessionScope.track.genres}" varStatus="status">
                                    ${genre.genreName}<c:if test="${!status.last}">, </c:if>
                                </c:forEach>
                            </div>
                            <div>Genres</div>
                        </div>
                    </div>
                </c:if>

                <!-- Display Artists Count -->
                <c:if test="${not empty sessionScope.track.artists}">
                    <div class="stat-item">
                        <i class="fas fa-users"></i>
                        <div>
                            <div>${sessionScope.track.artists.size()}</div>
                            <div>Artists</div>
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- Track Credits -->
            <div class="track-info-sections">
                <div class="track-credits">
                    <h2>Credits</h2>

                    <c:if test="${not empty sessionScope.track.artists}">
                        <c:forEach var="artist" items="${sessionScope.track.artists}">
                            <div class="credit-item">
                                <span class="credit-label">Artist</span>
                                <span class="credit-value">
                                    <span>${artist.name}</span>
                                </span>
                            </div>
                        </c:forEach>
                    </c:if>

                    <c:if test="${not empty sessionScope.track.genres}">
                        <div class="credit-item">
                            <span class="credit-label">Genres</span>
                            <span class="credit-value">
                                <c:forEach var="genre" items="${sessionScope.track.genres}" varStatus="status">
                                    ${genre.genreName}<c:if test="${!status.last}">, </c:if>
                                </c:forEach>
                            </span>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Artists Showcase Section -->
            <c:if test="${not empty sessionScope.track.artists && sessionScope.track.artists.size() > 1}">
                <div class="track-info-sections">
                    <h2>Featured Artists</h2>
                    <div class="artists-showcase">
                        <c:forEach var="artist" items="${sessionScope.track.artists}">
                            <div class="artist-card">
                                <div class="artist-image">
                                    <img src="${artist.imageUrl}" alt="${artist.name}">
                                </div>
                                <div class="artist-info">
                                    <h3>${artist.name}</h3>
                                    <a href="${pageContext.request.contextPath}/home/artist?id=${artist.artistID}"
                                       class="view-artist-btn">View Artist</a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <!-- More by Artists Section -->
            <c:if test="${not empty sessionScope.track.artists}">
                <div class="more-by-Artists">
                    <div class="section-header">
                        <h2>More by ${sessionScope.track.artists[0].name}</h2>
                        <form action="${pageContext.request.contextPath}/home/artist" method="POST"
                              class="artist-view-form">
                            <input type="hidden" name="id" value="${sessionScope.track.artists[0].artistID}">
                            <div class="view-artist-container">
                                <span class="view-artist-text">View Artist</span>
                                <button type="submit" class="full-area-button"></button>
                            </div>
                        </form>
                    </div>

                    <div class="album-section">
                        <!-- Display albums by the artist -->
                        <c:if test="${not empty sessionScope.artistAlbums}">
                            <c:forEach var="album" items="${sessionScope.artistAlbums}" varStatus="status">
                                <c:if test="${status.index < 2}">
                                    <div class="album-card">
                                        <form id="albumForm${album.albumID}"
                                              action="${pageContext.request.contextPath}/home/album" method="POST"
                                              style="display:none;">
                                            <input type="hidden" name="id" value="${album.albumID}">
                                        </form>
                                        <div class="card-image-container"
                                             onclick="document.getElementById('albumForm${album.albumID}').submit();"
                                             style="cursor: pointer;">
                                            <img src="${pageContext.request.contextPath}/${album.imageUrl}"
                                                 alt="${album.title}">
                                            <div class="hover-play-button">
                                                <i class="fas fa-play"></i>
                                            </div>
                                        </div>
                                        <div class="card-info"
                                             onclick="document.getElementById('albumForm${album.albumID}').submit();"
                                             style="cursor: pointer;">
                                            <h3 class="card-title">${album.title}</h3>
                                            <p class="card-description">
                                                <fmt:formatDate value="${album.releaseDate}" pattern="yyyy" /> •
                                                Album
                                            </p>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </c:if>

                        <!-- Display tracks by the artist -->
                        <c:if test="${not empty sessionScope.artistTracks}">
                            <c:forEach var="artistTrack" items="${sessionScope.artistTracks}"
                                       varStatus="status">
                                <c:if test="${status.index < 3}">
                                    <div class="track-card">
                                        <form id="trackForm${artistTrack.trackID}"
                                              action="${pageContext.request.contextPath}/home/track" method="POST"
                                              style="display:none;">
                                            <input type="hidden" name="id" value="${artistTrack.trackID}">
                                        </form>
                                        <div class="card-image-container"
                                             onclick="document.getElementById('trackForm${artistTrack.trackID}').submit();"
                                             style="cursor: pointer;">
                                            <img src="${pageContext.request.contextPath}/${artistTrack.imageUrl}"
                                                 alt="${artistTrack.title}">
                                            <div class="hover-play-button">
                                                <i class="fas fa-play"></i>
                                            </div>
                                        </div>
                                        <div class="card-info"
                                             onclick="document.getElementById('trackForm${artistTrack.trackID}').submit();"
                                             style="cursor: pointer;">
                                            <h3 class="card-title">${artistTrack.title}</h3>
                                            <p class="card-description">
                                                <fmt:formatDate value="${artistTrack.releaseDate}"
                                                                pattern="yyyy" /> • Track
                                            </p>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </c:if>
                    </div>
                </div>
            </c:if>

            <!-- Signup Banner -->
            <c:if test="${empty sessionScope.user}">
                <div class="signup-banner">
                    <div class="preview-text">
                        <h3>Preview of MTP-2K</h3>
                        <p>Sign up to get unlimited songs and podcasts with occasional ads. No credit card
                            needed.
                        </p>
                    </div>
                    <a href="${pageContext.request.contextPath}/login" class="signup-button">Sign up free</a>
                </div>
            </c:if>
        </div>

        <!-- Add JavaScript for toggle functionality -->
        <!----------------------------------Play Button-------------------------------->

        <script>
            function adjustTitleSize() {
                const title = document.querySelector('.album-title');
                const length = title.textContent.length;

                // Xóa tất cả data attributes cũ
                title.removeAttribute('data-length');

                // Thêm data attribute mới dựa trên độ dài
                if (length > 30) {
                    title.setAttribute('data-length', 'very-long');
                } else if (length > 20) {
                    title.setAttribute('data-length', 'long');
                } else if (length > 12) {
                    title.setAttribute('data-length', 'medium');
                }
            }

            // Hiệu ứng hover cho card
            document.addEventListener('DOMContentLoaded', function () {
                const cards = document.querySelectorAll('.album-card, .track-card');

                cards.forEach(card => {
                    card.addEventListener('mouseenter', function () {
                        const img = this.querySelector('img');
                        const playButton = this.querySelector('.hover-play-button');

                        if (img)
                            img.style.transform = 'scale(1.08)';
                        if (playButton)
                            playButton.style.opacity = '1';
                    });

                    card.addEventListener('mouseleave', function () {
                        const img = this.querySelector('img');
                        const playButton = this.querySelector('.hover-play-button');

                        if (img)
                            img.style.transform = 'scale(1)';
                        if (playButton)
                            playButton.style.opacity = '0';
                    });
                });
            });

            // Chạy khi trang load
            window.addEventListener('load', adjustTitleSize);
        </script>
        <!-- --------------------------------Play Button------------------------------ -->

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


        <script>
            let searchTimeout;

            function handleSearchSubmit(event) {
                event.preventDefault();
                const query = document.getElementById('searchInput').value;
                if (query.trim()) {
                    searchItems(query);
                }
                return false;
            }

            function searchItems(query) {
                clearTimeout(searchTimeout);
                const searchResults = document.getElementById('searchResults');

                if (!query.trim()) {
                    searchResults.style.display = 'none';
                    return;
                }

                searchTimeout = setTimeout(() => {
                    console.log('Searching for:', query);
                    fetch('${pageContext.request.contextPath}/search?q=' + encodeURIComponent(query) + '&ajax=true')
                            .then(response => {
                                console.log('Response status:', response.status);
                                return response.json();
                            })
                            .then(data => {
                                console.log('Search results:', data);
                                updateSearchResults(data);
                                searchResults.style.display = 'block';
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                searchResults.style.display = 'none';
                            });
                }, 300);
            }

            function updateSearchResults(data) {
                const searchResults = document.getElementById('searchResults');
                searchResults.style.display = 'block';
                const contextPath = '${pageContext.request.contextPath}';

                // Update tracks
                const tracksList = document.querySelector('.tracks-list');
                tracksList.innerHTML = data.tracks.map(function (track) {
                    const imageUrl = track.imageUrl.startsWith('http') ? track.imageUrl : contextPath + '/' + track.imageUrl;
                    return '<form action="' + contextPath + '/home/track" method="POST" class="search-item artist-form">' +
                            '<input type="hidden" name="id" value="' + track.trackID + '">' +
                            '<img src="' + imageUrl + '" alt="' + track.title + '" class="search-item-img">' +
                            '<div class="search-item-info">' +
                            '<span class="track-title">' + track.title + '</span>' +
                            '<span>Track</span>' +
                            '</div>' +
                            '<button type="submit" class="full-area-button"></button>' +
                            '</form>';
                }).join('');

                // Update artists - Sử dụng form POST thay vì thẻ <a>
                const artistsList = document.querySelector('.artists-list');
                artistsList.innerHTML = data.artists.map(function (artist) {
                    const imageUrl = artist.imageUrl.startsWith('http') ? artist.imageUrl : contextPath + '/' + artist.imageUrl;
                    return '<form action="' + contextPath + '/home/artist" method="POST" class="search-item artist-form">' +
                            '<input type="hidden" name="id" value="' + artist.artistID + '">' +
                            '<img src="' + imageUrl + '" alt="' + artist.name + '" class="search-item-img">' +
                            '<div class="search-item-info">' +
                            '<span class="artist-name">' + artist.name + '</span>' +
                            '<span>Artist</span>' +
                            '</div>' +
                            '<button type="submit" class="full-area-button"></button>' +
                            '</form>';
                }).join('');

                // Update albums - Sử dụng form POST tương tự
                const albumsList = document.querySelector('.albums-list');
                albumsList.innerHTML = data.albums.map(function (album) {
                    const imageUrl = album.imageUrl.startsWith('http') ? album.imageUrl : contextPath + '/' + album.imageUrl;
                    return '<form action="' + contextPath + '/home/album" method="POST" class="search-item album-form">' +
                            '<input type="hidden" name="id" value="' + album.albumID + '">' +
                            '<img src="' + imageUrl + '" alt="' + album.title + '" class="search-item-img">' +
                            '<div class="search-item-info">' +
                            '<span class="album-title">' + album.title + '</span>' +
                            '<span>Album</span>' +
                            '</div>' +
                            '<button type="submit" class="full-area-button"></button>' +
                            '</form>';
                }).join('');
            }

            // Close search results when clicking outside
            document.addEventListener('click', function (event) {
                const searchResults = document.getElementById('searchResults');
                const searchBar = document.querySelector('.search-bar');
                if (!searchResults.contains(event.target) && !searchBar.contains(event.target)) {
                    searchResults.style.display = 'none';
                }
            });
        </script>

        <!-- Music Player -->
        <c:if test="${not empty sessionScope.user}">
            <div class="music-player" id="musicPlayer" style="display: none;">
                <div class="now-playing">
                    <div class="now-playing-img" id="nowPlayingImg">
                        <img id="currentSongImg" src="${pageContext.request.contextPath}"
                             alt="Now Playing">
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
            <!-- Audio Element -->
            <audio id="audioPlayer"></audio>
            </c:if>

        <!--------------------------EXPANDED PLAYER-------------------------->
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
                    <img id="expandedImg" src="${pageContext.request.contextPath}/image/m-tp.jpg"
                         alt="Now Playing">
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

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Lấy các phần tử DOM
                const playButton = document.getElementById('playCurrentTrack');
                const audioPlayer = document.getElementById('audioPlayer');
                const musicPlayer = document.querySelector('.music-player');

                // Thêm sự kiện click cho nút play
                if (playButton) {
                    playButton.addEventListener('click', function () {
                        // Lấy thông tin track từ data attributes
                        const trackId = this.getAttribute('data-track-id');
                        const trackTitle = this.getAttribute('data-track-title');
                        const trackArtist = this.getAttribute('data-track-artist');
                        const trackImage = this.getAttribute('data-track-image');
                        const trackFile = this.getAttribute('data-track-file');

                        // Hiển thị music player nếu đang ẩn
                        if (musicPlayer && musicPlayer.style.display === 'none') {
                            musicPlayer.style.display = 'flex';
                        }

                        // Cập nhật thông tin bài hát trong player
                        document.getElementById('currentSongImg').src = '${pageContext.request.contextPath}/' + trackImage;
                        document.getElementById('currentSongTitle').textContent = trackTitle;
                        document.getElementById('currentSongArtist').textContent = trackArtist;

                        // Cập nhật thông tin trong expanded player
                        document.getElementById('expandedImg').src = '${pageContext.request.contextPath}/' + trackImage;
                        document.getElementById('expandedTitle').textContent = trackTitle;
                        document.getElementById('expandedArtist').textContent = trackArtist;

                        // Thiết lập nguồn âm thanh và phát
                        audioPlayer.src = '${pageContext.request.contextPath}/' + trackFile;
                        audioPlayer.load();
                        audioPlayer.play();

                        // Cập nhật biểu tượng play/pause
                        document.querySelector('#playPauseBtn i').className = 'fas fa-pause';
                        document.querySelector('#expandedPlayBtn i').className = 'fas fa-pause';

                        // Log để debug
                        console.log('Playing track:', trackTitle, 'by', trackArtist);
                        console.log('Track file URL:', '${pageContext.request.contextPath}/' + trackFile);
                    });
                }

                // Xử lý nút play/pause trong music player
                const playPauseBtn = document.getElementById('playPauseBtn');
                if (playPauseBtn) {
                    playPauseBtn.addEventListener('click', togglePlayPause);
                }

                const expandedPlayBtn = document.getElementById('expandedPlayBtn');
                if (expandedPlayBtn) {
                    expandedPlayBtn.addEventListener('click', togglePlayPause);
                }

                // Hàm chuyển đổi phát/tạm dừng
                function togglePlayPause() {
                    if (audioPlayer.paused) {
                        audioPlayer.play();
                        document.querySelector('#playPauseBtn i').className = 'fas fa-pause';
                        document.querySelector('#expandedPlayBtn i').className = 'fas fa-pause';
                    } else {
                        audioPlayer.pause();
                        document.querySelector('#playPauseBtn i').className = 'fas fa-play';
                        document.querySelector('#expandedPlayBtn i').className = 'fas fa-play';
                    }
                }

                // Cập nhật tiến trình phát
                audioPlayer.addEventListener('timeupdate', function () {
                    const currentTime = audioPlayer.currentTime;
                    const duration = audioPlayer.duration || 0;
                    const progressPercent = (currentTime / duration) * 100;

                    // Cập nhật thanh tiến trình
                    document.getElementById('progress').style.width = progressPercent + '%';
                    document.getElementById('expandedProgress').style.width = progressPercent + '%';

                    // Cập nhật thời gian
                    document.getElementById('currentTime').textContent = formatTime(currentTime);
                    document.getElementById('expandedCurrentTime').textContent = formatTime(currentTime);
                });

                // Cập nhật thời lượng khi metadata được tải
                audioPlayer.addEventListener('loadedmetadata', function () {
                    const duration = audioPlayer.duration || 0;
                    document.getElementById('totalTime').textContent = formatTime(duration);
                    document.getElementById('expandedTotalTime').textContent = formatTime(duration);
                });

                // Định dạng thời gian
                function formatTime(seconds) {
                    const minutes = Math.floor(seconds / 60);
                    const remainingSeconds = Math.floor(seconds % 60);
                    return minutes + ':' + (remainingSeconds < 10 ? '0' : '') + remainingSeconds;
                }

                // Xử lý click vào thanh tiến trình
                const progressBar = document.getElementById('progressBar');
                if (progressBar) {
                    progressBar.addEventListener('click', function (e) {
                        const width = this.clientWidth;
                        const clickX = e.offsetX;
                        const duration = audioPlayer.duration;
                        audioPlayer.currentTime = (clickX / width) * duration;
                    });
                }

                const expandedProgressBar = document.getElementById('expandedProgressBar');
                if (expandedProgressBar) {
                    expandedProgressBar.addEventListener('click', function (e) {
                        const width = this.clientWidth;
                        const clickX = e.offsetX;
                        const duration = audioPlayer.duration;
                        audioPlayer.currentTime = (clickX / width) * duration;
                    });
                }

                // Xử lý nút mở rộng player
                const expandBtn = document.getElementById('expandBtn');
                const expandedPlayer = document.getElementById('expandedPlayer');
                const expandedCloseBtn = document.getElementById('expandedCloseBtn');

                if (expandBtn && expandedPlayer && expandedCloseBtn) {
                    expandBtn.addEventListener('click', function () {
                        expandedPlayer.classList.add('active');
                    });

                    expandedCloseBtn.addEventListener('click', function () {
                        expandedPlayer.classList.remove('active');
                    });
                }

                // Xử lý điều chỉnh âm lượng
                const volumeBtn = document.getElementById('volumeBtn');
                const volumeBar = document.getElementById('volumeBar');
                const volumeLevel = document.getElementById('volumeLevel');
                const volumeTooltip = document.getElementById('volumeTooltip');

                if (volumeBtn && volumeBar && volumeLevel && volumeTooltip) {
                    // Thiết lập âm lượng mặc định
                    audioPlayer.volume = 0.7;
                    volumeLevel.style.width = '70%';

                    // Hiển thị/ẩn thanh âm lượng khi click vào nút volume
                    volumeBtn.addEventListener('click', function () {
                        const volumeContainer = this.nextElementSibling;
                        volumeContainer.classList.toggle('active');
                    });

                    // Điều chỉnh âm lượng khi click vào thanh âm lượng
                    volumeBar.addEventListener('click', function (e) {
                        const width = this.clientWidth;
                        const clickX = e.offsetX;
                        const volumePercent = clickX / width;

                        // Cập nhật thanh âm lượng
                        volumeLevel.style.width = (volumePercent * 100) + '%';

                        // Cập nhật tooltip
                        volumeTooltip.textContent = Math.round(volumePercent * 100) + '%';

                        // Cập nhật âm lượng audio
                        audioPlayer.volume = volumePercent;

                        // Cập nhật biểu tượng âm lượng
                        updateVolumeIcon(volumePercent);
                    });
                }

                // Xử lý điều chỉnh âm lượng trong expanded player
                const expandedVolumeBtn = document.getElementById('expandedVolumeBtn');
                const expandedVolumeBar = document.getElementById('expandedVolumeBar');
                const expandedVolumeLevel = document.getElementById('expandedVolumeLevel');
                const expandedVolumeTooltip = document.getElementById('expandedVolumeTooltip');

                if (expandedVolumeBtn && expandedVolumeBar && expandedVolumeLevel && expandedVolumeTooltip) {
                    // Hiển thị/ẩn thanh âm lượng khi click vào nút volume
                    expandedVolumeBtn.addEventListener('click', function () {
                        const volumeContainer = this.nextElementSibling;
                        volumeContainer.classList.toggle('active');
                    });

                    // Điều chỉnh âm lượng khi click vào thanh âm lượng
                    expandedVolumeBar.addEventListener('click', function (e) {
                        const width = this.clientWidth;
                        const clickX = e.offsetX;
                        const volumePercent = clickX / width;

                        // Cập nhật thanh âm lượng
                        expandedVolumeLevel.style.width = (volumePercent * 100) + '%';
                        volumeLevel.style.width = (volumePercent * 100) + '%';

                        // Cập nhật tooltip
                        expandedVolumeTooltip.textContent = Math.round(volumePercent * 100) + '%';
                        volumeTooltip.textContent = Math.round(volumePercent * 100) + '%';

                        // Cập nhật âm lượng audio
                        audioPlayer.volume = volumePercent;

                        // Cập nhật biểu tượng âm lượng
                        updateVolumeIcon(volumePercent);
                    });
                }

                // Hàm cập nhật biểu tượng âm lượng
                function updateVolumeIcon(volumePercent) {
                    const volumeIcon = document.querySelector('#volumeBtn i');
                    const expandedVolumeIcon = document.querySelector('#expandedVolumeBtn i');

                    if (volumePercent === 0) {
                        volumeIcon.className = 'fas fa-volume-mute';
                        expandedVolumeIcon.className = 'fas fa-volume-mute';
                    } else if (volumePercent < 0.5) {
                        volumeIcon.className = 'fas fa-volume-down';
                        expandedVolumeIcon.className = 'fas fa-volume-down';
                    } else {
                        volumeIcon.className = 'fas fa-volume-up';
                        expandedVolumeIcon.className = 'fas fa-volume-up';
                    }
                }

                // Xử lý nút queue
                const queueBtn = document.getElementById('queueBtn');
                const queuePanel = document.getElementById('queuePanel');
                const queueCloseBtn = document.getElementById('queueCloseBtn');

                if (queueBtn && queuePanel && queueCloseBtn) {
                    queueBtn.addEventListener('click', function () {
                        queuePanel.classList.add('active');
                    });

                    queueCloseBtn.addEventListener('click', function () {
                        queuePanel.classList.remove('active');
                    });
                }

                // Xử lý nút next và previous
                const nextBtn = document.getElementById('nextBtn');
                const prevBtn = document.getElementById('prevBtn');
                const expandedNextBtn = document.getElementById('expandedNextBtn');
                const expandedPrevBtn = document.getElementById('expandedPrevBtn');

                // Tạm thói chỉ log ra console vì chưa có danh sách phát
                if (nextBtn) {
                    nextBtn.addEventListener('click', function () {
                        console.log('Next button clicked');
                    });
                }

                if (prevBtn) {
                    prevBtn.addEventListener('click', function () {
                        console.log('Previous button clicked');
                    });
                }

                if (expandedNextBtn) {
                    expandedNextBtn.addEventListener('click', function () {
                        console.log('Expanded next button clicked');
                    });
                }

                if (expandedPrevBtn) {
                    expandedPrevBtn.addEventListener('click', function () {
                        console.log('Expanded previous button clicked');
                    });
                }

                // Xử lý nút shuffle và repeat
                const shuffleBtn = document.getElementById('shuffleBtn');
                const repeatBtn = document.getElementById('repeatBtn');
                const expandedShuffleBtn = document.getElementById('expandedShuffleBtn');
                const expandedRepeatBtn = document.getElementById('expandedRepeatBtn');

                if (shuffleBtn) {
                    shuffleBtn.addEventListener('click', function () {
                        this.classList.toggle('active');
                        if (expandedShuffleBtn) {
                            expandedShuffleBtn.classList.toggle('active');
                        }
                        console.log('Shuffle:', this.classList.contains('active'));
                    });
                }

                if (expandedShuffleBtn) {
                    expandedShuffleBtn.addEventListener('click', function () {
                        this.classList.toggle('active');
                        if (shuffleBtn) {
                            shuffleBtn.classList.toggle('active');
                        }
                        console.log('Shuffle:', this.classList.contains('active'));
                    });
                }

                if (repeatBtn) {
                    repeatBtn.addEventListener('click', function () {
                        this.classList.toggle('active');
                        if (expandedRepeatBtn) {
                            expandedRepeatBtn.classList.toggle('active');
                        }
                        console.log('Repeat:', this.classList.contains('active'));
                    });
                }

                if (expandedRepeatBtn) {
                    expandedRepeatBtn.addEventListener('click', function () {
                        this.classList.toggle('active');
                        if (repeatBtn) {
                            repeatBtn.classList.toggle('active');
                        }
                        console.log('Repeat:', this.classList.contains('active'));
                    });
                }

                // Xử lý khi bài hát kết thúc
                audioPlayer.addEventListener('ended', function () {
                    // Reset UI
                    document.querySelector('#playPauseBtn i').className = 'fas fa-play';
                    document.querySelector('#expandedPlayBtn i').className = 'fas fa-play';

                    // Nếu có chế độ repeat, phát lại bài hát
                    if (repeatBtn && repeatBtn.classList.contains('active')) {
                        audioPlayer.currentTime = 0;
                        audioPlayer.play();
                    } else {
                        // Nếu không, có thể chuyển sang bài tiếp theo (khi có danh sách phát)
                        console.log('Song ended');
                    }
                });
            });
        </script>


    </body>

</html>
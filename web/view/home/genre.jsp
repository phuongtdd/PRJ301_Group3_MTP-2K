<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${selectedGenre.genreName} - MTP-2K</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/search.css" />
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
              rel="stylesheet">
        <style>
            /* Keep original styles for sidebar */

            /* Main Content Styling */
            .main-content {
                margin-left: 260px;
                padding: 30px;
                width: calc(100% - 290px);
                margin-bottom: 100px;
            }

            /* Back Button */
            .top-navigation {
                padding: 20px 20px 0 20px;
            }

            .back-button {
                display: flex;
                align-items: center;
                background-color: rgba(255, 255, 255, 0.07);
                color: white;
                border: none;
                border-radius: 30px;
                padding: 10px 20px;
                font-size: 0.9rem;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.1);
            }

            .back-button i {
                margin-right: 8px;
                font-size: 0.9rem;
            }

            .back-button:hover {
                background-color: rgba(255, 255, 255, 0.15);
                transform: translateY(-2px);
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
            }

            .back-button:active {
                transform: translateY(0);
            }

            /* Genre Navigation */
            .genre-nav {
                display: flex;
                gap: 12px;
                padding: 20px;
                overflow-x: auto;
                white-space: nowrap;
                -ms-overflow-style: none;
                scrollbar-width: none;
                margin-bottom: 10px;
                position: relative;
            }

            .genre-nav::after {
                content: '';
                position: absolute;
                right: 0;
                top: 0;
                height: 100%;
                width: 60px;
                background: linear-gradient(to right, rgba(18, 18, 18, 0), rgba(18, 18, 18, 0.8));
                pointer-events: none;
            }

            .genre-nav::-webkit-scrollbar {
                display: none;
            }

            .genre-nav-item {
                padding: 12px 24px;
                border-radius: 30px;
                background-color: rgba(255, 255, 255, 0.07);
                color: white;
                text-decoration: none;
                transition: all 0.3s ease;
                font-weight: 600;
                font-size: 0.95rem;
                border: 1px solid rgba(255, 255, 255, 0.1);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .genre-nav-item:hover {
                background-color: rgba(255, 255, 255, 0.15);
                transform: translateY(-2px);
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
            }

            .genre-nav-item.active {
                background-color: #1DB954;
                border-color: #1DB954;
                box-shadow: 0 4px 12px rgba(29, 185, 84, 0.3);
            }

            /* Genre Header */
            .genre-header {
                padding: 60px 40px;
                background-size: cover !important;
                background-position: center !important;
                color: white;
                margin: 0 20px 30px 20px;
                border-radius: 20px;
                box-shadow: 0 12px 24px rgba(0, 0, 0, 0.25);
                position: relative;
                overflow: hidden;
            }

            .genre-header::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: linear-gradient(135deg, rgba(0, 0, 0, 0.3) 0%, rgba(0, 0, 0, 0.7) 100%);
                z-index: 1;
            }

            .genre-header-content {
                position: relative;
                z-index: 2;
                display: flex;
                align-items: center;
                gap: 30px;
            }

            .genre-icon-large {
                font-size: 4rem;
                color: rgba(255, 255, 255, 0.9);
                background: rgba(255, 255, 255, 0.1);
                width: 100px;
                height: 100px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
                border: 2px solid rgba(255, 255, 255, 0.2);
            }

            .genre-header-text {
                flex: 1;
            }

            .genre-title {
                font-size: 3.5rem;
                margin: 0;
                font-weight: 800;
                letter-spacing: -0.5px;
                position: relative;
                text-shadow: 0 4px 8px rgba(0, 0, 0, 0.4);
            }

            .track-count {
                font-size: 1.1rem;
                color: rgba(255, 255, 255, 0.9);
                margin-top: 10px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .track-count i {
                color: rgba(255, 255, 255, 0.7);
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .genre-header-content {
                    flex-direction: column;
                    text-align: center;
                    gap: 20px;
                }

                .genre-title {
                    font-size: 2.5rem;
                }

                .genre-icon-large {
                    width: 80px;
                    height: 80px;
                    font-size: 3rem;
                }
            }

            /* Tracks Container */
            .tracks-container {
                padding: 0 20px 20px 20px;
            }

            .track-list {
                list-style: none;
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
                gap: 24px;
                padding: 0;
            }

            .track-item {
                display: flex;
                flex-direction: column;
                align-items: center;
                padding: 20px;
                border-radius: 12px;
                transition: all 0.3s ease;
                background-color: rgba(255, 255, 255, 0.07);
                text-align: center;
                position: relative;
                overflow: hidden;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
                height: 100%;
            }

            .track-item:hover {
                background-color: rgba(255, 255, 255, 0.15);
                transform: translateY(-5px);
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
            }

            .track-item:hover .track-image {
                transform: scale(1.05);
            }

            .track-image {
                width: 100%;
                aspect-ratio: 1/1;
                object-fit: cover;
                border-radius: 8px;
                margin-bottom: 16px;
                transition: all 0.3s ease;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            }

            .track-info {
                flex-grow: 1;
                width: 100%;
                z-index: 1;
                display: flex;
                flex-direction: column;
            }

            .track-title {
                margin: 0 0 8px 0;
                width: 100%;
            }

            .view-track-btn {
                background: transparent;
                border: none;
                color: white;
                padding: 0;
                font-weight: 600;
                font-size: 1rem;
                text-align: center;
                cursor: pointer;
                width: 100%;
                overflow: hidden;
                text-overflow: ellipsis;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                transition: color 0.2s ease;
            }

            .view-track-btn:hover {
                color: #1DB954;
            }

            .track-artist {
                color: #b3b3b3;
                font-size: 0.85rem;
                margin: 0;
                overflow: hidden;
                text-overflow: ellipsis;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
            }

            /* Responsive adjustments for track grid */
            @media (max-width: 992px) {
                .track-list {
                    grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
                }
            }

            @media (max-width: 768px) {
                .track-list {
                    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                }

                .genre-title {
                    font-size: 2.5rem;
                }
            }

            @media (max-width: 576px) {
                .track-list {
                    grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
                    gap: 16px;
                }

                .track-item {
                    padding: 15px;
                }

                .genre-title {
                    font-size: 2rem;
                }
            }
        </style>
    </head>

    <body>

        <div id="toast" class="toast"></div>
        <script>
            window.onload = function () {
                var message = "${sessionScope.message}";
                if (message && message.trim() !== "") {
                    var toast = document.getElementById("toast");
                    var messageType = "${sessionScope.messageType}";

                    toast.textContent = message;
                    toast.className = "toast show " + (messageType || "info");

                    setTimeout(function () {
                        toast.classList.remove("show");
                    }, 3000);
                }
            };
        </script>
        <% session.removeAttribute("message");
            session.removeAttribute("messageType");%>
        <!-- Keep existing sidebar -->
        <div class="sidebar">
            <div class="logo-container">
                <img src="${pageContext.request.contextPath}/image/mtp2k-logo.png" alt="MTP-2K"
                     style="border-radius: 50%;">
            </div>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Home</a>
                </li>
                <li><a href="${pageContext.request.contextPath}/home/search"><i class="fas fa-search"></i>
                        Search</a></li>
                <li><a href="${pageContext.request.contextPath}/home/library"><i class="fas fa-book"></i>
                        Your
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
                                    <img src="${track.imageUrl}" alt="${track.title}"
                                         class="search-item-img">
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
                                    <img src="${artist.imageUrl}" alt="${artist.name}"
                                         class="search-item-img">
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
                                    <img src="${album.imageUrl}" alt="${album.title}"
                                         class="search-item-img">
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

            <!-- Back Button -->
            <div class="top-navigation">
                <button class="back-button" 
                        onclick="window.location.href = '${pageContext.request.contextPath}/home/search'">
                    <i class="fas fa-arrow-left"></i>
                    <span>Back to Search</span>
                </button>
            </div>

            <!-- Genre Navigation -->
            <nav class="genre-nav">
                <c:forEach items="${genres}" var="genre">
                    <a href="${pageContext.request.contextPath}/home/genre?id=${genre.genreID}"
                       class="genre-nav-item ${genre.genreID == selectedGenre.genreID ? 'active' : ''}">
                        ${genre.genreName}
                    </a>
                </c:forEach>
            </nav>

            <!-- Genre Header -->
            <div class="genre-header" style="background: linear-gradient(135deg,
                 ${selectedGenre.genreID % 10 == 0 ? '#4CAF50, #2E7D32' : 
                   selectedGenre.genreID % 10 == 1 ? '#2196F3, #1565C0' :
                   selectedGenre.genreID % 10 == 2 ? '#9C27B0, #6A1B9A' :
                   selectedGenre.genreID % 10 == 3 ? '#E91E63, #AD1457' :
                   selectedGenre.genreID % 10 == 4 ? '#FF5722, #D84315' :
                   selectedGenre.genreID % 10 == 5 ? '#673AB7, #4527A0' :
                   selectedGenre.genreID % 10 == 6 ? '#3F51B5, #283593' :
                   selectedGenre.genreID % 10 == 7 ? '#795548, #4E342E' :
                   selectedGenre.genreID % 10 == 8 ? '#FF4081, #C2185B' :
                   '#00BCD4, #00838F'});">
                <div class="genre-header-content">
                    <div class="genre-icon-large">
                        <i class="fas ${selectedGenre.genreID % 9 == 0 ? 'fa-guitar' : 
                                        selectedGenre.genreID % 9 == 1 ? 'fa-drum' :
                                        selectedGenre.genreID % 9 == 2 ? 'fa-music' :
                                        selectedGenre.genreID % 9 == 3 ? 'fa-headphones' :
                                        selectedGenre.genreID % 9 == 4 ? 'fa-compact-disc' :
                                        selectedGenre.genreID % 9 == 5 ? 'fa-microphone-alt' :
                                        selectedGenre.genreID % 9 == 6 ? 'fa-record-vinyl' :
                                        selectedGenre.genreID % 9 == 7 ? 'fa-volume-up' :
                                        'fa-podcast'}"></i>
                    </div>
                    <div class="genre-header-text">
                        <h1 class="genre-title">${selectedGenre.genreName}</h1>
                        <p class="track-count"><i class="fas fa-music"></i> ${tracks.size()} tracks</p>
                    </div>
                </div>
            </div>

            <!-- Tracks List -->
            <div class="tracks-container">
                <ul class="track-list">
                    <c:forEach items="${tracks}" var="track" varStatus="status">
                        <li class="track-item">
                            <img src="${pageContext.request.contextPath}/${track.imageUrl}" alt="${track.title}"
                                 class="track-image">
                            <div class="track-info">
                                <form id="trackViewForm${track.trackID}" action="${pageContext.request.contextPath}/home/track"
                                      method="POST" style="display:none;">
                                    <input type="hidden" name="id" value="${track.trackID}">
                                </form>
                                <button onclick="document.getElementById('trackViewForm${track.trackID}').submit();"
                                        class="view-track-btn">${track.title}</button>
                                <p class="track-artist">
                                    <c:forEach items="${track.artists}" var="artist" varStatus="artistStatus">
                                        ${artist.name}${!artistStatus.last ? ', ' : ''}
                                    </c:forEach>
                                </p>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>

        <!-- Keep existing signup banner -->
        <c:if test="${empty sessionScope.user}">
            <div class="signup-banner">
                <div class="preview-text">
                    <h3>Preview of MTP-2K</h3>
                    <p>Sign up to get unlimited songs and podcasts with occasional ads. No credit card
                        needed.</p>
                </div>
                <a href="${pageContext.request.contextPath}/login" class="signup-button">Sign up
                    free</a>
            </div>
        </c:if>

    </div>

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
            <p style="color: #e6f1ff; margin-bottom: 20px;">Are you sure you want to delete your
                account? This action cannot be undone.</p>
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
        
      
                function playTrack(trackId) {
                    // Redirect to track detail page
                    window.location.href = '${pageContext.request.contextPath}/home/track?id=' + trackId;
                }
            
    </script>

</body>

</html>
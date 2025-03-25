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
                <link
                    href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap&family=Roboto:wght@300;400;500;700&family=Noto+Sans:wght@300;400;500;700&display=swap&subset=vietnamese"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/search.css" />
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/artist.css" />
                <script src="https://cdnjs.cloudflare.com/ajax/libs/color-thief/2.3.0/color-thief.umd.js"></script>
                <style>
                    body {
                        font-family: 'Noto Sans', 'Roboto', 'Poppins', sans-serif;
                    }
                </style>
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

                <!-- Main Content -->
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


                    <!-- Artist Header -->
                    <div class="artist-header">
                        <img src="${pageContext.request.contextPath}/${sessionScope.artist.imageUrl}"
                            alt="Artist Avatar" class="artist-avatar">
                        <div class="artist-info">
                            <span class="artist-type">Artist</span>
                            <h1 class="artist-name">${artist.name}</h1>
                            <div class="artist-stats">
                            </div>
                        </div>
                    </div>

                    <div class="artist-actions">
                        <div class="play-button">
                            <i class="fas fa-play"></i>
                        </div>
                        <i class="far fa-heart artist-action-icon"></i>
                        <i class="fas fa-plus-square artist-action-icon" title="Add to Your Library"></i>

                    </div>

                    <!-- Popular Tracks Section -->
                    <section class="popular-tracks">
                        <h2>Popular</h2>
                        <div class="track-list">
                            <c:choose>
                                <c:when test="${not empty sessionScope.artistTopTracks}">
                                    <c:forEach var="track" items="${sessionScope.artistTopTracks}" varStatus="loop">
                                        <c:if test="${loop.index < 5}">
                                            <div class="track-item popular">
                                                <form id="trackForm${track.trackID}"
                                                    action="${pageContext.request.contextPath}/home/track" method="POST"
                                                    style="display:none;">
                                                    <input type="hidden" name="id" value="${track.trackID}">
                                                </form>
                                                <div class="track-number">${loop.index + 1}</div>
                                                <div class="track-info"
                                                    onclick="document.getElementById('trackForm${track.trackID}').submit();"
                                                    style="cursor: pointer;">
                                                    <img src="${pageContext.request.contextPath}/${track.imageUrl}"
                                                        alt="${track.title}" class="track-cover">
                                                    <div class="track-details">
                                                        <div class="track-title">${track.title}</div>
                                                    </div>
                                                </div>
                                                <div class="track-plays">
                                                    <i class="fas fa-headphones-alt"></i> ${track.record}
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-tracks-message">
                                        <p>No tracks available for this artist.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </section>

                    <!-- Album Releases Section -->
                    <section class="popular-releases">
                        <div class="section-header">
                            <h2>Albums</h2>
                            <a href="#" class="show-all">Show all</a>
                        </div>
                        <div class="album-section">
                            <c:choose>
                                <c:when test="${not empty sessionScope.artistAlbums}">
                                    <c:forEach var="album" items="${sessionScope.artistAlbums}" varStatus="loop">
                                        <c:if test="${loop.index < 4}">
                                            <div class="album-card">
                                                <form id="albumForm${album.albumID}"
                                                    action="${pageContext.request.contextPath}/home/album" method="POST"
                                                    style="display:none;">
                                                    <input type="hidden" name="id" value="${album.albumID}">
                                                </form>
                                                <div onclick="document.getElementById('albumForm${album.albumID}').submit();"
                                                    style="cursor: pointer;">
                                                    <img src="${pageContext.request.contextPath}/${album.imageUrl}"
                                                        alt="${album.title}">
                                                    <div class="card-info">
                                                        <h3>${album.title}</h3>
                                                        <p>${album.releaseDate.getYear() + 1900}</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-albums-message">
                                        <p>No albums available for this artist.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </section>


                    <!-- Track Section -->
                    <section class="popular-releases">
                        <div class="section-header">
                            <h2>Tracks</h2>
                            <a href="#" class="show-all">Show all</a>
                        </div>
                        <div class="album-section">
                            <c:choose>
                                <c:when test="${not empty sessionScope.artistTopTracks}">
                                    <c:forEach var="track" items="${sessionScope.artistTopTracks}" varStatus="loop">
                                        <c:if test="${loop.index < 5}">
                                            <div class="track-card">
                                                <form id="trackDetailForm${track.trackID}"
                                                    action="${pageContext.request.contextPath}/home/track" method="POST"
                                                    style="display:none;">
                                                    <input type="hidden" name="id" value="${track.trackID}">
                                                </form>
                                                <div onclick="document.getElementById('trackDetailForm${track.trackID}').submit();"
                                                    style="cursor: pointer;">
                                                    <img src="${pageContext.request.contextPath}/${track.imageUrl}"
                                                        alt="${track.title}">
                                                    <div class="card-info">
                                                        <h3 class="card-title">${track.title}</h3>
                                                        <p class="card-description">${track.record} plays</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-tracks-message">
                                        <p>No tracks available for this artist.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </section>
                </div>



                <!-- Signup Banner -->
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
                <script>
                    // Script cho nút Follow
                    const followButton = document.querySelector('.follow-button');
                    let isFollowing = false;

                    followButton.addEventListener('click', function () {
                        isFollowing = !isFollowing;
                        if (isFollowing) {
                            followButton.textContent = 'FOLLOWING';
                            followButton.classList.add('following');
                        } else {
                            followButton.textContent = 'FOLLOW';
                            followButton.classList.remove('following');
                        }
                    });

                    // Thêm hover effect để hiển thị "UNFOLLOW" khi hover vào nút Following
                    followButton.addEventListener('mouseenter', function () {
                        if (isFollowing) {
                            followButton.textContent = 'UNFOLLOW';
                        }
                    });

                    followButton.addEventListener('mouseleave', function () {
                        if (isFollowing) {
                            followButton.textContent = 'FOLLOWING';
                        }
                    });

                    function adjustTitleSize() {
                        const title = document.querySelector('.artist-name');
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


            </body>

            </html>
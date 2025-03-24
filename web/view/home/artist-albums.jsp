<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Artist Albums - MTP-2K</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link
        href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap&family=Roboto:wght@300;400;500;700&family=Noto+Sans:wght@300;400;500;700&display=swap&subset=vietnamese"
        rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/search.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/artist.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/show-all.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/color-thief/2.3.0/color-thief.umd.js"></script>
    <style>
        body {
            font-family: 'Noto Sans', 'Roboto', 'Poppins', sans-serif;
        }
        .all-container {
            padding: 30px;
            margin-top: 20px;
        }
        .all-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        .all-title {
            font-size: 28px;
            color: #fff;
            margin: 0;
        }
        .back-button {
            background: #1db954;
            color: white;
            padding: 10px 20px;
            border-radius: 30px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .back-button:hover {
            background: #1ed760;
            transform: scale(1.05);
        }
        .grid-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 24px;
        }
        .album-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            padding: 16px;
            transition: all 0.3s ease;
        }
        .album-card:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-5px);
        }
        .album-image {
            width: 100%;
            aspect-ratio: 1/1;
            object-fit: cover;
            border-radius: 4px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.3);
        }
        .card-info {
            margin-top: 12px;
        }
        .card-title {
            font-size: 16px;
            font-weight: 600;
            color: #fff;
            margin: 8px 0 4px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .card-description {
            font-size: 14px;
            color: #a8b2d1;
            margin: 0;
        }
        .no-albums-message {
            grid-column: 1 / -1;
            text-align: center;
            padding: 40px;
            color: #a8b2d1;
            font-size: 18px;
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
            }
        }
    </script>
    
    <% 
        // Clean up session attributes
        if (session.getAttribute("message") != null) {
            session.removeAttribute("message");
            session.removeAttribute("messageType");
        }
    %>

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
            <form action="${pageContext.request.contextPath}/home/search" method="GET" class="search-bar"
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
                        <div class="auth-buttons">
                            <a href="${pageContext.request.contextPath}/login"
                                class="signup-btn">Sign Up</a>
                            <a href="${pageContext.request.contextPath}/login"
                                class="login-btn">Log In</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <!------------------------------ USER LOGIN --------------------------------------------->
        </div>

        <div class="all-container">
            <div class="all-header">
                <h1 class="all-title">All Albums by ${requestScope.artist.name}</h1>
                <a href="${pageContext.request.contextPath}/home/artist?id=${requestScope.artist.artistID}" class="back-button">
                    <i class="fas fa-arrow-left"></i> Back to Artist
                </a>
            </div>

            <div class="grid-container">
                <c:choose>
                    <c:when test="${not empty requestScope.artistAlbums}">
                        <c:forEach var="album" items="${requestScope.artistAlbums}">
                            <div class="album-card">
                                <form id="albumForm${album.albumID}"
                                    action="${pageContext.request.contextPath}/home/album" method="POST"
                                    style="display:none;">
                                    <input type="hidden" name="id" value="${album.albumID}">
                                </form>
                                <div onclick="document.getElementById('albumForm${album.albumID}').submit();"
                                    style="cursor: pointer;">
                                    <img src="${pageContext.request.contextPath}/${album.imageUrl}"
                                        alt="${album.title}" class="album-image">
                                    <div class="card-info">
                                        <h3 class="card-title">${album.title}</h3>
                                        <p class="card-description">${album.releaseDate.getYear() + 1900}</p>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="no-albums-message">
                            <p>No albums available for this artist.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

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

    <!-- Modal forms for user profile management -->
    <div id="profileModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal('profileModal')">&times;</span>
            <h2>Your Profile</h2>
            <div class="profile-info">
                <p><strong>Name:</strong> ${sessionScope.user.fullName}</p>
                <p><strong>Email:</strong> ${sessionScope.user.email}</p>
                <p><strong>Phone:</strong> ${sessionScope.user.phone}</p>
            </div>
        </div>
    </div>

    <div id="passwordModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal('passwordModal')">&times;</span>
            <h2>Change Password</h2>
            <form action="${pageContext.request.contextPath}/user?action=changePassword" method="POST">
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
                </div>
                <button type="submit" class="btn-submit">Change Password</button>
            </form>
        </div>
    </div>

    <div id="emailModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal('emailModal')">&times;</span>
            <h2>Change Email</h2>
            <form action="${pageContext.request.contextPath}/user?action=changeEmail" method="POST">
                <div class="form-group">
                    <label for="currentEmail">Current Email</label>
                    <input type="email" id="currentEmail" value="${sessionScope.user.email}" readonly>
                </div>
                <div class="form-group">
                    <label for="newEmail">New Email</label>
                    <input type="email" id="newEmail" name="newEmail" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <button type="submit" class="btn-submit">Change Email</button>
            </form>
        </div>
    </div>

    <div id="phoneModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal('phoneModal')">&times;</span>
            <h2>Change Phone Number</h2>
            <form action="${pageContext.request.contextPath}/user?action=changePhone" method="POST">
                <div class="form-group">
                    <label for="currentPhone">Current Phone</label>
                    <input type="text" id="currentPhone" value="${sessionScope.user.phone}" readonly>
                </div>
                <div class="form-group">
                    <label for="newPhone">New Phone</label>
                    <input type="text" id="newPhone" name="newPhone" required>
                </div>
                <div class="form-group">
                    <label for="phonePassword">Password</label>
                    <input type="password" id="phonePassword" name="password" required>
                </div>
                <button type="submit" class="btn-submit">Change Phone</button>
            </form>
        </div>
    </div>

    <div id="deleteAccountModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal('deleteAccountModal')">&times;</span>
            <h2>Delete Account</h2>
            <p class="warning-text">Warning: This action cannot be undone. All your data will be permanently deleted.</p>
            <form action="${pageContext.request.contextPath}/user?action=deleteAccount" method="POST">
                <div class="form-group">
                    <label for="deletePassword">Enter your password to confirm</label>
                    <input type="password" id="deletePassword" name="password" required>
                </div>
                <button type="submit" class="btn-delete">Delete My Account</button>
            </form>
        </div>
    </div>

    <script>
        function showModal(modalId) {
            document.getElementById(modalId).style.display = "block";
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = "none";
        }

        // Close modal when clicking outside of it
        window.onclick = function (event) {
            if (event.target.classList.contains('modal')) {
                event.target.style.display = "none";
            }
        }

        function handleSearchSubmit(event) {
            const searchInput = document.getElementById('searchInput');
            if (!searchInput.value.trim()) {
                event.preventDefault();
                return false;
            }
            return true;
        }
    </script>
</body>
</html>

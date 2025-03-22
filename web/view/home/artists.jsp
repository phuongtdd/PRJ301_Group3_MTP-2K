<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Music Library</title>
        <link rel="stylesheet" href="styles.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap&family=Roboto:wght@300;400;500;700&family=Noto+Sans:wght@300;400;500;700&display=swap&subset=vietnamese" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/artist.css"/>
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
            <!-- Search Container -->
            <div class="search-container">
                <div class="search-bar">
                    <i class="fas fa-search" style="color: #a8b2d1;"></i>
                    <input type="text" placeholder="What do you want to listen to?">
                </div>
                <div class="nav-buttons">
                    <a href="playlist" class="nav-button">
                        <i class="fas fa-list-ul"></i>
                        Playlist
                    </a>
                    <a href="artists" class="nav-button active">
                        <i class="fas fa-microphone-alt"></i>
                        Artists
                    </a>
                    <a href="albums" class="nav-button">
                        <i class="fas fa-compact-disc"></i>
                        Albums
                    </a>
                </div>
            </div>

            <!-- Artist Header -->
            <div class="artist-header">
                <img src="${pageContext.request.contextPath}/${sessionScope.artist.imageUrl}" alt="Artist Avatar" class="artist-avatar">
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
                    <div class="track-item popular">
                        <div class="track-number">1</div>
                        <div class="track-info">
                            <img src="../image/chungtacuahientai.jpg" alt="Track Cover" class="track-cover">
                            <div class="track-details">
                                <div class="track-title">Chúng Ta Của Hiện Tại</div>

                            </div>
                        </div>
                        <div class="track-duration"></div>
                    </div>

                    <div class="track-item popular">
                        <div class="track-number">2</div>
                        <div class="track-info">
                            <img src="../image/makingmyway.jpg" alt="Track Cover" class="track-cover">
                            <div class="track-details">
                                <div class="track-title">Making My Way</div>

                            </div>
                        </div>
                        <div class="track-duration"></div>
                    </div>

                    <div class="track-item popular">
                        <div class="track-number">3</div>
                        <div class="track-info">
                            <img src="../image/muonroimasaocon.jpg" alt="Track Cover" class="track-cover">
                            <div class="track-details">
                                <div class="track-title">Muộn Rồi Mà Sao Còn</div>

                            </div>
                        </div>
                        <div class="track-duration"></div>
                    </div>
                </div>
            </section>

            <!-- Popular Releases Section -->
            <section class="popular-releases">
                <div class="section-header">
                    <h2>Popular Releases</h2>
                    <a href="#" class="show-all">Show all</a>
                </div>
                <div class="album-section">
                    <div class="album-card">
                        <img src="../image/skytour.jpg" alt="Album Cover">
                        <div class="card-info">
                            <h3 class="card-title">Sky Tour</h3>
                            <p class="card-description">Album • 2021</p>
                        </div>
                    </div>
                    <div class="track-card">
                        <img src="../image/muonroimasaocon.jpg" alt="Track Cover">
                        <div class="card-info">
                            <h3 class="card-title">Muộn rồi mà sao còn</h3>
                            <p class="card-description">2022 • Track</p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Albums Section -->
            <section class="popular-releases">
                <div class="section-header">
                    <h2>Albums</h2>
                    <a href="#" class="show-all">Show all</a>
                </div>
                <div class="album-section">
                    <div class="album-card">
                        <img src="../image/skytour.jpg" alt="Album Cover">
                        <div class="card-info">
                            <h3 class="card-title">Sky Tour</h3>
                            <p class="card-description">Album • 2021</p>
                        </div>
                    </div>
                    <div class="album-card">
                        <img src="../image/m-tp.jpg" alt="Album Cover">
                        <div class="card-info">
                            <h3 class="card-title">M-TP</h3>
                            <p class="card-description">Album • 2021</p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Track Section -->
            <section class="popular-releases">
                <div class="section-header">
                    <h2>Tracks</h2>
                    <a href="#" class="show-all">Show all</a>
                </div>
                <div class="album-section">
                    <div class="track-card">
                        <img src="../image/muonroimasaocon.jpg" alt="Track Cover">
                        <div class="card-info">
                            <h3 class="card-title">Muộn rồi mà sao còn</h3>
                            <p class="card-description">2022 • Track</p>
                        </div>
                    </div>
                    <div class="track-card">
                        <img src="../image/makingmyway.jpg" alt="Track Cover">
                        <div class="card-info">
                            <h3 class="card-title">Making My Way</h3>
                            <p class="card-description">2023 • Track</p>
                        </div>
                    </div>
                    <div class="track-card">
                        <img src="../image/chungtacuahientai.jpg" alt="Track Cover">
                        <div class="card-info">
                            <h3 class="card-title">Chúng Ta Của Hiện Tại</h3>
                            <p class="card-description">2023 • Track</p>
                        </div>
                    </div>
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
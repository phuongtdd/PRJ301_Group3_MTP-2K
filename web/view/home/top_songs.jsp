<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Top Songs - MTP-2K</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/topsong.css"/>
    </head>
    <body>
        <!-- Page transition overlay -->
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
        <div class="page-transition-overlay" id="pageTransitionOverlay"></div>

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
            <div class="section-title">

            </div>


            <!-- Charts Section -->
            <div class="charts-section">
                <div class="section-title" style="font-size: 20px;">
                    <i class="fas fa-chart-line"></i> Top Most-Played Songs of All Time
                </div>
                <div class="chart-container" id="trackChart">
                    <!-- Chart bars will be generated by JavaScript -->
                </div>

            </div>

            <!-- Tracks Section -->
            <div class="tracks-list">
                <div class="track-list-header">
                    <div>#</div>
                    <div></div>
                    <div>TITLE</div>
                    <div>DATE ADDED</div>
                    <div>DURATION</div>
                    <div>PLAYS</div>
                </div>

                <c:forEach var="item" items="${tracks}" varStatus="loop">
                    <div class="track-item" onclick="playTrack('${pageContext.request.contextPath}/${item.fileUrl}', '${item.title}')">
                        <div class="track-rank">
                            <c:choose>
                                <c:when test="${loop.index == 0}">
                                    <i class="fas fa-medal" style="color: #FFD700;"></i> <!-- Huy chương vàng -->
                                </c:when>
                                <c:when test="${loop.index == 1}">
                                    <i class="fas fa-medal" style="color: #C0C0C0;"></i> <!-- Huy chương bạc -->
                                </c:when>
                                <c:when test="${loop.index == 2}">
                                    <i class="fas fa-medal" style="color: #CD7F32;"></i> <!-- Huy chương đồng -->
                                </c:when>
                                <c:otherwise>
                                    ${loop.index + 1}
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <img src="${pageContext.request.contextPath}/${item.imageUrl}" alt="${item.title}" class="track-image">
                        <div class="track-info">
                            <h3 class="track-title">${item.title}</h3>
                            <p class="track-artist">Various Artists</p>
                        </div>
                        <div class="track-date">Dec 1, 2023</div>
                        <div class="track-duration">3:30</div>
                        <div class="track-plays">${item.record}</div>
                    </div>
                </c:forEach>
            </div>
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
        <!-- Audio Player and Toast -->
        <audio id="audioPlayer"></audio>
        <div class="toast" id="toast"></div>



        <script>

            // Play track function
            function playTrack(src, title) {
                const audioPlayer = document.getElementById('audioPlayer');
                audioPlayer.src = src;
                audioPlayer.play();

                // Show toast notification
                const toast = document.getElementById('toast');
                toast.textContent = `Now playing: ${title}`;
                toast.classList.add('show');

                // Hide toast after 3 seconds
                setTimeout(() => {
                    toast.classList.remove('show');
                }, 3000);
            }
            /*===============================================================================================================================*/
            document.addEventListener('DOMContentLoaded', function () {
                // Sample data: Top 8 tracks
                const trackData = [
                    {title: "Đánh Đổi", plays: 7250, artist: "Sơn Tùng MTP"},
                    {title: "Drunk", plays: 5680, artist: "HIEUTHUHAI"},
                    {title: "Thiên Lý Ơi", plays: 4480, artist: "JACK"},
                    {title: "-237 Độ C", plays: 2760, artist: "HIEUTHUHAI"},
                    {title: "Anh Đã Quen Với Cô Đơn", plays: 1890, artist: "Sơn Tùng MTP"},
                    {title: "3107", plays: 1150, artist: "W/n x Nâu x Duongg"},
                    {title: "Gặp Nhưng Không Ở Lại", plays: 720, artist: "HIỀN HỒ"},
                    {title: "Flower", plays: 1320, artist: "JISOO"}
                ];

                // Sort tracks by plays (descending order)
                trackData.sort((a, b) => b.plays - a.plays);

                // Find maximum plays to scale the chart
                const maxPlays = Math.max(...trackData.map(t => t.plays));

                // Get the chart container
                const chartContainer = document.getElementById('trackChart');

                /*==================================================================================================================================*/

                // Set the height of the chart container
                const chartHeight = 420; // Example height of the chart container in pixels
                chartContainer.style.height = `${chartHeight}px`;

                // Create bars for the chart
                trackData.forEach((track, index) => {
                    // Calculate height as a percentage of the max plays
                    const heightPercentage = (track.plays / maxPlays) * 100;
                    const height = (heightPercentage * chartHeight) / 100; // Use the dynamic height of the container

                    // Assign color for each bar (example: using a color array)
                    const colors = ['#FF6F61', '#FFA07A', '#FFD700', '#90EE90', '#ADD8E6', '#B0E0E6', '#9370DB', '#64FFDA'];
                    const barColor = colors[index % colors.length];

                    // Create the bar element
                    const barDiv = document.createElement('div');
                    barDiv.className = 'chart-bar';
                    barDiv.style.height = '0px'; // Start at 0 for animation
                    barDiv.style.backgroundColor = barColor; // Set the color for each bar

                    // Tạo tooltip hiển thị khi hover vào cột
                    const tooltipDiv = document.createElement('div');
                    tooltipDiv.className = 'chart-tooltip';

                    // Tạo nội dung cho tooltip gồm 3 thành phần
                    const titleElem = document.createElement('div');
                    titleElem.className = 'tooltip-title';
                    titleElem.textContent = track.title;

                    const artistElem = document.createElement('div');
                    artistElem.className = 'tooltip-artist';
                    artistElem.textContent = track.artist;

                    const playsElem = document.createElement('div');
                    playsElem.className = 'tooltip-plays';
                    playsElem.innerHTML = `<span>${track.plays.toLocaleString()}</span> lượt nghe`;

                    // Thêm 3 thành phần vào tooltip
                    tooltipDiv.appendChild(titleElem);
                    tooltipDiv.appendChild(artistElem);


                    // Thêm tooltip vào cột
                    barDiv.appendChild(tooltipDiv);

                    // Add title (label) on top of the bar with text truncation if needed
                    const labelDiv = document.createElement('div');
                    labelDiv.className = 'chart-bar-label';

                    labelDiv.style.color = 'white'; // Đảm bảo chữ màu trắng
                    labelDiv.style.marginTop = '10px'; // Đưa chữ xuống dưới cột


                    // Add play count value under the bar
                    const valueDiv = document.createElement('div');
                    valueDiv.className = 'chart-bar-value';
                    valueDiv.textContent = track.plays; // Display only the number
                    valueDiv.style.color = barColor; // Set the color of the text to match the bar color

                    // Append label and value to the bar
                    barDiv.appendChild(labelDiv);
                    barDiv.appendChild(valueDiv);
                    chartContainer.appendChild(barDiv);

                    // Animate height after a small delay
                    setTimeout(() => {
                        barDiv.style.height = height + 'px';
                    }, 100 + index * 50);
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
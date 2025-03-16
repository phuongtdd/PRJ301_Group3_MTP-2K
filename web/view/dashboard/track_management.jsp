<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Track Management - Admin Panel</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
        <style>
            .track-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 25px;
                margin-top: 30px;
            }

            .track-card {
                background: #112240;
                border-radius: 12px;
                overflow: hidden;
                transition: all 0.3s ease;
                border: 1px solid rgba(100, 255, 218, 0.1);
            }

            .track-card:hover {
                transform: translateY(-5px);
                border-color: #64ffda;
                box-shadow: 0 10px 30px rgba(100, 255, 218, 0.1);
            }

            .track-image-container {
                position: relative;
                padding-top: 100%;
                background: #1a365d;
            }

            .track-image {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .track-info {
                padding: 20px;
            }

            .track-name {
                color: #e6f1ff;
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 8px;
            }

            .track-stats {
                display: flex;
                gap: 15px;
                margin-bottom: 15px;
            }

            .stat {
                display: flex;
                align-items: center;
                gap: 5px;
                color: #a8b2d1;
                font-size: 13px;
            }

            .track-genres {
                display: flex;
                flex-wrap: wrap;
                gap: 8px;
                margin-bottom: 15px;
            }

            .genre-tag {
                background: rgba(100, 255, 218, 0.1);
                color: #64ffda;
                padding: 4px 12px;
                border-radius: 15px;
                font-size: 12px;
            }

            .card-actions {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding-top: 15px;
                border-top: 1px solid rgba(100, 255, 218, 0.1);
            }

            .track-status {
                font-size: 13px;
            }

            .status-verified {
                color: #64ffda;
            }

            .status-pending {
                color: #ffd700;
            }

            .filter-bar {
                display: flex;
                gap: 15px;
                margin-bottom: 20px;
                flex-wrap: wrap;
            }

            .filter-group {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .filter-label {
                color: #a8b2d1;
                font-size: 14px;
            }

            .sort-select {
                min-width: 180px;
            }

            .view-toggle {
                display: flex;
                gap: 10px;
                margin-left: auto;
            }

            .view-toggle button {
                background: transparent;
                border: 1px solid #64ffda;
                color: #64ffda;
                width: 40px;
                height: 40px;
                border-radius: 6px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .view-toggle button.active {
                background: #64ffda;
                color: #0a192f;
            }

            .track-table {
                display: none;
            }

            .track-table.active {
                display: table;
            }

            .track-grid.active {
                display: grid;
            }
        </style>
    </head>
    <body>
        <div class="sidebar">
            <div class="logo">
                <i class="fas fa-music"></i>
                MTP-2K Admin
            </div>
            <ul class="nav-menu">
                <li><a href="${pageContext.request.contextPath}/admin?action=dashboard" class="${currentPage == 'dashboard' ? 'active' : ''}"><i class="fas fa-home"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin?action=user-management" class="${currentPage == 'user-management' ? 'active' : ''}"><i class="fas fa-users"></i> User Management</a></li>
                <li><a href="${pageContext.request.contextPath}/admin?action=order-management" class="${currentPage == 'order-management' ? 'active' : ''}"><i class="fas fa-shopping-cart"></i> Orders</a></li>
                <li><a href="${pageContext.request.contextPath}/admin?action=track-management" class="${currentPage == 'track-management' ? 'active' : ''}"><i class="fas fa-music"></i> Tracks</a></li>
                <li><a href="${pageContext.request.contextPath}/admin?action=album-management" class="${currentPage == 'album-management' ? 'active' : ''}"><i class="fas fa-compact-disc"></i> Albums</a></li>
                <li><a href="${pageContext.request.contextPath}/admin?action=artist-management" class="${currentPage == 'artist-management' ? 'active' : ''}"><i class="fas fa-user-circle"></i> Artists</a></li>
                <li><a href="${pageContext.request.contextPath}/admin?action=logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </div>

        <div class="main-content">
            <div class="page-header">
                <h1 class="page-title">Track Management</h1>
                <button class="action-button" onclick="showAddTrackModal()">
                    <i class="fas fa-plus"></i> Add Track
                </button>
            </div>

            <div class="filter-bar">
                <div class="filter-group">
                    <div class="filter-label">Search:</div>
                    <input type="text" class="search-input" placeholder="Search tracks...">
                </div>
                <div class="filter-group">
                    <div class="filter-label">Genre:</div>
                    <select class="filter-select">
                        <option value="">All Genres</option>
                        <option value="pop">Pop</option>
                        <option value="rock">Rock</option>
                        <option value="jazz">Jazz</option>
                        <option value="hiphop">Hip Hop</option>
                    </select>
                </div>
                <div class="filter-group">
                    <div class="filter-label">Sort by:</div>
                    <select class="filter-select sort-select">
                        <option value="name">Name</option>
                        <option value="popularity">Popularity</option>
                        <option value="duration">Duration</option>
                        <option value="date">Date Added</option>
                    </select>
                </div>
                <div class="view-toggle">
                    <button class="active" onclick="toggleView('grid')">
                        <i class="fas fa-th"></i>
                    </button>
                    <button onclick="toggleView('table')">
                        <i class="fas fa-list"></i>
                    </button>
                </div>
            </div>

            <!-- Grid View -->
            <div class="track-grid active">
                <c:forEach items="${tracks}" var="track">
                    <div class="track-card">
                        <div class="track-image-container">
                            <img src="${track.imageUrl}" alt="${track.name}" class="track-image">
                        </div>
                        <div class="track-info">
                            <div class="track-name">${track.name}</div>
                            <div class="track-stats">
                                <div class="stat">
                                    <i class="fas fa-clock"></i>
                                    ${track.duration} mins
                                </div>
                                <div class="stat">
                                    <i class="fas fa-compact-disc"></i>
                                    ${track.albumName}
                                </div>
                            </div>
                            <div class="track-genres">
                                <c:forEach items="${track.genres}" var="genre">
                                    <span class="genre-tag">${genre}</span>
                                </c:forEach>
                            </div>
                            <div class="card-actions">
                                <div class="track-status ${track.verified ? 'status-verified' : 'status-pending'}">
                                    <i class="fas ${track.verified ? 'fa-check-circle' : 'fa-clock'}"></i>
                                    ${track.verified ? 'Verified' : 'Pending'}
                                </div>
                                <div class="action-icons">
                                    <i class="fas fa-edit" onclick="editTrack(${track.id})"></i>
                                    <i class="fas fa-trash" onclick="deleteTrack(${track.id})"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <!-- Sample Track Card -->
                <div class="track-card">
                    <div class="track-image-container">
                        <img src="https://via.placeholder.com/300" alt="Sample Track" class="track-image">
                    </div>
                    <div class="track-info">
                        <div class="track-name">Sample Track</div>
                        <div class="track-stats">
                            <div class="stat">
                                <i class="fas fa-clock"></i>
                                3:45 mins
                            </div>
                            <div class="stat">
                                <i class="fas fa-compact-disc"></i>
                                Sample Album
                            </div>
                        </div>
                        <div class="track-genres">
                            <span class="genre-tag">Pop</span>
                            <span class="genre-tag">Rock</span>
                        </div>
                        <div class="card-actions">
                            <div class="track-status status-verified">
                                <i class="fas fa-check-circle"></i>
                                Verified
                            </div>
                            <div class="action-icons">
                                <i class="fas fa-edit"></i>
                                <i class="fas fa-trash"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Table View -->
            <table class="data-table track-table">
                <thead>
                    <tr>
                        <th>Track</th>
                        <th>Genres</th>
                        <th>Duration</th>
                        <th>Album</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${tracks}" var="track">
                        <tr>
                            <td>
                                <div style="display: flex; align-items: center; gap: 10px;">
                                    <img src="${track.imageUrl}" alt="${track.name}" 
                                         style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover;">
                                    <span>${track.name}</span>
                                </div>
                            </td>
                            <td>
                                <div class="track-genres">
                                    <c:forEach items="${track.genres}" var="genre">
                                        <span class="genre-tag">${genre}</span>
                                    </c:forEach>
                                </div>
                            </td>
                            <td>${track.duration} mins</td>
                            <td>${track.albumName}</td>
                            <td>
                                <span class="status-badge ${track.verified ? 'status-active' : 'status-inactive'}">
                                    ${track.verified ? 'Verified' : 'Pending'}
                                </span>
                            </td>
                            <td>
                                <div class="action-icons">
                                    <i class="fas fa-edit" onclick="editTrack(${track.id})"></i>
                                    <i class="fas fa-trash" onclick="deleteTrack(${track.id})"></i>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <!-- Sample Table Row -->
                    <tr>
                        <td>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <img src="https://via.placeholder.com/40" alt="Sample Track" 
                                     style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover;">
                                <span>Sample Track</span>
                            </div>
                        </td>
                        <td>
                            <div class="track-genres">
                                <span class="genre-tag">Pop</span>
                                <span class="genre-tag">Rock</span>
                            </div>
                        </td>
                        <td>3:45 mins</td>
                        <td>Sample Album</td>
                        <td>
                            <span class="status-badge status-active">Verified</span>
                        </td>
                        <td>
                            <div class="action-icons">
                                <i class="fas fa-edit"></i>
                                <i class="fas fa-trash"></i>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>

            <div class="pagination">
                <button><i class="fas fa-chevron-left"></i></button>
                <button class="active">1</button>
                <button>2</button>
                <button>3</button>
                <button><i class="fas fa-chevron-right"></i></button>
            </div>
        </div>

        <!-- Add/Edit Track Modal -->
        <div id="trackModal" class="modal">
            <div class="modal-content">
                <h2>Add New Track</h2>
                <form action="add-track" method="POST" enctype="multipart/form-data">
                    <div class="form-group">
                        <label>Track Name</label>
                        <input type="text" name="name" required>
                    </div>
                    <div class="form-group">
                        <label>Track Image</label>
                        <input type="file" name="image" accept="image/*" required>
                    </div>
                    <div class="form-group">
                        <label>Genres</label>
                        <select name="genres" multiple required>
                            <option value="pop">Pop</option>
                            <option value="rock">Rock</option>
                            <option value="jazz">Jazz</option>
                            <option value="hiphop">Hip Hop</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Duration</label>
                        <input type="text" name="duration" placeholder="e.g., 3:45" required>
                    </div>
                    <div class="form-group">
                        <label>Album Name</label>
                        <input type="text" name="albumName" required>
                    </div>
                    <div class="form-actions">
                        <button type="button" onclick="closeModal()">Cancel</button>
                        <button type="submit">Save Track</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function showAddTrackModal() {
                document.getElementById('trackModal').style.display = 'block';
            }

            function closeModal() {
                document.getElementById('trackModal').style.display = 'none';
            }

            function toggleView(view) {
                const gridView = document.querySelector('.track-grid');
                const tableView = document.querySelector('.track-table');
                const gridButton = document.querySelector('.view-toggle button:first-child');
                const tableButton = document.querySelector('.view-toggle button:last-child');

                if (view === 'grid') {
                    gridView.classList.add('active');
                    tableView.classList.remove('active');
                    gridButton.classList.add('active');
                    tableButton.classList.remove('active');
                } else {
                    gridView.classList.remove('active');
                    tableView.classList.add('active');
                    gridButton.classList.remove('active');
                    tableButton.classList.add('active');
                }
            }

            function editTrack(trackId) {
                // Implement edit track functionality
                console.log('Edit track:', trackId);
            }

            function deleteTrack(trackId) {
                if (confirm('Are you sure you want to delete this track?')) {
                    // Implement delete track functionality
                    console.log('Delete track:', trackId);
                }
            }
        </script>
    </body>
</html> 
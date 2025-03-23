<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Artist Management - Admin Panel</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
        <style>
            .artist-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 25px;
                margin-top: 30px;
            }

            .artist-card {
                background: #112240;
                border-radius: 12px;
                overflow: hidden;
                transition: all 0.3s ease;
                border: 1px solid rgba(100, 255, 218, 0.1);
            }

            .artist-card:hover {
                transform: translateY(-5px);
                border-color: #64ffda;
                box-shadow: 0 10px 30px rgba(100, 255, 218, 0.1);
            }

            .artist-image-container {
                position: relative;
                padding-top: 100%;
                background: #1a365d;
            }

            .artist-image {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .artist-info {
                padding: 20px;
            }

            .artist-name {
                color: #e6f1ff;
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 8px;
            }

            .artist-description {
                color: #a8b2d1;
                font-size: 14px;
                margin-bottom: 15px;
            }

            .artist-details {
                display: flex;
                gap: 15px;
                margin-bottom: 15px;
            }

            .gender {
                display: flex;
                align-items: center;
                gap: 5px;
                color: #a8b2d1;
                font-size: 13px;
            }

            .artist-genres {
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

            .artist-status {
                font-size: 13px;
            }

            .status-verified {
                color: #64ffda;
            }

            .status-pending {
                color: #ffd700;
            }

            .filter-bar {
                margin: 20px 0;
                padding: 20px;
                background: #112240;
                border-radius: 10px;
                border: 1px solid rgba(100, 255, 218, 0.1);
            }

            .filter-form {
                flex: 1;
            }

            .search-section {
                display: flex;
                gap: 10px;
                align-items: center;
            }

            .search-input {
                flex: 1;
                min-width: 300px;
                padding: 8px 12px;
                background: #1a365d;
                border: 1px solid rgba(100, 255, 218, 0.1);
                border-radius: 6px;
                color: #e6f1ff;
                font-size: 14px;
            }

            .search-input:focus {
                border-color: #64ffda;
                outline: none;
            }

            .action-button {
                padding: 8px 16px;
                background: #64ffda;
                color: #0a192f;
                border: none;
                border-radius: 6px;
                font-size: 14px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                transition: all 0.3s ease;
                text-decoration: none;
            }

            .action-button:hover {
                background: #9bf6e5;
            }

            .action-button.secondary {
                background: transparent;
                border: 1px solid #64ffda;
                color: #64ffda;
            }

            .action-button.secondary:hover {
                background: rgba(100, 255, 218, 0.1);
            }

            @media (max-width: 768px) {
                .search-section {
                    flex-wrap: wrap;
                }
                
                .search-input {
                    min-width: 100%;
                }
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
                margin-top: 20px;
            }

            .view-toggle button.active {
                background: #64ffda;
                color: #0a192f;
            }

            .artist-table {
                display: none;
            }

            .artist-table.active {
                display: table;
            }

            .artist-grid.active {
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
                <li><a href="${pageContext.request.contextPath}/admin" class="${currentPage == 'dashboard' ? 'active' : ''}"><i class="fas fa-home"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/usermanagement" class="${currentPage == 'user-management' ? 'active' : ''}"><i class="fas fa-users"></i> User Management</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/orders" class="${currentPage == 'order-management' ? 'active' : ''}"><i class="fas fa-shopping-cart"></i> Orders</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/tracks" class="${currentPage == 'track-management' ? 'active' : ''}"><i class="fas fa-music"></i> Tracks</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/albums" class="${currentPage == 'album-management' ? 'active' : ''}"><i class="fas fa-compact-disc"></i> Albums</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/artists" class="${currentPage == 'artist-management' ? 'active' : ''}"><i class="fas fa-user-circle"></i> Artists</a></li>
                <li><a href="${pageContext.request.contextPath}/admin?action=logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </div>

        <div class="main-content">
            <div class="page-header">
                <h1 class="page-title">Artist Management</h1>
                <button class="action-button" onclick="showAddArtistModal()">
                    <i class="fas fa-plus"></i> Add Artist
                </button>
            </div>

            <div class="filter-bar">
                <form action="${pageContext.request.contextPath}/admin" method="GET" class="filter-form">
                    <input type="hidden" name="action" value="artist-management">
                    <div class="filter-group search-section">
                        <div class="filter-label">Search:</div>
                        <input type="text" name="search" value="${param.search}" 
                               class="search-input" placeholder="Search by artist name...">
                        <button type="submit" class="action-button">
                            <i class="fas fa-search"></i> Search
                        </button>
                        <a href="${pageContext.request.contextPath}/admin?action=artist-management" 
                           class="action-button secondary">
                            <i class="fas fa-times"></i> Clear
                        </a>
                    </div>
                </form>
                <div></div>
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
            <div class="artist-grid active">
                <c:forEach items="${artists}" var="artist">
                    <div class="artist-card">
                        <div class="artist-image-container">
                            <img src="${pageContext.request.contextPath}/${artist.imageUrl}" alt="${artist.name}" class="artist-image">
                        </div>
                        <div class="artist-info">
                            <div class="artist-name">${artist.name}</div>
                            <div class="artist-description">
                                ${artist.description}
                            </div>
                            <div class="artist-details">
                                <span class="gender">
                                    <i class="fas fa-user"></i> ${artist.gender}
                                </span>
                            </div>
                            <div class="card-actions">
                                <div class="action-icons">
                                    <i class="fas fa-edit" onclick="editArtist(${artist.artistID})"></i>
                                    <i class="fas fa-trash" onclick="deleteArtist(${artist.artistID})"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
<%-- 
--%>            <!-- Table View -->
            <table class="data-table artist-table">
                <thead>
                    <tr>
                        <th>Artist</th>
                        <th>Gender</th>
                        <th>Description</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${artists}" var="artist">
                        <tr>
                            <td>
                                <div style="display: flex; align-items: center; gap: 10px;">
                                    <img src="${pageContext.request.contextPath}/${artist.imageUrl}" alt="${artist.name}" 
                                         style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover;">
                                    <span>${artist.name}</span>
                                </div>
                            </td>
                            <td>${artist.gender}</td>
                            <td>${artist.description}</td>
                            <td>
                                <div class="action-icons">
                                    <i class="fas fa-edit" onclick="editArtist(${artist.artistID})"></i>
                                    <i class="fas fa-trash" onclick="deleteArtist(${artist.artistID})"></i>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="pagination">
                <c:if test="${pageNumber > 1}">
                    <a href="${pageContext.request.contextPath}/admin?action=artist-management&page=${pageNumber - 1}${not empty param.search ? '&search='.concat(param.search) : ''}" class="pagination-button">
                        <i class="fas fa-chevron-left"></i>
                    </a>
                </c:if>
                <c:if test="${pageNumber == 1}">
                    <span class="pagination-button disabled">
                        <i class="fas fa-chevron-left"></i>
                    </span>
                </c:if>
                
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="${pageContext.request.contextPath}/admin?action=artist-management&page=${i}${not empty param.search ? '&search='.concat(param.search) : ''}" 
                       class="pagination-button ${i == pageNumber ? 'active' : ''}">
                        ${i}
                    </a>
                </c:forEach>
                
                <c:if test="${pageNumber < totalPages}">
                    <a href="${pageContext.request.contextPath}/admin?action=artist-management&page=${pageNumber + 1}${not empty param.search ? '&search='.concat(param.search) : ''}" class="pagination-button">
                        <i class="fas fa-chevron-right"></i>
                    </a>
                </c:if>
                <c:if test="${pageNumber >= totalPages}">
                    <span class="pagination-button disabled">
                        <i class="fas fa-chevron-right"></i>
                    </span>
                </c:if>
            </div>
            
            <!-- Pagination Info -->
            <div class="pagination-info">
                <c:if test="${totalRecords > 0}">
                    Hiển thị ${(pageNumber-1)*8 + 1} - ${Math.min(pageNumber*8, totalRecords)} trong tổng số ${totalRecords} nghệ sĩ
                </c:if>
                <c:if test="${totalRecords == 0}">
                    Không tìm thấy nghệ sĩ nào
                </c:if>
            </div>
        </div> 

        <!-- Add/Edit Artist Modal -->
        <div id="artistModal" class="modal">
            <div class="modal-content">
                <h2 id="modalTitle">Add New Artist</h2>
                <form id="artistForm" action="${pageContext.request.contextPath}/admin" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add-artist">
                    <input type="hidden" name="artistId" value="">
                    
                    <div class="form-group">
                        <label>Artist Name</label>
                        <input type="text" name="name" required>
                    </div>
                    <div class="form-group">
                        <label>Gender</label>
                        <select name="gender" required>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Description</label>
                        <textarea name="description" rows="4"></textarea>
                    </div>
                    <div class="form-group">
                        <label>Profile Image</label>
                        <input type="file" name="image" accept="image/*">
                        <small class="image-hint" style="display: none;">Leave empty to keep current image</small>
                    </div>
                    <div class="form-actions">
                        <button type="button" onclick="closeModal()">Cancel</button>
                        <button type="submit">Save Artist</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function showAddArtistModal() {
                const modal = document.getElementById('artistModal');
                const form = document.getElementById('artistForm');
                const modalTitle = document.getElementById('modalTitle');
                const imageHint = document.querySelector('.image-hint');
                
                modalTitle.textContent = 'Add New Artist';
                form.action = '${pageContext.request.contextPath}/admin';
                form.elements['action'].value = 'add-artist';
                form.elements['artistId'].value = '';
                form.reset();
                
                imageHint.style.display = 'none';
                document.querySelector('input[name="image"]').required = true;
                
                modal.style.display = 'block';
            }

            function editArtist(artistId) {
                console.log('Edit artist clicked:', artistId); // Debug log
                
                const modal = document.getElementById('artistModal');
                const form = document.getElementById('artistForm');
                const modalTitle = document.getElementById('modalTitle');
                const imageHint = document.querySelector('.image-hint');
                
                // Show modal immediately
                modalTitle.textContent = 'Edit Artist';
                form.action = '${pageContext.request.contextPath}/admin';
                form.elements['action'].value = 'update-artist';
                form.elements['artistId'].value = artistId; // Set ID immediately
                
                imageHint.style.display = 'block';
                document.querySelector('input[name="image"]').required = false;
                
                modal.style.display = 'block';
                
                // Then fetch artist data
                fetch('${pageContext.request.contextPath}/admin?action=edit-artist&id=' + artistId)
                    .then(response => {
                        console.log('Response status:', response.status);
                        return response.json();
                    })
                    .then(artist => {
                        console.log('Artist data:', artist);
                        // Update form with artist data
                        form.elements['name'].value = artist.name;
                        form.elements['gender'].value = artist.gender;
                        form.elements['description'].value = artist.description;
                    })
                    .catch(error => {
                        console.error('Error fetching artist:', error);
                        alert('Error loading artist data. Please try again.');
                    });
            }

            function deleteArtist(artistId) {
                if (confirm('Are you sure you want to delete this artist?')) {
                    window.location.href = '${pageContext.request.contextPath}/admin?action=delete-artist&id=' + artistId;
                }
            }

            function closeModal() {
                document.getElementById('artistModal').style.display = 'none';
            }

            // Close modal when clicking outside
            window.onclick = function(event) {
                var modal = document.getElementById('artistModal');
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            }

            function toggleView(view) {
                const gridView = document.querySelector('.artist-grid');
                const tableView = document.querySelector('.artist-table');
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
        </script>
    </body>
</html> 
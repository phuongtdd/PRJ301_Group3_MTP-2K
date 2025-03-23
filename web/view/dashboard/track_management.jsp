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
                display: none !important; /* Ẩn hoàn toàn grid view */
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
                display: table; /* Luôn hiển thị bảng */
                width: 100%;
                margin-top: 20px;
            }

            .track-grid.active {
                display: grid;
            }
            
            .artist-name {
                color: #a8b2d1;
                font-size: 14px;
                margin-bottom: 8px;
            }

            .modal-content {
                max-width: 600px;
                background: #0a192f;
                border-radius: 10px;
                padding: 30px;
                color: #e6f1ff;
                border: 1px solid rgba(100, 255, 218, 0.1);
                max-height: 80vh;
                overflow-y: auto;
            }

            /* Adding modal background style */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.7);
                overflow: auto;
            }
            
            /* Styles cho phân trang */
            .pagination {
                display: flex;
                justify-content: center;
                gap: 10px;
                margin: 30px 0 15px;
            }
            
            .pagination-button {
                display: inline-flex;
                align-items: center;
                justify-content: center;
                width: 40px;
                height: 40px;
                background: #112240;
                color: #e6f1ff;
                border: 1px solid rgba(100, 255, 218, 0.2);
                border-radius: 6px;
                font-size: 16px;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
            }
            
            .pagination-button:hover {
                background: rgba(100, 255, 218, 0.1);
                border-color: #64ffda;
            }
            
            .pagination-button.active {
                background: #64ffda;
                color: #0a192f;
                font-weight: bold;
                border-color: #64ffda;
                cursor: default;
            }
            
            .pagination-info {
                text-align: center;
                color: #a8b2d1;
                font-size: 14px;
                margin-bottom: 30px;
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
                <li><a href="${pageContext.request.contextPath}/admin/usermanagement"><i class="fas fa-users"></i> User Management</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/orders" class="${currentPage == 'order-management' ? 'active' : ''}"><i class="fas fa-shopping-cart"></i> Orders</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/tracks" class="${currentPage == 'track-management' ? 'active' : ''}"><i class="fas fa-music"></i> Tracks</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/albums" class="${currentPage == 'album-management' ? 'active' : ''}"><i class="fas fa-compact-disc"></i> Albums</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/artists" class="${currentPage == 'artist-management' ? 'active' : ''}"><i class="fas fa-user-circle"></i> Artists</a></li>
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
                <form id="searchForm" action="${pageContext.request.contextPath}/admin" method="GET" style="display: flex; flex-wrap: wrap; gap: 15px; width: 100%; align-items: center;">
                    <input type="hidden" name="action" value="track-management">
                <div class="filter-group">
                    <div class="filter-label">Search:</div>
                        <input type="text" class="search-input" placeholder="Search tracks" name="search" value="${param.search}" style="min-width: 200px;">
                </div>
                <div class="filter-group">
                    <div class="filter-label">Genre:</div>
                        <select class="filter-select" name="genreFilter">
                        <option value="">All Genres</option>
                            <c:forEach items="${genres}" var="genre">
                                <option value="${genre.genreID}" ${param.genreFilter == genre.genreID ? 'selected' : ''}>${genre.genreName}</option>
                            </c:forEach>
                    </select>
                </div>
                    <!-- <div class="filter-group">
                    <div class="filter-label">Sort by:</div>
                        <select class="filter-select sort-select" name="sortBy">
                            <option value="name" ${param.sortBy == 'name' ? 'selected' : ''}>Name</option>
                            <option value="popularity" ${param.sortBy == 'popularity' ? 'selected' : ''}>Popularity</option>
                            <option value="releaseDate" ${param.sortBy == 'releaseDate' ? 'selected' : ''}>Release Date</option>
                            <option value="record" ${param.sortBy == 'record' ? 'selected' : ''}>Play Count</option>
                    </select>
                    </div> -->
                    <div class="filter-group">
                        <button type="submit" class="action-button">
                            <i class="fas fa-search"></i> Search
                    </button>
                </div>
                </form>
            </div>

            <!-- Grid View -->
            <div class="track-grid">
                <c:forEach items="${tracks}" var="track">
                    <div class="track-card">
                        <div class="track-image-container">
                            <img src="${pageContext.request.contextPath}/${track.imageUrl}" alt="${track.title}" class="track-image">
                        </div>
                        <div class="track-info">
                            <div class="track-name">${track.title}</div>
                            <c:if test="${not empty track.artists}">
                                <div class="artist-name">
                                    <c:forEach items="${track.artists}" var="artist" varStatus="status">
                                        ${artist.name}${!status.last ? ', ' : ''}
                                    </c:forEach>
                                </div>
                            </c:if>
                            <div class="track-stats">
                                <div class="stat">
                                    <i class="fas fa-play-circle"></i>
                                    ${track.record} plays
                                </div>
                                <div class="stat">
                                    <i class="fas fa-calendar"></i>
                                    <fmt:formatDate value="${track.releaseDate}" pattern="yyyy-MM-dd" />
                                </div>
                            </div>
                            <div class="track-genres">
                                <c:forEach items="${track.genres}" var="genre">
                                    <span class="genre-tag">${genre.genreName}</span>
                                </c:forEach>
                            </div>
                            <div class="card-actions">
                                <div class="track-status status-verified">
                                    <i class="fas fa-check-circle"></i>
                                    Active
                                </div>
                                <div class="action-icons">
                                    <i class="fas fa-edit" onclick="editTrack('${track.trackID}')"></i>
                                    <i class="fas fa-trash" onclick="deleteTrack('${track.trackID}')"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Table View -->
            <table class="data-table track-table active">
                <thead>
                    <tr>
                        <th>Track</th>
                        <th>Artists</th>
                        <th>Genres</th>
                        <th>Release Date</th>
                        <th>Plays</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${tracks}" var="track">
                        <tr>
                            <td>
                                <div style="display: flex; align-items: center; gap: 10px;">
                                    <img src="${pageContext.request.contextPath}/${track.imageUrl}" alt="${track.title}" 
                                         style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover;">
                                    <span>${track.title}</span>
                                </div>
                            </td>
                            <td>
                                <c:forEach items="${track.artists}" var="artist" varStatus="status">
                                    ${artist.name}${!status.last ? ', ' : ''}
                                </c:forEach>
                            </td>
                            <td>
                                <div class="track-genres">
                                    <c:forEach items="${track.genres}" var="genre">
                                        <span class="genre-tag">${genre.genreName}</span>
                                    </c:forEach>
                                </div>
                            </td>
                            <td><fmt:formatDate value="${track.releaseDate}" pattern="yyyy-MM-dd" /></td>
                            <td>${track.record}</td>
                            <td>
                                <div class="action-icons">
                                    <i class="fas fa-edit" onclick="editTrack('${track.trackID}')"></i>
                                    <i class="fas fa-trash" onclick="deleteTrack('${track.trackID}')"></i>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="pagination">
                <c:if test="${currentPageNum > 1}">
                    <a href="${pageContext.request.contextPath}/admin?action=track-management&page=${currentPageNum - 1}${not empty param.search ? '&search='.concat(param.search) : ''}${not empty param.genreFilter ? '&genreFilter='.concat(param.genreFilter) : ''}${not empty param.sortBy ? '&sortBy='.concat(param.sortBy) : ''}" class="pagination-button">
                        <i class="fas fa-chevron-left"></i>
                    </a>
                </c:if>
                
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <c:choose>
                        <c:when test="${i == currentPageNum}">
                            <span class="pagination-button active">${i}</span>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/admin?action=track-management&page=${i}${not empty param.search ? '&search='.concat(param.search) : ''}${not empty param.genreFilter ? '&genreFilter='.concat(param.genreFilter) : ''}${not empty param.sortBy ? '&sortBy='.concat(param.sortBy) : ''}" class="pagination-button">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                
                <c:if test="${currentPageNum < totalPages}">
                    <a href="${pageContext.request.contextPath}/admin?action=track-management&page=${currentPageNum + 1}${not empty param.search ? '&search='.concat(param.search) : ''}${not empty param.genreFilter ? '&genreFilter='.concat(param.genreFilter) : ''}${not empty param.sortBy ? '&sortBy='.concat(param.sortBy) : ''}" class="pagination-button">
                        <i class="fas fa-chevron-right"></i>
                    </a>
                </c:if>
            </div>
            
            <div class="pagination-info">
                Hiển thị ${tracks.size()} trong tổng số ${totalTracks} bài hát | Trang ${currentPageNum}/${totalPages}
            </div>
        </div>

        <!-- Add/Edit Track Modal -->
        <div id="trackModal" class="modal">
            <div class="modal-content">
                <h2 id="modalTitle">Add New Track</h2>
                <form id="trackForm" action="${pageContext.request.contextPath}/admin" method="POST" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="add-track">
                    <input type="hidden" name="trackId" id="edit-track-id" value="">
                    <div class="form-group">
                        <label>Track Name</label>
                        <input type="text" name="name" id="edit-track-title" required>
                    </div>
                    <div class="form-group">
                        <label>Release Date</label>
                        <input type="date" name="releaseDate" id="edit-track-releaseDate">
                    </div>
                    <div class="form-group">
                        <label>Track Image</label>
                        <div class="current-image" id="image-preview-container" style="display: none; margin-bottom: 10px;">
                            <img id="current-image-preview" src="" alt="Current track image" style="max-width: 100px; max-height: 100px; display: block;">
                            <small>Current image (upload a new one to replace)</small>
                        </div>
                        <input type="file" name="image" accept="image/*" id="track-image-input">
                    </div>
                    <div class="form-group">
                        <label>Audio File</label>
                        <div class="current-audio" id="audio-preview-container" style="display: none; margin-bottom: 10px;">
                            <audio id="current-audio-preview" controls style="width: 100%;">
                                <source src="" type="audio/mpeg">
                                Your browser does not support the audio element.
                            </audio>
                            <small>Current audio (upload a new one to replace)</small>
                        </div>
                        <input type="file" name="audioFile" accept="audio/*" id="track-audio-input">
                    </div>
                    <div class="form-group">
                        <label>Play Count</label>
                        <input type="number" name="record" id="edit-track-record" value="0" min="0">
                    </div>
                    <div class="form-group">
                        <label>Genres</label>
                        <select name="genres" multiple id="edit-track-genres">
                            <c:forEach items="${genres}" var="genre">
                                <option value="${genre.genreID}">${genre.genreName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Artists</label>
                        <select name="artists" multiple id="edit-track-artists">
                            <c:forEach items="${artists}" var="artist">
                                <option value="${artist.artistID}">${artist.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-actions">
                        <button type="button" onclick="closeModal()">Cancel</button>
                        <button type="submit">Save Track</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Thêm form ẩn để xử lý xóa track -->
        <form id="deleteTrackForm" action="${pageContext.request.contextPath}/admin?action=delete-track" method="POST" style="display: none;">
            <input type="hidden" name="trackId" id="delete-track-id" value="">
        </form>
        
        <!-- Success Modal -->
        <div id="successModal" class="modal">
            <div class="modal-content" style="max-width: 400px; text-align: center;">
                <div style="font-size: 70px; color: #64ffda; margin-bottom: 20px;">
                    <i class="fas fa-check-circle"></i>
                </div>
                <h2 id="successMessage" style="margin-bottom: 20px; color: #e6f1ff;">Thành công!</h2>
                <button onclick="closeSuccessModal()" class="action-button" style="margin: 0 auto; display: block; background-color: #64ffda; color: #0a192f;">
                    Đóng
                </button>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            // Hiển thị modal thành công nếu có message
            document.addEventListener('DOMContentLoaded', function() {
                // Kiểm tra xem có thông báo từ session không
                <c:if test="${not empty sessionScope.message && sessionScope.messageType == 'success'}">
                    document.getElementById('successMessage').textContent = "${sessionScope.message}";
                    document.getElementById('successModal').style.display = 'block';
                    <c:remove var="message" scope="session" />
                    <c:remove var="messageType" scope="session" />
                </c:if>
                
                // Đảm bảo hiển thị mặc định là table view
                const tableView = document.querySelector('.track-table');
                tableView.classList.add('active');
                
                // Xử lý thông báo kết quả tìm kiếm
                const searchParams = new URLSearchParams(window.location.search);
                const search = searchParams.get('search');
                const genreFilter = searchParams.get('genreFilter');
                const sortBy = searchParams.get('sortBy');
                
                if (search || genreFilter || sortBy) {
                    let searchTerms = [];
                    if (search) searchTerms.push(`"${search}"`);
                    if (genreFilter) {
                        const genreElement = document.querySelector(`select[name="genreFilter"] option[value="${genreFilter}"]`);
                        if (genreElement) searchTerms.push(`genre "${genreElement.textContent}"`);
                    }
                    if (sortBy) {
                        let sortText = '';
                        switch(sortBy) {
                            case 'name':
                                sortText = 'Name (A-Z)';
                                break;
                            case 'popularity':
                                sortText = 'Popularity';
                                break;
                            case 'releaseDate':
                                sortText = 'Release Date';
                                break;
                            case 'record':
                                sortText = 'Play Count';
                                break;
                        }
                        if (sortText) searchTerms.push(`sorted by "${sortText}"`);
                    }
                    
                    if (searchTerms.length > 0) {
                        const mainContent = document.querySelector('.main-content');
                        const filterBar = document.querySelector('.filter-bar');
                        
                        const searchInfo = document.createElement('div');
                        searchInfo.className = 'search-info';
                        searchInfo.style.margin = '10px 0';
                        searchInfo.style.padding = '10px';
                        searchInfo.style.backgroundColor = 'rgba(100, 255, 218, 0.1)';
                        searchInfo.style.borderRadius = '5px';
                        searchInfo.style.color = '#e6f1ff';
                        
                        searchInfo.innerHTML = `
                            <p>Search results for ${searchTerms.join(' and ')} (${totalTracks} results)</p>
                            <a href="${pageContext.request.contextPath}/admin?action=track-management" style="color: #64ffda; text-decoration: none;">
                                <i class="fas fa-times"></i> Clear filters
                            </a>
                        `;
                        
                        mainContent.insertBefore(searchInfo, filterBar.nextSibling);
                    }
                }
            });
            
            function closeSuccessModal() {
                document.getElementById('successModal').style.display = 'none';
            }
            
            // Thêm event listener để đóng success modal khi click bên ngoài
            window.onclick = function(event) {
                const successModal = document.getElementById('successModal');
                const trackModal = document.getElementById('trackModal');
                
                if (event.target === successModal) {
                    closeSuccessModal();
                }
                
                if (event.target === trackModal) {
                    closeModal();
                }
            };
            
            function showAddTrackModal() {
                const modal = document.getElementById('trackModal');
                const form = document.getElementById('trackForm');
                const modalTitle = document.getElementById('modalTitle');
                const imagePreviewContainer = document.getElementById('image-preview-container');
                const audioPreviewContainer = document.getElementById('audio-preview-container');
                
                // Reset form
                form.reset();
                modalTitle.textContent = 'Add New Track';
                form.action = '${pageContext.request.contextPath}/admin';
                form.elements['action'].value = 'add-track';
                form.elements['trackId'].value = '';
                
                // Hide preview containers for add mode
                imagePreviewContainer.style.display = 'none';
                audioPreviewContainer.style.display = 'none';
                
                // Set required attributes
                document.getElementById('track-image-input').required = true;
                document.getElementById('track-audio-input').required = true;
                
                modal.style.display = 'block';
            }

            function closeModal() {
                document.getElementById('trackModal').style.display = 'none';
            }

            function editTrack(trackId) {
                const modal = document.getElementById('trackModal');
                const form = document.getElementById('trackForm');
                const modalTitle = document.getElementById('modalTitle');
                const imagePreviewContainer = document.getElementById('image-preview-container');
                const audioPreviewContainer = document.getElementById('audio-preview-container');
                
                // Set form properties
                modalTitle.textContent = 'Edit Track';
                form.action = '${pageContext.request.contextPath}/admin';
                form.elements['action'].value = 'update-track';
                form.elements['trackId'].value = trackId;
                
                // Set required attributes for edit mode
                document.getElementById('track-image-input').required = false;
                document.getElementById('track-audio-input').required = false;
                
                // Show modal immediately
                modal.style.display = 'block';
                
                // Fetch track data
                fetch('${pageContext.request.contextPath}/admin?action=get-track&id=' + trackId)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response was not ok');
                        }
                        return response.json();
                    })
                    .then(track => {
                        // Populate form with track data
                        document.getElementById('edit-track-title').value = track.title || '';
                        
                        // Format date if available
                        if (track.releaseDate) {
                            document.getElementById('edit-track-releaseDate').value = track.releaseDate;
                        }
                        
                        // Set record count
                        document.getElementById('edit-track-record').value = track.record || 0;
                        
                        // Show current image if available
                        if (track.imageUrl) {
                            const currentImagePreview = document.getElementById('current-image-preview');
                            currentImagePreview.src = track.imageUrl;
                            imagePreviewContainer.style.display = 'block';
                        }
                        
                        // Show current audio if available
                        if (track.fileUrl) {
                            const currentAudioPreview = document.getElementById('current-audio-preview');
                            const audioSource = currentAudioPreview.querySelector('source');
                            audioSource.src = '${pageContext.request.contextPath}/' + track.fileUrl;
                            currentAudioPreview.load(); // Important to reload the audio element
                            audioPreviewContainer.style.display = 'block';
                        }
                        
                        // Select genres
                        const genresSelect = document.getElementById('edit-track-genres');
                        if (track.genres && track.genres.length > 0) {
                            // Clear all selected options
                            for (let i = 0; i < genresSelect.options.length; i++) {
                                genresSelect.options[i].selected = false;
                            }
                            
                            // Select the correct genres
                            track.genres.forEach(genre => {
                                for (let i = 0; i < genresSelect.options.length; i++) {
                                    if (genresSelect.options[i].value == genre.genreID) {
                                        genresSelect.options[i].selected = true;
                                    }
                                }
                            });
                        }
                        
                        // Select artists
                        const artistsSelect = document.getElementById('edit-track-artists');
                        if (track.artists && track.artists.length > 0) {
                            // Clear all selected options
                            for (let i = 0; i < artistsSelect.options.length; i++) {
                                artistsSelect.options[i].selected = false;
                            }
                            
                            // Select the correct artists
                            track.artists.forEach(artist => {
                                for (let i = 0; i < artistsSelect.options.length; i++) {
                                    if (artistsSelect.options[i].value == artist.artistID) {
                                        artistsSelect.options[i].selected = true;
                                    }
                                }
                            });
                        }
                    })
                    .catch(error => {
                        console.error('Error fetching track:', error);
                        alert('Error loading track data. Please try again.');
                        closeModal();
                    });
            }

            function deleteTrack(trackId) {
                if (confirm('Are you sure you want to delete this track?')) {
                    // Thay vì chuyển hướng, gửi POST request để xóa track
                    const deleteForm = document.getElementById('deleteTrackForm');
                    document.getElementById('delete-track-id').value = trackId;
                    deleteForm.submit();
                }
            }
        </script>
    </body>
</html> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Album Management - Admin Panel</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
        <style>
            .album-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 25px;
                margin-top: 30px;
            }

            .album-card {
                background: #112240;
                border-radius: 12px;
                overflow: hidden;
                transition: all 0.3s ease;
                border: 1px solid rgba(100, 255, 218, 0.1);
            }

            .album-card:hover {
                transform: translateY(-5px);
                border-color: #64ffda;
                box-shadow: 0 10px 30px rgba(100, 255, 218, 0.1);
            }

            .album-image-container {
                position: relative;
                padding-top: 100%;
                background: #1a365d;
            }

            .album-image {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .album-info {
                padding: 20px;
            }

            .album-title {
                color: #e6f1ff;
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 8px;
            }

            .album-description {
                color: #a8b2d1;
                font-size: 14px;
                margin-bottom: 15px;
                display: -webkit-box;
                -webkit-line-clamp: 3;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }

            .album-details {
                display: flex;
                gap: 15px;
                margin-bottom: 15px;
                color: #a8b2d1;
                font-size: 13px;
            }

            .release-date, .artist-info {
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .artist-info i {
                color: #64ffda;
            }

            .artist-info a {
                color: #64ffda;
                text-decoration: none;
            }

            .artist-info a:hover {
                text-decoration: underline;
            }

            .card-actions {
                display: flex;
                justify-content: flex-end;
                padding-top: 15px;
                border-top: 1px solid rgba(100, 255, 218, 0.1);
            }

            .action-icons {
                display: flex;
                gap: 15px;
            }

            .action-icons i {
                color: #64ffda;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .action-icons i:hover {
                transform: scale(1.1);
            }

            .action-icons i.fa-trash {
                color: #ff6464;
            }

            /* Modal Styles */
            .modal {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(10, 25, 47, 0.8);
                backdrop-filter: blur(5px);
                z-index: 1000;
                overflow-y: auto;
            }

            .modal-content {
                background: #112240;
                border-radius: 10px;
                padding: 30px;
                width: 90%;
                max-width: 500px;
                position: relative;
                margin: 50px auto;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #a8b2d1;
            }

            .form-group input,
            .form-group select,
            .form-group textarea {
                width: 100%;
                padding: 10px;
                background: #233554;
                border: 1px solid rgba(100, 255, 218, 0.1);
                border-radius: 6px;
                color: #e6f1ff;
            }

            .form-actions {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                margin-top: 20px;
            }

            .form-actions button {
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .form-actions button[type="button"] {
                background: transparent;
                color: #a8b2d1;
                border: 1px solid #a8b2d1;
            }

            .form-actions button[type="submit"] {
                background: #64ffda;
                color: #0a192f;
                border: none;
            }

            /* Search Form Styles */
            .search-bar {
                margin: 20px 0;
                padding: 20px;
                background: #112240;
                border-radius: 10px;
                border: 1px solid rgba(100, 255, 218, 0.1);
            }

            .search-form {
                width: 100%;
            }

            .search-input-group {
                display: flex;
                gap: 15px;
                align-items: center;
            }

            .search-input {
                flex: 1;
                padding: 10px 15px;
                background: #233554;
                border: 1px solid rgba(100, 255, 218, 0.1);
                border-radius: 6px;
                color: #e6f1ff;
                font-size: 14px;
            }

            .filter-select {
                min-width: 200px;
                padding: 10px;
                background: #233554;
                border: 1px solid rgba(100, 255, 218, 0.1);
                border-radius: 6px;
                color: #e6f1ff;
                font-size: 14px;
            }

            .search-button {
                padding: 10px 20px;
                background: #64ffda;
                color: #0a192f;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .clear-button {
                padding: 10px 20px;
                background: transparent;
                color: #a8b2d1;
                border: 1px solid #a8b2d1;
                border-radius: 6px;
                text-decoration: none;
                font-size: 14px;
                display: flex;
                align-items: center;
                gap: 8px;
                cursor: pointer;
            }

            .clear-button:hover {
                border-color: #64ffda;
                color: #64ffda;
            }

            .action-button.secondary:hover {
                background: rgba(100, 255, 218, 0.1);
            }

            /* Artist Search Styles */
            .artist-selection {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .artist-search-container {
                position: relative;
            }

            .artist-search {
                width: 100%;
                padding: 8px 12px;
                background: #233554;
                border: 1px solid rgba(100, 255, 218, 0.1);
                border-radius: 6px;
                color: #e6f1ff;
                font-size: 14px;
            }

            .search-results {
                position: absolute;
                top: 100%;
                left: 0;
                width: 100%;
                max-height: 200px;
                overflow-y: auto;
                background: #1a365d;
                border: 1px solid rgba(100, 255, 218, 0.1);
                border-radius: 0 0 6px 6px;
                z-index: 10;
                display: none;
            }

            .search-results.active {
                display: block;
            }

            .artist-result {
                padding: 8px 12px;
                cursor: pointer;
                color: #e6f1ff;
                transition: all 0.2s ease;
            }

            .artist-result:hover {
                background: #233554;
                color: #64ffda;
            }

            @media (max-width: 768px) {
                .search-section {
                    flex-wrap: wrap;
                }
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
                <h1 class="page-title">Album Management</h1>
                <button class="action-button" onclick="showAddAlbumModal()">
                    <i class="fas fa-plus"></i> Add Album
                </button>
            </div>

            <!-- Search Form -->
            <div class="search-bar">
                <form action="${pageContext.request.contextPath}/admin" method="GET" class="search-form">
                    <input type="hidden" name="action" value="album-management">
                    <div class="search-input-group">
                        <input type="text" name="search" value="${param.search}" 
                               placeholder="Search by album title, description or artist name..." 
                               class="search-input">
                        <select name="artistFilter" class="filter-select">
                            <option value="">All Artists</option>
                            <c:forEach items="${artists}" var="artist">
                                <option value="${artist.artistID}" ${param.artistFilter == artist.artistID ? 'selected' : ''}>${artist.name}</option>
                            </c:forEach>
                        </select>
                        <button type="submit" class="search-button">
                            <i class="fas fa-search"></i> Search
                        </button>
                        <a href="${pageContext.request.contextPath}/admin?action=album-management" class="clear-button">
                            <i class="fas fa-times"></i> Clear
                        </a>
                    </div>
                </form>
            </div>

            <!-- Album Grid -->
            <div class="album-grid">
                <c:forEach items="${albums}" var="album">
                    <div class="album-card">
                        <div class="album-image-container">
                            <img src="${pageContext.request.contextPath}/${album.imageUrl}" alt="${album.title}" class="album-image">
                        </div>
                        <div class="album-info">
                            <div class="album-title">${album.title}</div>
                            <div class="album-description">${album.description}</div>
                            <div class="album-details">
                                <div class="release-date">
                                    <i class="fas fa-calendar"></i>
                                    <fmt:formatDate value="${album.releaseDate}" pattern="dd/MM/yyyy"/>
                                </div>
                                <div class="artist-info">
                                    <i class="fas fa-user"></i>
                                    <c:forEach items="${artists}" var="artist">
                                        <c:if test="${artist.artistID == album.artistID}">
                                            <a href="${pageContext.request.contextPath}/admin?action=artist-management&view=${artist.artistID}">${artist.name}</a>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="card-actions">
                                <div class="action-icons">
                                    <i class="fas fa-edit edit-album-btn" data-id="${album.albumID}"></i>
                                    <i class="fas fa-trash delete-album-btn" data-id="${album.albumID}"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Add Album Modal -->
            <div id="albumModal" class="modal">
                <div class="modal-content">
                    <h2>Add New Album</h2>
                    <form action="${pageContext.request.contextPath}/admin?action=add-album" method="POST" enctype="multipart/form-data">
                        <div class="form-group">
                            <label>Album Title</label>
                            <input type="text" name="title" required>
                        </div>
                        <div class="form-group">
                            <label>Release Date</label>
                            <input type="date" name="releaseDate" required>
                        </div>
                        <div class="form-group">
                            <label>Description</label>
                            <textarea name="description" rows="4"></textarea>
                        </div>
                        <div class="form-group">
                            <label>Artist</label>
                            <div class="artist-selection">
                                <select name="artistID" id="artistSelect">
                                    <option value="">-- Choose artist --</option>
                                    <c:forEach items="${artists}" var="artist">
                                        <option value="${artist.artistID}">${artist.name}</option>
                                    </c:forEach>
                                </select>
                                <!-- <div class="artist-search-container">
                                    <input type="text" id="artistSearch" placeholder="Tìm nghệ sĩ..." class="artist-search">
                                    <div id="artistSearchResults" class="search-results"></div>
                                </div> -->
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Album Cover</label>
                            <input type="file" name="image" accept="image/*" required>
                        </div>
                        <div class="form-actions">
                            <button type="button" onclick="closeModal()">Cancel</button>
                            <button type="submit">Save Album</button>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- Edit Album Modal -->
            <div id="editAlbumModal" class="modal">
                <div class="modal-content">
                    <h2>Edit Album</h2>
                    <form action="${pageContext.request.contextPath}/admin?action=update-album" method="POST" enctype="multipart/form-data">
                        <input type="hidden" name="albumId" id="edit-album-id">
                        <div class="form-group">
                            <label>Album Title</label>
                            <input type="text" name="name" id="edit-album-title" required>
                        </div>
                        <div class="form-group">
                            <label>Release Date</label>
                            <input type="date" name="releaseDate" id="edit-album-releaseDate" required>
                        </div>
                        <div class="form-group">
                            <label>Description</label>
                            <textarea name="description" id="edit-album-description" rows="4"></textarea>
                        </div>
                        <div class="form-group">
                            <label>Artist</label>
                            <div class="artist-selection">
                                <select name="artist_id" id="edit-artist-select">
                                    <option value="">-- Choose artist --</option>
                                    <c:forEach items="${artists}" var="artist">
                                        <option value="${artist.artistID}">${artist.name}</option>
                                    </c:forEach>
                                </select>
                                <!-- <div class="artist-direct-input" style="margin-top: 10px;">
                                    <label>
                                        <input type="checkbox" name="useArtistName" id="edit-use-artist-name"> Use artist name directly
                                    </label>
                                    <input type="text" name="artist_name" id="edit-artist-name" style="display: none; margin-top: 10px;" placeholder="Enter artist name...">
                                </div> -->
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Album Cover</label>
                            <div class="current-image" style="margin-bottom: 10px;">
                                <img id="edit-album-current-image" src="" alt="Current album cover" style="max-width: 100px; max-height: 100px; display: block;">
                                <small>Current image (upload a new one to replace)</small>
                            </div>
                            <input type="file" name="image" accept="image/*">
                        </div>
                        <div class="form-actions">
                            <button type="button" onclick="closeEditModal()">Cancel</button>
                            <button type="submit">Update Album</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            function showAddAlbumModal() {
                document.getElementById('albumModal').style.display = 'block';
            }

            function closeModal() {
                document.getElementById('albumModal').style.display = 'none';
            }
            
            function closeEditModal() {
                document.getElementById('editAlbumModal').style.display = 'none';
            }

            function editAlbum(albumId) {
                // Lấy thông tin album từ server
                fetch('${pageContext.request.contextPath}/admin?action=get-album&id=' + albumId)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response was not ok');
                        }
                        return response.json();
                    })
                    .then(album => {
                        // Điền thông tin vào form chỉnh sửa
                        document.getElementById('edit-album-id').value = album.albumID;
                        document.getElementById('edit-album-title').value = album.title;
                        
                        // Format ngày
                        if (album.releaseDate) {
                            const date = new Date(album.releaseDate);
                            const year = date.getFullYear();
                            const month = String(date.getMonth() + 1).padStart(2, '0');
                            const day = String(date.getDate()).padStart(2, '0');
                            document.getElementById('edit-album-releaseDate').value = `${year}-${month}-${day}`;
                        }
                        
                        document.getElementById('edit-album-description').value = album.description || '';
                        
                        // Chọn nghệ sĩ
                        const artistSelect = document.getElementById('edit-artist-select');
                        artistSelect.value = album.artistID;
                        
                        // Hiển thị ảnh hiện tại
                        const currentImageElem = document.getElementById('edit-album-current-image');
                        if (album.imageUrl) {
                            currentImageElem.src = album.imageUrl;
                            currentImageElem.style.display = 'block';
                            currentImageElem.parentElement.style.display = 'block';
                        } else {
                            currentImageElem.style.display = 'none';
                            currentImageElem.parentElement.style.display = 'none';
                        }
                        
                        // Hiển thị modal
                        document.getElementById('editAlbumModal').style.display = 'block';
                    })
                    .catch(error => {
                        console.error('Error fetching album details:', error);
                        alert('Failed to get album details. Please try again.');
                    });
            }

            function deleteAlbum(albumId) {
                if (confirm('Are you sure you want to delete this album?')) {
                    // Tạo form để thực hiện POST request
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '${pageContext.request.contextPath}/admin';
                    
                    // Thêm action parameter
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'delete-album';
                    form.appendChild(actionInput);
                    
                    // Thêm albumId parameter
                    const albumIdInput = document.createElement('input');
                    albumIdInput.type = 'hidden';
                    albumIdInput.name = 'albumId';
                    albumIdInput.value = albumId;
                    form.appendChild(albumIdInput);
                    
                    // Thêm form vào body và submit
                    document.body.appendChild(form);
                    form.submit();
                }
            }

            // Artist Search Functionality
            document.addEventListener('DOMContentLoaded', function () {
                const artistSearch = document.getElementById('artistSearch');
                const artistSearchResults = document.getElementById('artistSearchResults');
                const artistSelect = document.getElementById('artistSelect');
                const useArtistNameCheckbox = document.getElementById('edit-use-artist-name');
                const directArtistNameInput = document.getElementById('edit-artist-name');
                
                // Xử lý checkbox nhập tên nghệ sĩ trực tiếp
                if (useArtistNameCheckbox) {
                    useArtistNameCheckbox.addEventListener('change', function () {
                        if (this.checked) {
                            // Hiển thị ô nhập tên nghệ sĩ trực tiếp
                            directArtistNameInput.style.display = 'block';
                            // Ẩn select box
                            document.getElementById('edit-artist-select').style.display = 'none';
                        } else {
                            // Ẩn ô nhập tên nghệ sĩ trực tiếp
                            directArtistNameInput.style.display = 'none';
                            directArtistNameInput.value = '';
                            // Hiển thị select box
                            document.getElementById('edit-artist-select').style.display = 'block';
                        }
                    });
                }

                if (artistSearch) {
                    artistSearch.addEventListener('input', function () {
                        const searchTerm = this.value.trim();

                        if (searchTerm.length < 2) {
                            artistSearchResults.innerHTML = '';
                            artistSearchResults.classList.remove('active');
                            return;
                        }

                        // Gọi API tìm kiếm nghệ sĩ
                        fetch('${pageContext.request.contextPath}/admin?action=search-artists&term=' + searchTerm)
                                .then(response => response.json())
                                .then(data => {
                                    artistSearchResults.innerHTML = '';

                                    if (data.length === 0) {
                                        const noResult = document.createElement('div');
                                        noResult.className = 'artist-result';
                                        noResult.textContent = 'Không tìm thấy nghệ sĩ';
                                        artistSearchResults.appendChild(noResult);
                                    } else {
                                        data.forEach(artist => {
                                            const resultItem = document.createElement('div');
                                            resultItem.className = 'artist-result';
                                            resultItem.textContent = artist.name;
                                            resultItem.dataset.id = artist.id;

                                            resultItem.addEventListener('click', function () {
                                                // Cập nhật select box
                                                for (let i = 0; i < artistSelect.options.length; i++) {
                                                    if (artistSelect.options[i].value == artist.id) {
                                                        artistSelect.selectedIndex = i;
                                                        break;
                                                    }
                                                }

                                                // Nếu không tìm thấy trong select box, thêm option mới
                                                if (artistSelect.value != artist.id) {
                                                    const newOption = new Option(artist.name, artist.id);
                                                    artistSelect.add(newOption);
                                                    artistSelect.value = artist.id;
                                                }

                                                // Xóa kết quả tìm kiếm
                                                artistSearch.value = artist.name;
                                                artistSearchResults.innerHTML = '';
                                                artistSearchResults.classList.remove('active');
                                            });

                                            artistSearchResults.appendChild(resultItem);
                                        });
                                    }

                                    artistSearchResults.classList.add('active');
                                })
                                .catch(error => {
                                    console.error('Error searching artists:', error);
                                    artistSearchResults.innerHTML = '<div class="artist-result">Lỗi khi tìm kiếm</div>';
                                    artistSearchResults.classList.add('active');
                                });
                    });

                    // Ẩn kết quả tìm kiếm khi click ra ngoài
                    document.addEventListener('click', function (e) {
                        if (!artistSearch.contains(e.target) && !artistSearchResults.contains(e.target)) {
                            artistSearchResults.classList.remove('active');
                        }
                    });
                }
            });

            // Thêm event listeners cho các nút chỉnh sửa và xóa album
            document.addEventListener('DOMContentLoaded', function() {
                // Thêm listeners cho nút edit
                const editButtons = document.querySelectorAll('.edit-album-btn');
                editButtons.forEach(button => {
                    button.addEventListener('click', function() {
                        const albumId = this.getAttribute('data-id');
                        editAlbum(albumId);
                    });
                });
                
                // Thêm listeners cho nút delete
                const deleteButtons = document.querySelectorAll('.delete-album-btn');
                deleteButtons.forEach(button => {
                    button.addEventListener('click', function() {
                        const albumId = this.getAttribute('data-id');
                        deleteAlbum(albumId);
                    });
                });
            });

            // Close modal when clicking outside
            window.onclick = function(event) {
                const addModal = document.getElementById('albumModal');
                const editModal = document.getElementById('editAlbumModal');
                
                if (event.target == addModal) {
                    addModal.style.display = "none";
                }
                
                if (event.target == editModal) {
                    editModal.style.display = "none";
                }
            }
        </script>
    </body>
</html> 
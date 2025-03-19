<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>User Management - Admin Panel</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
        <style>
            /* Common Admin Styles */
body {
    background-color: #0a192f;
    color: #e6f1ff;
    font-family: 'Poppins', sans-serif;
    margin: 0;
    padding: 0;
    display: flex;
}

.sidebar {
    width: 250px;
    background: #112240;
    height: 100vh;
    padding: 20px;
    position: fixed;
}

.logo {
    color: #64ffda;
    font-size: 24px;
    font-weight: 600;
    margin-bottom: 40px;
    display: flex;
    align-items: center;
    gap: 10px;
}

.nav-menu {
    list-style: none;
    padding: 0;
    margin: 0;
}

.nav-menu li {
    margin-bottom: 5px;
}

.nav-menu a {
    color: #a8b2d1;
    text-decoration: none;
    padding: 12px 15px;
    display: flex;
    align-items: center;
    gap: 10px;
    border-radius: 6px;
    transition: all 0.3s ease;
}

.nav-menu a:hover, .nav-menu a.active {
    background: #233554;
    color: #64ffda;
}

.nav-menu i {
    width: 20px;
}

.main-content {
    margin-left: 290px;
    padding: 30px;
    width: calc(100% - 290px);
}

.page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
}

.page-title {
    color: #64ffda;
    font-size: 28px;
    font-weight: 600;
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
}

.modal-content {
    background: #112240;
    border-radius: 10px;
    padding: 30px;
    width: 90%;
    max-width: 500px;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
}

.modal-content h2 {
    color: #64ffda;
    margin-bottom: 25px;
    font-size: 24px;
}

.form-group {
    margin-bottom: 20px;
}

.form-group label {
    display: block;
    margin-bottom: 8px;
    color: #a8b2d1;
    font-size: 14px;
}

.form-group input,
.form-group select {
    width: 100%;
    padding: 10px 15px;
    background: #233554;
    border: 1px solid rgba(100, 255, 218, 0.1);
    border-radius: 6px;
    color: #e6f1ff;
    font-family: 'Poppins', sans-serif;
    font-size: 14px;
}

.form-group input:focus,
.form-group select:focus {
    outline: none;
    border-color: #64ffda;
}

.form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 15px;
    margin-top: 30px;
}

.form-actions button {
    padding: 10px 20px;
    border-radius: 6px;
    font-size: 14px;
    font-weight: 500;
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
    border: 1px solid #64ffda;
}

.form-actions button:hover {
    transform: translateY(-2px);
}

/* Table Styles */
.data-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    background: #112240;
    border-radius: 8px;
    overflow: hidden;
}

.data-table th {
    background: #1a365d;
    color: #64ffda;
    text-align: left;
    padding: 15px;
    font-weight: 500;
}

.data-table td {
    padding: 15px;
    border-bottom: 1px solid rgba(100, 255, 218, 0.1);
    color: #a8b2d1;
}

.data-table tr:hover {
    background: #233554;
}

/* Status Badge Styles */
.status-badge {
    padding: 5px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 500;
}

.status-active {
    background: rgba(100, 255, 218, 0.1);
    color: #64ffda;
}

.status-inactive {
    background: rgba(255, 100, 100, 0.1);
    color: #ff6464;
}

/* Action Icons */
.action-icons {
    display: flex;
    gap: 15px;
}

.action-icons i {
    color: #64ffda;
    cursor: pointer;
    transition: all 0.3s ease;
    font-size: 16px;
}

.action-icons i:hover {
    transform: scale(1.1);
}

.action-icons i.fa-trash {
    color: #ff6464;
}

.action-icons i.fa-key {
    color: #ffd700;
}

/* Search Bar Styles */
.search-bar {
    display: flex;
    gap: 10px;
    margin-bottom: 20px;
}

.search-input {
    background: #233554;
    border: 1px solid rgba(100, 255, 218, 0.1);
    color: #e6f1ff;
    padding: 10px 15px;
    border-radius: 6px;
    flex: 1;
    font-family: 'Poppins', sans-serif;
}

.search-input:focus {
    outline: none;
    border-color: #64ffda;
}

.filter-select {
    background: #233554;
    border: 1px solid rgba(100, 255, 218, 0.1);
    color: #e6f1ff;
    padding: 10px 15px;
    border-radius: 6px;
    font-family: 'Poppins', sans-serif;
    min-width: 150px;
}

/* Action Button */
.action-button {
    background: transparent;
    color: #64ffda;
    border: 1px solid #64ffda;
    padding: 10px 20px;
    border-radius: 6px;
    cursor: pointer;
    font-size: 14px;
    transition: all 0.3s ease;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 8px;
}

.action-button:hover {
    background: rgba(100, 255, 218, 0.1);
    transform: translateY(-2px);
}

/* Pagination */
.pagination {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    margin-top: 20px;
}

.pagination button {
    background: #233554;
    border: none;
    color: #64ffda;
    padding: 8px 15px;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.3s ease;
    min-width: 40px;
}

.pagination button:hover {
    background: rgba(100, 255, 218, 0.1);
}

.pagination button.active {
    background: #64ffda;
    color: #0a192f;
}

/* Alert Messages */
.alert {
    padding: 15px 20px;
    border-radius: 6px;
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    animation: slideIn 0.5s ease-in-out;
}

.alert i {
    margin-right: 10px;
}

.alert-success {
    background: rgba(100, 255, 218, 0.1);
    border: 1px solid #64ffda;
    color: #64ffda;
}

.alert-error {
    background: rgba(255, 100, 100, 0.1);
    border: 1px solid #ff6464;
    color: #ff6464;
}

.close-alert {
    background: none;
    border: none;
    color: inherit;
    cursor: pointer;
    padding: 0;
    font-size: 16px;
    opacity: 0.8;
    transition: opacity 0.3s ease;
}

.close-alert:hover {
    opacity: 1;
}

@keyframes slideIn {
    from {
        transform: translateY(-20px);
        opacity: 0;
    }
    to {
        transform: translateY(0);
        opacity: 1;
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
            <!-- Alert Messages -->
            <c:if test="${param.message eq 'delete_success'}">
                <div class="alert alert-success" id="alertMessage">
                    <div>
                        <i class="fas fa-check-circle"></i>
                        User has been deleted successfully!
                    </div>
                    <button type="button" class="close-alert" onclick="this.parentElement.style.display='none';">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </c:if>
            <c:if test="${param.message eq 'delete_failed'}">
                <div class="alert alert-error" id="alertMessage">
                    <div>
                        <i class="fas fa-exclamation-circle"></i>
                        Failed to delete user. Please try again.
                    </div>
                    <button type="button" class="close-alert" onclick="this.parentElement.style.display='none';">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </c:if>

            <div class="search-bar">
                <form action="${pageContext.request.contextPath}/admin" method="GET" id="searchForm">
                    <input type="hidden" name="action" value="user-management">
                    <input type="text" name="search" class="search-input" placeholder="Search by username, email, or full name..." value="${param.search}">
                    <select name="role" class="filter-select" onchange="document.getElementById('searchForm').submit()">
                        <option value="" ${empty param.role ? 'selected' : ''}>All Roles</option>
                        <option value="1" ${param.role == '1' ? 'selected' : ''}>Admin</option>
                        <option value="2" ${param.role == '2' ? 'selected' : ''}>User</option>
                        <option value="3" ${param.role == '3' ? 'selected' : ''}>Premium User</option>
                    </select>
                    <button type="submit" class="action-button">
                        <i class="fas fa-search"></i> Search
                    </button>
                </form>
            </div>

            <c:if test="${not empty param.search || not empty param.role}">
                <div style="margin: 10px 0;">
                    <span style="color: #64ffda;">
                        Search results for: 
                        <c:if test="${not empty param.search}">
                            "${param.search}"
                        </c:if>
                        <c:if test="${not empty param.role}">
                            (Role: ${param.role == '1' ? 'Admin' : param.role == '2' ? 'User' : 'Premium User'})
                        </c:if>
                    </span>
                    <a href="${pageContext.request.contextPath}/admin?action=user-management" 
                       style="margin-left: 10px; color: #ff6464; text-decoration: none;">
                        <i class="fas fa-times"></i> Clear filters
                    </a>
                </div>
            </c:if>

            <table class="data-table">
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Full Name</th>
                        <th>Phone</th>
                        <th>Created At</th>
                        <th>Premium Status</th>
                        <th>Roles</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${users}" var="user">
                        <tr>
                            <td>${user.userID}</td>
                            <td>${user.userName}</td>
                            <td>${user.email}</td>
                            <td>${user.fullName}</td>
                            <td>${user.phone}</td>
                            <td><fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.premiumExpiry != null && user.premiumExpiry.time > System.currentTimeMillis()}">
                                        <span class="status-badge status-active">Premium</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-badge status-inactive">Standard</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty user.roles}">
                                        <c:forEach items="${user.roles}" var="role" varStatus="status">
                                            ${role}${!status.last ? ', ' : ''}
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        No roles
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="action-icons">
                                    <%-- <i class="fas fa-edit" onclick="editUser(${user.userID})" title="Edit User"></i> --%>
                                    <%-- <i class="fas fa-key" onclick="resetPassword(${user.userID})" title="Reset Password"></i> --%>
                                    <i class="fas fa-trash" onclick="deleteUser(${user.userID})" title="Delete User"></i>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
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

        <!-- Add User Modal -->
        <!-- <div id="addUserModal" class="modal">
            <div class="modal-content">
                <h2>Add New User</h2>
                <form action="admin?action=add-user" method="POST">
                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" name="userName" required>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" required>
                    </div>
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="fullName" required>
                    </div>
                    <div class="form-group">
                        <label>Phone</label>
                        <input type="text" name="phone">
                    </div>
                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" name="password" required>
                    </div>
                    <div class="form-group">
                        <label>Role</label>
                        <select name="role" required>
                            <option value="2">User</option>
                            <option value="1">Admin</option>
                            <option value="3">Premium User</option>
                        </select>
                    </div>
                    <div class="form-actions">
                        <button type="button" onclick="closeModal()">Cancel</button>
                        <button type="submit">Add User</button>
                    </div>
                </form>
            </div>
        </div> -->

        <script>
            function showAddUserModal() {
                document.getElementById('addUserModal').style.display = 'block';
            }

            function closeModal() {
                document.getElementById('addUserModal').style.display = 'none';
            }

            function editUser(userId) {
                // Implement edit user functionality
                console.log('Edit user:', userId);
            }

            function deleteUser(userId) {
                if (confirm('Are you sure you want to delete this user?')) {
                    window.location.href = 'admin?action=delete-user&id=' + userId;
                }
            }

            function resetPassword(userId) {
                if (confirm('Are you sure you want to reset this user\'s password?')) {
                    window.location.href = 'admin?action=reset-password&id=' + userId;
                }
            }

            // Close modal when clicking outside
            window.onclick = function(event) {
                var modal = document.getElementById('addUserModal');
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            }
            
            // Auto-hide alert messages after 5 seconds
            document.addEventListener('DOMContentLoaded', function() {
                var alertMessage = document.getElementById('alertMessage');
                if (alertMessage) {
                    setTimeout(function() {
                        alertMessage.style.display = 'none';
                    }, 5000); // Hide after 5 seconds
                }
            });
        </script>
    </body>
</html> 
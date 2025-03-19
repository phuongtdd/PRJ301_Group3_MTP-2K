<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Panel - Music Paradise</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
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
            }

            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .stat-card {
                background: #112240;
                padding: 20px;
                border-radius: 8px;
                border: 1px solid rgba(100, 255, 218, 0.1);
            }

            .stat-title {
                color: #a8b2d1;
                font-size: 14px;
                margin-bottom: 10px;
            }

            .stat-value {
                color: #64ffda;
                font-size: 24px;
                font-weight: 600;
            }

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
            }

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
            }

            .pagination button:hover {
                background: rgba(100, 255, 218, 0.1);
            }

            .pagination button.active {
                background: #64ffda;
                color: #0a192f;
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
                <h1 class="page-title">Dashboard</h1>
                <!-- <button class="action-button">
                    <i class="fas fa-plus"></i> Add New
                </button> -->
            </div>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-title">Total Users</div>
                    <div class="stat-value">1,234</div>
                </div>
                <div class="stat-card">
                    <div class="stat-title">Active Subscriptions</div>
                    <div class="stat-value">856</div>
                </div>
                <div class="stat-card">
                    <div class="stat-title">Total Tracks</div>
                    <div class="stat-value">5,678</div>
                </div>
                <div class="stat-card">
                    <div class="stat-title">Monthly Revenue</div>
                    <div class="stat-value">$12,345</div>
                </div>
            </div>

            <div class="search-bar">
                <input type="text" class="search-input" placeholder="Search...">
                <select class="filter-select">
                    <option value="">All Status</option>
                    <option value="active">Active</option>
                    <option value="inactive">Inactive</option>
                </select>
                <button class="action-button">
                    <i class="fas fa-search"></i> Search
                </button>
            </div>

            <table class="data-table">
                <thead>
                    <tr>
                        <th>User</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Last Login</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${users}" var="user">
                        <tr>
                            <td>${user.name}</td>
                            <td>${user.email}</td>
                            <td>${user.role}</td>
                            <td>
                                <span class="status-badge status-active">Active</span>
                            </td>
                            <td>${user.lastLogin}</td>
                            <td>
                                <div class="action-icons">
                                    <i class="fas fa-edit"></i>
                                    <i class="fas fa-trash"></i>
                                    <i class="fas fa-key"></i>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <!-- Sample data -->
                    <tr>
                        <td>John Doe</td>
                        <td>john@example.com</td>
                        <td>Admin</td>
                        <td><span class="status-badge status-active">Active</span></td>
                        <td>2024-03-15 10:30</td>
                        <td>
                            <div class="action-icons">
                                <i class="fas fa-edit"></i>
                                <i class="fas fa-trash"></i>
                                <i class="fas fa-key"></i>
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
    </body>
</html>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order Management - Admin Panel</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
        <style>
            .order-table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                margin-top: 20px;
                border-radius: 12px;
                overflow: hidden;
            }

            .order-table th, .order-table td {
                padding: 12px 15px;
                text-align: left;
                background-color: #1a365d;
                color: #e6f1ff;
            }

            .order-table th {
                background-color: #112240;
            }

            .order-table tr:nth-child(even) {
                background-color: #1a365d;
            }

            .order-table tr:hover {
                background-color: #2b4a6f;
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

            .action-icons {
                display: flex;
                gap: 10px;
            }

            .modal {
                display: none;
                position: fixed;
                z-index: 1;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                overflow: auto;
                background-color: rgb(0,0,0);
                background-color: rgba(0,0,0,0.4);
                padding-top: 60px;
            }

            .modal-content {
                background-color: #0a192f;
                color: #cfd8dc;
                margin: 5% auto;
                padding: 20px;
                border: 1px solid #888;
                width: 80%;
            }

            .modal-content h2 {
                color: #64ffda;
            }

            .close {
                color: #cfd8dc;
                float: right;
                font-size: 28px;
                font-weight: bold;
            }

            .close:hover,
            .close:focus {
                color: #64ffda;
                text-decoration: none;
                cursor: pointer;
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
                <h1 class="page-title">Order Management</h1>
            </div>

            <div class="filter-bar">
                <div class="filter-group">
                    <div class="filter-label">Search:</div>
                    <input type="text" class="search-input" placeholder="Search orders...">
                </div>
                <div class="filter-group">
                    <div class="filter-label">Status:</div>
                    <select class="filter-select">
                        <option value="">All Statuses</option>
                        <option value="pending">Pending</option>
                        <option value="completed">Completed</option>
                        <option value="shipped">Shipped</option>
                        <option value="cancelled">Cancelled</option>
                    </select>
                </div>
                <div class="filter-group">
                    <div class="filter-label">Sort by:</div>
                    <select class="filter-select sort-select">
                        <option value="date">Date</option>
                        <option value="total">Total Amount</option>
                        <option value="customer">Customer Name</option>
                    </select>
                </div>
            </div>

            <table class="order-table">
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Customer</th>
                        <th>Package</th>
                        <th>Payment Method</th>
                        <th>Order Date</th>
                        <th>Expiry Date</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${orders}" var="order">
                        <tr>
                            <td>${order.orderID}</td>
                            <td>${order.userFullName}</td>
                            <td>${order.packageName}</td>
                            <td>${order.paymentName}</td>
                            <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/></td>
                            <td><fmt:formatDate value="${order.expiryDate}" pattern="dd/MM/yyyy"/></td>
                            <td>$${order.amount}</td>
                            <td>
                                <span class="status-badge ${order.status == 'Completed' ? 'status-active' : 'status-inactive'}">
                                    ${order.status}
                                </span>
                            </td>
                            <td>
                                <div class="action-icons">
                                    <i class="fas fa-eye" onclick="viewOrder(${order.orderID})" title="View Order"></i>
                                    <i class="fas fa-edit" onclick="editOrder(${order.orderID})" title="Edit Order"></i>
                                    <i class="fas fa-trash" onclick="deleteOrder(${order.orderID})" title="Delete Order"></i>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <!-- Order Details Modal -->
            <div id="orderModal" class="modal">
                <div class="modal-content">
                    <span class="close" onclick="closeModal()">&times;</span>
                    <h2>Order Details</h2>
                    <div id="orderDetails">
                        <!-- Order details will be dynamically loaded here -->
                    </div>
                </div>
            </div>
        </div>

        <script>
            function viewOrder(orderId) {
                // Implement view order functionality
                console.log('View order:', orderId);
                document.getElementById('orderModal').style.display = 'block';
            }

            function editOrder(orderId) {
                // Implement edit order functionality
                console.log('Edit order:', orderId);
            }

            function deleteOrder(orderId) {
                if (confirm('Are you sure you want to delete this order?')) {
                    // Implement delete order functionality
                    console.log('Delete order:', orderId);
                }
            }

            function closeModal() {
                document.getElementById('orderModal').style.display = 'none';
            }
        </script>
    </body>
</html> 
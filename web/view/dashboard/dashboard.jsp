<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Panel - Music Paradise</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

            /* Main content styles start here */
            .main-content {
                margin-left: 290px;
                padding: 30px;
                width: calc(100% - 290px);
                background: linear-gradient(135deg, #0a192f 0%, #0d1b2a 100%);
                min-height: 100vh;
            }

            .page-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 35px;
                padding-bottom: 15px;
                border-bottom: 1px solid rgba(100, 255, 218, 0.1);
            }

            .page-title {
                color: #64ffda;
                font-size: 30px;
                font-weight: 600;
                position: relative;
            }
            
            .page-title:after {
                content: '';
                position: absolute;
                left: 0;
                bottom: -8px;
                width: 50px;
                height: 3px;
                background: #64ffda;
                border-radius: 2px;
            }

            .action-button {
                background: rgba(100, 255, 218, 0.05);
                color: #64ffda;
                border: 1px solid #64ffda;
                padding: 10px 20px;
                border-radius: 8px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                box-shadow: 0 4px 12px rgba(100, 255, 218, 0.1);
            }

            .action-button:hover {
                background: rgba(100, 255, 218, 0.15);
                transform: translateY(-2px);
                box-shadow: 0 6px 15px rgba(100, 255, 218, 0.2);
            }

            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
                gap: 25px;
                margin-bottom: 40px;
            }

            .stat-card {
                background: #112240;
                padding: 24px;
                border-radius: 12px;
                border: 1px solid rgba(100, 255, 218, 0.1);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }
            
            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.25);
            }
            
            .stat-card:before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 4px;
                height: 100%;
                background: #64ffda;
                opacity: 0.8;
            }
            
            .stat-card.users:before { background: #60a5fa; }
            .stat-card.premium:before { background: #fbbf24; }
            .stat-card.tracks:before { background: #64ffda; }
            .stat-card.artists:before { background: #f472b6; }
            .stat-card.albums:before { background: #a78bfa; }
            .stat-card.revenue:before { background: #4ade80; }

            .stat-title {
                color: #a8b2d1;
                font-size: 15px;
                margin-bottom: 15px;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            
            .stat-title i {
                font-size: 18px;
            }
            
            .stat-card.users .stat-title i { color: #60a5fa; }
            .stat-card.premium .stat-title i { color: #fbbf24; }
            .stat-card.tracks .stat-title i { color: #64ffda; }
            .stat-card.artists .stat-title i { color: #f472b6; }
            .stat-card.albums .stat-title i { color: #a78bfa; }
            .stat-card.revenue .stat-title i { color: #4ade80; }

            .stat-value {
                font-size: 32px;
                font-weight: 600;
                margin-top: 10px;
            }
            
            .stat-card.users .stat-value { color: #60a5fa; }
            .stat-card.premium .stat-value { color: #fbbf24; }
            .stat-card.tracks .stat-value { color: #64ffda; }
            .stat-card.artists .stat-value { color: #f472b6; }
            .stat-card.albums .stat-value { color: #a78bfa; }
            .stat-card.revenue .stat-value { color: #4ade80; }
            
            .charts-section {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 30px;
                margin-bottom: 40px;
            }
            
            .chart-container {
                background: #112240;
                border-radius: 12px;
                border: 1px solid rgba(100, 255, 218, 0.1);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
                padding: 20px;
                transition: all 0.3s ease;
            }
            
            .chart-container:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.25);
            }
            
            .chart-title {
                color: #64ffda;
                font-size: 18px;
                font-weight: 600;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
                padding-bottom: 10px;
                border-bottom: 1px solid rgba(100, 255, 218, 0.1);
            }
            
            .chart-canvas {
                width: 100%;
                height: 300px;
            }

            .section-header {
                color: #64ffda;
                margin-top: 40px;
                margin-bottom: 25px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding-bottom: 10px;
                border-bottom: 1px solid rgba(100, 255, 218, 0.1);
            }

            .section-header h2 {
                margin: 0;
                font-size: 22px;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            
            .section-header h2 i {
                font-size: 20px;
            }

            .data-table-container {
                background: #112240;
                border-radius: 12px;
                padding: 5px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
                overflow: hidden;
            }

            .data-table {
                width: 100%;
                border-collapse: collapse;
                background: transparent;
                border-radius: 12px;
                overflow: hidden;
            }

            .data-table th {
                background: rgba(26, 54, 93, 0.8);
                color: #64ffda;
                text-align: left;
                padding: 16px;
                font-weight: 500;
            }

            .data-table td {
                padding: 16px;
                border-bottom: 1px solid rgba(100, 255, 218, 0.08);
                color: #a8b2d1;
            }

            .data-table tbody tr {
                transition: all 0.3s ease;
            }

            .data-table tbody tr:hover {
                background: rgba(35, 53, 84, 0.6);
            }
            
            .data-table tbody tr:hover td {
                color: #e6f1ff;
            }

            .status-badge {
                padding: 6px 14px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }

            .status-active {
                background: rgba(100, 255, 218, 0.15);
                color: #64ffda;
                border: 1px solid rgba(100, 255, 218, 0.3);
            }

            .status-premium {
                background: rgba(255, 193, 7, 0.15);
                color: #ffc107;
                border: 1px solid rgba(255, 193, 7, 0.3);
            }

            .status-inactive {
                background: rgba(255, 100, 100, 0.15);
                color: #ff6464;
                border: 1px solid rgba(255, 100, 100, 0.3);
            }

            .action-icons {
                display: flex;
                gap: 15px;
                justify-content: center;
            }

            .action-icons a, .action-icons i {
                color: #a8b2d1;
                cursor: pointer;
                transition: all 0.3s ease;
                font-size: 16px;
                width: 32px;
                height: 32px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
                background: rgba(100, 255, 218, 0.08);
            }

            .action-icons a:hover, .action-icons i:hover {
                color: #64ffda;
                background: rgba(100, 255, 218, 0.15);
                transform: scale(1.1);
            }
            
            .action-icons .fa-trash:hover {
                color: #ff6464;
                background: rgba(255, 100, 100, 0.15);
            }

            .no-data {
                color: #a8b2d1;
                text-align: center;
                padding: 40px;
                font-style: italic;
                background: #112240;
                border-radius: 12px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 15px;
            }
            
            .no-data i {
                font-size: 40px;
                color: #64ffda;
                opacity: 0.5;
            }
            
            @media screen and (max-width: 1200px) {
                .charts-section {
                    grid-template-columns: 1fr;
                }
            }
            
            @media screen and (max-width: 768px) {
                .main-content {
                    padding: 20px;
                }
                
                .stats-grid {
                    grid-template-columns: repeat(2, 1fr);
                }
            }
            
            @media screen and (max-width: 576px) {
                .stats-grid {
                    grid-template-columns: 1fr;
                }
            }

            /* Additional styles for online status */
            .online-status {
                display: flex;
                align-items: center;
                gap: 6px;
                font-size: 12px;
                font-weight: 500;
            }
            
            .status-online {
                color: #4ade80;
            }
            
            .status-offline {
                color: #9ca3af;
            }
            
            .status-text {
                transition: all 0.3s ease;
            }
            
            .is-online .status-text {
                color: #4ade80;
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
                <h1 class="page-title">Dashboard</h1>
            </div>

            <div class="stats-grid">
                <div class="stat-card users">
                    <div class="stat-title"><i class="fas fa-users"></i> Total Users</div>
                    <div class="stat-value">${totalUsers}</div>
                </div>
                <div class="stat-card premium">
                    <div class="stat-title"><i class="fas fa-crown"></i> Premium Users</div>
                    <div class="stat-value">${premiumUsers}</div>
                </div>
                <div class="stat-card tracks">
                    <div class="stat-title"><i class="fas fa-music"></i> Total Tracks</div>
                    <div class="stat-value">${totalTracks}</div>
                </div>
                <div class="stat-card artists">
                    <div class="stat-title"><i class="fas fa-user-circle"></i> Total Artists</div>
                    <div class="stat-value">${totalArtists}</div>
                </div>
                <div class="stat-card albums">
                    <div class="stat-title"><i class="fas fa-compact-disc"></i> Total Albums</div>
                    <div class="stat-value">${totalAlbums}</div>
                </div>
                <div class="stat-card revenue">
                    <div class="stat-title"><i class="fas fa-dollar-sign"></i> Monthly Revenue</div>
                    <div class="stat-value">$<fmt:formatNumber value="${premiumUsers * 15.99}" pattern="#,##0.00"/></div>
                </div>
            </div>
            
            <div class="section-header">
                <h2><i class="fas fa-chart-line"></i> Analytics Overview</h2>
            </div>
            
            <div class="charts-section">
                <div class="chart-container">
                    <div class="chart-title">
                        <i class="fas fa-chart-pie"></i>
                        Content Distribution
                    </div>
                    <canvas id="contentDistributionChart" class="chart-canvas"></canvas>
                </div>
                <div class="chart-container">
                    <div class="chart-title">
                        <i class="fas fa-chart-bar"></i>
                        User Statistics
                    </div>
                    <canvas id="userStatsChart" class="chart-canvas"></canvas>
                </div>
            </div>
        </div>
        <!-- <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Get values from JSP variables
                const totalUsers = parseInt("${totalUsers}");
                const premiumUsers = parseInt("${premiumUsers}");
                const regularUsers = totalUsers - premiumUsers;
                const totalTracks = parseInt("${totalTracks}");
                const totalArtists = parseInt("${totalArtists}");
                const totalAlbums = parseInt("${totalAlbums}");
                const monthlyRevenue = parseFloat("${premiumUsers * 15.99}".replace(',', '.'));
        
                // Global Chart configuration
                Chart.defaults.color = '#e6f1ff';
                Chart.defaults.font.family = 'Poppins, sans-serif';
                Chart.defaults.font.size = 14;
        
                // Destroy existing charts if they exist
                ['contentChart', 'userChart'].forEach(chart => {
                    if (window[chart]) {
                        window[chart].destroy();
                    }
                });
        
                // Content Distribution Chart (Doughnut)
                const contentDistributionCtx = document.getElementById('contentDistributionChart').getContext('2d');
                window.contentChart = new Chart(contentDistributionCtx, {
                                            animation: false,

                    type: 'doughnut',
                    data: {
                        labels: ['Tracks', 'Artists', 'Albums'],
                        datasets: [{
                            data: [totalTracks, totalArtists, totalAlbums],
                            backgroundColor: [
                                'rgba(100, 255, 218, 0.8)',
                                'rgba(244, 114, 182, 0.8)',
                                'rgba(167, 139, 250, 0.8)'
                            ],
                            borderColor: '#112240',
                            borderWidth: 3,
                            hoverOffset: 20,
                            shadowOffsetX: 3,
                            shadowOffsetY: 3,
                            shadowBlur: 10,
                            shadowColor: 'rgba(0, 0, 0, 0.3)'
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        animation: false,
                        cutout: '70%',
                        plugins: {
                            legend: {
                                position: 'bottom',
                                labels: {
                                    padding: 25,
                                    usePointStyle: true,
                                    pointStyle: 'circle',
                                    font: {
                                        size: 14,
                                        weight: '500'
                                    }
                                }
                            },
                            tooltip: {
                                backgroundColor: 'rgba(17, 34, 64, 0.95)',
                                cornerRadius: 8,
                                padding: 12,
                                titleFont: {
                                    size: 16,
                                    weight: 'bold'
                                },
                                bodyFont: {
                                    size: 14
                                },
                                callbacks: {
                                    label: function(context) {
                                        const label = context.label;
                                        const value = context.raw;
                                        const total = context.dataset.data.reduce((acc, val) => acc + val, 0);
                                        const percentage = ((value / total) * 100).toFixed(1);
                                        return `${label}: ${value} (${percentage}%)`;
                                    }
                                }
                            }
                        },
                        animation: {
                            duration: 1000,
                            easing: 'easeOutQuart'
                        }
                    }
                });
        
                // User Statistics Chart (Bar)
                const userStatsCtx = document.getElementById('userStatsChart').getContext('2d');
                window.userChart = new Chart(userStatsCtx, {
                    type: 'bar',
                    data: {
                        labels: ['Regular Users', 'Premium Users', 'Revenue ($)'],
                        datasets: [{
                            data: [regularUsers, premiumUsers, monthlyRevenue],
                            backgroundColor: [
                                'rgba(96, 165, 250, 0.8)',
                                'rgba(251, 191, 36, 0.8)',
                                'rgba(74, 222, 128, 0.8)'
                            ],
                            borderColor: '#112240',
                            borderWidth: 2,
                            borderRadius: {
                                topLeft: 8,
                                topRight: 8,
                                bottomLeft: 0,
                                bottomRight: 0
                            },
                            hoverBackgroundColor: [
                                'rgba(96, 165, 250, 1)',
                                'rgba(251, 191, 36, 1)',
                                'rgba(74, 222, 128, 1)'
                            ]
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        animation: false,
                        indexAxis: 'y',
                        plugins: {
                            legend: {
                                display: false
                            },
                            tooltip: {
                                backgroundColor: 'rgba(17, 34, 64, 0.95)',
                                cornerRadius: 8,
                                padding: 12,
                                titleFont: {
                                    size: 16,
                                    weight: 'bold'
                                },
                                bodyFont: {
                                    size: 14
                                },
                                callbacks: {
                                    label: function(context) {
                                        const value = context.raw;
                                        return context.dataIndex === 2 ? 
                                            `Revenue: $${value.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2})}` : 
                                            `Users: ${value}`;
                                    }
                                }
                            }
                        },
                        scales: {
                            x: {
                                grid: {
                                    color: 'rgba(100, 255, 218, 0.1)',
                                    borderColor: 'transparent'
                                },
                                ticks: {
                                    color: '#a8b2d1',
                                    padding: 10,
                                    callback: function(value) {
                                        return this.getLabelForValue(value).includes('$') ? 
                                            `$${value.toLocaleString()}` : value;
                                    }
                                }
                            },
                            y: {
                                grid: {
                                    display: false
                                },
                                ticks: {
                                    color: '#e6f1ff',
                                    font: {
                                        size: 14,
                                        weight: '600'
                                    },
                                    padding: 10
                                }
                            }
                        },
                        animation: {
                            duration: 1200,
                            easing: 'easeOutBounce'
                        }
                    }
                });
            });
        </script> -->
    </body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Top Songs - MTP-2K</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>


            /* Custom scrollbar styles */
            ::-webkit-scrollbar {
                width: 8px;
            }

            ::-webkit-scrollbar-track {
                background: rgba(2, 12, 27, 0.95);
            }

            ::-webkit-scrollbar-thumb {
                background: #64ffda;
                border-radius: 4px;
            }

            ::-webkit-scrollbar-thumb:hover {
                background: #4ad3b3;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #0a192f;
                color: #e6f1ff;
                margin: 0;
                padding: 0;
                display: flex;

            }
            .sidebar {
                width: 240px;
                background: rgba(2, 12, 27, 0.95);
                padding: 20px;
                height: calc(100vh - 60px);
                position: fixed;
                display: flex;
                flex-direction: column;
                overflow-y: auto;
                padding-bottom: 80px;
                box-shadow: 2px 0 10px rgba(0, 0, 0, 0.3);
                backdrop-filter: blur(10px);
            }

            .logo-container {
                margin-bottom: 30px;
                text-align: center;
            }

            .logo-container img {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                box-shadow: 0 0 20px rgba(100, 255, 218, 0.2);
                transition: transform 0.3s ease;
            }

            .logo-container img:hover {
                transform: scale(1.05);
            }

            .nav-links {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .nav-links li {
                padding: 12px 15px;
                margin: 5px 0;
                border-radius: 8px;
                display: flex;
                align-items: center;
                gap: 15px;
                transition: all 0.3s ease;
            }

            .nav-links li:hover {
                background: rgba(23, 42, 69, 0.8);
                transform: translateX(5px);
            }

            .nav-links a {
                color: #a8b2d1;
                text-decoration: none;
                font-size: 14px;
                font-weight: 500;
                transition: color 0.3s ease;
                width: 100%;
            }

            .nav-links a:hover {
                color: #64ffda;
            }

            .nav-links i {
                font-size: 16px;
                width: 20px;
                text-align: center;
            }

            .footer-links {
                margin-top: auto;
                padding: 15px 0;
                border-top: 1px solid rgba(100, 255, 218, 0.1);
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 10px;
                padding-bottom: 70px;
            }

            .footer-links a {
                color: #a8b2d1;
                text-decoration: none;
                font-size: 12px;
                transition: color 0.3s ease;
                padding: 4px 0;
            }

            .footer-links a:hover {
                color: #64ffda;
            }

            /* Main Content */
            .main-content {
                margin-left: 280px;
                padding: 5px 30px 30px 30px; /* top | right | bottom | left */
                width: calc(100% - 280px);
                /* animation: slideIn 0.6s ease-out; */ /* có thể bỏ nếu muốn mượt hơn */
            }


            @keyframes slideIn {
                from {
                    transform: translateX(30px);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }

            .section-title {
                font-size: 24px;
                color: #64ffda; /* Màu chữ mặc định */
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                animation: fadeInUp 0.5s ease-out;
                text-transform: uppercase; /* In hoa để tiêu đề nổi bật */
                font-weight: 700; /* Làm cho chữ đậm */
                text-shadow: 2px 2px 10px rgba(100, 255, 218, 0.5); /* Thêm bóng chữ nhẹ */
            }

            .section-title:hover {
                color: #64ffda; /* Màu khi hover */
                text-shadow: 2px 2px 15px rgba(100, 255, 218, 0.8); /* Tăng độ mờ bóng khi hover */
            }

            .section-title i {
                margin-right: 10px;
                color: #64ffda;
            }

            .filter-controls {
                display: flex;
                justify-content: center;
                margin-bottom: 30px;
                animation: fadeInUp 0.6s ease-out;
            }

            .filter-btn {
                background-color: rgba(100, 255, 218, 0.1);
                color: #ccd6f6;
                border: 1px solid rgba(100, 255, 218, 0.3);
                padding: 8px 16px;
                margin: 0 10px;
                border-radius: 5px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .filter-btn:hover, .filter-btn.active {
                background-color: rgba(100, 255, 218, 0.2);
                color: #64ffda;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            }

            /* Track list styles */
            .tracks-list {
                background-color: rgba(2, 12, 27, 0.7);
                border-radius: 10px;
                overflow: hidden;
                animation: fadeInUp 0.8s ease-out;
            }

            .track-item {
                display: grid;
                grid-template-columns: 50px 60px 1fr 120px 100px 80px;
                align-items: center;
                padding: 15px 20px;
                border-bottom: 1px solid rgba(100, 255, 218, 0.1);
                transition: background-color 0.3s ease;
                animation: fadeInUp 0.4s ease-out;
                animation-fill-mode: both;
                cursor: pointer;
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .track-item:hover {
                background-color: rgba(100, 255, 218, 0.05);
            }

            .track-rank {
                font-size: 20px;
                font-weight: bold;
                color: #8892b0;
            }

            .track-rank.rank-1 {
                color: #FFD700;
            }

            .track-rank.rank-2 {
                color: #C0C0C0;
            }

            .track-rank.rank-3 {
                color: #CD7F32;
            }

            .track-image {
                width: 50px;
                height: 50px;
                border-radius: 5px;
                object-fit: cover;
            }

            .track-info {
                display: flex;
                flex-direction: column;
                margin-left: 15px;
            }

            .track-title {
                font-size: 16px;
                font-weight: 600;
                margin: 0;
                color: #e6f1ff;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                max-width: 300px;
            }

            .track-artist {
                font-size: 14px;
                color: #8892b0;
                margin: 0;
            }

            .track-date {
                color: #8892b0;
                font-size: 14px;
                text-align: center;
            }

            .track-duration {
                color: #8892b0;
                font-size: 14px;
                text-align: center;
            }

            .track-plays {
                font-size: 14px;
                font-weight: bold;
                color: #ff6347; /* Màu đỏ cam, tạo sự nổi bật */
                text-align: right;
            }



            .play-btn {
                background-color: transparent;
                color: #8892b0;
                border: none;
                font-size: 16px;
                cursor: pointer;
                transition: all 0.3s ease;
                width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
            }

            .track-item:hover .play-btn {
                color: #64ffda;
                background-color: rgba(100, 255, 218, 0.1);
            }

            .track-list-header {
                display: grid;
                grid-template-columns: 75px 60px 1fr 120px 130px 35px;
                align-items: center;
                padding: 10px 20px;
                border-bottom: 2px solid #64ffda;
                font-size: 16px;
                color: #64ffda;
                font-weight: 600;
                background-color: rgba(2, 12, 27, 0.9);
                transition: all 0.3s ease;
            }

            /* Hiệu ứng glow khi hover */
            .track-list-header:hover {
                color: #ff6347; /* Đổi màu chữ khi hover */
                text-shadow: 0 0 10px #64ffda, 0 0 20px #64ffda, 0 0 30px #64ffda; /* Thêm hiệu ứng lấp lánh */
                box-shadow: 0 4px 15px rgba(100, 255, 218, 0.5); /* Tăng bóng đổ */
                transform: translateY(-5px); /* Nâng lên khi hover */
            }

            /* Khoảng cách các phần tử của Track List Header*/
            .track-list-header div:nth-child(1) {
                padding-left: 7px; /* Dịch dấu # qua phải */
                padding-right: 10px; /* Khoảng cách giữa # và ảnh */
            }

            .track-list-header div:nth-child(2) {
                padding-right: 15px; /* Khoảng cách giữa ảnh và TITLE */
            }

            .track-list-header div:nth-child(3) {
                padding-right: 25px; /* TITLE và DATE ADDED */
            }

            .track-list-header div:nth-child(4) {
                padding-right: 20px; /* DATE ADDED và DURATION */
            }

            .track-list-header div:nth-child(5) {
                padding-right: 10px; /* DURATION và PLAYS */
            }


            /* Charts section */
            /* Phần biểu đồ */
            .charts-section {
                background-color: rgba(2, 12, 27, 0.7);
                padding: 20px;
                transform: translateY(-10px); /* Dịch lên 10px */
                border-radius: 10px;
                margin-top: 0px;
                margin-bottom: 40px;

            }

            .chart-container {
                height: 500px;
                display: flex;
                align-items: flex-end;
                justify-content: space-around;
                margin-top: 30px;
                padding: 0 20px;
            }

            .chart-bar {
                position: relative; /* Để đặt các phần tử con vào vị trí tuyệt đối */
                width: 60px;
                background-color: rgba(100, 255, 218, 0.6);
                border-radius: 5px 5px 0 0;
                transition: height 1s ease;
                cursor: pointer; /* Thêm con trỏ để biết có thể tương tác */
            }

            .chart-bar:hover {
                transform: scale(1.05); /* Tăng kích thước một chút khi hover */
                background-color: rgba(100, 255, 218, 0.8); /* Thay đổi màu khi hover */
            }


            /* Tooltip cho tên bài hát và ca sĩ */
            .chart-tooltip {
                position: absolute;
                top: -95px; /* Đưa tooltip gần với đỉnh cột hơn */
                left: 50%;
                transform: translateX(-50%);
                background-color: rgba(0, 0, 0, 0.7);
                border: 1px solid #64ffda;
                border-radius: 5px;
                padding: 10px;
                min-width: 180px;
                color: #e6f1ff;
                font-size: 12px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
                pointer-events: none;
                opacity: 0;
                visibility: hidden;
                transition: opacity 0.3s, visibility 0.3s;
                z-index: 100;
            }



            /* Hiển thị tooltip khi hover vào cột */
            .chart-bar:hover .chart-tooltip {
                opacity: 1;
                visibility: visible;
            }

            /* CSS cho các thông tin trong tooltip */
            .tooltip-title {
                font-weight: bold;
                font-size: 14px;
                color: #64ffda;
                margin-bottom: 5px;
                text-align: center;
            }

            .tooltip-artist {
                color: #a8b2d1;
                margin-bottom: 5px;
                text-align: center;
            }

            .tooltip-plays {
                color: #e6f1ff;
                font-weight: bold;
                text-align: center;
            }

            .tooltip-plays span {
                color: #ff6347;
            }

            .chart-bar-value {
                position: absolute;
                top: -25px; /* Vị trí của số lượt phát trên đỉnh cột */
                left: 50%;
                transform: translateX(-50%); /* Căn giữa */
                font-size: 14px;
                color: #ff6347; /* Thay màu sắc tùy chỉnh, ví dụ màu đỏ cam */
                font-weight: bold;
            }


            .chart-label {
                margin-top: 30px;
                text-align: center;
                color: #8892b0;
                font-size: 14px;
            }

            /* Hiệu ứng chuyển trang */
            .track-item:nth-child(1) {
                animation-delay: 0.1s;
            }
            .track-item:nth-child(2) {
                animation-delay: 0.15s;
            }
            .track-item:nth-child(3) {
                animation-delay: 0.2s;
            }
            .track-item:nth-child(4) {
                animation-delay: 0.25s;
            }
            .track-item:nth-child(5) {
                animation-delay: 0.3s;
            }
            .track-item:nth-child(6) {
                animation-delay: 0.35s;
            }
            .track-item:nth-child(7) {
                animation-delay: 0.4s;
            }
            .track-item:nth-child(8) {
                animation-delay: 0.45s;
            }
            .track-item:nth-child(9) {
                animation-delay: 0.5s;
            }
            .track-item:nth-child(10) {
                animation-delay: 0.55s;
            }
            .track-item:nth-child(11) {
                animation-delay: 0.6s;
            }
            .track-item:nth-child(12) {
                animation-delay: 0.65s;
            }
            .track-item:nth-child(13) {
                animation-delay: 0.7s;
            }
            .track-item:nth-child(14) {
                animation-delay: 0.75s;
            }
            .track-item:nth-child(15) {
                animation-delay: 0.8s;
            }

            audio {
                display: none;
            }

            .toast {
                position: fixed;
                bottom: 20px;
                right: 20px;
                background-color: rgba(100, 255, 218, 0.2);
                border: 1px solid #64ffda;
                color: #64ffda;
                padding: 12px 20px;
                border-radius: 5px;
                z-index: 1000;
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .toast.show {
                opacity: 1;
            }

            /* Page transition overlay */
            .page-transition-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: #0a192f;
                z-index: 9999;
                opacity: 0;
                pointer-events: none;
                transition: opacity 0.4s ease;
            }

            .page-transition-overlay.active {
                opacity: 1;
                pointer-events: all;
            }
        </style>
    </head>
    <body>
        <!-- Page transition overlay -->
        <div class="page-transition-overlay" id="pageTransitionOverlay"></div>

        <div class="sidebar">
            <div class="logo-container">
                <img src="${pageContext.request.contextPath}/image/mtp2k-logo.png" alt="MTP-2K"
                     style="border-radius: 50%;">
            </div>
            <ul class="nav-links">
                <li><a href="home"><i class="fas fa-home"></i> Home</a></li>
                <li><a href="${pageContext.request.contextPath}/home/search"><i class="fas fa-search"></i>
                        Search</a></li>
                <li><a href="${pageContext.request.contextPath}/home/library"><i class="fas fa-book"></i> Your
                        Library</a></li>
                <li style="margin-top: 24px"><a
                        href="${pageContext.request.contextPath}/home/create-playlist    "><i
                            class="fas fa-plus-square"></i> Create Playlist</a></li>
                <li><a href="${pageContext.request.contextPath}/home/liked-songs"><i class="fas fa-heart"></i>
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
    </body>
</html> 
// Library page specific functionality
document.addEventListener("DOMContentLoaded", () => {
    // Các biến toàn cục cho trình phát nhạc
    let audioPlayer = document.getElementById("audioPlayer");
    let isPlaying = false;
    let currentTrackIndex = 0;
    let playlist = [];
    
    // Thêm biến toàn cục để theo dõi queue
    let temporaryQueue = [];
    
    // Khởi tạo các sự kiện cho trình phát nhạc
    initMusicPlayer();
    
    // Chức năng lọc
    const filterButtons = document.querySelectorAll('.filter-btn');
    
    filterButtons.forEach(button => {
        button.addEventListener('click', () => {
            // Xóa lớp active từ tất cả các nút
            filterButtons.forEach(btn => btn.classList.remove('active'));
            
            // Thêm lớp active cho nút được nhấp
            button.classList.add('active');
            
            // Lọc các mục thư viện dựa trên lựa chọn
            filterLibraryItems(button.textContent.trim().toLowerCase());
        });
    });
    
    function filterLibraryItems(filter) {
        const libraryGrid = document.querySelector('.library-grid');
        
        // Xóa các mục hiện tại
        libraryGrid.innerHTML = '';
        
        // Xác định các mục cần hiển thị dựa trên bộ lọc
        let itemsToShow = [];
        
        switch(filter) {
            case 'all':
                itemsToShow = [...samplePlaylists, ...sampleAlbums];
                break;
            case 'playlists':
                itemsToShow = samplePlaylists;
                break;
            case 'albums':
                itemsToShow = sampleAlbums;
                break;
            default:
                itemsToShow = [...samplePlaylists, ...sampleAlbums];
        }
        
        // Hiển thị các mục đã lọc
        renderLibraryItems(itemsToShow);
    }
    
    function renderLibraryItems(items) {
        const libraryGrid = document.querySelector('.library-grid');
        
        items.forEach(item => {
            const itemElement = document.createElement('div');
            itemElement.className = 'library-item';
            itemElement.dataset.id = item.id;
            
            // Xác định số lượng bài hát thực tế
            const songCount = item.songs ? item.songs.length : 0;
            
            // Xác định phụ đề dựa trên loại mục và số lượng bài hát thực tế
            let subtitle = '';
            if (item.type === 'Playlist') {
                subtitle = `${item.type} • ${songCount} ${songCount === 1 ? 'song' : 'songs'}`;
            } else if (item.type === 'Album') {
                subtitle = `${item.type} • ${item.artist}`;
            }
            
            itemElement.innerHTML = `
                <div class="library-item-img">
                    <img src="${window.contextPath + item.img}" alt="${item.title}">
                    ${item.isNew ? '<div class="library-item-badge">New</div>' : ''}
                    <div class="library-item-overlay">
                        <button class="play-btn">
                            <i class="fas fa-play"></i>
                        </button>
                    </div>
                </div>
                <div class="library-item-info">
                    <div class="library-item-title">${item.title}</div>
                    <div class="library-item-subtitle">${subtitle}</div>
                </div>
            `;
            
            // Thêm sự kiện lắng nghe
            const playBtn = itemElement.querySelector('.play-btn');
            playBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                if (!item.songs || item.songs.length === 0) {
                    showNotification('This playlist/album is empty');
                    return;
                }
                playLibraryItem(item);
            });
            
            itemElement.addEventListener('click', () => {
                openLibraryItem(item);
            });
            
            libraryGrid.appendChild(itemElement);
        });
    }
    
    function playLibraryItem(item, parentItem = null) {
        console.log(`Đang phát: ${item.title}`);
        
        if (Array.isArray(item.songs)) {
            // Nếu item là playlist hoặc album
            playlist = [...item.songs];
            currentTrackIndex = 0;
            temporaryQueue = []; // Xóa queue tạm thời khi phát playlist mới
            playTrack(playlist[currentTrackIndex]);
            updateQueue();
            return;
        }

        // Nếu item là một bài hát đơn lẻ và có parentItem (từ playlist/album view)
        if (parentItem && parentItem.songs) {
            // Tìm index của bài hát được click trong playlist/album gốc
            const songIndex = parentItem.songs.findIndex(song => song.audioSrc === item.audioSrc);
            if (songIndex !== -1) {
                // Sắp xếp lại playlist để bài hát được click nằm đầu tiên
                const reorderedSongs = [
                    item,
                    ...parentItem.songs.slice(0, songIndex),
                    ...parentItem.songs.slice(songIndex + 1)
                ];
                
                // Cập nhật playlist và phát ngay lập tức
                playlist = reorderedSongs;
                currentTrackIndex = 0;
                temporaryQueue = []; // Xóa queue tạm thời
                playTrack(playlist[currentTrackIndex]);
                updateQueue();
                return;
            }
        }

        // Xử lý khi bài hát là một bài đơn lẻ
        if (!audioPlayer.src) {
            // Nếu chưa có bài hát nào đang phát
            playlist = [item];
            currentTrackIndex = 0;
            playTrack(item);
            updateQueue();
        } else {
            // Nếu đang có bài hát phát
            // Thêm bài hát hiện tại vào playlist nếu chưa có
            if (!playlist.some(song => song.audioSrc === item.audioSrc)) {
                playlist.push(item);
                currentTrackIndex = playlist.length - 1;
                playTrack(item);
                updateQueue();
            } else {
                // Nếu bài hát đã có trong playlist, chuyển đến và phát nó
                const existingIndex = playlist.findIndex(song => song.audioSrc === item.audioSrc);
                currentTrackIndex = existingIndex;
                playTrack(item);
                updateQueue();
            }
        }
    }
    
    function openLibraryItem(item) {
        const expandedPlaylist = document.getElementById('expandedPlaylist');
        const expandedPlaylistImg = document.getElementById('expandedPlaylistImg');
        const expandedPlaylistType = document.getElementById('expandedPlaylistType');
        const expandedPlaylistTitle = document.getElementById('expandedPlaylistTitle');
        const expandedPlaylistDescription = document.getElementById('expandedPlaylistDescription');
        const expandedPlaylistStats = document.getElementById('expandedPlaylistStats');
        const expandedPlaylistSongs = document.getElementById('expandedPlaylistSongs');
        const playlistPlayBtn = document.querySelector('.playlist-play-btn');
        
        // Cập nhật thông tin playlist/album
        expandedPlaylistImg.src = window.contextPath + item.img;
        expandedPlaylistType.textContent = item.type;
        expandedPlaylistTitle.textContent = item.title;
        expandedPlaylistDescription.textContent = item.description || 'No description available';
        
        // Xác định số lượng bài hát thực tế
        const songCount = item.songs ? item.songs.length : 0;
        
        // Cập nhật số lượng bài hát
        if (item.type === 'Playlist') {
            expandedPlaylistStats.textContent = `• ${songCount} ${songCount === 1 ? 'song' : 'songs'}`;
        } else {
            expandedPlaylistStats.textContent = `• Album • ${item.artist}`;
        }
        
        // Xóa danh sách bài hát cũ
        expandedPlaylistSongs.innerHTML = '';
        
        // Kiểm tra nếu không có bài hát
        if (!item.songs || item.songs.length === 0) {
            const emptyMessage = document.createElement('div');
            emptyMessage.className = 'empty-playlist-message';
            emptyMessage.style.cssText = `
                padding: 40px;
                text-align: center;
                color: #a8b2d1;
                font-size: 16px;
            `;
            emptyMessage.textContent = `This ${item.type.toLowerCase()} is empty`;
            expandedPlaylistSongs.appendChild(emptyMessage);
            
            // Vô hiệu hóa nút play
            playlistPlayBtn.disabled = true;
            playlistPlayBtn.style.opacity = '0.5';
            return;
        }
        
        // Kích hoạt nút play nếu có bài hát
        playlistPlayBtn.disabled = false;
        playlistPlayBtn.style.opacity = '1';
        
        // Tạo một mảng để lưu trữ các bài hát và thứ tự của chúng
        let songElements = [];
        let loadedCount = 0;
        
        // Thêm loading indicator
        const loadingIndicator = document.createElement('div');
        loadingIndicator.className = 'loading-indicator';
        loadingIndicator.style.cssText = `
            padding: 20px;
            text-align: center;
            color: #64ffda;
        `;
        loadingIndicator.textContent = 'Loading songs...';
        expandedPlaylistSongs.appendChild(loadingIndicator);
        
        // Thêm các bài hát vào danh sách
        item.songs.forEach((song, index) => {
            // Tạo audio element tạm thời để lấy duration
            const tempAudio = new Audio(window.contextPath + song.audioSrc);
            
            tempAudio.addEventListener('loadedmetadata', () => {
                const duration = formatTime(tempAudio.duration);
                const songElement = document.createElement('div');
                songElement.className = 'playlist-song-item';
                songElement.dataset.index = index;
                songElement.innerHTML = `
                    <div class="song-number">${index + 1}</div>
                    <div class="song-info">
                        <img src="${window.contextPath + song.img}" alt="${song.title}">
                        <div class="song-details">
                            <div class="song-title">${song.title}</div>
                            <div class="song-artist">${song.artist}</div>
                        </div>
                    </div>
                    <div class="song-album">${song.album}</div>
                    <div class="song-duration">${duration}</div>
                `;
                
                // Thêm sự kiện click cho bài hát với parentItem
                songElement.addEventListener('click', () => {
                    playLibraryItem(song, item);
                });
                
                // Thêm vào mảng tạm thời
                songElements[index] = songElement;
                loadedCount++;
                
                // Kiểm tra xem đã load hết các bài hát chưa
                if (loadedCount === item.songs.length) {
                    // Xóa loading indicator
                    loadingIndicator.remove();
                    
                    // Thêm các bài hát vào DOM theo đúng thứ tự
                    songElements.forEach(element => {
                        if (element) {
                            expandedPlaylistSongs.appendChild(element);
                        }
                    });
                }
            });

            // Thêm error handler để tránh trường hợp không load được audio
            tempAudio.addEventListener('error', () => {
                loadedCount++;
                console.error(`Error loading audio for song: ${song.title}`);
                
                // Vẫn tạo element nhưng với duration là 0:00
                const songElement = document.createElement('div');
                songElement.className = 'playlist-song-item';
                songElement.dataset.index = index;
                songElement.innerHTML = `
                    <div class="song-number">${index + 1}</div>
                    <div class="song-info">
                        <img src="${window.contextPath + song.img}" alt="${song.title}">
                        <div class="song-details">
                            <div class="song-title">${song.title}</div>
                            <div class="song-artist">${song.artist}</div>
                        </div>
                    </div>
                    <div class="song-album">${song.album}</div>
                    <div class="song-duration">0:00</div>
                `;
                
                songElement.addEventListener('click', () => {
                    playLibraryItem(song, item);
                });
                
                songElements[index] = songElement;
                
                if (loadedCount === item.songs.length) {
                    loadingIndicator.remove();
                    songElements.forEach(element => {
                        if (element) {
                            expandedPlaylistSongs.appendChild(element);
                        }
                    });
                }
            });
        });
        
        // Thêm sự kiện cho nút play
        playlistPlayBtn.addEventListener('click', () => {
            if (item.songs && item.songs.length > 0) {
                playLibraryItem(item);
            } else {
                showNotification('This playlist/album is empty');
            }
        });
        
        // Hiển thị expanded view
        expandedPlaylist.classList.add('active');
        
        // Thêm sự kiện cho nút đóng
        const closeBtn = document.getElementById('expandedPlaylistClose');
        closeBtn.addEventListener('click', () => {
            expandedPlaylist.classList.remove('active');
        });
    }
    
    // Khởi tạo trình phát nhạc
    function initMusicPlayer() {
        // Các phần tử DOM
        const playPauseBtn = document.getElementById("playPauseBtn");
        const playPauseIcon = playPauseBtn.querySelector("i");
        const prevBtn = document.getElementById("prevBtn");
        const nextBtn = document.getElementById("nextBtn");
        const shuffleBtn = document.getElementById("shuffleBtn");
        const repeatBtn = document.getElementById("repeatBtn");
        const progressBar = document.getElementById("progressBar");
        const progress = document.getElementById("progress");
        const currentTimeEl = document.getElementById("currentTime");
        const totalTimeEl = document.getElementById("totalTime");
        const volumeBtn = document.getElementById("volumeBtn");
        const volumeIcon = volumeBtn.querySelector("i");
        const volumeBar = document.getElementById("volumeBar");
        const volumeLevel = document.getElementById("volumeLevel");
        const queueBtn = document.getElementById("queueBtn");
        const queuePanel = document.getElementById("queuePanel");
        const queueCloseBtn = document.getElementById("queueCloseBtn");
        const expandBtn = document.getElementById("expandBtn");
        const expandedPlayer = document.getElementById("expandedPlayer");
        const expandedCloseBtn = document.getElementById("expandedCloseBtn");
        const expandedPlayBtn = document.getElementById("expandedPlayBtn");
        const expandedPlayIcon = expandedPlayBtn.querySelector("i");
        const expandedProgressBar = document.getElementById("expandedProgressBar");
        const expandedVolumeBar = document.getElementById("expandedVolumeBar");
        
        // Sự kiện cho nút phát/tạm dừng
        playPauseBtn.addEventListener("click", togglePlayPause);
        expandedPlayBtn.addEventListener("click", togglePlayPause);
        
        // Sự kiện cho nút trước/sau
        prevBtn.addEventListener("click", playPreviousTrack);
        nextBtn.addEventListener("click", playNextTrack);
        document.getElementById("expandedPrevBtn").addEventListener("click", playPreviousTrack);
        document.getElementById("expandedNextBtn").addEventListener("click", playNextTrack);
        
        // Sự kiện cho nút xáo trộn/lặp lại
        shuffleBtn.addEventListener("click", toggleShuffle);
        repeatBtn.addEventListener("click", toggleRepeat);
        document.getElementById("expandedShuffleBtn").addEventListener("click", toggleShuffle);
        document.getElementById("expandedRepeatBtn").addEventListener("click", toggleRepeat);
        
        // Sự kiện cho thanh tiến trình
        progressBar.addEventListener("mousedown", startDragging);
        expandedProgressBar.addEventListener("mousedown", startDragging);
        
        // Thêm sự kiện click cho thanh tiến trình
        progressBar.addEventListener("click", handleProgressBarClick);
        expandedProgressBar.addEventListener("click", handleProgressBarClick);
        
        // Sự kiện cho điều khiển âm lượng
        volumeBtn.addEventListener("click", toggleMute);
        document.getElementById("expandedVolumeBtn").addEventListener("click", toggleMute);
        volumeBar.addEventListener("mousedown", startVolumeDragging);
        expandedVolumeBar.addEventListener("mousedown", startVolumeDragging);
        
        // Thêm sự kiện click cho thanh âm lượng
        volumeBar.addEventListener("click", handleVolumeBarClick);
        expandedVolumeBar.addEventListener("click", handleVolumeBarClick);
        
        // Sự kiện cho bảng điều khiển hàng đợi
        queueBtn.addEventListener("click", toggleQueuePanel);
        queueCloseBtn.addEventListener("click", closeQueuePanel);
        
        // Sự kiện cho trình phát mở rộng
        expandBtn.addEventListener("click", openExpandedPlayer);
        expandedCloseBtn.addEventListener("click", closeExpandedPlayer);
        
        // Sự kiện cho trình phát âm thanh
        audioPlayer.addEventListener("timeupdate", updateProgress);
        audioPlayer.addEventListener("ended", handleTrackEnd);
        audioPlayer.addEventListener("loadedmetadata", updateDuration);
        
        // Thêm sự kiện mousemove và mouseup cho toàn bộ document
        document.addEventListener("mousemove", handleDragging);
        document.addEventListener("mousemove", handleVolumeDragging);
        document.addEventListener("mouseup", stopDragging);
        document.addEventListener("mouseup", stopVolumeDragging);
        
        // Đặt âm lượng ban đầu
        audioPlayer.volume = 0.7;
    }
    
    // Phát một bài hát
    function playTrack(song) {
        if (!song) return;
        
        // Cập nhật thông tin bài hát hiện tại
        updateCurrentTrackInfo(song);
        
        // Đặt nguồn âm thanh và phát ngay lập tức
        audioPlayer.src = window.contextPath + song.audioSrc;
        audioPlayer.load();
        
        const playPromise = audioPlayer.play();
        if (playPromise !== undefined) {
            playPromise
                .then(() => {
                    isPlaying = true;
                    updatePlayPauseIcons();
                })
                .catch(error => {
                    console.error("Lỗi khi phát âm thanh:", error);
                    // Thử phát lại sau 100ms
                    setTimeout(() => {
                        audioPlayer.play()
                            .then(() => {
                                isPlaying = true;
                                updatePlayPauseIcons();
                            })
                            .catch(err => console.error("Lỗi khi thử phát lại:", err));
                    }, 100);
                });
        }
        
        // Cập nhật queue ngay lập tức
        updateQueue();
    }
    
    // Cập nhật thông tin bài hát hiện tại
    function updateCurrentTrackInfo(track) {
        document.getElementById("currentSongImg").src = window.contextPath + track.img;
        document.getElementById("currentSongTitle").textContent = track.title;
        document.getElementById("currentSongArtist").textContent = track.artist;
        
        // Cập nhật trình phát mở rộng
        document.getElementById("expandedImg").src = window.contextPath + track.img;
        document.getElementById("expandedTitle").textContent = track.title;
        document.getElementById("expandedArtist").textContent = track.artist;
        
        // Cập nhật tiêu đề tài liệu
        document.title = `${track.title} - ${track.artist} | MTP-2K`;
    }
    
    // Chuyển đổi phát/tạm dừng
    function togglePlayPause() {
        if (!audioPlayer.src && playlist.length > 0) {
            playTrack(playlist[currentTrackIndex]);
            return;
        }
        
        if (isPlaying) {
            audioPlayer.pause();
            isPlaying = false;
        } else {
            audioPlayer.play()
                .then(() => {
                    isPlaying = true;
                    updatePlayPauseIcons();
                })
                .catch(error => {
                    console.error("Lỗi khi phát âm thanh:", error);
                });
        }
        
        updatePlayPauseIcons();
    }
    
    // Cập nhật biểu tượng phát/tạm dừng
    function updatePlayPauseIcons() {
        const playPauseIcon = document.querySelector('#playPauseBtn i');
        const expandedPlayIcon = document.querySelector('#expandedPlayBtn i');
        
        if (isPlaying) {
            playPauseIcon.className = "fas fa-pause";
            expandedPlayIcon.className = "fas fa-pause";
        } else {
            playPauseIcon.className = "fas fa-play";
            expandedPlayIcon.className = "fas fa-play";
        }
    }
    
    // Phát bài hát trước đó
    function playPreviousTrack() {
        if (playlist.length === 0) return;
        
        // Nếu bài hát hiện tại đã phát hơn 3 giây, bắt đầu lại
        if (audioPlayer.currentTime > 3) {
            audioPlayer.currentTime = 0;
            return;
        }
        
        // Lấy bài hát trước đó
        currentTrackIndex = (currentTrackIndex - 1 + playlist.length) % playlist.length;
        playTrack(playlist[currentTrackIndex]);
        updateQueue(); // Cập nhật queue khi chuyển bài
    }
    
    // Phát bài hát tiếp theo
    function playNextTrack() {
        if (playlist.length === 0) return;
        
        // Lấy bài hát tiếp theo
        currentTrackIndex = (currentTrackIndex + 1) % playlist.length;
        playTrack(playlist[currentTrackIndex]);
        updateQueue(); // Cập nhật queue khi chuyển bài
    }
    
    // Chuyển đổi xáo trộn
    function toggleShuffle() {
        const shuffleBtn = document.getElementById("shuffleBtn");
        const expandedShuffleBtn = document.getElementById("expandedShuffleBtn");
        
        shuffleBtn.classList.toggle("active");
        expandedShuffleBtn.classList.toggle("active");
        
        // Trong ứng dụng thực tế, bạn sẽ xáo trộn danh sách phát ở đây
    }
    
    // Chuyển đổi lặp lại
    function toggleRepeat() {
        const repeatBtn = document.getElementById("repeatBtn");
        const expandedRepeatBtn = document.getElementById("expandedRepeatBtn");
        
        // Chuyển đổi giữa các chế độ lặp lại: không lặp lại, lặp lại một, lặp lại tất cả
        if (!repeatBtn.classList.contains("active")) {
            // Chuyển sang lặp lại một
            repeatBtn.classList.add("active");
            expandedRepeatBtn.classList.add("active");
            repeatBtn.innerHTML = '<i class="fas fa-redo"></i><span class="repeat-one">1</span>';
            expandedRepeatBtn.innerHTML = '<i class="fas fa-redo"></i><span class="repeat-one">1</span>';
        } else if (repeatBtn.querySelector(".repeat-one")) {
            // Chuyển sang lặp lại tất cả
            repeatBtn.innerHTML = '<i class="fas fa-redo"></i>';
            expandedRepeatBtn.innerHTML = '<i class="fas fa-redo"></i>';
        } else {
            // Chuyển sang không lặp lại
            repeatBtn.classList.remove("active");
            expandedRepeatBtn.classList.remove("active");
            repeatBtn.innerHTML = '<i class="fas fa-redo"></i>';
            expandedRepeatBtn.innerHTML = '<i class="fas fa-redo"></i>';
        }
    }
    
    // Cập nhật tiến trình
    function updateProgress() {
        const currentTime = audioPlayer.currentTime;
        const duration = audioPlayer.duration || 1; // Tránh chia cho 0
        const percentage = (currentTime / duration) * 100;
        
        // Cập nhật thanh tiến trình
        document.getElementById("progress").style.width = `${percentage}%`;
        document.getElementById("expandedProgress").style.width = `${percentage}%`;
        
        // Cập nhật hiển thị thời gian
        document.getElementById("currentTime").textContent = formatTime(currentTime);
        document.getElementById("expandedCurrentTime").textContent = formatTime(currentTime);
    }
    
    // Cập nhật thời lượng
    function updateDuration() {
        const duration = audioPlayer.duration;
        document.getElementById("totalTime").textContent = formatTime(duration);
        document.getElementById("expandedTotalTime").textContent = formatTime(duration);
    }
    
    // Tìm kiếm đến vị trí
    function seekToPosition(event) {
        const progressBar = event.currentTarget;
        const rect = progressBar.getBoundingClientRect();
        const offsetX = Math.max(0, Math.min(event.clientX - rect.left, rect.width));
        const percentage = offsetX / rect.width;
        
        // Cập nhật vị trí âm thanh
        audioPlayer.currentTime = percentage * audioPlayer.duration;
        
        // Cập nhật thanh tiến trình
        document.getElementById("progress").style.width = `${percentage * 100}%`;
        document.getElementById("expandedProgress").style.width = `${percentage * 100}%`;
    }
    
    // Thay đổi âm lượng
    function changeVolume(event) {
        const volumeBar = event.currentTarget;
        const rect = volumeBar.getBoundingClientRect();
        const offsetX = Math.max(0, Math.min(event.clientX - rect.left, rect.width));
        const percentage = offsetX / rect.width;
        
        // Cập nhật âm lượng
        audioPlayer.volume = percentage;
        
        // Cập nhật giao diện người dùng
        document.getElementById("volumeLevel").style.width = `${percentage * 100}%`;
        document.getElementById("expandedVolumeLevel").style.width = `${percentage * 100}%`;
        
        // Cập nhật biểu tượng âm lượng
        updateVolumeIcon(percentage);
    }
    
    // Cập nhật biểu tượng âm lượng
    function updateVolumeIcon(volume) {
        const volumeIcon = document.querySelector('#volumeBtn i');
        const expandedVolumeIcon = document.querySelector('#expandedVolumeBtn i');
        
        if (volume === 0 || audioPlayer.muted) {
            volumeIcon.className = "fas fa-volume-mute";
            expandedVolumeIcon.className = "fas fa-volume-mute";
        } else if (volume < 0.5) {
            volumeIcon.className = "fas fa-volume-down";
            expandedVolumeIcon.className = "fas fa-volume-down";
        } else {
            volumeIcon.className = "fas fa-volume-up";
            expandedVolumeIcon.className = "fas fa-volume-up";
        }
    }
    
    // Chuyển đổi tắt tiếng
    function toggleMute() {
        audioPlayer.muted = !audioPlayer.muted;
        
        // Cập nhật biểu tượng âm lượng
        const volumeIcon = document.querySelector('#volumeBtn i');
        const expandedVolumeIcon = document.querySelector('#expandedVolumeBtn i');
        
        if (audioPlayer.muted) {
            volumeIcon.className = "fas fa-volume-mute";
            expandedVolumeIcon.className = "fas fa-volume-mute";
            // Cập nhật thanh âm lượng khi tắt tiếng
            document.getElementById("volumeLevel").style.width = "0%";
            document.getElementById("expandedVolumeLevel").style.width = "0%";
        } else {
            // Khôi phục âm lượng và thanh âm lượng
            const volume = audioPlayer.volume;
            document.getElementById("volumeLevel").style.width = `${volume * 100}%`;
            document.getElementById("expandedVolumeLevel").style.width = `${volume * 100}%`;
            updateVolumeIcon(volume);
        }
    }
    
    // Xử lý kết thúc bài hát
    function handleTrackEnd() {
        const repeatBtn = document.getElementById("repeatBtn");
        
        if (repeatBtn.querySelector(".repeat-one")) {
            // Lặp lại một
            audioPlayer.currentTime = 0;
            audioPlayer.play()
                .catch(error => {
                    console.error("Lỗi khi phát âm thanh:", error);
                });
            updateQueue(); // Cập nhật queue
        } else if (repeatBtn.classList.contains("active")) {
            // Lặp lại tất cả
            playNextTrack();
            updateQueue(); // Cập nhật queue
        } else {
            // Lưu bài hát hiện tại
            const currentSong = playlist[currentTrackIndex];
            
            if (currentTrackIndex < playlist.length - 1) {
                // Nếu còn bài hát tiếp theo trong playlist
                // Di chuyển bài hát hiện tại xuống cuối playlist
                playlist.splice(currentTrackIndex, 1); // Xóa bài hát hiện tại khỏi vị trí hiện tại
                playlist.push(currentSong); // Thêm vào cuối playlist
                
                // Không cần điều chỉnh currentTrackIndex vì bài hát đã bị xóa
                playTrack(playlist[currentTrackIndex]);
                updateQueue(); // Cập nhật queue
            } else if (temporaryQueue.length > 0) {
                // Nếu còn bài hát trong queue tạm thời
                // Di chuyển bài hát hiện tại xuống cuối playlist
                playlist.splice(currentTrackIndex, 1); // Xóa bài hát hiện tại khỏi vị trí hiện tại
                playlist.push(currentSong); // Thêm vào cuối playlist
                
                // Thêm bài hát từ queue tạm thời vào playlist
                const nextSong = temporaryQueue.shift();
                playlist.push(nextSong);
                currentTrackIndex = playlist.length - 2; // Trỏ đến bài hát mới thêm vào
                playTrack(nextSong);
                updateQueue(); // Cập nhật queue
            } else {
                // Nếu không còn bài hát nào trong cả playlist và queue tạm thời
                // Di chuyển bài hát hiện tại xuống cuối và bắt đầu lại từ đầu
                playlist.splice(currentTrackIndex, 1);
                playlist.push(currentSong);
                currentTrackIndex = 0;
                playTrack(playlist[currentTrackIndex]);
                updateQueue(); // Cập nhật queue
            }
        }
    }
    
    // Chuyển đổi bảng điều khiển hàng đợi
    function toggleQueuePanel() {
        const queuePanel = document.getElementById("queuePanel");
        if (queuePanel.style.right === "0px" || queuePanel.classList.contains("active")) {
            queuePanel.style.right = "-320px";
            queuePanel.classList.remove("active");
        } else {
            queuePanel.style.right = "0px";
            queuePanel.classList.add("active");
        }
    }
    
    // Đóng bảng điều khiển hàng đợi
    function closeQueuePanel() {
        const queuePanel = document.getElementById("queuePanel");
        queuePanel.style.right = "-320px";
        queuePanel.classList.remove("active");
    }
    
    // Mở trình phát mở rộng
    function openExpandedPlayer() {
        const expandedPlayer = document.getElementById("expandedPlayer");
        expandedPlayer.style.display = "flex";
        expandedPlayer.classList.add("active");
    }
    
    // Đóng trình phát mở rộng
    function closeExpandedPlayer() {
        const expandedPlayer = document.getElementById("expandedPlayer");
        expandedPlayer.style.display = "none";
        expandedPlayer.classList.remove("active");
    }
    
    // Cập nhật hàng đợi
    function updateQueue() {
        const queueContent = document.getElementById("queueContent");
        const nowPlayingQueue = document.getElementById("nowPlayingQueue");
        
        // Xóa nội dung hiện tại
        queueContent.innerHTML = "";
        nowPlayingQueue.innerHTML = "";
        
        // Hiển thị bài hát đang phát
        if (playlist.length > 0) {
            const currentSong = playlist[currentTrackIndex];
            
            const nowPlayingItem = document.createElement("div");
            nowPlayingItem.className = "queue-item active";
            nowPlayingItem.innerHTML = `
                <i class="fas fa-volume-up queue-now-playing"></i>
                <div class="queue-item-img">
                    <img src="${window.contextPath + currentSong.img}" alt="${currentSong.title}">
                </div>
                <div class="queue-item-info">
                    <div class="queue-item-title">${currentSong.title}</div>
                    <div class="queue-item-artist">${currentSong.artist}</div>
                </div>
                <div class="queue-item-duration">${currentSong.duration || "0:00"}</div>
            `;
            
            nowPlayingQueue.appendChild(nowPlayingItem);
            
            // Hiển thị các bài hát tiếp theo trong playlist hiện tại
            for (let i = currentTrackIndex + 1; i < playlist.length; i++) {
                const song = playlist[i];
                addSongToQueueUI(song, queueContent, i);
            }

            // Hiển thị các bài hát đã phát (trước bài hát hiện tại)
            if (currentTrackIndex > 0) {
                for (let i = 0; i < currentTrackIndex; i++) {
                    const song = playlist[i];
                    addSongToQueueUI(song, queueContent, i);
                }
            }
            
            // Hiển thị các bài hát trong queue tạm thời
            if (temporaryQueue.length > 0) {
                // Thêm divider cho queue tạm thời
                const divider = document.createElement("div");
                divider.className = "queue-divider";
                divider.textContent = "Bài hát đã thêm";
                divider.style.cssText = `
                    padding: 16px;
                    color: #64ffda;
                    font-size: 14px;
                    font-weight: 600;
                    border-top: 1px solid rgba(100, 255, 218, 0.1);
                    border-bottom: 1px solid rgba(100, 255, 218, 0.1);
                `;
                queueContent.appendChild(divider);
                
                temporaryQueue.forEach((song, index) => {
                    addSongToQueueUI(song, queueContent, playlist.length + index);
                });
            }
        }
    }
    
    function addSongToQueueUI(song, container, index) {
        const queueItem = document.createElement("div");
        queueItem.className = "queue-item";
        queueItem.innerHTML = `
            <div class="queue-item-img">
                <img src="${window.contextPath + song.img}" alt="${song.title}">
            </div>
            <div class="queue-item-info">
                <div class="queue-item-title">${song.title}</div>
                <div class="queue-item-artist">${song.artist}</div>
            </div>
            <div class="queue-item-duration">${song.duration || "0:00"}</div>
        `;
        
        // Thêm sự kiện nhấp chuột để phát bài hát
        queueItem.addEventListener("click", () => {
            if (index < playlist.length) {
                // Nếu bài hát trong playlist hiện tại
                currentTrackIndex = index;
                playTrack(playlist[index]);
            } else {
                // Nếu bài hát trong queue tạm thời
                const tempIndex = index - playlist.length;
                const song = temporaryQueue[tempIndex];
                
                // Thêm bài hát vào cuối playlist hiện tại và phát
                playlist.push(song);
                currentTrackIndex = playlist.length - 1;
                
                // Xóa bài hát khỏi queue tạm thời
                temporaryQueue.splice(tempIndex, 1);
                
                playTrack(song);
            }
        });
        
        container.appendChild(queueItem);
    }
    
    // Định dạng thời gian
    function formatTime(seconds) {
        const minutes = Math.floor(seconds / 60);
        const secs = Math.floor(seconds % 60);
        return `${minutes}:${secs.toString().padStart(2, "0")}`;
    }
    
    // Khởi tạo thư viện với tất cả các mục
    filterLibraryItems('all');

    // Thêm các biến toàn cục cho việc kéo thả
    let isDragging = false;
    let isVolumeDragging = false;
    let dragStartX = 0;
    let dragStartWidth = 0;
    let dragStartTime = 0;
    let dragStartVolume = 0;
    let currentProgressBar = null;

    // Xử lý bắt đầu kéo thanh tiến trình
    function startDragging(event) {
        isDragging = true;
        currentProgressBar = event.currentTarget;
        const rect = currentProgressBar.getBoundingClientRect();
        dragStartX = event.clientX - rect.left;
        dragStartWidth = rect.width;
        dragStartTime = audioPlayer.currentTime;
        document.addEventListener('mousemove', handleDragging);
        document.addEventListener('mouseup', stopDragging);
    }

    // Xử lý bắt đầu kéo thanh âm lượng
    function startVolumeDragging(event) {
        isVolumeDragging = true;
        const volumeBar = event.currentTarget;
        const rect = volumeBar.getBoundingClientRect();
        dragStartX = event.clientX - rect.left;
        dragStartWidth = rect.width;
        dragStartVolume = audioPlayer.volume;
        document.addEventListener('mousemove', handleVolumeDragging);
        document.addEventListener('mouseup', stopVolumeDragging);
    }

    // Xử lý kéo thanh tiến trình
    function handleDragging(event) {
        if (!isDragging || !currentProgressBar) return;
        
        const rect = currentProgressBar.getBoundingClientRect();
        const currentX = event.clientX - rect.left;
        const percentage = Math.max(0, Math.min(1, currentX / dragStartWidth));
        
        // Cập nhật vị trí âm thanh
        audioPlayer.currentTime = percentage * audioPlayer.duration;
        
        // Cập nhật thanh tiến trình
        document.getElementById("progress").style.width = `${percentage * 100}%`;
        document.getElementById("expandedProgress").style.width = `${percentage * 100}%`;
        
        // Cập nhật tooltip
        const tooltip = currentProgressBar.querySelector('.progress-tooltip');
        if (tooltip) {
            tooltip.textContent = formatTime(percentage * audioPlayer.duration);
            tooltip.style.left = `${currentX}px`;
        }
    }

    // Xử lý kéo thanh âm lượng
    function handleVolumeDragging(event) {
        if (!isVolumeDragging) return;
        
        const volumeBar = event.target.closest('.volume-bar, .expanded-volume-bar');
        if (!volumeBar) return;
        
        const rect = volumeBar.getBoundingClientRect();
        const currentX = event.clientX - rect.left;
        const percentage = Math.max(0, Math.min(1, currentX / rect.width));
        
        // Cập nhật âm lượng
        audioPlayer.volume = percentage;
        
        // Cập nhật giao diện người dùng
        document.getElementById("volumeLevel").style.width = `${percentage * 100}%`;
        document.getElementById("expandedVolumeLevel").style.width = `${percentage * 100}%`;
        
        // Cập nhật tooltip
        updateVolumeTooltip(volumeBar, currentX, percentage);
        
        // Cập nhật biểu tượng âm lượng
        updateVolumeIcon(percentage);
    }

    // Dừng kéo thanh tiến trình
    function stopDragging() {
        isDragging = false;
        currentProgressBar = null;
        document.removeEventListener('mousemove', handleDragging);
        document.removeEventListener('mouseup', stopDragging);
    }

    // Dừng kéo thanh âm lượng
    function stopVolumeDragging() {
        isVolumeDragging = false;
        document.removeEventListener('mousemove', handleVolumeDragging);
        document.removeEventListener('mouseup', stopVolumeDragging);
    }

    // Thêm hàm xử lý click trực tiếp vào thanh tiến trình
    function handleProgressBarClick(event) {
        // Ngăn chặn sự kiện mousedown từ việc kích hoạt
        event.stopPropagation();
        
        const progressBar = event.currentTarget;
        const rect = progressBar.getBoundingClientRect();
        const offsetX = event.clientX - rect.left;
        const percentage = Math.max(0, Math.min(1, offsetX / rect.width));
        
        // Cập nhật vị trí âm thanh
        audioPlayer.currentTime = percentage * audioPlayer.duration;
        
        // Cập nhật thanh tiến trình
        document.getElementById("progress").style.width = `${percentage * 100}%`;
        document.getElementById("expandedProgress").style.width = `${percentage * 100}%`;
        
        // Cập nhật tooltip
        const tooltip = progressBar.querySelector('.progress-tooltip');
        if (tooltip) {
            tooltip.textContent = formatTime(percentage * audioPlayer.duration);
            tooltip.style.left = `${offsetX}px`;
        }
    }

    // Thêm hàm xử lý click trực tiếp vào thanh âm lượng
    function handleVolumeBarClick(event) {
        // Ngăn chặn sự kiện mousedown từ việc kích hoạt
        event.stopPropagation();
        
        const volumeBar = event.target.closest('.volume-bar, .expanded-volume-bar');
        if (!volumeBar) return;
        
        const rect = volumeBar.getBoundingClientRect();
        const offsetX = event.clientX - rect.left;
        const percentage = Math.max(0, Math.min(1, offsetX / rect.width));
        
        // Cập nhật âm lượng
        audioPlayer.volume = percentage;
        
        // Cập nhật giao diện người dùng
        document.getElementById("volumeLevel").style.width = `${percentage * 100}%`;
        document.getElementById("expandedVolumeLevel").style.width = `${percentage * 100}%`;
        
        // Cập nhật tooltip
        updateVolumeTooltip(volumeBar, offsetX, percentage);
        
        // Cập nhật biểu tượng âm lượng
        updateVolumeIcon(percentage);
    }

    // Thêm hàm mới để cập nhật tooltip âm lượng
    function updateVolumeTooltip(volumeBar, xPosition, percentage) {
        let tooltip;
        if (volumeBar.classList.contains('volume-bar')) {
            tooltip = document.getElementById('volumeTooltip');
        } else {
            tooltip = document.getElementById('expandedVolumeTooltip');
        }
        
        if (tooltip) {
            tooltip.textContent = `${Math.round(percentage * 100)}%`;
            tooltip.style.left = `${xPosition}px`;
        }
    }

    // Thêm event listener cho các bài hát trong Recently Played
    const activityItems = document.querySelectorAll('.activity-item');
    activityItems.forEach((item, index) => {
        item.addEventListener('click', () => {
            const title = item.querySelector('.activity-title').textContent;
            const artist = item.querySelector('.activity-subtitle').textContent;
            const imgSrc = item.querySelector('img').src;
            
            // Tìm bài hát tương ứng trong sampleSongs
            const song = sampleSongs.find(s => s.title === title && s.artist === artist);
            
            if (song) {
                // Phát bài hát
                playLibraryItem(song);
            }
        });
    });

    function addToQueue(song) {
        // Kiểm tra xem bài hát đã có trong queue hoặc playlist chưa
        const isInQueue = temporaryQueue.some(item => item.audioSrc === song.audioSrc);
        const isInCurrentPlaylist = playlist.some(item => item.audioSrc === song.audioSrc);
        
        // Chỉ thêm vào queue nếu bài hát có audioSrc khác và chưa có trong cả queue và playlist
        if (!isInQueue && !isInCurrentPlaylist) {
            temporaryQueue.push(song);
            updateQueue();
        }
    }

    function showNotification(message) {
        // Tạo phần tử thông báo
        const notification = document.createElement('div');
        notification.className = 'notification';
        notification.textContent = message;
        notification.style.cssText = `
            position: fixed;
            bottom: 100px;
            right: 20px;
            background-color: #64ffda;
            color: #0a192f;
            padding: 12px 24px;
            border-radius: 4px;
            z-index: 1000;
            animation: fadeInOut 3s ease;
        `;
        
        // Thêm keyframes animation vào head
        if (!document.querySelector('#notification-style')) {
            const style = document.createElement('style');
            style.id = 'notification-style';
            style.textContent = `
                @keyframes fadeInOut {
                    0% { opacity: 0; transform: translateY(20px); }
                    10% { opacity: 1; transform: translateY(0); }
                    90% { opacity: 1; transform: translateY(0); }
                    100% { opacity: 0; transform: translateY(-20px); }
                }
            `;
            document.head.appendChild(style);
        }
        
        document.body.appendChild(notification);
        
        // Xóa thông báo sau 3 giây
        setTimeout(() => {
            notification.remove();
        }, 3000);
    }
});
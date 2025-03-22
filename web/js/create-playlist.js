
// Global variables
let selectedSongs = []
let searchResults = []
let isPlaying = false
let isMuted = false
let previousVolume = 70
let currentTrackIndex = 0
let currentTrackTime = 0
let isShuffled = false
let repeatMode = 0 // 0: no repeat, 1: repeat one, 2: repeat all
let playlist = [...sampleQueueSongs]
let queue = []
let isDraggingProgress = false
let isDraggingVolume = false
let isExpandedPlayerActive = false
let audioPlayer // Reference to the audio element
let isPreviewMode = false

// DOM Elements
document.addEventListener("DOMContentLoaded", () => {
  // Playlist Form
  const playlistNameInput = document.getElementById("playlistName")
  const playlistDescriptionInput = document.getElementById("playlistDescription")
  const saveBtn = document.getElementById("saveBtn")
  const cancelBtn = document.getElementById("cancelBtn")

  // Search
  const searchInput = document.getElementById("searchInput")
  const searchResultsContainer = document.getElementById("searchResults")

  // Selected Songs
  const selectedSongsContainer = document.getElementById("selectedSongsContainer")
  const emptyState = document.getElementById("emptyState")
  const selectedSongsList = document.getElementById("selectedSongsList")
  const selectedSongsBody = document.getElementById("selectedSongs")
  const clearAllBtn = document.getElementById("clearAllBtn")

  // Player Controls
  const playPauseBtn = document.getElementById("playPauseBtn")
  const playPauseIcon = playPauseBtn.querySelector("i")
  const progressBar = document.getElementById("progressBar")
  const progress = document.getElementById("progress")
  const progressHandle = document.querySelector(".progress-handle")
  const progressTooltip = document.getElementById("progressTooltip")
  const currentTimeEl = document.getElementById("currentTime")
  const totalTimeEl = document.getElementById("totalTime")
  const volumeBar = document.getElementById("volumeBar")
  const volumeLevel = document.getElementById("volumeLevel")
  const volumeHandle = document.querySelector(".volume-handle")
  const volumeTooltip = document.getElementById("volumeTooltip")
  const volumeBtn = document.getElementById("volumeBtn")
  const volumeIcon = volumeBtn.querySelector("i")
  const shuffleBtn = document.getElementById("shuffleBtn")
  const repeatBtn = document.getElementById("repeatBtn")
  const prevBtn = document.getElementById("prevBtn")
  const nextBtn = document.getElementById("nextBtn")
  const currentSongImg = document.getElementById("currentSongImg")
  const currentSongTitle = document.getElementById("currentSongTitle")
  const currentSongArtist = document.getElementById("currentSongArtist")
  const nowPlayingImg = document.getElementById("nowPlayingImg")
  const expandBtn = document.getElementById("expandBtn")

  // Queue Panel
  const queueBtn = document.getElementById("queueBtn")
  const queuePanel = document.getElementById("queuePanel")
  const queueCloseBtn = document.getElementById("queueCloseBtn")
  const queueContent = document.getElementById("queueContent")
  const nowPlayingQueue = document.getElementById("nowPlayingQueue")

  // Expanded Player
  const expandedPlayer = document.getElementById("expandedPlayer")
  const expandedCloseBtn = document.getElementById("expandedCloseBtn")
  const expandedImg = document.getElementById("expandedImg")
  const expandedTitle = document.getElementById("expandedTitle")
  const expandedArtist = document.getElementById("expandedArtist")
  const expandedProgressBar = document.getElementById("expandedProgressBar")
  const expandedProgress = document.getElementById("expandedProgress")
  const expandedProgressHandle = document.querySelector(".expanded-progress-handle")
  const expandedProgressTooltip = document.getElementById("expandedProgressTooltip")
  const expandedCurrentTime = document.getElementById("expandedCurrentTime")
  const expandedTotalTime = document.getElementById("expandedTotalTime")
  const expandedPlayBtn = document.getElementById("expandedPlayBtn")
  const expandedPlayIcon = expandedPlayBtn.querySelector("i")
  const expandedShuffleBtn = document.getElementById("expandedShuffleBtn")
  const expandedRepeatBtn = document.getElementById("expandedRepeatBtn")
  const expandedPrevBtn = document.getElementById("expandedPrevBtn")
  const expandedNextBtn = document.getElementById("expandedNextBtn")
  const expandedVolumeBtn = document.getElementById("expandedVolumeBtn")
  const expandedVolumeIcon = expandedVolumeBtn.querySelector("i")
  const expandedVolumeBar = document.getElementById("expandedVolumeBar")
  const expandedVolumeLevel = document.getElementById("expandedVolumeLevel")

  // Audio Player
  audioPlayer = document.getElementById("audioPlayer")

  // Initialize
  init()

  // Functions
  function init() {
    // Set up initial playlist with sample queue data ONLY
    playlist = [...sampleQueueSongs]
    
    // Initialize song durations
    initializeSongDurations()

    // Set up event listeners
    searchInput.addEventListener("input", handleSearch)

    clearAllBtn.addEventListener("click", clearAllSelectedSongs)

    saveBtn.addEventListener("click", savePlaylist)
    cancelBtn.addEventListener("click", () => (window.location.href = "home"))

    // Player controls
    playPauseBtn.addEventListener("click", togglePlayPause)
    expandedPlayBtn.addEventListener("click", togglePlayPause)

    // Progress bar
    initProgressControl()

    // Volume controls
    initVolumeControl()

    // Track navigation
    prevBtn.addEventListener("click", playPreviousTrack)
    expandedPrevBtn.addEventListener("click", playPreviousTrack)
    nextBtn.addEventListener("click", playNextTrack)
    expandedNextBtn.addEventListener("click", playNextTrack)

    // Shuffle and repeat
    shuffleBtn.addEventListener("click", toggleShuffle)
    expandedShuffleBtn.addEventListener("click", toggleShuffle)
    repeatBtn.addEventListener("click", toggleRepeat)
    expandedRepeatBtn.addEventListener("click", toggleRepeat)

    // Queue panel
    queueBtn.addEventListener("click", toggleQueuePanel)
    queueCloseBtn.addEventListener("click", closeQueuePanel)

    // Expanded player
    expandBtn.addEventListener("click", openExpandedPlayer)
    expandedCloseBtn.addEventListener("click", closeExpandedPlayer)
    nowPlayingImg.addEventListener("click", openExpandedPlayer)

    // Keyboard shortcuts
    document.addEventListener("keydown", handleKeyboardShortcuts)

    // Populate initial search results
    populateSearchResults(sampleSearchSongs)

    // Set initial track from queue if available
    if (playlist.length > 0) {
      updateCurrentTrackInfo(playlist[currentTrackIndex])
    }

    // Set initial volume
    updateVolumeUI(previousVolume)

    // Audio player event listeners
    setupAudioEventListeners()
  }

  function setupAudioEventListeners() {
    // When audio metadata is loaded (duration, etc.)
    audioPlayer.addEventListener("loadedmetadata", () => {
      const duration = audioPlayer.duration
      const formattedDuration = formatTime(duration)
      totalTimeEl.textContent = formattedDuration
      expandedTotalTime.textContent = formattedDuration
    })

    // When audio time updates during playback
    audioPlayer.addEventListener("timeupdate", () => {
      if (!isDraggingProgress) {
        const currentTime = audioPlayer.currentTime
        const duration = audioPlayer.duration || 1 // Prevent division by zero
        const percentage = (currentTime / duration) * 100

        // Update progress bars
        progress.style.width = `${percentage}%`
        expandedProgress.style.width = `${percentage}%`

        // Update time displays
        currentTimeEl.textContent = formatTime(currentTime)
        expandedCurrentTime.textContent = formatTime(currentTime)

        // Store current time
        currentTrackTime = currentTime
      }
    })

    // When audio playback ends
    audioPlayer.addEventListener("ended", () => {
      handleTrackEnd()
    })

    // Set initial volume
    audioPlayer.volume = previousVolume / 100
  }

  function handleKeyboardShortcuts(event) {
    // Only handle shortcuts if not in an input field
    if (event.target.tagName === "INPUT" || event.target.tagName === "TEXTAREA") {
      return
    }

    switch (event.key) {
      case " ": // Space bar for play/pause
        event.preventDefault()
        togglePlayPause()
        break
      case "ArrowRight": // Right arrow for next track
        if (event.ctrlKey) {
          event.preventDefault()
          playNextTrack()
        }
        break
      case "ArrowLeft": // Left arrow for previous track
        if (event.ctrlKey) {
          event.preventDefault()
          playPreviousTrack()
        }
        break
      case "m": // M for mute/unmute
        event.preventDefault()
        toggleMute()
        break
      case "f": // F for fullscreen
        event.preventDefault()
        isExpandedPlayerActive ? closeExpandedPlayer() : openExpandedPlayer()
        break
    }
  }

  function handleSearch(event) {
    const searchTerm = event.target.value.toLowerCase()
    if (searchTerm.length === 0) {
      populateSearchResults(sampleSearchSongs)
      return
    }

    const filteredSongs = sampleSearchSongs.filter(
      (song) =>
        song.title.toLowerCase().includes(searchTerm) ||
        song.artist.toLowerCase().includes(searchTerm) ||
        song.album.toLowerCase().includes(searchTerm)
    )

    populateSearchResults(filteredSongs)
  }

  // Add this function to get audio duration
  async function getAudioDuration(audioSrc) {
    return new Promise((resolve) => {
        try {
            const audio = new Audio(window.contextPath + audioSrc)
            
            const errorHandler = () => {
                console.error('Error loading audio:', audioSrc)
                resolve('0:00')
                audio.remove()
            }

            const loadHandler = () => {
                try {
                    const duration = formatTime(audio.duration)
                    resolve(duration)
                } catch (err) {
                    console.error('Error getting duration:', err)
                    resolve('0:00')
                } finally {
                    audio.remove()
                }
            }

            audio.addEventListener('loadedmetadata', loadHandler)
            audio.addEventListener('error', errorHandler)
            
            // Set a timeout in case the audio load hangs
            setTimeout(() => {
                errorHandler()
            }, 5000)
        } catch (err) {
            console.error('Error creating audio element:', err)
            resolve('0:00')
        }
    })
  }

  // Initialize function to update all sample songs with actual durations
  async function initializeSongDurations() {
    // Update search songs
    for (const song of sampleSearchSongs) {
      song.duration = await getAudioDuration(song.audioSrc)
    }
    
    // Update queue songs
    for (const song of sampleQueueSongs) {
      song.duration = await getAudioDuration(song.audioSrc)
    }
    
    // Update initial display
    updateQueue()
    populateSearchResults(sampleSearchSongs)
  }

  async function createSongRow(song, index, isSelected) {
    const row = document.createElement("tr")
    row.className = "song-row"

    const numberCell = document.createElement("td")
    numberCell.className = "song-number"
    numberCell.textContent = index

    const titleCell = document.createElement("td")
    const songInfo = document.createElement("div")
    songInfo.className = "song-info"

    const songImg = document.createElement("div")
    songImg.className = "song-img"
    const img = document.createElement("img")
    img.src = window.contextPath + song.img
    img.alt = song.title
    songImg.appendChild(img)

    const songDetails = document.createElement("div")
    songDetails.className = "song-details"
    const songTitle = document.createElement("div")
    songTitle.className = "song-title"
    songTitle.textContent = song.title
    const songArtist = document.createElement("div")
    songArtist.className = "song-artist"
    songArtist.textContent = song.artist

    songDetails.appendChild(songTitle)
    songDetails.appendChild(songArtist)

    songInfo.appendChild(songImg)
    songInfo.appendChild(songDetails)
    titleCell.appendChild(songInfo)

    const albumCell = document.createElement("td")
    albumCell.className = "song-album"
    albumCell.textContent = song.album

    const durationCell = document.createElement("td")
    durationCell.className = "song-duration"
    durationCell.dataset.songId = song.id
    
    // Get and set the actual duration
    const duration = await getAudioDuration(song.audioSrc)
    durationCell.textContent = duration
    song.duration = duration // Update the song object

    const actionsCell = document.createElement("td")
    actionsCell.className = "song-actions"
    const actionBtn = document.createElement("button")
    actionBtn.className = `song-action-btn ${isSelected ? "active" : ""}`
    actionBtn.innerHTML = isSelected ? '<i class="fas fa-check"></i>' : '<i class="fas fa-plus"></i>'

    actionBtn.addEventListener("click", () => {
      if (isSelected) {
        removeSongFromSelection(song)
      } else {
        addSongToSelection(song)
      }
    })

    actionsCell.appendChild(actionBtn)

    row.appendChild(numberCell)
    row.appendChild(titleCell)
    row.appendChild(albumCell)
    row.appendChild(durationCell)
    row.appendChild(actionsCell)

    // Add click event to preview the song
    titleCell.addEventListener("click", () => {
      previewTrack(song)
    })

    return row
  }

  async function populateSearchResults(songs) {
    searchResults = songs
    searchResultsContainer.innerHTML = ""

    // Use for...of instead of forEach for async operations
    for (let i = 0; i < songs.length; i++) {
      const song = songs[i]
      const isSelected = selectedSongs.some((s) => s.id === song.id)
      const row = await createSongRow(song, i + 1, isSelected)
      searchResultsContainer.appendChild(row)
    }
  }

  function addSongToSelection(song) {
    if (!selectedSongs.some((s) => s.id === song.id)) {
      selectedSongs.push(song)
      updateSelectedSongsList()
      populateSearchResults(searchResults) // Refresh search results to update buttons
    }
  }

  function removeSongFromSelection(song) {
    selectedSongs = selectedSongs.filter((s) => s.id !== song.id)
    updateSelectedSongsList()
    populateSearchResults(searchResults) // Refresh search results to update buttons
  }

  async function updateSelectedSongsList() {
    if (selectedSongs.length === 0) {
      emptyState.style.display = "flex"
      selectedSongsList.style.display = "none"
      return
    }

    emptyState.style.display = "none"
    selectedSongsList.style.display = "table"
    selectedSongsBody.innerHTML = ""

    for (let i = 0; i < selectedSongs.length; i++) {
      const song = selectedSongs[i]
      const row = await createSongRow(song, i + 1, true)
      selectedSongsBody.appendChild(row)
    }
  }

  function clearAllSelectedSongs() {
    selectedSongs = []
    updateSelectedSongsList()
    populateSearchResults(searchResults)
  }

  function savePlaylist() {
    const playlistName = playlistNameInput.value.trim()
    if (!playlistName) {
        alert("Please enter a playlist name")
        return
    }

    if (selectedSongs.length === 0) {
        alert("Please add at least one song to your playlist")
        return
    }

    const playlistData = {
        name: playlistName,
        description: playlistDescriptionInput.value.trim(),
        songs: selectedSongs,
    }

    // In a real application, you would send this data to the server
    console.log("Playlist data:", playlistData)
    alert("Playlist created successfully!")

    // Redirect to the library page
    window.location.href = "library"
  }

  // Player functionality
  function playTrack(song) {
    if (!song) return
    
    isPreviewMode = false

    // Update current track info
    updateCurrentTrackInfo(song)

    // Set audio source and play
    audioPlayer.src = window.contextPath + song.audioSrc
    audioPlayer.load()
    audioPlayer.play()
        .then(() => {
            isPlaying = true
            playPauseIcon.className = "fas fa-pause"
            expandedPlayIcon.className = "fas fa-pause"
        })
        .catch(error => {
            console.error("Error playing audio:", error)
        })

    // Update queue
    updateQueue()
  }

  function updateCurrentTrackInfo(track) {
    currentSongImg.src = window.contextPath + track.img
    currentSongTitle.textContent = track.title
    currentSongArtist.textContent = track.artist

    // Update expanded player
    expandedImg.src = window.contextPath + track.img
    expandedTitle.textContent = track.title
    expandedArtist.textContent = track.artist

    // Update document title
    document.title = `${track.title} - ${track.artist} | MTP-2K`
  }

  async function updateNowPlayingQueue(track) {
    nowPlayingQueue.innerHTML = ""

    // Get actual duration
    const duration = await getAudioDuration(track.audioSrc)
    track.duration = duration

    const queueItem = document.createElement("div")
    queueItem.className = "queue-item active"

    queueItem.innerHTML = `
            <i class="fas fa-volume-up queue-now-playing"></i>
            <div class="queue-item-img">
                <img src="${window.contextPath + track.img}" alt="${track.title}">
            </div>
            <div class="queue-item-info">
                <div class="queue-item-title">${track.title}</div>
                <div class="queue-item-artist">${track.artist}</div>
            </div>
            <div class="queue-item-duration">${duration}</div>
        `

    nowPlayingQueue.appendChild(queueItem)
  }

  function togglePlayPause() {
    if (!audioPlayer.src) {
      // If no track is loaded and we have a playlist, play the first track from queue
      if (playlist.length > 0 && !isPreviewMode) {
        playTrack(playlist[currentTrackIndex])
      }
      return
    }

    if (isPlaying) {
      audioPlayer.pause()
      isPlaying = false
      playPauseIcon.className = "fas fa-play"
      expandedPlayIcon.className = "fas fa-play"
    } else {
      audioPlayer.play()
        .then(() => {
          isPlaying = true
          playPauseIcon.className = "fas fa-pause"
          expandedPlayIcon.className = "fas fa-pause"
        })
        .catch(error => {
          console.error("Error playing audio:", error)
        })
    }
  }

  function initProgressControl() {
    // Progress bar mouse events
    progressBar.addEventListener("mousedown", startDraggingProgress)
    expandedProgressBar.addEventListener("mousedown", startDraggingExpandedProgress)
    document.addEventListener("mousemove", handleDragging)
    document.addEventListener("mouseup", stopDragging)

    // Progress bar hover events for tooltip
    progressBar.addEventListener("mousemove", updateProgressTooltip)
    expandedProgressBar.addEventListener("mousemove", updateExpandedProgressTooltip)

    // Click events for instant seeking
    progressBar.addEventListener("click", seekToPosition)
    expandedProgressBar.addEventListener("click", seekToExpandedPosition)
  }

  function startDraggingProgress(event) {
    isDraggingProgress = true
    updateProgressPosition(event)
    event.preventDefault() // Prevent text selection during drag
  }

  function startDraggingExpandedProgress(event) {
    isDraggingProgress = true
    updateExpandedProgressPosition(event)
    event.preventDefault() // Prevent text selection during drag
  }

  function handleDragging(event) {
    if (isDraggingProgress) {
      updateProgressPosition(event)
    } else if (isDraggingVolume) {
      const target = event.target.closest('.volume-bar') ? 'normal' : 'expanded'
      if (target === 'normal') {
        updateVolumePosition(event)
      } else {
        updateExpandedVolumePosition(event)
      }
    }
  }

  function stopDragging() {
    if (isDraggingVolume) {
        volumeBar.classList.remove("active")
        expandedVolumeBar.classList.remove("active")
    }
    isDraggingVolume = false
    isDraggingProgress = false
  }

  function updateProgressTooltip(event) {
    if (!audioPlayer.duration) return

    const rect = progressBar.getBoundingClientRect()
    const offsetX = Math.max(0, Math.min(event.clientX - rect.left, rect.width))
    const percentage = offsetX / rect.width

    // Update tooltip position
    progressTooltip.style.left = `${offsetX}px`

    // Update tooltip content
    const tooltipTime = Math.floor(percentage * audioPlayer.duration)
    progressTooltip.textContent = formatTime(tooltipTime)
  }

  function updateExpandedProgressTooltip(event) {
    if (!audioPlayer.duration) return

    const rect = expandedProgressBar.getBoundingClientRect()
    const offsetX = Math.max(0, Math.min(event.clientX - rect.left, rect.width))
    const percentage = offsetX / rect.width

    // Update tooltip position
    expandedProgressTooltip.style.left = `${offsetX}px`

    // Update tooltip content
    const tooltipTime = Math.floor(percentage * audioPlayer.duration)
    expandedProgressTooltip.textContent = formatTime(tooltipTime)
  }

  function updateProgressPosition(event) {
    if (!isDraggingProgress || !audioPlayer.duration) return

    const rect = progressBar.getBoundingClientRect()
    const offsetX = Math.max(0, Math.min(event.clientX - rect.left, rect.width))
    const percentage = offsetX / rect.width

    // Update progress bar
    progress.style.width = `${percentage * 100}%`
    expandedProgress.style.width = `${percentage * 100}%`

    // Update time display
    const newTime = Math.floor(percentage * audioPlayer.duration)
    currentTrackTime = newTime
    currentTimeEl.textContent = formatTime(newTime)
    expandedCurrentTime.textContent = formatTime(newTime)

    // Update audio position
    audioPlayer.currentTime = newTime
  }

  function updateExpandedProgressPosition(event) {
    if (!isDraggingProgress || !audioPlayer.duration) return

    const rect = expandedProgressBar.getBoundingClientRect()
    const offsetX = Math.max(0, Math.min(event.clientX - rect.left, rect.width))
    const percentage = offsetX / rect.width

    // Update progress bar
    progress.style.width = `${percentage * 100}%`
    expandedProgress.style.width = `${percentage * 100}%`

    // Update time display
    const newTime = Math.floor(percentage * audioPlayer.duration)
    currentTrackTime = newTime
    currentTimeEl.textContent = formatTime(newTime)
    expandedCurrentTime.textContent = formatTime(newTime)

    // Update audio position
    audioPlayer.currentTime = newTime
  }

  function seekToPosition(event) {
    if (!audioPlayer.duration) return

    const rect = progressBar.getBoundingClientRect()
    const offsetX = Math.max(0, Math.min(event.clientX - rect.left, rect.width))
    const percentage = offsetX / rect.width

    // Update progress bar
    progress.style.width = `${percentage * 100}%`
    expandedProgress.style.width = `${percentage * 100}%`

    // Update time display
    const newTime = Math.floor(percentage * audioPlayer.duration)
    currentTrackTime = newTime
    currentTimeEl.textContent = formatTime(newTime)
    expandedCurrentTime.textContent = formatTime(newTime)

    // Update audio position
    audioPlayer.currentTime = newTime
  }

  function seekToExpandedPosition(event) {
    if (!audioPlayer.duration) return

    const rect = expandedProgressBar.getBoundingClientRect()
    const offsetX = Math.max(0, Math.min(event.clientX - rect.left, rect.width))
    const percentage = offsetX / rect.width

    // Update progress bar
    progress.style.width = `${percentage * 100}%`
    expandedProgress.style.width = `${percentage * 100}%`

    // Update time display
    const newTime = Math.floor(percentage * audioPlayer.duration)
    currentTrackTime = newTime
    currentTimeEl.textContent = formatTime(newTime)
    expandedCurrentTime.textContent = formatTime(newTime)

    // Update audio position
    audioPlayer.currentTime = newTime
  }

  function initVolumeControl() {
    // Set initial volume
    audioPlayer.volume = previousVolume / 100;
    updateVolumeUI(previousVolume);

    // Volume control events
    volumeBtn.addEventListener("click", toggleMute);
    expandedVolumeBtn.addEventListener("click", toggleMute);
    
    // Volume bar events
    volumeBar.addEventListener("mousedown", startDraggingVolume);
    expandedVolumeBar.addEventListener("mousedown", startDraggingExpandedVolume);
    
    // Global mouse events
    document.addEventListener("mousemove", handleDragging);
    document.addEventListener("mouseup", stopDragging);

    // Volume hover events for tooltip
    volumeBar.addEventListener("mousemove", updateVolumeTooltip);
    expandedVolumeBar.addEventListener("mousemove", updateExpandedVolumeTooltip);

    // Click events for instant volume change
    volumeBar.addEventListener("click", changeVolume);
    expandedVolumeBar.addEventListener("click", changeExpandedVolume);
  }

  function startDraggingVolume(event) {
    isDraggingVolume = true
    volumeBar.classList.add("active")
    updateVolumePosition(event)
    event.preventDefault()
  }

  function startDraggingExpandedVolume(event) {
    isDraggingVolume = true
    expandedVolumeBar.classList.add("active")
    updateExpandedVolumePosition(event)
    event.preventDefault()
  }

  function updateVolumeTooltip(event) {
    const rect = volumeBar.getBoundingClientRect()
    const offsetX = Math.max(0, Math.min(event.clientX - rect.left, rect.width))
    const percentage = Math.round((offsetX / rect.width) * 100)

    volumeTooltip.textContent = `${percentage}%`
    volumeTooltip.style.left = `${offsetX}px`
  }

  function updateExpandedVolumeTooltip(event) {
    const rect = expandedVolumeBar.getBoundingClientRect()
    const offsetX = Math.max(0, Math.min(event.clientX - rect.left, rect.width))
    const percentage = Math.round((offsetX / rect.width) * 100)

    expandedVolumeTooltip.textContent = `${percentage}%`
    expandedVolumeTooltip.style.left = `${offsetX}px`
  }

  function updateVolumePosition(event) {
    if (!isDraggingVolume) return

    const rect = volumeBar.getBoundingClientRect()
    const offsetX = Math.max(0, Math.min(event.clientX - rect.left, rect.width))
    const percentage = Math.round((offsetX / rect.width) * 100)

    updateVolumeUI(percentage)
    audioPlayer.volume = percentage / 100

    if (isMuted && percentage > 0) {
        isMuted = false
        audioPlayer.muted = false
    }
  }

  function updateExpandedVolumePosition(event) {
    if (!isDraggingVolume) return

    const rect = expandedVolumeBar.getBoundingClientRect()
    const offsetX = Math.max(0, Math.min(event.clientX - rect.left, rect.width))
    const percentage = Math.round((offsetX / rect.width) * 100)

    updateVolumeUI(percentage)
    audioPlayer.volume = percentage / 100

    if (isMuted && percentage > 0) {
        isMuted = false
        audioPlayer.muted = false
    }
  }

  function changeVolume(event) {
    const rect = volumeBar.getBoundingClientRect()
    const offsetX = Math.max(0, Math.min(event.clientX - rect.left, rect.width))
    const percentage = Math.round((offsetX / rect.width) * 100)

    updateVolumeUI(percentage)
    audioPlayer.volume = percentage / 100

    if (isMuted && percentage > 0) {
        isMuted = false
        audioPlayer.muted = false
    }
  }

  function changeExpandedVolume(event) {
    const rect = expandedVolumeBar.getBoundingClientRect()
    const offsetX = Math.max(0, Math.min(event.clientX - rect.left, rect.width))
    const percentage = Math.round((offsetX / rect.width) * 100)

    updateVolumeUI(percentage)
    audioPlayer.volume = percentage / 100

    if (isMuted && percentage > 0) {
        isMuted = false
        audioPlayer.muted = false
    }
  }

  function updateVolumeUI(volumePercentage) {
    // Update volume levels
    volumeLevel.style.width = `${volumePercentage}%`;
    expandedVolumeLevel.style.width = `${volumePercentage}%`;

    // Update tooltips
    volumeTooltip.textContent = `${volumePercentage}%`;
    expandedVolumeTooltip.textContent = `${volumePercentage}%`;

    // Update volume icons based on volume percentage and mute state
    if (isMuted || volumePercentage === 0) {
        volumeIcon.className = "fas fa-volume-mute";
        expandedVolumeIcon.className = "fas fa-volume-mute";
    } else if (volumePercentage < 30) {
        volumeIcon.className = "fas fa-volume-off";
        expandedVolumeIcon.className = "fas fa-volume-off";
    } else if (volumePercentage < 70) {
        volumeIcon.className = "fas fa-volume-down";
        expandedVolumeIcon.className = "fas fa-volume-down";
    } else {
        volumeIcon.className = "fas fa-volume-up";
        expandedVolumeIcon.className = "fas fa-volume-up";
    }
  }

  function toggleMute() {
    if (isMuted) {
        // Unmuting - restore previous volume
        isMuted = false;
        audioPlayer.muted = false;
        audioPlayer.volume = previousVolume / 100;
        updateVolumeUI(previousVolume);
    } else {
        // Muting - store current volume and set to 0
        isMuted = true;
        audioPlayer.muted = true;
        previousVolume = Math.round(audioPlayer.volume * 100);
        updateVolumeUI(0);
    }
  }

  function toggleShuffle() {
    isShuffled = !isShuffled
    shuffleBtn.classList.toggle("active", isShuffled)
    expandedShuffleBtn.classList.toggle("active", isShuffled)

    // Update queue if shuffle is toggled
    updateQueue()
  }

  function toggleRepeat() {
    repeatMode = (repeatMode + 1) % 3 // Cycle through 0, 1, 2

    // Update UI based on repeat mode
    switch (repeatMode) {
      case 0: // No repeat
        repeatBtn.classList.remove("active")
        repeatBtn.innerHTML = '<i class="fas fa-redo"></i>'
        expandedRepeatBtn.classList.remove("active")
        expandedRepeatBtn.innerHTML = '<i class="fas fa-redo"></i>'
        break
      case 1: // Repeat one
        repeatBtn.classList.add("active")
        repeatBtn.innerHTML = '<i class="fas fa-redo"></i><span class="repeat-one">1</span>'
        expandedRepeatBtn.classList.add("active")
        expandedRepeatBtn.innerHTML = '<i class="fas fa-redo"></i><span class="repeat-one">1</span>'
        break
      case 2: // Repeat all
        repeatBtn.classList.add("active")
        repeatBtn.innerHTML = '<i class="fas fa-redo"></i>'
        expandedRepeatBtn.classList.add("active")
        expandedRepeatBtn.innerHTML = '<i class="fas fa-redo"></i>'
        break
    }
  }

  function playPreviousTrack() {
    if (playlist.length === 0) return

    // If current track has played for more than 3 seconds, restart it
    if (audioPlayer.currentTime > 3) {
      audioPlayer.currentTime = 0
      return
    }

    // Get the previous track based on the original playlist order
    let prevIndex
    if (isShuffled) {
      // In shuffle mode, generate a random previous track
      prevIndex = Math.floor(Math.random() * playlist.length)
    } else {
      // In normal mode, get the actual previous track
      prevIndex = (currentTrackIndex - 1 + playlist.length) % playlist.length
    }

    currentTrackIndex = prevIndex
    const prevTrack = playlist[prevIndex]

    // Update queue to reflect the change
    queue = [
      prevTrack,
      ...queue
    ]
    
    playTrack(prevTrack)
  }

  function playNextTrack() {
    if (playlist.length === 0 || queue.length <= 1) return

    // Get the next track from the queue
    queue.shift() // Remove current track from queue
    const nextTrack = queue[0] // Get the next track
    
    if (nextTrack) {
      // Find the track index in the original playlist
      currentTrackIndex = playlist.findIndex(track => track.id === nextTrack.id)
      playTrack(nextTrack)
    }
  }

  function toggleQueuePanel() {
    queuePanel.classList.toggle("active")
    queueBtn.classList.toggle("active")
  }

  function closeQueuePanel() {
    queuePanel.classList.remove("active")
    queueBtn.classList.remove("active")
  }

  async function updateQueue() {
    // Clear current queue
    queueContent.innerHTML = ""

    // Create a copy of the playlist for the queue
    if (isShuffled) {
      // If shuffled, create a randomized queue excluding current track
      queue = [...playlist]
      const currentTrack = queue.splice(currentTrackIndex, 1)[0] // Remove current track
      
      // Fisher-Yates shuffle algorithm
      for (let i = queue.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1))
        [queue[i], queue[j]] = [queue[j], queue[i]]
      }
      
      // Add current track back at the beginning
      queue.unshift(currentTrack)
    } else {
      // If not shuffled, maintain playlist order starting from current track
      queue = [
        ...playlist.slice(currentTrackIndex), // Songs from current to end
        ...playlist.slice(0, currentTrackIndex) // Songs from start to current
      ]
    }

    try {
        // Update now playing in queue
        if (queue[0]) {
            const currentDuration = await getAudioDuration(queue[0].audioSrc)
            queue[0].duration = currentDuration
            await updateNowPlayingQueue(queue[0])
        }

        // Populate queue (skip the first item as it's the current track)
        for (const track of queue.slice(1)) {
            const queueItem = document.createElement("div")
            queueItem.className = "queue-item"

            // Get actual duration for each track
            const duration = await getAudioDuration(track.audioSrc)
            
            // Add temporary indicator if the track is temporary
            const temporaryClass = track.isTemporary ? "temporary-track" : ""
            
            queueItem.innerHTML = `
                <div class="queue-item-img">
                    <img src="${window.contextPath + track.img}" alt="${track.title}">
                </div>
                <div class="queue-item-info ${temporaryClass}">
                    <div class="queue-item-title">${track.title}</div>
                    <div class="queue-item-artist">${track.artist}</div>
                </div>
                <div class="queue-item-duration">${duration}</div>
            `

            queueItem.addEventListener("click", () => {
                // Find the track in the queue and update currentTrackIndex
                const trackIndex = playlist.findIndex(t => t.id === track.id)
                if (trackIndex !== -1) {
                    currentTrackIndex = trackIndex
                    playTrack(playlist[currentTrackIndex])
                }
            })

            queueContent.appendChild(queueItem)
        }
    } catch (error) {
        console.error("Error updating queue:", error)
    }
  }

  function openExpandedPlayer() {
    expandedPlayer.classList.add("active")
    isExpandedPlayerActive = true
  }

  function closeExpandedPlayer() {
    expandedPlayer.classList.remove("active")
    isExpandedPlayerActive = false
  }

  function handleTrackEnd() {
    if (isPreviewMode) {
      // Remove temporary tracks when they finish playing
      if (playlist[currentTrackIndex]?.isTemporary) {
        playlist.splice(currentTrackIndex, 1)
        // Adjust currentTrackIndex if necessary
        if (currentTrackIndex >= playlist.length) {
          currentTrackIndex = 0
        }
      }
      isPreviewMode = false
    }

    // Handle queue playback
    switch (repeatMode) {
      case 0: // No repeat
        if (queue.length > 1) {
          playNextTrack()
        } else {
          isPlaying = false
          playPauseIcon.className = "fas fa-play"
          expandedPlayIcon.className = "fas fa-play"
        }
        break
      case 1: // Repeat one
        audioPlayer.currentTime = 0
        audioPlayer.play()
          .then(() => {
            isPlaying = true
          })
          .catch(error => {
            console.error("Error playing audio:", error)
          })
        break
      case 2: // Repeat all
        if (queue.length > 1) {
          playNextTrack()
        } else {
          currentTrackIndex = 0
          queue = [...playlist]
          playTrack(playlist[0])
        }
        break
    }
  }

  function formatTime(seconds) {
    const minutes = Math.floor(seconds / 60)
    const secs = Math.floor(seconds % 60)
    return `${minutes}:${secs.toString().padStart(2, "0")}`
  }

  function previewTrack(song) {
    // Add song temporarily to queue if not already in playlist
    if (!playlist.some(track => track.audioSrc === song.audioSrc)) {
      // Create a temporary version of the song
      const tempSong = {
        ...song,
        isTemporary: true // Mark as temporary
      }
      
      // Add to beginning of playlist after current track
      playlist.splice(currentTrackIndex + 1, 0, tempSong)
      
      // Update currentTrackIndex to point to the new song
      currentTrackIndex++
      
      // Update the queue
      updateQueue()
    } else {
      // If song is already in playlist, find its index
      currentTrackIndex = playlist.findIndex(track => track.audioSrc === song.audioSrc)
    }

    // Play the track
    playTrack(song)
  }
})

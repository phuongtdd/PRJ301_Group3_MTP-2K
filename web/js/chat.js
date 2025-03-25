document.addEventListener('DOMContentLoaded', function () {
    const chatIcon = document.getElementById('chat-icon');
    const chatBox = document.getElementById('chat-box');
    const chatMessages = document.getElementById('chat-messages');
    const chatInput = document.getElementById('chat-input');
    const sendButton = document.getElementById('send-button');
    const closeButton = document.getElementById('close-button');
    
    // Speech synthesis variables
    let speechSynthesis = window.speechSynthesis;
    let isSpeechEnabled = false;
    let currentUtterance = null;

    // Create voice toggle and stop buttons
    const voiceControlsDiv = document.createElement('div');
    voiceControlsDiv.className = 'voice-controls';
    
    const voiceToggleButton = document.createElement('button');
    voiceToggleButton.id = 'voice-toggle';
    voiceToggleButton.innerHTML = '<i class="fas fa-volume-mute"></i>';
    voiceToggleButton.title = 'Enable voice responses';
    
    const stopSpeechButton = document.createElement('button');
    stopSpeechButton.id = 'stop-speech';
    stopSpeechButton.innerHTML = '<i class="fas fa-stop"></i>';
    stopSpeechButton.title = 'Stop speaking';
    stopSpeechButton.style.display = 'none';
    
    voiceControlsDiv.appendChild(voiceToggleButton);
    voiceControlsDiv.appendChild(stopSpeechButton);
    
    // Insert voice controls next to close button
    const chatHeader = document.querySelector('.chat-header');
    chatHeader.insertBefore(voiceControlsDiv, closeButton);

    // Toggle voice responses
    voiceToggleButton.addEventListener('click', function() {
        isSpeechEnabled = !isSpeechEnabled;
        if (isSpeechEnabled) {
            voiceToggleButton.innerHTML = '<i class="fas fa-volume-up"></i>';
            voiceToggleButton.title = 'Disable voice responses';
        } else {
            voiceToggleButton.innerHTML = '<i class="fas fa-volume-mute"></i>';
            voiceToggleButton.title = 'Enable voice responses';
            stopSpeech();
        }
    });
    
    // Stop speech button
    stopSpeechButton.addEventListener('click', stopSpeech);

    // Function to stop current speech
    function stopSpeech() {
        if (speechSynthesis && currentUtterance) {
            speechSynthesis.cancel();
            currentUtterance = null;
            stopSpeechButton.style.display = 'none';
        }
    }
    
    // Function to speak text
    function speakText(text) {
        if (!isSpeechEnabled || !speechSynthesis) return;
        
        // Stop any current speech
        stopSpeech();
        
        // Create a new utterance
        currentUtterance = new SpeechSynthesisUtterance(text);
        
        // Set language to Vietnamese
        currentUtterance.lang = 'vi-VN';
        
        // Show stop button when speaking starts
        stopSpeechButton.style.display = 'inline-block';
        
        // Hide stop button when speaking ends
        currentUtterance.onend = function() {
            stopSpeechButton.style.display = 'none';
            currentUtterance = null;
        };
        
        // Speak the text
        speechSynthesis.speak(currentUtterance);
    }

    // Toggle chat box visibility
    chatIcon.addEventListener('click', function () {
        chatBox.classList.toggle('hidden');
        if (!chatBox.classList.contains('hidden')) {
            chatInput.focus();
        }
    });

    // Close chat box
    closeButton.addEventListener('click', function () {
        chatBox.classList.add('hidden');
        stopSpeech(); // Stop any speech when closing chat
    });

    // Send message on button click
    sendButton.addEventListener('click', sendMessage);

    // Send message on Enter key
    chatInput.addEventListener('keypress', function (e) {
        if (e.key === 'Enter') {
            sendMessage();
        }
    });

    function sendMessage() {
        const message = chatInput.value.trim();
        if (message === '')
            return;

        // Add user message to chat
        addMessage('user', message);
        chatInput.value = '';

        // Add loading indicator
        const loadingElement = document.createElement('div');
        loadingElement.className = 'message ai-message loading';
        loadingElement.innerHTML = '<div class="message-content"><div class="typing-indicator"><span></span><span></span><span></span></div></div>';
        chatMessages.appendChild(loadingElement);
        chatMessages.scrollTop = chatMessages.scrollHeight;

        // Get the context path from a hidden input or data attribute
        let contextPath = '';
        try {
            const metaTag = document.querySelector('meta[name="contextPath"]');
            if (metaTag) {
                contextPath = metaTag.getAttribute('content') || '';
                console.log('Context path from meta tag:', contextPath);
            } else {
                console.warn('Context path meta tag not found');
            }
        } catch (e) {
            console.error('Error getting context path:', e);
        }

        // Log the full URL for debugging
        const url = contextPath + '/chat';
        console.log('Sending request to:', url);

        // Send message to server with full context path
        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'message=' + encodeURIComponent(message)
        })
                .then(response => {
                    console.log('Response status:', response.status);
                    if (!response.ok) {
                        throw new Error('Network response was not ok: ' + response.status);
                    }
                    return response.json();
                })
                .then(data => {
                    // Remove loading indicator
                    chatMessages.removeChild(loadingElement);

                    console.log('Received data:', data);
                    // Add AI response to chat
                    addMessage('ai', data.response);
                    
                    // Speak the AI response
                    speakText(data.response);
                })
                .catch(error => {
                    // Remove loading indicator
                    chatMessages.removeChild(loadingElement);

                    console.error('Fetch error:', error);
                    // Add error message
                    const errorMessage = 'Sorry, I encountered an error: ' + error.message;
                    addMessage('ai', errorMessage);
                    
                    // Speak the error message
                    speakText(errorMessage);
                });
    }

    function addMessage(sender, content) {
        const messageElement = document.createElement('div');
        messageElement.className = `message ${sender}-message`;
        messageElement.innerHTML = `<div class="message-content">${content}</div>`;
        chatMessages.appendChild(messageElement);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }
});
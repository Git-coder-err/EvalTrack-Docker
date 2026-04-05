// app.js - Core functionality for EvalTrack Static Frontend (Phase 2)

const APP_NAME = "EvalTrack";

// --- PROSPECTUS DATA (Updated strictly to prompt requirements) ---
// Keys are formatted simply for HTML value mapping.
const BSIT_PROSPECTUS = {
    // FIRST YEAR
    "1-1": [
        { code: "GE 4", desc: "Reading in Philippine History", prereq: "none" },
        { code: "GE 5", desc: "The Contemporary World", prereq: "none" },
        { code: "GE 11", desc: "Entrepreneurial Mind", prereq: "none" },
        { code: "GE 9", desc: "Life and Works of Rizal", prereq: "none" },
        { code: "GE 10", desc: "Environmental Science", prereq: "none" },
        { code: "CC 101", desc: "Introduction to Computing 1", prereq: "none" },
        { code: "CC 102", desc: "Computer Programming 1", prereq: "none" },
        { code: "PE 1", desc: "Physical Education", prereq: "none" },
        { code: "NSTP 1", desc: "National Service Training Program 1", prereq: "none" },
        { code: "SF 1", desc: "Student Formation 1", prereq: "none" }
    ],
    "1-2": [
        { code: "GE 1", desc: "Understanding the Self", prereq: "none" },
        { code: "GE 2", desc: "Mathematics in the Modern World", prereq: "none" },
        { code: "GE 3", desc: "Purposive Communication", prereq: "none" },
        { code: "CC 103", desc: "Introduction to Computing", prereq: "CC 102" },
        { code: "HCI 101", desc: "Computer Programming 1", prereq: "CC 101" }, // Note: desc from prompt 'Computer Programming 1' but code HCI
        { code: "MS 101 A", desc: "Discrete Mathematics 1", prereq: "none" },
        { code: "WEBDEV", desc: "Web Development", prereq: "none" },
        { code: "PE 2", desc: "Physical Education 2", prereq: "PE 1" },
        { code: "NSTP 2", desc: "National Service Training Program 2", prereq: "NSTP 1" },
        { code: "SF 2", desc: "Student Formation 2", prereq: "SF 1" }
    ],
    "summer-2": [
        { code: "GE 12", desc: "Great Books", prereq: "none" },
        { code: "GE 7", desc: "Science Technology and Society", prereq: "none" }
    ],
    // SECOND YEAR
    "2-1": [
        { code: "GE 6", desc: "Art Appreciation", prereq: "none" },
        { code: "GE 8", desc: "Ethics", prereq: "none" },
        { code: "MS 101 B", desc: "Discrete Mathematics 2", prereq: "MS 101 A" },
        { code: "PF 101", desc: "Object Oriented Programming", prereq: "CC 103" },
        { code: "CC 104", desc: "Data Structure and Algorithms", prereq: "CC 103" },
        { code: "PT 101", desc: "Platform Technologies", prereq: "CC 103" },
        { code: "IT ELECT 1", desc: "IT Elective 1", prereq: "2nd Year Standing" },
        { code: "PE 3", desc: "Physical Education 3", prereq: "PE 2" },
        { code: "SF 3", desc: "Student Formation 3", prereq: "SF 2" }
    ],
    "2-2": [
        { code: "CC 105", desc: "Information Management", prereq: "CC 104 & PF 101" },
        { code: "MS 102", desc: "Quantitative Methods (inci. Modeling & Simulation)", prereq: "MS 101 B" },
        { code: "NET 101", desc: "Networking 1", prereq: "PT 101" },
        { code: "IPT 101", desc: "Integrative Programming & Technology", prereq: "PF 101 & PT 101" },
        { code: "OS 101", desc: "Operating Systems", prereq: "CC 104 & PF 101" },
        { code: "IT ELECT 2", desc: "IT Elective 2", prereq: "2nd Year Standing" },
        { code: "PE 4", desc: "Physical Education 4", prereq: "PE 3" },
        { code: "SF 4", desc: "Student Formation 4", prereq: "SF 3" }
    ],
    // THIRD YEAR
    "3-1": [
        { code: "IM 101", desc: "Advance Database System", prereq: "CC 105" },
        { code: "NET 102", desc: "Networking 2", prereq: "NET 101" },
        { code: "SIA 101", desc: "System Integration and Architecture", prereq: "NET 101" },
        { code: "EDP 101", desc: "Event - Driven Programming", prereq: "CC 104" },
        { code: "IAS 101", desc: "Information Assurance And Security 1", prereq: "CC 105" },
        { code: "MAP 101", desc: "Mobile Application Development 1", prereq: "CC 104 & PF 101" },
        { code: "SAD 101", desc: "System Analysis And Design", prereq: "CC 105" },
        { code: "IT ELECT 3", desc: "IT Elective 3", prereq: "3rd Year Standing" },
        { code: "SF 5", desc: "Student Formation 5", prereq: "SF 4" }
    ],
    "3-2": [
        { code: "IAS 102", desc: "Information Assurance And Security 2", prereq: "IAS 101" },
        { code: "SP 101", desc: "Social Issues And Professional Practice", prereq: "3rd Year Standing" },
        { code: "CC 106", desc: "Application Development And Emerging Technologies", prereq: "IM 101" },
        { code: "MAP 102", desc: "Mobile Application Development 2", prereq: "MAP 101" },
        { code: "IT ELECT 4", desc: "IT Elective 4", prereq: "3rd Year Standing" }, // Changed 3 to 4 based on context
        { code: "TECHPRO", desc: "Technopreneurship", prereq: "3rd Year Standing" },
        { code: "PM 101", desc: "IT Project Management", prereq: "SAD 101" },
        { code: "SF 6", desc: "Student Formation 6", prereq: "SF 5" }
    ],
    "summer-4": [
        { code: "CAP 101", desc: "Capstone Project and Research 1", prereq: "4th Year Standing" }
    ],
    // FOURTH YEAR
    "4-1": [
        { code: "SA 101", desc: "System Administration And Maintenance", prereq: "IAS 102" },
        { code: "CAP 102", desc: "Capstone Project And Research 2", prereq: "CAP 101" },
        { code: "SWT 101", desc: "ICT Seminar & Workshop", prereq: "4th Year Standing" }
    ],
    "4-2": [
        { code: "PRAC 101", desc: "PRACTICUM (486 hours)", prereq: "4th Year Standing" },
        { code: "SF 8", desc: "Student Formation 8", prereq: "4th Year Standing" }
    ]
};

// Utilities
function generateSemesters() {
    let semesters = [];
    for (let y = 2003; y <= 2026; y++) {
        semesters.push(`${y} - 1 semester`);
        semesters.push(`${y} - 2 semester`);
        semesters.push(`${y} - summer`);
    }
    return semesters.reverse(); // Newest first
}

function getProspectusArray() {
    let all = [];
    Object.keys(BSIT_PROSPECTUS).forEach(k => {
        all = all.concat(BSIT_PROSPECTUS[k]);
    });
    return all;
}

// --- INITIALIZE LOCAL STORAGE ---
function initDB() {
    if (!localStorage.getItem('users')) {
        const defaultUsers = [
            { id: 'admin@jmc.edu.ph', name: 'Admin', email: 'admin@jmc.edu.ph', password: 'Admin', role: 'admin', status: 'Active' },
            { id: 'INS001', name: 'Jerwin Carreon', email: 'jerwin.carreon@jmc.edu.ph', password: 'password', role: 'instructor', status: 'Active' },
            { id: '20230001', name: 'Genesis G. Diaz', email: 'genesis.diaz@jmc.edu.ph', password: 'password', role: 'student', program: 'BSIT', type: 'regular', status: 'Active' }
        ];
        localStorage.setItem('users', JSON.stringify(defaultUsers));
    }

    if (!localStorage.getItem('evaluations')) {
        localStorage.setItem('evaluations', JSON.stringify([]));
    }

    if (!localStorage.getItem('messages')) {
        localStorage.setItem('messages', JSON.stringify([]));
    }
}

// --- AUTHENTICATION (DATABASE VERSION) ---
async function login(email, password) {
    const formData = new FormData();
    formData.append('email', email);
    formData.append('password', password);

    try {
        const response = await fetch('login.php', {
            method: 'POST',
            body: formData
        });

        if (!response.ok) {
            throw new Error(`Server error: ${response.statusText}`);
        }

        const result = await response.json();

        if (result.success) {
            sessionStorage.setItem('currentUser', JSON.stringify(result.user));

            if (result.user.must_change_password) {
                window.location.href = 'must_change_password.html';
            } else {
                const rolesMap = {
                    'admin': 'admin.html',
                    'instructor': 'instructor.html',
                    'student': 'student.html',
                    'dean': 'admin.html'
                };
                window.location.href = rolesMap[result.user.role] || 'login.html';
            }
            return { success: true, user: result.user };
        } else {
            return { success: false, message: result.message };
        }
    } catch (err) {
        console.error("Login Error:", err);
        return { success: false, message: 'Connection to server failed. Ensure XAMPP is running.' };
    }
}

function logout() {
    sessionStorage.removeItem('currentUser');
    window.location.href = 'login.html';
}

function checkAuth(allowedRoles) {
    const userStr = sessionStorage.getItem('currentUser');
    if (!userStr) {
        window.location.href = 'login.html';
        return null;
    }
    const user = JSON.parse(userStr);
    if (allowedRoles && !allowedRoles.includes(user.role)) {
        window.location.href = 'login.html';
        return null;
    }
    return user;
}

function updateHeaderUser(user) {
    const subEl = document.querySelector('.topbar .sub');
    if (subEl && user) {
        let roleDisplay = user.role.charAt(0).toUpperCase() + user.role.slice(1);
        if (user.role === 'instructor') roleDisplay = 'Instructor / Prg. Head';
        if (user.role === 'admin') roleDisplay = 'Dean / Admin';
        subEl.innerHTML = `${user.name} <span style="opacity:0.7; font-size:0.8rem; margin-left: 5px;">(${roleDisplay})</span>`;
    }
}

// --- CHATBOT UI SYSTEM ---
function openChatbot(title, introMessage) {
    console.log("Opening Chatbot:", title);
    let overlay = document.getElementById('chat-overlay');
    if (!overlay) {
        overlay = document.createElement('div');
        overlay.id = 'chat-overlay';
        overlay.style.cssText = 'position:fixed; inset:0; background:rgba(0,0,0,0.5); z-index:9998; display:none; align-items:center; justify-content:center; backdrop-filter:blur(3px);';

        const chatBox = document.createElement('div');
        chatBox.className = 'chat-modal';
        chatBox.style.cssText = 'background:#fff; width:90%; max-width:500px; border-radius:12px; box-shadow:0 10px 30px rgba(0,0,0,0.3); overflow:hidden; display:flex; flex-direction:column; animation:fadeInUp 0.3s ease; height: 600px;';

        chatBox.innerHTML = `
            <div style="background:#1b5e20; color:white; padding:15px 20px; display:flex; justify-content:space-between; align-items:center;">
                <h3 id="chat-title" style="margin:0; font-size:1.1rem; display:flex; align-items:center; gap:10px; color:#fff;"><i class="fa fa-robot"></i> AI Assistant</h3>
                <i class="fa fa-times" onclick="document.getElementById('chat-overlay').style.display='none'" style="cursor:pointer; font-size:1.2rem;"></i>
            </div>
            <div id="chat-messages" style="flex:1; padding:20px; overflow-y:auto; background:#f9f9f9; display:flex; flex-direction:column; gap:15px;"></div>
            <div style="padding:15px; background:white; border-top:1px solid #eee; display:flex; gap:10px;">
                <input type="text" id="chat-input-text" class="form-control" placeholder="Ask something..." style="flex:1; padding:10px 15px;">
                <button class="btn btn-primary" id="chat-send-btn" style="padding:10px 20px; background:#1b5e20; border:none;"><i class="fa fa-paper-plane"></i></button>
            </div>
        `;
        overlay.appendChild(chatBox);
        document.body.appendChild(overlay);

        document.getElementById('chat-send-btn').addEventListener('click', handleChatSend);
        document.getElementById('chat-input-text').addEventListener('keypress', (e) => { if (e.key === 'Enter') handleChatSend(); });
    }

    const titleEl = document.getElementById('chat-title');
    const msgArea = document.getElementById('chat-messages');

    if (titleEl) titleEl.innerHTML = `<i class="fa fa-robot"></i> ${title}`;
    if (msgArea) {
        msgArea.innerHTML = '';
        overlay.style.display = 'flex';
        addChatBubble(introMessage || "Hello! How can I help you today?", 'bot');
    }
}

function handleChatSend() {
    const input = document.getElementById('chat-input-text');
    const text = input.value.trim();
    if (!text) return;

    addChatBubble(text, 'user');
    input.value = '';

    const thinkingId = 'thinking-' + Date.now();
    addChatBubble("Thinking...", 'bot', thinkingId);

    const title = document.getElementById('chat-title').textContent.trim();

    fetch('ai_chat_handler.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ topic: title, query: text })
    })
        .then(res => res.json())
        .then(data => {
            const thinkingBubble = document.getElementById(thinkingId);
            if (thinkingBubble) {
                thinkingBubble.innerHTML = String(data.reply).replace(/\n/g, '<br>');
            }
        })
        .catch(err => {
            const thinkingBubble = document.getElementById(thinkingId);
            if (thinkingBubble) {
                thinkingBubble.innerHTML = "Connection error. Is XAMPP running?";
            }
        });
}

function addChatBubble(text, sender, id = null) {
    const msgs = document.getElementById('chat-messages');
    const wrapper = document.createElement('div');
    wrapper.style.display = 'flex';
    wrapper.style.justifyContent = sender === 'user' ? 'flex-end' : 'flex-start';

    const bubble = document.createElement('div');
    if (id) bubble.id = id;
    bubble.style.maxWidth = '80%';
    bubble.style.padding = '12px 16px';
    bubble.style.borderRadius = '15px';
    bubble.style.lineHeight = '1.4';
    bubble.style.fontSize = '0.9rem';

    if (sender === 'user') {
        bubble.style.background = 'var(--primary)';
        bubble.style.color = 'white';
        bubble.style.borderBottomRightRadius = '2px';
    } else {
        bubble.style.background = 'white';
        bubble.style.color = '#333';
        bubble.style.border = '1px solid #e1bee7';
        bubble.style.borderBottomLeftRadius = '2px';
        bubble.style.boxShadow = '0 2px 5px rgba(0,0,0,0.02)';
    }

    // Simple line break support
    if (!text) text = "No response from AI.";
    bubble.innerHTML = String(text).replace(/\n/g, '<br>');

    wrapper.appendChild(bubble);
    msgs.appendChild(wrapper);
    msgs.scrollTop = msgs.scrollHeight;
}


// --- TOAST NOTIFICATIONS ---
function showToast(message, type = 'info') {
    let container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toast-container';
        container.style.cssText = 'position:fixed; top:20px; right:20px; z-index:9999; display:flex; flex-direction:column; gap:10px;';
        document.body.appendChild(container);
    }
    const toast = document.createElement('div');
    const colors = { success: '#2d8f6b', error: '#c0392b', info: '#6a1b9a' };
    const icons = { success: 'fa-check-circle', error: 'fa-exclamation-circle', info: 'fa-info-circle' };

    toast.style.cssText = `
        background: rgba(255,255,255,0.95);
        border-left: 4px solid ${colors[type]};
        box-shadow: 0 4px 15px rgba(0,0,0,0.15);
        padding: 12px 20px;
        border-radius: 8px;
        color: #333;
        font-weight: 500;
        display: flex;
        align-items: center;
        gap: 10px;
        animation: slideInRight 0.3s ease, fadeOut 0.3s ease 2.7s forwards;
        backdrop-filter: blur(5px);
    `;
    toast.innerHTML = `<i class="fa ${icons[type]}" style="color:${colors[type]}"></i> ${message}`;
    container.appendChild(toast);
    setTimeout(() => toast.remove(), 3000);
}

// --- PARTICLES ---
function initParticles() {
    const canvas = document.getElementById('particles');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
    const particles = [];
    class Particle {
        constructor() { this.reset(); }
        reset() {
            this.x = Math.random() * canvas.width;
            this.y = canvas.height + 20;
            this.size = Math.random() * 2 + 1;
            this.speed = Math.random() * 1 + 0.3;
        }
        update() {
            this.y -= this.speed;
            if (this.y < -20) this.reset();
        }
        draw() {
            ctx.beginPath();
            ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
            ctx.fillStyle = 'rgba(255,255,255,.1)';
            ctx.fill();
        }
    }
    for (let i = 0; i < 40; i++) particles.push(new Particle());
    function animate() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        particles.forEach(p => { p.update(); p.draw(); });
        requestAnimationFrame(animate);
    }
    animate();
    window.addEventListener('resize', () => { canvas.width = window.innerWidth; canvas.height = window.innerHeight; });
}

// --- MESSAGING SYSTEM (Advanced Local Real-time) ---
// --- DATABASE MESSAGING SYSTEM (Live) ---
async function loadGlobalMessages(senderId, receiverId) {
    if (!senderId || !receiverId) return [];
    try {
        const response = await fetch(`get_messages.php?sender_id=${senderId}&receiver_id=${receiverId}`);
        return await response.json();
    } catch (err) {
        console.error("Fetch Messages Error:", err);
        return [];
    }
}

async function saveGlobalMessage(senderId, senderName, senderRole, receiverId, text) {
    const formData = new FormData();
    formData.append('id', Date.now());
    formData.append('sender_id', senderId);
    formData.append('sender_name', senderName);
    formData.append('receiver_id', receiverId);
    formData.append('text', text);
    formData.append('time_label', new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }));

    try {
        const response = await fetch('send_message.php', { method: 'POST', body: formData });
        return await response.json();
    } catch (err) {
        console.error("Send Message Error:", err);
        return { success: false };
    }
}

async function deleteGlobalMessage(msgId) {
    const formData = new FormData();
    formData.append('id', msgId);
    try {
        const response = await fetch('delete_msg.php', { method: 'POST', body: formData });
        return await response.json();
    } catch (err) { console.error("Del Error:", err); return { success: false }; }
}

async function editGlobalMessage(msgId, newText) {
    const formData = new FormData();
    formData.append('id', msgId);
    formData.append('text', newText);
    try {
        const response = await fetch('edit_msg.php', { method: 'POST', body: formData });
        return await response.json();
    } catch (err) { console.error("Edit Error:", err); return { success: false }; }
}

let currentChatTarget = null;
let lastMsgCount = 0;

function initAdvancedChat(containerId, currentUser) {
    const container = document.getElementById(containerId);
    if (!container) return;

    // Build Base HTML with Premium SaaS Redesign
    container.innerHTML = `
        <div class="msg-container">
            <!-- Contacts Sidebar -->
            <div class="msg-contacts">
                <div class="msg-contacts-header">
                    <h3>Direct Messages</h3>
                    <button class="btn-xs btn-outline" style="border-radius:6px; padding:2px 6px;" title="New Message">
                        <i class="fa fa-plus"></i>
                    </button>
                </div>
                <div id="chat-contacts" class="msg-contacts-list">
                    <!-- JS Injected Contacts -->
                </div>
            </div>
            
            <!-- Chat Area -->
            <div class="msg-chat-area">
                <div id="chat-header" class="msg-chat-header">
                    <div style="color:var(--g400); font-size:13px; font-weight:500;">
                        <i class="fa fa-info-circle"></i> Select a conversation to start
                    </div>
                </div>
                
                <div id="chat-messages" class="msg-chat-msgs">
                    <div class="empty-chat-state">
                        <i class="fa fa-comments-alt"></i>
                        <h3>Your Workspace Messages</h3>
                        <p>Select an administrator or colleague from the left to view your secure message history.</p>
                    </div>
                </div>
                
                <div class="msg-chat-input-row">
                    <div class="chat-input-wrapper">
                        <div class="chat-input-attachment" title="Attach Files">
                            <i class="fa fa-paperclip"></i>
                        </div>
                        <input type="text" id="chat-advanced-input" class="chat-input-field" placeholder="Message Admin..." disabled>
                        <button id="chat-advanced-send" class="chat-send-btn" disabled>
                            <i class="fa fa-paper-plane"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    `;

    renderContacts();
    setupListeners();

    // HEARTBEAT (Update my status every 20 seconds)
    function startHeartbeat() {
        const sendHeartbeat = () => {
            const fd = new FormData();
            fd.append('user_id', currentUser.id);
            fetch('update_status.php', { method: 'POST', body: fd }).catch(e => console.error(e));
        };
        sendHeartbeat();
        setInterval(sendHeartbeat, 20000);
    }
    startHeartbeat();

    // LIVE POLLING (Real-time check every 3 seconds)
    setInterval(() => {
        if (currentChatTarget) renderMessages(true);
        renderContacts(true); // Quietly update online status
    }, 3000);

    async function renderContacts(isSilent = false) {
        try {
            const response = await fetch('get_users.php');
            const users = await response.json();
            const contactsList = document.getElementById('chat-contacts');
            if (!contactsList) return;

            if (!isSilent) contactsList.innerHTML = '';

            // Filter out self and only show Staff/Admins
            const validContacts = users.filter(u => u.id !== currentUser.id && (u.role === 'admin' || u.role === 'instructor'));

            if (isSilent) {
                validContacts.forEach(contact => {
                    const dot = document.getElementById(`status-dot-${contact.id}`);
                    if (dot) {
                        const isOnline = checkIsOnline(contact.last_seen);
                        dot.className = `contact-status-dot ${isOnline ? 'online' : ''}`;
                    }
                });
                return;
            }

            validContacts.forEach(contact => {
                const div = document.createElement('div');
                const isActive = currentChatTarget && currentChatTarget.id === contact.id;
                const isOnline = checkIsOnline(contact.last_seen);
                const initial = contact.name.charAt(0).toUpperCase();

                div.className = `contact-item ${isActive ? 'active' : ''}`;
                div.innerHTML = `
                    <div class="contact-avatar-wrap">
                        <div class="contact-avatar">${initial}</div>
                        <div id="status-dot-${contact.id}" class="contact-status-dot ${isOnline ? 'online' : ''}"></div>
                    </div>
                    <div class="contact-info">
                        <div class="contact-name">${contact.name}</div>
                        <div class="contact-role">${contact.role === 'admin' ? 'Administrative Dean' : 'Program Coordinator'}</div>
                    </div>
                `;

                div.addEventListener('click', () => {
                    if (currentChatTarget && currentChatTarget.id === contact.id) return;
                    currentChatTarget = contact;
                    const contactOnline = checkIsOnline(contact.last_seen);
                    const selInitial = contact.name.charAt(0).toUpperCase();
                    
                    document.getElementById('chat-header').innerHTML = `
                        <div class="chat-target-profile">
                            <div class="contact-avatar" style="background:var(--p500); color:white; border:none; width:44px; height:44px;">${selInitial}</div>
                            <div class="chat-target-meta">
                                <h4>${contact.name}</h4>
                                <div class="chat-target-status ${contactOnline ? 'online' : 'offline'}">
                                    <i class="fa fa-circle" style="font-size:7px;"></i> ${contactOnline ? 'Active Now' : 'Last seen recently'}
                                </div>
                            </div>
                        </div>
                        <div style="display:flex; gap:12px;">
                            <button class="btn-xs btn-outline" style="width:32px; height:32px; padding:0; border-radius:8px;"><i class="fa fa-phone"></i></button>
                            <button class="btn-xs btn-outline" style="width:32px; height:32px; padding:0; border-radius:8px;"><i class="fa fa-info"></i></button>
                        </div>
                    `;
                        
                    document.getElementById('chat-advanced-input').disabled = false;
                    document.getElementById('chat-advanced-send').disabled = false;
                    document.getElementById('chat-advanced-input').focus();
                    renderContacts();
                    renderMessages();
                });
                contactsList.appendChild(div);
            });
        } catch (err) { console.error("Chat Contact Error:", err); }
    }

    function checkIsOnline(lastSeen) {
        if (!lastSeen) return false;
        // lastSeen comes from MySQL as "YYYY-MM-DD HH:MM:SS"
        const lastSeenDate = new Date(lastSeen.replace(/-/g, "/"));
        const now = new Date();
        const diffSeconds = (now - lastSeenDate) / 1000;
        return diffSeconds < 40; // True if active in last 40 seconds
    }

    window.handleEditMessage = async function (msgId) {
        const newText = prompt("Edit message:");
        if (newText !== null && newText.trim() !== "") {
            await editGlobalMessage(msgId, newText.trim());
            renderMessages();
        }
    };

    window.handleDeleteMessage = async function (msgId) {
        if (confirm("Delete this message?")) {
            await deleteGlobalMessage(msgId);
            renderMessages();
        }
    };

    async function renderMessages(isSilent = false) {
        if (!currentChatTarget) return;

        const container = document.getElementById('chat-messages');
        const allMsgs = await loadGlobalMessages(currentUser.id, currentChatTarget.id);

        if (!isSilent) container.innerHTML = '';

        // Only re-render if count changed to prevent flicker during polling
        if (isSilent && allMsgs.length === lastMsgCount) return;
        lastMsgCount = allMsgs.length;

        container.innerHTML = `<div class="msg-chat-inner"></div>`;
        const inner = container.querySelector('.msg-chat-inner');

        if (allMsgs.length === 0) {
            inner.innerHTML = `<div class="hub-empty" style="margin-top: 2rem;"><i class="fa fa-hand-wave"></i><p>No messages yet. Start the conversation!</p></div>`;
            return;
        }

        allMsgs.forEach(msg => {
            const isMe = msg.sender_id === currentUser.id;
            const wrap = document.createElement('div');
            wrap.className = `msg-bubble-wrap ${isMe ? 'me' : 'them'}`;

            const bubble = document.createElement('div');
            bubble.className = 'msg-bubble';
            
            let content = msg.text;
            if (msg.edited) content += ` <span style="font-size:0.75em; opacity:0.6; font-style:italic;">(edited)</span>`;
            
            bubble.innerHTML = content;

            const meta = document.createElement('div');
            meta.className = 'msg-meta';
            
            if (isMe) {
                meta.innerHTML = `
                    <span>${msg.timestamp}</span>
                    <i class="fa fa-check-double" style="color:var(--p300); margin-left:4px;" title="Delivered"></i>
                    <span style="cursor:pointer; margin-left:10px;" onclick="handleEditMessage(${msg.id})"><i class="fa fa-pen"></i></span>
                    <span style="cursor:pointer; margin-left:6px;" onclick="handleDeleteMessage(${msg.id})"><i class="fa fa-trash"></i></span>
                `;
            } else {
                meta.innerHTML = `<span>${msg.timestamp}</span>`;
            }

            wrap.appendChild(bubble);
            wrap.appendChild(meta);
            inner.appendChild(wrap);
        });

        container.scrollTop = container.scrollHeight;
    }

    function setupListeners() {
        const btn = document.getElementById('chat-advanced-send');
        const input = document.getElementById('chat-advanced-input');

        const sendMsg = async () => {
            if (!currentChatTarget) return;
            const text = input.value.trim();
            if (!text) return;

            const res = await saveGlobalMessage(currentUser.id, currentUser.name, currentUser.role, currentChatTarget.id, text);
            if (res.success) {
                input.value = '';
                renderMessages();
            }
        };

        btn.addEventListener('click', sendMsg);
        input.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') sendMsg();
        });
    }
}

document.addEventListener('DOMContentLoaded', () => {
    initDB();
    initParticles();

    const logoutBtn = document.querySelector('.btn-logout');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', (e) => {
            e.preventDefault();
            logout();
        });
    }

    const navButtons = document.querySelectorAll('.btn-nav');
    if (navButtons.length > 0) {
        navButtons.forEach(btn => {
            btn.addEventListener('click', e => {
                e.preventDefault();
                document.querySelectorAll('.btn-nav').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                const sec = btn.dataset.section;
                document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));
                const targetSec = document.getElementById(sec);
                if (targetSec) targetSec.classList.add('active');
            });
        });
    }
});

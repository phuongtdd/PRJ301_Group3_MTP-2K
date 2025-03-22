<%-- 
    Document   : login
    Created on : Mar 8, 2025, 5:08:04 PM
    Author     : Minh Tuan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>MTP-2K - Login</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css">

    </head>
    <body>


        <!-- Logo Title with link. Nhấn vào sẽ ra home -->
        <a href="${pageContext.request.contextPath}/home" class="logo-title">MTP-2K</a>

        <div class="music-banner">
            &#127911; Harmony for your heart, melody for your mind  &#127911;
        </div>

        <div class="container" id="container">
            <!-- Sign In Form -->
            <div class="form-container sign-in-container">
                <div class="form-box">
                    <i class="fas fa-music music-icon music-icon-1"></i>
                    <i class="fas fa-headphones music-icon music-icon-2"></i>
                    <i class="fas fa-compact-disc music-icon music-icon-3"></i>
                    <h1 class="mb-4">
                        <i class="fas fa-headphones-alt mr-2 text-purple-500"></i>
                        Sign In to MTP-2K with
                    </h1>

                    <%-- Sử dụng JSTL để tạo danh sách các nút mạng xã hội --%>
                    <%-- 
                    - <c:set>: Tạo biến JSTL để lưu trữ mảng các loại nút và biểu tượng.
                    - value="${['google', 'facebook']}": Tạo mảng chứa các class CSS cho nút.
                    - <c:forEach>: Vòng lặp qua mảng để tạo các nút mạng xã hội.
                Lợi ích: Nếu muốn thêm nút mạng xã hội mới (như Twitter), bạn chỉ cần thêm vào mảng mà không cần sửa HTML.
                    --%>

                    <div class="social-container">
                        <c:set var="socialButtons" value="${['google', 'facebook']}" />
                        <c:set var="socialIcons" value="${['fa-google', 'fa-facebook-f']}" />

                        <c:forEach var="i" begin="0" end="${socialButtons.size() - 1}">
                            <a href="#" class="social-btn ${socialButtons[i]}">
                                <i class="fab ${socialIcons[i]}"></i>
                            </a>
                        </c:forEach>
                    </div>




                    <span class="text-gray-500 text-sm">or use your account</span>

                    <form action="${pageContext.request.contextPath}/login?action=login" method="post" class="w-full mt-4">
                        <div class="input-group">
                            <i class="fas fa-user input-icon"></i>
                            <input type="text" name="username" placeholder="Username or Email" 
                                   class="form-input" value="<c:out value="${param.username}" />" required>
                        </div>

                        <div class="input-group">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" name="password" id="password" placeholder="Password" 
                                   class="form-input" required>
                            <!-- Con mắt vĩnh viễn trong form đăng nhập -->
                            <i class="fas fa-eye toggle-password absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400" 
                               onclick="togglePasswordVisibility()"></i>
                        </div>


                        <div class="flex justify-between items-center w-full mb-4">
                            <label class="flex items-center text-gray-600 text-sm">
                                <input type="checkbox" name="remember" class="form-checkbox h-4 w-4 text-indigo-600 rounded focus:ring-indigo-500 mr-2">
                                <span>Remember me</span>
                            </label>
                            <a href="#" class="text-sm text-purple-500 hover:text-purple-600">Forgot password?</a>
                        </div>

                        <%-- Thêm div cho thông báo lỗi đăng nhập --%>
                        <c:if test="${param.action eq 'login' && not empty requestScope.error}">
                            <div class="error-message text-center mb-24 text-red-600 bg-red-100 border border-red-400 rounded p-2">
                                <c:out value="${requestScope.error}" />
                            </div>
                        </c:if>

                        <button type="submit" id="loginButton" class="login-btn">
                            <div class="btn-content">
                                <i class="fas fa-sign-in-alt mr-2"></i>
                                <span>Sign In</span>
                            </div>
                        </button>

                        <div class="mt-4 text-center text-gray-600 text-sm">
                            Don't have an account? <button type="button" id="signUpLink" class="text-purple-500 font-semibold hover:underline">Sign Up</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Sign Up Form -->
            <div class="form-container sign-up-container">
                <div class="form-box">
                    <i class="fas fa-music music-icon music-icon-1"></i>
                    <i class="fas fa-headphones music-icon music-icon-2"></i>
                    <i class="fas fa-compact-disc music-icon music-icon-3"></i>
                    <h1 class="mb-4">
                        <i class="fas fa-user-plus mr-2 text-purple-500"></i>
                        Create Account
                    </h1>

                    <%-- Sử dụng JSTL để tạo danh sách các nút mạng xã hội (giống như trên) --%>
                    <div class="social-container">
                        <c:forEach var="i" begin="0" end="${socialButtons.size() - 1}">
                            <a href="#" class="social-btn ${socialButtons[i]}">
                                <i class="fab ${socialIcons[i]}"></i>
                            </a>
                        </c:forEach>
                    </div>

                    <span class="text-gray-500 text-sm">or sign up with your email or facebook</span>

                    <form action="${pageContext.request.contextPath}/login?action=register" method="post" class="w-full mt-4" id="registerForm">
                        <%--
                        - <c:set var="registerFields" value="${[...]}">: Tạo mảng các đối tượng chứa thông tin về các trường input.
                        - <c:forEach var="field" items="${registerFields}">: Vòng lặp qua mảng để tạo các trường input.
                        - <c:if test="${not empty field.id}">id="${field.id}"</c:if>: Thêm thuộc tính id nếu có.
                        - <c:if test="${field.name eq 'password'}">: Thêm icon hiển thị/ẩn mật khẩu chỉ cho trường password.
                Lợi ích: Dễ dàng thêm, xóa hoặc sửa đổi các trường input mà không cần sửa nhiều HTML.
                        --%>
                        <%-- Sử dụng JSTL để tạo các trường input --%>
                        <c:set var="registerFields" value="${[
                                                             {'name': 'fullName', 'type': 'text', 'placeholder': 'Full Name', 'icon': 'fa-id-card', 'id': 'fullName'},
                                                             {'name': 'userName', 'type': 'text', 'placeholder': 'Username', 'icon': 'fa-user', 'id': 'userName'},
                                                             {'name': 'email', 'type': 'email', 'placeholder': 'Email', 'icon': 'fa-envelope', 'id': 'email'},
                                                             {'name': 'password', 'type': 'password', 'placeholder': 'Password', 'icon': 'fa-lock', 'id': 'registerPassword', 'showToggle': true},
                                                             {'name': 'confirmPassword', 'type': 'password', 'placeholder': 'Confirm Password', 'icon': 'fa-lock', 'id': 'confirmPassword', 'showToggle': true},
                                                             {'name': 'phone', 'type': 'tel', 'placeholder': 'Phone', 'icon': 'fa-phone', 'id': 'phone'}
                                                             ]}" />

                        <c:forEach var="field" items="${registerFields}">
                            <div class="input-group">
                                <i class="fas ${field.icon} input-icon"></i>
                                <input type="${field.type}" name="${field.name}" 
                                       <c:if test="${not empty field.id}">id="${field.id}"</c:if>
                                       placeholder="${field.placeholder}" 
                                       class="form-input" required>
                                <%-- Hiển thị icon mắt khi click vào (Vĩnh viễn) --%>
                                <c:if test="${field.showToggle eq true}">
                                    <i class="fas fa-eye toggle-password absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400" 
                                       onclick="toggleRegisterPasswordVisibility('${field.id}')"></i>
                                </c:if>

                                <div class="error-message" id="${field.id}-error"></div>
                            </div>
                        </c:forEach>

                        <button type="submit" class="login-btn">
                            <div class="btn-content">
                                <i class="fas fa-user-plus mr-2"></i>
                                <span>Sign Up</span>
                            </div>
                        </button>

                        <div class="mt-4 mb-12 text-center text-gray-600 text-sm">
                            Already have an account? <button type="button" id="signInLink" class="text-purple-500 font-semibold hover:underline">Sign In</button>
                        </div>

                        <%-- Hiển thị thông báo lỗi đăng ký --%>
                        <c:if test="${not empty requestScope.error}">
                            <div class="mt-4 bg-red-500 bg-opacity-20 border border-red-500 text-red-700 px-4 py-2 rounded-lg text-sm">
                                <p><c:out value="${requestScope.error}" /></p>
                            </div>
                        </c:if>

                        <%-- Hiển thị thông báo đăng ký thành công --%>
                        <c:if test="${not empty requestScope.registerSuccess}">
                            <div class="mt-4 bg-green-500 bg-opacity-20 border border-green-500 text-green-700 px-4 py-2 rounded-lg text-sm">
                                <p><c:out value="${requestScope.registerSuccess}" /></p>
                            </div>
                        </c:if>
                    </form>
                </div>
            </div>

            <!-- Overlay Container -->
            <div class="overlay-container">
                <div class="overlay">
                    <!-- Left Overlay Panel (Sign Up) -->
                    <div class="overlay-panel overlay-left">
                        <div class="logo-container mb-4">
                            <img src="${pageContext.request.contextPath}/image/mtp2k-logo.png" alt="MTP-2K Logo" class="logo-image">
                            <div class="logo-text">MTP-2K</div>
                        </div>

                        <%-- 
                        - <c:set var="leftPanelContent" value="${{...}}">: Tạo đối tượng chứa nội dung của panel.
                        - <c:out value="${leftPanelContent.title}">: Hiển thị tiêu đề từ đối tượng.
                    Lợi ích: Dễ dàng thay đổi nội dung panel mà không cần sửa nhiều HTML.
                        --%>
                        <%-- Sử dụng JSTL để hiển thị nội dung panel --%>
                        <c:set var="leftPanelContent" value="${{
                                                               'title': 'Welcome Back!',
                                                               'message': 'To keep connected with us please login with your personal info',
                                                               'buttonText': 'Sign In',
                                                               'buttonIcon': 'fa-sign-in-alt',
                                                               'buttonId': 'signIn'
                                                               }}" />

                        <h1 class="mb-2"><c:out value="${leftPanelContent.title}" /></h1>
                        <p><c:out value="${leftPanelContent.message}" /></p>

                        <!-- Equalizer animation -->
                        <div class="equalizer mt-4 mb-4">
                            <c:forEach begin="1" end="8" var="i">
                                <div class="bar bar${i}"></div>
                            </c:forEach>
                        </div>

                        <button class="ghost-btn" id="${leftPanelContent.buttonId}">
                            <i class="fas ${leftPanelContent.buttonIcon} mr-2"></i>
                            <c:out value="${leftPanelContent.buttonText}" />
                        </button>
                    </div>

                    <!-- Right Overlay Panel (Sign In) -->
                    <div class="overlay-panel overlay-right">
                        <div class="logo-container mb-4">
                            <img src="${pageContext.request.contextPath}/image/mtp2k-logo.png" alt="MTP-2K Logo" class="logo-image">
                            <div class="logo-text">MTP-2K</div>
                        </div>

                        <%-- Sử dụng JSTL để hiển thị nội dung panel --%>
                        <c:set var="rightPanelContent" value="${{
                                                                'title': 'Hello, Friend!',
                                                                'message': 'Enter your personal details and start your journey with us',
                                                                'buttonText': 'Sign Up',
                                                                'buttonIcon': 'fa-user-plus',
                                                                'buttonId': 'signUp'
                                                                }}" />

                        <h1 class="mb-2"><c:out value="${rightPanelContent.title}" /></h1>
                        <p><c:out value="${rightPanelContent.message}" /></p>

                        <!-- Equalizer animation -->

                        <%-- 
                        - <c:forEach begin="1" end="8" var="i">: Vòng lặp qua 8 thanh để tạo các thanh của equalizer.
                        - <div class="bar bar${i}"></div>: Tạo một thanh có class bar${i} để sử dụng trong CSS.
                        Lợi ích: Dễ dàng thay đổi số lượng thanh hoặc thay đổi CSS cho chúng.
                        --%>
                        <%-- Sử dụng JSTL để tạo các thanh của equalizer --%>
                        <div class="equalizer mt-4 mb-4">
                            <c:forEach begin="1" end="8" var="i">
                                <div class="bar bar${i}"></div>
                            </c:forEach>
                        </div>

                        <button class="ghost-btn" id="${rightPanelContent.buttonId}">
                            <i class="fas ${rightPanelContent.buttonIcon} mr-2"></i>
                            <c:out value="${rightPanelContent.buttonText}" />
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Thêm hàm kiểm tra khoảng trắng
            function isEmptyOrWhitespace(str) {
                return str === null || str === undefined || str.trim() === '';
            }

            // Định nghĩa các hàm validation ở phạm vi toàn cục
            // Hàm kiểm tra họ tên
            function validateFullName(fullName) {
                // Kiểm tra nếu chuỗi rỗng hoặc chỉ chứa khoảng trắng
                if (isEmptyOrWhitespace(fullName))
                    return false;

                // Kiểm tra độ dài sau khi đã loại bỏ khoảng trắng thừa ở đầu và cuối
                const trimmedName = fullName.trim();
                if (trimmedName.length < 2)
                    return false;

                // Kiểm tra nếu có nhiều khoảng trắng liên tiếp
                if (/\s{2,}/.test(trimmedName))
                    return false;

                // Kiểm tra họ tên chỉ chứa chữ cái và khoảng trắng, không chứa ký tự đặc biệt hoặc số
                const regex = /^[a-zA-ZÀ-ỹ\s]{2,50}$/;
                return regex.test(trimmedName);
            }

            // Hàm kiểm tra tên đăng nhập
            function validateUsername(username) {
                if (username === '')
                    return false;
                const regex = /^[a-zA-Z0-9_]{5,20}$/;
                return regex.test(username);
            }

            // Hàm kiểm tra email
            function validateEmail(email) {
                if (email === '')
                    return false;

                // Kiểm tra định dạng email cơ bản
                const basicEmailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                if (!basicEmailRegex.test(email)) {
                    return false;
                }

                // Danh sách các domain phổ biến được chấp nhận
                const validDomains = [
                    '.com',
                    '.edu',
                    '.org',
                    '.net',
                    '.gov',
                    '.edu.vn',
                    '.com.vn',
                    '.org.vn',
                    '.net.vn',
                    '.gov.vn'
                ];

                // Kiểm tra xem email có kết thúc bằng một trong các domain hợp lệ không
                return validDomains.some(domain => email.toLowerCase().endsWith(domain));
            }

            // Hàm kiểm tra mật khẩu
            function validatePassword(password) {
                if (password === '')
                    return false;
                // Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt
                const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[#@$!%^*?&])[A-Za-z\d#@$^!%*?&]{8,}$/;
                return regex.test(password);
            }

            // Hàm kiểm tra số điện thoại
            function validatePhone(phone) {
                if (phone === '')
                    return false;

                // Kiểm tra số điện thoại Việt Nam
                // Bắt đầu bằng 0 và có 10 số (VD: 0912345678)
                // Hoặc bắt đầu bằng +84 và có 9 số phía sau (VD: +84912345678)
                const phoneRegex = /^(0\d{9}|\+84\d{9})$/;
                return phoneRegex.test(phone);
            }

            // Hàm hiển thị lỗi
            function showError(inputId, message) {
                const errorElement = document.getElementById(inputId + '-error');
                const inputElement = document.getElementById(inputId);

                if (errorElement && inputElement) {
                    errorElement.textContent = message;
                    errorElement.style.display = 'block';

                    inputElement.classList.add('input-error');
                    inputElement.classList.remove('input-success');
                }
            }

            // Hàm xóa lỗi
            function clearError(inputId) {
                const errorElement = document.getElementById(inputId + '-error');
                const inputElement = document.getElementById(inputId);

                if (errorElement && inputElement) {
                    errorElement.textContent = '';
                    errorElement.style.display = 'none';

                    inputElement.classList.remove('input-error');
                    inputElement.classList.add('input-success');
                }
            }

            // Khởi tạo các sự kiện khi trang web đã tải xong
            document.addEventListener('DOMContentLoaded', function () {
                // Auto-hide login error messages after 5 seconds
                const loginErrors = document.querySelectorAll('.sign-in-container .error-message');
                loginErrors.forEach(error => {
                    if (error.style.display !== 'none') {
                        setTimeout(() => {
                            error.style.display = 'none';
                        }, 5000);
                    }
                });

                // Lấy các phần tử DOM cần thiết cho việc chuyển đổi panel
                const signUpButton = document.getElementById('signUp');
                const signInButton = document.getElementById('signIn');
                const signUpLink = document.getElementById('signUpLink');
                const signInLink = document.getElementById('signInLink');
                const container = document.getElementById('container');

                // Thêm sự kiện click cho nút "Sign Up" trong form đăng nhập
                // Khi người dùng click vào link "Sign Up" trong form đăng nhập, chuyển sang form đăng ký
                if (signUpLink) {
                    signUpLink.addEventListener('click', () => {
                        container.classList.add('right-panel-active');
                    });
                }

                // Thêm sự kiện click cho nút "Sign In" trong form đăng ký
                // Khi người dùng click vào link "Sign In" trong form đăng ký, chuyển sang form đăng nhập
                if (signInLink) {
                    signInLink.addEventListener('click', () => {
                        container.classList.remove('right-panel-active');
                    });
                }

                // Thêm sự kiện click cho nút "Sign Up" trong overlay bên phải
                // Khi người dùng click vào nút "Sign Up" trong panel bên phải, chuyển sang form đăng ký
                signUpButton.addEventListener('click', () => {
                    container.classList.add('right-panel-active');
                });

                // Thêm sự kiện click cho nút "Sign In" trong overlay bên trái
                // Khi người dùng click vào nút "Sign In" trong panel bên trái, chuyển sang form đăng nhập
                signInButton.addEventListener('click', () => {
                    container.classList.remove('right-panel-active');
                });

                // Thêm hiệu ứng animation cho các thanh equalizer
                // Tạo hiệu ứng chuyển động cho các thanh equalizer để mô phỏng hiệu ứng âm nhạc
                const bars = document.querySelectorAll('.bar');
                bars.forEach((bar, index) => {
                    // Mỗi thanh có một độ trễ khác nhau để tạo hiệu ứng sóng
                    bar.style.animation = `barAnimation 1.5s infinite ${index * 0.1}s`;
                });

                // Thêm hiệu ứng pulse cho logo
                // Tạo hiệu ứng nhấp nháy cho logo để thu hút sự chú ý
                const logoContainers = document.querySelectorAll('.logo-container');
                logoContainers.forEach(container => {
                    container.style.animation = 'pulse 2s infinite';
                });

                // Tạo các keyframes animation động bằng JavaScript
                // Định nghĩa các animation sử dụng trong trang
                const style = document.createElement('style');
                style.textContent = `
                    /* Hiệu ứng animation cho các thanh equalizer - tạo hiệu ứng nhảy lên xuống */
                    @keyframes barAnimation {
                        0% { transform: scaleY(1); }
                        50% { transform: scaleY(0.6); }
                        100% { transform: scaleY(1); }
                    }
                    
                    /* Hiệu ứng pulse cho logo - tạo hiệu ứng phát sáng xung quanh logo */
                    @keyframes pulse {
                        0% { box-shadow: 0 0 0 0 rgba(255, 255, 255, 0.4); }
                        70% { box-shadow: 0 0 0 15px rgba(255, 255, 255, 0); }
                        100% { box-shadow: 0 0 0 0 rgba(255, 255, 255, 0); }
                    }
                    
                    /* Hiệu ứng gradient animation cho nút - tạo hiệu ứng chuyển màu gradient */
                    @keyframes gradientAnimation {
                        0% { background-position: 0% 50%; }
                        50% { background-position: 100% 50%; }
                        100% { background-position: 0% 50%; }
                    }
                    
                    /* Hiệu ứng bounce cho nội dung nút - tạo hiệu ứng nảy lên xuống */
                    @keyframes bounce {
                        0%, 100% { transform: translateY(0); }
                        50% { transform: translateY(-5px); }
                    }
                `;
                document.head.appendChild(style);

                // Thêm hiệu ứng cho nút đăng nhập
                // Tạo các hiệu ứng tương tác khi người dùng di chuột vào nút đăng nhập
                const loginButton = document.getElementById('loginButton');

                // Sự kiện khi di chuột vào nút đăng nhập
                if (loginButton) {
                    loginButton.addEventListener('mouseenter', function () {
                        // Thêm hiệu ứng gradient animation khi di chuột vào nút
                        this.style.backgroundSize = '300% 300%';
                        this.style.animation = 'gradientAnimation 3s ease infinite';

                        // Thêm hiệu ứng nảy lên cho nội dung nút
                        const btnContent = this.querySelector('.btn-content');
                        btnContent.style.animation = 'bounce 0.5s ease';

                        // Tạo và hiển thị các nốt nhạc xung quanh nút
                        createMusicNotes(this);

                        // Phát âm thanh khi di chuột vào nút
                        playSound();
                    });

                    // Sự kiện khi di chuột ra khỏi nút đăng nhập
                    loginButton.addEventListener('mouseleave', function () {
                        // Xóa các hiệu ứng animation khi di chuột ra khỏi nút
                        this.style.animation = '';
                        const btnContent = this.querySelector('.btn-content');
                        btnContent.style.animation = '';

                        // Xóa tất cả các nốt nhạc
                        document.querySelectorAll('.music-note').forEach(note => {
                            note.remove();
                        });
                    });
                }

                // Hàm tạo các nốt nhạc xung quanh nút khi hover
                // Tạo hiệu ứng các nốt nhạc bay lên từ nút đăng nhập
                function createMusicNotes(button) {
                    // Tạo 5 nốt nhạc với vị trí và chuyển động ngẫu nhiên
                    for (let i = 0; i < 5; i++) {
                        const note = document.createElement('i');
                        note.className = 'fas fa-music music-note';
                        button.appendChild(note);

                        // Đặt vị trí ngẫu nhiên cho nốt nhạc
                        const x = Math.random() * button.offsetWidth;
                        const y = button.offsetHeight / 2;

                        note.style.left = `${x}px`;
                        note.style.top = `${y}px`;

                        // Tạo hiệu ứng animation cho nốt nhạc
                        setTimeout(() => {
                            note.style.opacity = '1';
                            note.style.transform = `translate(${Math.random() * 20 - 10}px, -${30 + Math.random() * 20}px) rotate(${Math.random() * 40 - 20}deg)`;
                            note.style.transition = 'all 1s ease';

                            // Làm mờ dần và xóa nốt nhạc sau một khoảng thời gian
                            setTimeout(() => {
                                note.style.opacity = '0';
                                setTimeout(() => {
                                    note.remove();
                                }, 500);
                            }, 1000);
                        }, i * 200);
                    }
                }

                // Hàm phát âm thanh khi hover nút đăng nhập
                // Tạo âm thanh nốt nhạc A4 khi di chuột vào nút đăng nhập
                function playSound() {
                    // Sử dụng Web Audio API để tạo âm thanh
                    if (window.AudioContext || window.webkitAudioContext) {
                        try {
                            const AudioContext = window.AudioContext || window.webkitAudioContext;
                            const audioCtx = new AudioContext();
                            const oscillator = audioCtx.createOscillator();
                            const gainNode = audioCtx.createGain();

                            // Thiết lập loại sóng âm, tần số và âm lượng
                            oscillator.type = 'sine';
                            oscillator.frequency.setValueAtTime(440, audioCtx.currentTime); // A4 note
                            gainNode.gain.setValueAtTime(0.1, audioCtx.currentTime);
                            gainNode.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + 0.5);

                            // Kết nối các node âm thanh
                            oscillator.connect(gainNode);
                            gainNode.connect(audioCtx.destination);

                            // Phát và dừng âm thanh
                            oscillator.start();
                            oscillator.stop(audioCtx.currentTime + 0.5);
                        } catch (e) {
                            console.log('Web Audio API not supported or user has not interacted with the document yet');
                        }
                    }
                }

                // Lấy các phần tử input
                const fullNameInput = document.getElementById('fullName');
                const usernameInput = document.getElementById('userName');
                const emailInput = document.getElementById('email');
                const passwordInput = document.getElementById('registerPassword');
                const confirmPasswordInput = document.getElementById('confirmPassword');
                const phoneInput = document.getElementById('phone');

                // Thêm sự kiện input cho các trường
                if (fullNameInput) {
                    // Kiểm tra khi người dùng bắt đầu nhập (sự kiện input)
                    fullNameInput.addEventListener('input', validateFullName);

                    // Kiểm tra khi người dùng nhấn phím (sự kiện keyup)
                    fullNameInput.addEventListener('keyup', validateFullName);

                    // Kiểm tra khi người dùng bấm vào trường (sự kiện focus)
                    fullNameInput.addEventListener('focus', function () {
                        // Nếu đã có giá trị, kiểm tra ngay
                        if (this.value) {
                            validateFullName.call(this);
                        }
                    });

                    // Kiểm tra khi người dùng rời khỏi trường (sự kiện blur)
                    fullNameInput.addEventListener('blur', validateFullName);

                    // Hàm kiểm tra họ tên
                    function validateFullName() {
                        const value = this.value;

                        // Kiểm tra nếu trường rỗng hoặc chỉ có khoảng trắng
                        if (value === '' || value.trim() === '') {
                            showError('fullName', 'Vui lòng nhập họ tên');
                            return false;
                        }

                        // Kiểm tra độ dài
                        if (value.trim().length < 2) {
                            showError('fullName', 'Họ tên phải có ít nhất 2 ký tự');
                            return false;
                        }

                        // Kiểm tra khoảng trắng liên tiếp
                        if (/\s{2,}/.test(value)) {
                            showError('fullName', 'Họ tên không được chứa nhiều khoảng trắng liên tiếp');
                            return false;
                        }

                        // Kiểm tra ký tự đặc biệt và số
                        if (!/^[a-zA-ZÀ-ỹ\s]{2,50}$/.test(value.trim())) {
                            showError('fullName', 'Họ tên chỉ được chứa chữ cái và khoảng trắng, không chứa số hoặc ký tự đặc biệt');
                            return false;
                        }

                        // Nếu hợp lệ
                        clearError('fullName');
                        return true;
                    }
                }

                if (usernameInput) {
                    usernameInput.addEventListener('input', function () {
                        const value = this.value.trim();
                        if (value === '') {
                            showError('userName', 'Vui lòng nhập tên đăng nhập');
                        } else if (!validateUsername(value)) {
                            showError('userName', 'Tên đăng nhập phải từ 5-20 ký tự, chỉ chứa chữ cái, số và dấu gạch dưới');
                        } else {
                            clearError('userName');
                        }
                    });
                }

                if (emailInput) {
                    emailInput.addEventListener('input', function () {
                        const value = this.value.trim();
                        if (value === '') {
                            showError('email', 'Vui lòng nhập email');
                        } else if (!validateEmail(value)) {
                            showError('email', 'Email không đúng định dạng. Ví dụ hợp lệ: user@example.com, student@university.edu.vn');
                        } else {
                            clearError('email');
                        }
                    });
                }

                if (passwordInput) {
                    passwordInput.addEventListener('input', function () {
                        const value = this.value.trim();
                        if (value === '') {
                            showError('registerPassword', 'Vui lòng nhập mật khẩu');
                        } else if (!validatePassword(value)) {
                            showError('registerPassword', 'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt');
                        } else {
                            clearError('registerPassword');
                        }

                        // Kiểm tra lại xác nhận mật khẩu nếu đã nhập
                        if (confirmPasswordInput && confirmPasswordInput.value.trim() !== '') {
                            if (confirmPasswordInput.value.trim() !== value) {
                                showError('confirmPassword', 'Xác nhận mật khẩu không khớp');
                            } else {
                                clearError('confirmPassword');
                            }
                        }
                    });
                }

                if (confirmPasswordInput) {
                    confirmPasswordInput.addEventListener('input', function () {
                        const value = this.value.trim();
                        const password = passwordInput ? passwordInput.value.trim() : '';

                        if (value === '') {
                            showError('confirmPassword', 'Vui lòng xác nhận mật khẩu');
                        } else if (value !== password) {
                            showError('confirmPassword', 'Xác nhận mật khẩu không khớp');
                        } else {
                            clearError('confirmPassword');
                        }
                    });
                }

                if (phoneInput) {
                    phoneInput.addEventListener('input', function () {
                        const value = this.value.trim();
                        if (value === '') {
                            showError('phone', 'Vui lòng nhập số điện thoại');
                        } else if (!validatePhone(value)) {
                            showError('phone', 'Số điện thoại không hợp lệ. Định dạng: 0xxxxxxxxx hoặc +84xxxxxxxxx');
                        } else {
                            clearError('phone');
                        }
                    });
                }

                // Thêm validation cho form đăng nhập
                const loginUsernameInput = document.getElementById('loginUsername');
                const loginPasswordInput = document.getElementById('password');

                if (loginUsernameInput) {
                    loginUsernameInput.addEventListener('input', function () {
                        const value = this.value.trim();
                        if (value === '') {
                            showError('loginUsername', 'Vui lòng nhập tên đăng nhập hoặc email');
                        } else {
                            clearError('loginUsername');
                        }
                    });
                }

                if (loginPasswordInput) {
                    loginPasswordInput.addEventListener('input', function () {
                        const value = this.value.trim();
                        if (value === '') {
                            showError('password', 'Vui lòng nhập mật khẩu');
                        } else {
                            clearError('password');
                        }
                    });
                }
            });

            // Xử lý khi submit form
            document.getElementById('registerForm').addEventListener('submit', function (e) {
                let isValid = true;

                // Lấy giá trị các trường
                const fullName = document.getElementById('fullName').value.trim();
                const username = document.getElementById('userName').value.trim();
                const email = document.getElementById('email').value.trim();
                const password = document.getElementById('registerPassword').value.trim();
                const confirmPassword = document.getElementById('confirmPassword').value.trim();
                const phone = document.getElementById('phone').value.trim();

                // Kiểm tra họ tên
                if (isEmptyOrWhitespace(fullName)) {
                    showError('fullName', 'Vui lòng nhập họ tên');
                    isValid = false;
                } else if (fullName.trim().length < 2) {
                    showError('fullName', 'Họ tên phải có ít nhất 2 ký tự');
                    isValid = false;
                } else if (/\s{2,}/.test(fullName)) {
                    showError('fullName', 'Họ tên không được chứa nhiều khoảng trắng liên tiếp');
                    isValid = false;
                } else if (!/^[a-zA-ZÀ-ỹ\s]{2,50}$/.test(fullName.trim())) {
                    showError('fullName', 'Họ tên chỉ được chứa chữ cái và khoảng trắng, không chứa số hoặc ký tự đặc biệt');
                    isValid = false;
                }

                // Kiểm tra tên đăng nhập
                if (!validateUsername(username)) {
                    showError('userName', 'Tên đăng nhập phải từ 5-20 ký tự, chỉ chứa chữ cái, số và dấu gạch dưới');
                    isValid = false;
                }

                // Kiểm tra email
                if (!validateEmail(email)) {
                    showError('email', 'Email không đúng định dạng. Ví dụ hợp lệ: user@example.com, student@university.edu.vn');
                    isValid = false;
                }

                // Kiểm tra mật khẩu
                if (!validatePassword(password)) {
                    showError('registerPassword', 'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt');
                    isValid = false;
                }

                // Kiểm tra xác nhận mật khẩu
                if (password !== confirmPassword) {
                    showError('confirmPassword', 'Xác nhận mật khẩu không khớp');
                    isValid = false;
                }

                // Kiểm tra số điện thoại
                if (!validatePhone(phone)) {
                    showError('phone', 'Số điện thoại không hợp lệ. Định dạng: 0xxxxxxxxx hoặc +84xxxxxxxxx');
                    isValid = false;
                }

                // Nếu có lỗi, ngăn form submit
                if (!isValid) {
                    e.preventDefault();
                }
            });

            // Thêm validation cho form đăng nhập
            document.getElementById('loginForm').addEventListener('submit', function (e) {
                let isValid = true;

                // Lấy giá trị các trường
                const username = document.getElementById('loginUsername').value.trim();
                const password = document.getElementById('password').value.trim();

                // Kiểm tra username/email
                if (username === '') {
                    showError('loginUsername', 'Vui lòng nhập tên đăng nhập hoặc email');
                    isValid = false;
                }

                // Kiểm tra mật khẩu
                if (password === '') {
                    showError('password', 'Vui lòng nhập mật khẩu');
                    isValid = false;
                }

                // Nếu có lỗi, ngăn form submit
                if (!isValid) {
                    e.preventDefault();
                }
            });

            // Hàm hiển thị/ẩn mật khẩu trong form đăng nhập
            // Chuyển đổi giữa hiển thị và ẩn mật khẩu khi người dùng click vào icon con mắt
            function togglePasswordVisibility() {
                // Lấy phần tử input mật khẩu và icon
                const passwordInput = document.getElementById('password');
                const toggleIcon = document.querySelector('.toggle-password');

                // Kiểm tra trạng thái hiện tại của input mật khẩu
                if (passwordInput.type === 'password') {
                    // Nếu đang ẩn, chuyển sang hiển thị và đổi icon
                    passwordInput.type = 'text';
                    toggleIcon.classList.remove('fa-eye');
                    toggleIcon.classList.add('fa-eye-slash');
                } else {
                    // Nếu đang hiển thị, chuyển sang ẩn và đổi icon
                    passwordInput.type = 'password';
                    toggleIcon.classList.remove('fa-eye-slash');
                    toggleIcon.classList.add('fa-eye');
                }
            }

            // Hàm hiển thị/ẩn mật khẩu trong form đăng ký
            // Tương tự như hàm togglePasswordVisibility nhưng áp dụng cho trường mật khẩu trong form đăng ký
            function toggleRegisterPasswordVisibility(inputId) {
                // Lấy phần tử input mật khẩu và icon tương ứng
                const passwordInput = document.getElementById(inputId);
                const toggleIcon = passwordInput.nextElementSibling;

                // Kiểm tra trạng thái hiện tại của input mật khẩu
                if (passwordInput.type === 'password') {
                    // Nếu đang ẩn, chuyển sang hiển thị và đổi icon
                    passwordInput.type = 'text';
                    toggleIcon.classList.remove('fa-eye');
                    toggleIcon.classList.add('fa-eye-slash');
                } else {
                    // Nếu đang hiển thị, chuyển sang ẩn và đổi icon
                    passwordInput.type = 'password';
                    toggleIcon.classList.remove('fa-eye-slash');
                    toggleIcon.classList.add('fa-eye');
                }
            }

            // Validate form khi submit
            registerForm.addEventListener('submit', function (e) {
                let isValid = true;

                // Kiểm tra từng trường input
                registerFields.forEach(field => {
                    const input = document.getElementById(field.id);
                    if (input) {
                        validateField(input);
                        if (input.classList.contains('invalid')) {
                            isValid = false;
                        }
                    }
                });

                // Nếu có lỗi, ngăn form submit
                if (!isValid) {
                    e.preventDefault();
                }
            });



            // Thêm sự kiện khi chuyển đổi form
            document.querySelector('.sign-up-button').addEventListener('click', function () {
                // Xóa lỗi đăng nhập khi chuyển sang form đăng ký
                const loginError = document.querySelector('.sign-in-container .error-message');
                if (loginError) {
                    loginError.style.display = 'none';
                    loginError.textContent = '';
                }
            });

            // Hiển thị và tự động ẩn thông báo lỗi
            document.addEventListener('DOMContentLoaded', function () {
                const loginError = document.getElementById('loginError');
                if (loginError && '${requestScope.error}' !== '') {
                    // Hiển thị thông báo
                    loginError.style.display = 'block';

                    // Tự động ẩn sau 5 giây
                    setTimeout(function () {
                        loginError.style.transition = 'opacity 0.5s ease';
                        loginError.style.opacity = '0';
                        setTimeout(() => {
                            loginError.style.display = 'none';
                        }, 500);
                    }, 5000);
                }
            });

            // Sửa lại phần xử lý hiển thị thông báo lỗi
            document.addEventListener('DOMContentLoaded', function () {
                const errorMessages = document.querySelectorAll('.error-message');
                errorMessages.forEach(error => {
                    if (error.textContent.trim() !== '') {
                        // Tự động ẩn sau 5 giây
                        setTimeout(() => {
                            error.style.opacity = '0';
                            setTimeout(() => {
                                error.style.display = 'none';
                            }, 300);
                        }, 5000);
                    } else {
                        error.style.display = 'none';
                    }
                });
            });

            // Xử lý hiển thị thông báo lỗi đăng nhập
            document.addEventListener('DOMContentLoaded', function () {
                const loginError = document.getElementById('loginError');

                if (loginError && '${not empty requestScope.error}' === 'true') {
                    // Hiển thị thông báo lỗi với độ trễ nhỏ
                    setTimeout(() => {
                        loginError.classList.add('show');

                        // Tự động ẩn sau 5 giây
                        setTimeout(() => {
                            loginError.style.opacity = '0';
                            setTimeout(() => {
                                loginError.classList.remove('show');
                            }, 300);
                        }, 5000);
                    }, 100);
                }
            });
        </script>
    </body>
</html>

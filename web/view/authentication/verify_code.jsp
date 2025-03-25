<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>MTP-2K - Verify Code</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css">
        <style>
            /* Internal CSS cho trang verify code */
            .container {
                position: relative;
                display: flex;
                align-items: center;
                justify-content: center;
                min-height: 70vh;
            }
            
            .form-container {
                position: static !important;
                width: 100% !important;
                max-width: 450px !important;
                height: auto !important;
                left: auto !important;
                transform: none !important;
                margin: 0 auto;
            }
            
            .form-box {
                width: 100%;
                padding: 2.5rem;
                border-radius: 1rem;
                box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            }
            
            .input-group {
                width: 100%;
                margin-bottom: 1.5rem;
            }
            
            .form-input {
                width: 100%;
            }
            
            .login-btn {
                width: 100%;
            }
        </style>
    </head>
    <body>
        <!-- Logo Title with link. Nhấn vào sẽ ra home -->
        <a href="${pageContext.request.contextPath}/home" class="logo-title">MTP-2K</a>

        <div class="music-banner">
            &#127911; Harmony for your heart, melody for your mind  &#127911;
        </div>

        <div class="container" id="container">
            <div class="form-container sign-in-container">
                <div class="form-box">
                    <i class="fas fa-music music-icon music-icon-1"></i>
                    <i class="fas fa-headphones music-icon music-icon-2"></i>
                    <i class="fas fa-compact-disc music-icon music-icon-3"></i>
                    <h1 class="mb-4">
                        <i class="fas fa-shield-alt mr-2 text-purple-500"></i>
                        Verify Code
                    </h1>

                    <span class="text-gray-500 text-sm mb-2">We've sent a verification code to your email</span>
                    <span class="text-purple-500 font-semibold mb-4">${requestScope.email}</span>

                    <c:if test="${not empty requestScope.message}">
                        <div class="success-message text-center mb-4 text-green-600 bg-green-100 border border-green-400 rounded p-2">
                            <c:out value="${requestScope.message}" />
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login?action=verifyCode" method="post" class="w-full mt-4">
                        <input type="hidden" name="email" value="${requestScope.email}">

                        <div class="input-group">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="text" name="code" placeholder="Enter 6-digit code" 
                                   class="form-input" required pattern="[0-9]{6}" 
                                   title="Please enter the 6-digit code">
                        </div>

                        <c:if test="${not empty requestScope.error}">
                            <div class="error-message text-center mb-4 text-red-600 bg-red-100 border border-red-400 rounded p-2">
                                <c:out value="${requestScope.error}" />
                            </div>
                        </c:if>

                        <button type="submit" class="login-btn">
                            <div class="btn-content">
                                <i class="fas fa-check-circle mr-2"></i>
                                <span>Verify Code</span>
                            </div>
                        </button>

                        <div class="mt-4 text-center text-gray-600 text-sm">
                            Didn't receive the code? 
                            <a href="${pageContext.request.contextPath}/login?action=forgotPassword" class="text-purple-500 font-semibold hover:underline">
                                Request again
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            // Add any JavaScript if needed
        </script>
    </body>
</html>
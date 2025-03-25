<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MTP-2K Premium</title>
        <!-- Import Bootstrap and FontAwesome -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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

            /* Main CSS for Premium page */
            body {
                background-color: #0a192f;
                /* Dark blue background */
                color: white;
                font-family: 'Poppins', sans-serif;
                overflow-x: hidden;
            }

            /* Premium header section */
            .premium-header {
                text-align: center;
                padding: 3rem 0;
                margin-bottom: 2rem;
                margin-top: 120px;
            }

            /* Pricing cards */
            .pricing-card {
                background-color: #112240;
                /* Dark blue card background */
                border: none;
                border-radius: 12px;
                padding: 1.5rem;
                height: 100%;
                transition: transform 0.3s;
                margin-bottom: 20px;
            }

            /* Hover effect for cards */
            .pricing-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
            }

            /* Card header style */
            .pricing-card .card-header {
                background-color: transparent;
                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                text-align: center;
                padding-bottom: 1rem;
            }

            /* Price style */
            .price {
                font-size: 2.5rem;
                font-weight: bold;
                color: #64ffda;
                /* Teal accent color */
            }

            /* Period style */
            .period {
                font-size: 1rem;
                color: #aaa;
            }

            /* Feature list style */
            .feature-list {
                padding-left: 0;
                list-style-type: none;
            }

            .feature-list li {
                padding: 0.5rem 0;
                display: flex;
                align-items: center;
            }

            /* Check icon for feature list */
            .feature-list i {
                color: #64ffda;
                /* Teal accent color */
                margin-right: 10px;
            }

            /* Premium button */
            .btn-premium {
                background-color: #64ffda;
                /* Teal accent color */
                border: none;
                padding: 10px 0;
                color: #0a192f;
                /* Dark text on light button */
                font-weight: bold;
                border-radius: 30px;
                transition: background-color 0.3s;
            }

            /* Button hover effect */
            .btn-premium:hover {
                background-color: #4ad3b3;
                /* Darker teal on hover */
                color: #0a192f;
            }

            /* MTP-2K Logo */
            .mtp-logo {
                color: #64ffda;
                font-size: 3rem;
                font-weight: bold;
                text-align: center;
                margin-bottom: 1rem;
            }

            /* Logo title style */
            .logo-title {
                font-size: 2.5rem;
                font-weight: bold;
                color: #64ffda;
                text-shadow: 0 0 5px rgba(100, 255, 218, 0.5), 0 0 10px rgba(100, 255, 218, 0.3);
                margin-top: 0rem;
                margin-bottom: 0.5rem;
                text-align: center;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
                position: absolute;
                top: 30px;
                left: 50%;
                transform: translateX(-50%);
                z-index: 20;
                padding: 0 20px;
                letter-spacing: 0.25px;
                font-family: 'Poppins', sans-serif;
                text-transform: uppercase;
            }

            .logo-title:hover {
                transform: translateX(-50%) scale(1.05);
                text-shadow: 0 0 10px rgba(100, 255, 218, 0.8), 0 0 20px rgba(100, 255, 218, 0.5);
                color: #64ffda;
            }

            .logo-title:active {
                transform: translateX(-50%) scale(0.95);
            }

            .header-subtitle {
                position: absolute;
                top: 10vh;
                left: 0;
                width: 100%;
                background: transparent;
                color: #64ffda;
                text-align: center;
                padding: 1vh 0;
                font-size: clamp(0.875rem, 2vw, 1rem);
                z-index: 10;
                text-shadow: 0 0 5px rgba(100, 255, 218, 0.7);
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 1vh;
                font-size: 1.1rem;
            }

            .header-icon {
                color: white;
                margin: 0 5px;
            }

            /* Reset navbar styling */
            .navbar {
                display: none;
            }

            /* Premium title */
            .premium-title {
                color: #64ffda;
                font-size: 2.5rem;
                font-weight: bold;
                margin-bottom: 1rem;
            }

            /* Premium subtitle */
            .premium-subtitle {
                color: #8892b0;
                font-size: 1.1rem;
                margin-bottom: 2rem;
            }

            /* Why choose premium section */
            .why-premium {
                text-align: center;
                margin-top: 3rem;
                margin-bottom: 3rem;
            }

            .why-premium h2 {
                color: #64ffda;
                margin-bottom: 2rem;
            }
        </style>
    </head>

    <body>
        <!-- Main header -->
        <div class="main-header">
            <a href="${pageContext.request.contextPath}/home" class="logo-title">MTP-2K Premium</a>
            <div class="header-subtitle">
                <i class="fas fa-music header-icon"></i>
                Your Music, Your Way
                <i class="fas fa-headphones header-icon"></i>
            </div>
        </div>

        <div class="container">
            <!-- Premium header -->
            <div class="premium-header">
                <p class="premium-subtitle">Unlock the full potential of your music experience with our premium plans.
                    Remove ads and easily adjust songs.</p>
            </div>

            <!-- Premium plans -->
            <div class="row">
                <!-- Weekly Premium -->
                <div class="col-md-4">
                    <div class="pricing-card card h-100">
                        <div class="card-header">
                            <h4>Weekly Premium</h4>
                            <div class="price">6,800 ₫<span class="period">/week</span></div>
                        </div>
                        <div class="card-body">
                            <ul class="feature-list">
                                <li><i class="fas fa-check"></i> Ad-free listening</li>
                                <li><i class="fas fa-check"></i> High quality audio</li>
                                <li><i class="fas fa-check"></i> Download 100 songs</li>
                                <li><i class="fas fa-check"></i> Listen offline</li>
                            </ul>
                        </div>


                        <div class="card-footer bg-transparent border-0 text-center">
                            <a href="${pageContext.request.contextPath}/payment?packageId=1"
                                class="btn btn-premium w-100">Get Started</a>
                        </div>
                    </div>
                </div>

                <!-- Monthly Premium -->
                <div class="col-md-4">
                    <div class="pricing-card card h-100">
                        <div class="card-header">
                            <h4>Monthly Premium</h4>
                            <div class="price">18,600 ₫<span class="period">/month</span></div>
                        </div>
                        <div class="card-body">
                            <ul class="feature-list">
                                <li><i class="fas fa-check"></i> All Basic features</li>
                                <li><i class="fas fa-check"></i> Ultra HD audio</li>
                                <li><i class="fas fa-check"></i> Unlimited downloads</li>
                                <li><i class="fas fa-check"></i> Exclusive content</li>
                                <li><i class="fas fa-check"></i> Priority support</li>
                            </ul>
                        </div>
                        <div class="card-footer bg-transparent border-0 text-center">
                            <a href="${pageContext.request.contextPath}/payment?packageId=2"
                                class="btn btn-premium w-100">Get Premium</a>
                        </div>
                    </div>
                </div>

                <!-- 6-Month Premium -->
                <div class="col-md-4">
                    <div class="pricing-card card h-100">
                        <div class="card-header">
                            <h4>6-Month Premium</h4>
                            <div class="price">99,999 ₫<span class="period">/6 months</span></div>
                        </div>
                        <div class="card-body">
                            <ul class="feature-list">
                                <li><i class="fas fa-check"></i> All Premium features</li>
                                <li><i class="fas fa-check"></i> Up to 5 accounts</li>
                                <li><i class="fas fa-check"></i> Family mix playlist</li>
                                <li><i class="fas fa-check"></i> Parental controls</li>
                                <li><i class="fas fa-check"></i> Split payment</li>
                            </ul>
                        </div>
                        <div class="card-footer bg-transparent border-0 text-center">
                            <a href="${pageContext.request.contextPath}/payment?packageId=3"
                                class="btn btn-premium w-100">Choose Family</a>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <!-- Footer -->
        <footer class="bg-dark text-white py-4 mt-5">
            <div class="container">
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <h5>About MTP-2K</h5>
                        <p class="text-muted">MTP-2K is a music streaming platform that brings you the best music
                            experience.</p>
                    </div>
                    <div class="col-md-4 mb-3">
                        <h5>Quick Links</h5>
                        <ul class="list-unstyled">
                            <li><a href="${pageContext.request.contextPath}/home" class="text-muted">Home</a></li>
                            <li><a href="${pageContext.request.contextPath}/premium" class="text-muted">Premium</a></li>
                        </ul>
                    </div>
                    <div class="col-md-4 mb-3">
                        <h5>Follow Us</h5>
                        <div class="d-flex">
                            <a href="https://www.facebook.com/dp3711" target="_blank" class="text-muted me-3"><i class="fab fa-facebook-f"></i></a>
                            <a href="https://www.youtube.com/@memoriesofkl7263" target="_blank" class="text-muted"><i class="fab fa-youtube"></i></a>
                        </div>
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-12 text-center">
                        <p class="text-muted mb-0">&copy; 2025 MTP-2K. All rights reserved.</p>
                    </div>
                </div>
            </div>
        </footer>
    </body>

    </html>
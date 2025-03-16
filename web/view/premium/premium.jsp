<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Premium - Music Paradise</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                background-color: #0a192f;
                color: #e6f1ff;
                font-family: 'Poppins', sans-serif;
                margin: 0;
                padding: 0;
                min-height: 100vh;
            }

            .premium-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 40px 20px;
            }

            .premium-header {
                text-align: center;
                margin-bottom: 60px;
            }

            .premium-header h1 {
                color: #64ffda;
                font-size: 48px;
                margin-bottom: 20px;
            }

            .premium-header p {
                color: #a8b2d1;
                font-size: 18px;
                max-width: 600px;
                margin: 0 auto;
                line-height: 1.6;
            }

            .plans-container {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 30px;
                margin-top: 40px;
            }

            .plan-card {
                background: #112240;
                border-radius: 15px;
                padding: 30px;
                text-align: center;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                border: 1px solid transparent;
            }

            .plan-card:hover {
                transform: translateY(-10px);
                border-color: #64ffda;
                box-shadow: 0 10px 30px rgba(100, 255, 218, 0.1);
            }

            .plan-name {
                color: #64ffda;
                font-size: 24px;
                margin-bottom: 15px;
            }

            .plan-price {
                font-size: 42px;
                font-weight: 700;
                margin-bottom: 25px;
            }

            .plan-price span {
                font-size: 16px;
                font-weight: normal;
            }

            .features-list {
                list-style: none;
                padding: 0;
                margin: 0 0 30px 0;
            }

            .features-list li {
                padding: 12px 0;
                color: #a8b2d1;
                border-bottom: 1px solid rgba(100, 255, 218, 0.1);
            }

            .features-list li:last-child {
                border-bottom: none;
            }

            .subscribe-btn {
                background: transparent;
                color: #64ffda;
                border: 1px solid #64ffda;
                padding: 12px 30px;
                border-radius: 25px;
                font-size: 16px;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
            }

            .subscribe-btn:hover {
                background: rgba(100, 255, 218, 0.1);
                transform: translateY(-2px);
            }

            .premium-features {
                margin-top: 80px;
                text-align: center;
            }

            .features-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 30px;
                margin-top: 40px;
            }

            .feature-item {
                background: #233554;
                padding: 30px;
                border-radius: 15px;
                transition: transform 0.3s ease;
            }

            .feature-item:hover {
                transform: translateY(-5px);
            }

            .feature-icon {
                color: #64ffda;
                font-size: 36px;
                margin-bottom: 20px;
            }

            .feature-title {
                color: #e6f1ff;
                font-size: 20px;
                margin-bottom: 15px;
            }

            .feature-description {
                color: #a8b2d1;
                font-size: 14px;
                line-height: 1.6;
            }
        </style>
    </head>
    <body>
        <div class="premium-container">
            <div class="premium-header">
                <h1>MTP-2K Premium</h1>
                <p>Unlock the full potential of your music experience with our premium plans. Remove ads and easily adjust songs.</p>
            </div>

            <div class="plans-container">
                <div class="plan-card">
                    <div class="plan-name">Monthly Premium</div>
                    <div class="plan-price">$5.99<span>/month</span></div>
                    <ul class="features-list">
                        <li><i class="fas fa-check"></i> Ad-free listening</li>
                        <li><i class="fas fa-check"></i> High quality audio</li>
                        <li><i class="fas fa-check"></i> Download 100 songs</li>
                        <li><i class="fas fa-check"></i> Listen offline</li>
                    </ul>
                    <a href="#" class="subscribe-btn">Get Started</a>
                </div>

                <div class="plan-card">
                    <div class="plan-name">Quarterly Premium</div>
                    <div class="plan-price">$14.99<span>/month</span></div>
                    <ul class="features-list">
                        <li><i class="fas fa-check"></i> All Basic features</li>
                        <li><i class="fas fa-check"></i> Ultra HD audio</li>
                        <li><i class="fas fa-check"></i> Unlimited downloads</li>
                        <li><i class="fas fa-check"></i> Exclusive content</li>
                        <li><i class="fas fa-check"></i> Priority support</li>
                    </ul>
                    <a href="#" class="subscribe-btn">Get Premium</a>
                </div>

                <div class="plan-card">
                    <div class="plan-name">Yearly Premium</div>
                    <div class="plan-price">$49.99<span>/month</span></div>
                    <ul class="features-list">
                        <li><i class="fas fa-check"></i> All Premium features</li>
                        <li><i class="fas fa-check"></i> Up to 6 accounts</li>
                        <li><i class="fas fa-check"></i> Family mix playlist</li>
                        <li><i class="fas fa-check"></i> Parental controls</li>
                        <li><i class="fas fa-check"></i> Split payment</li>
                    </ul>
                    <a href="#" class="subscribe-btn">Choose Family</a>
                </div>
            </div>

            <div class="premium-features">
                <h2 style="color: #64ffda; margin-bottom: 40px;">Why Choose Premium?</h2>
                <div class="features-grid">
                    <div class="feature-item">
                        <div class="feature-icon">
                            <i class="fas fa-music"></i>
                        </div>
                        <div class="feature-title">High Quality Audio</div>
                        <div class="feature-description">Experience music in ultra HD quality with crystal clear sound.</div>
                    </div>
                    <div class="feature-item">
                        <div class="feature-icon">
                            <i class="fas fa-download"></i>
                        </div>
                        <div class="feature-title">Offline Listening</div>
                        <div class="feature-description">Download your favorite tracks and listen anywhere, anytime.</div>
                    </div>
                    <div class="feature-item">
                        <div class="feature-icon">
                            <i class="fas fa-ban"></i>
                        </div>
                        <div class="feature-title">Ad-Free Experience</div>
                        <div class="feature-description">Enjoy uninterrupted music without any advertisements.</div>
                    </div>
                    <div class="feature-item">
                        <div class="feature-icon">
                            <i class="fas fa-star"></i>
                        </div>
                        <div class="feature-title">Exclusive Content</div>
                        <div class="feature-description">Access to exclusive releases, concerts, and behind-the-scenes content.</div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>

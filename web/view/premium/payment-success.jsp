<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Payment Success - MTP-2K</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                background-color: #0a192f;
                color: white;
                font-family: 'Poppins', sans-serif;
            }

            .success-container {
                max-width: 600px;
                margin: 100px auto;
                background-color: #112240;
                border-radius: 12px;
                padding: 30px;
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
                text-align: center;
            }

            .success-icon {
                font-size: 5rem;
                color: #64ffda;
                margin-bottom: 20px;
            }

            .success-title {
                color: #64ffda;
                font-size: 2rem;
                font-weight: bold;
                margin-bottom: 15px;
            }

            .success-message {
                font-size: 1.1rem;
                margin-bottom: 30px;
            }

            .package-details {
                background-color: rgba(100, 255, 218, 0.1);
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 30px;
                text-align: left;
            }

            .package-details p {
                margin-bottom: 8px;
            }

            .package-details strong {
                color: #64ffda;
            }

            .btn-home {
                background-color: #64ffda;
                border: none;
                color: #0a192f;
                padding: 10px 30px;
                border-radius: 30px;
                font-weight: bold;
                transition: all 0.3s;
            }

            .btn-home:hover {
                background-color: #4ad3b3;
                transform: translateY(-2px);
            }

            .logo-title {
                font-size: 2rem;
                font-weight: bold;
                color: #64ffda;
                text-decoration: none;
                display: block;
                text-align: center;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="success-container">
                <a href="${pageContext.request.contextPath}/home" class="logo-title">MTP-2K</a>

                <div class="success-icon">
                    <i class="fas fa-check-circle"></i>
                </div>

                <h1 class="success-title">Payment Successful!</h1>
                <p class="success-message">Thank you for upgrading to MTP-2K Premium. Your account has been successfully upgraded.</p>

                <div class="package-details">
                    <h4 class="text-center mb-3">Your Premium Package</h4>
                    <p><strong>Package:</strong> ${premiumPackage.name}</p>
                    <p><strong>Duration:</strong> ${premiumPackage.duration} days</p>
                    <p><strong>Amount Paid:</strong> ${premiumPackage.price} ₫</p>
                    <p><strong>Status:</strong> Active</p>
                </div>

                <a href="${pageContext.request.contextPath}/home" class="btn btn-home">
                    <i class="fas fa-home me-2"></i> Back to Home
                </a>
            </div>
        </div>
    </body>
</html>
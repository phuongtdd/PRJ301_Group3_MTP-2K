<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>MTP-2K Payment</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                background-color: #0a192f;
                color: white;
                font-family: 'Poppins', sans-serif;
            }

            .payment-container {
                max-width: 600px;
                margin: 100px auto;
                background-color: #112240;
                border-radius: 12px;
                padding: 30px;
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
            }

            .payment-header {
                text-align: center;
                margin-bottom: 30px;
            }

            .payment-title {
                color: #64ffda;
                font-size: 2rem;
                font-weight: bold;
            }

            .payment-details {
                margin-bottom: 30px;
            }

            .payment-details h4 {
                color: #64ffda;
                margin-bottom: 15px;
            }

            .payment-info {
                background-color: rgba(100, 255, 218, 0.1);
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 20px;
            }

            .payment-info p {
                margin-bottom: 8px;
            }

            .payment-info strong {
                color: #64ffda;
            }

            .btn-back {
                background-color: transparent;
                border: 1px solid #64ffda;
                color: #64ffda;
                padding: 10px 20px;
                border-radius: 30px;
                transition: all 0.3s;
            }

            .btn-back:hover {
                background-color: rgba(100, 255, 218, 0.1);
                color: #64ffda;
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
            <div class="payment-container">
                <a href="${pageContext.request.contextPath}/home" class="logo-title">MTP-2K</a>

                <div class="payment-header">
                    <h1 class="payment-title">Complete Your Payment</h1>
                    <p>Please scan the QR code to complete your payment</p>
                </div>

                <div class="payment-details">
                    <h4>Order Summary</h4>
                    <div class="payment-info">
                        <p><strong>Package:</strong> ${premiumPackage.name}</p>
                        <p><strong>Duration:</strong> ${premiumPackage.duration} days</p>
                        <p><strong>Amount:</strong> ${premiumPackage.price} ₫</p>
                    </div>

                    <h4>Payment Instructions</h4>
                    <ol>
                        <li>Open your banking app</li>
                        <li>Scan the QR code below</li>
                        <li>Confirm the payment details</li>
                        <li>Complete the payment</li>
                        <li>Wait for confirmation (do not close this page)</li>
                    </ol>

                    <div class="text-center my-4">
                        <form id="paymentForm" action="${pageContext.request.contextPath}/payment" method="post">
                            <input type="hidden" name="packageId" value="${premiumPackage.premiumID}">
                            <button type="submit" class="btn btn-primary">Generate QR Code</button>
                        </form>
                    </div>
                </div>

                <div class="text-center">
                    <a href="${pageContext.request.contextPath}/premium" class="btn btn-back">
                        <i class="fas fa-arrow-left me-2"></i> Back to Premium Plans
                    </a>
                </div>
            </div>
        </div>
    </body>
</html>
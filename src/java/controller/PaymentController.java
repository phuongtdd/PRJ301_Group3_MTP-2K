package controller;

import dao.OrderDAO;
import dao.PremiumPackageDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.UUID;
import model.PremiumPackage;
import model.User;
import org.json.JSONObject;

public class PaymentController extends HttpServlet {

    private static final String PAYOS_CLIENT_ID = "d27717a0-0ed4-462e-91a7-ef729810e1df";
    private static final String PAYOS_API_KEY = "6cc14b31-861b-4c8a-8a9d-ce3430decf13";
    private static final String PAYOS_CHECKSUM_KEY = "3d8b100c73fc475688d58e5edb57e5b3810379e63f888b4729ed6131a1a0338b";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            // Display payment page with package details
            int packageId = Integer.parseInt(request.getParameter("packageId"));
            PremiumPackageDAO packageDAO = new PremiumPackageDAO();
            PremiumPackage premiumPackage = packageDAO.getPackageById(packageId);

            request.setAttribute("premiumPackage", premiumPackage);
            request.getRequestDispatcher("/view/premium/payment.jsp").forward(request, response);
        } else if (action.equals("success")) {
            // Handle payment success
            processPaymentSuccess(request, response);
        } else if (action.equals("cancel")) {
            // Handle payment cancellation
            response.sendRedirect(request.getContextPath() + "/premium");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int packageId = Integer.parseInt(request.getParameter("packageId"));

        // Get package details
        PremiumPackageDAO packageDAO = new PremiumPackageDAO();
        PremiumPackage premiumPackage = packageDAO.getPackageById(packageId);

        if (premiumPackage == null) {
            response.sendRedirect(request.getContextPath() + "/premium?error=invalid_package");
            return;
        }

        // Create order in database - status will be 'Pending'
        OrderDAO orderDAO = new OrderDAO();
        int orderId = orderDAO.createOrder(user.getUserID(), 1, packageId, premiumPackage.getPrice());

        if (orderId == -1) {
            response.sendRedirect(request.getContextPath() + "/premium?error=order_creation_failed");
            return;
        }

        // Create PayOS payment request
        try {
            // Generate a numeric order code instead of a string
            long orderCode = System.currentTimeMillis(); // Use current timestamp as order code
            
            String cancelUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
                    + request.getContextPath() + "/payment?action=cancel";
            String returnUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
                    + request.getContextPath() + "/payment?action=success&orderID=" + orderId;

            // Format expiredAt as Unix timestamp in seconds
            long expiredAt = System.currentTimeMillis() / 1000 + 15 * 60; // 15 minutes in seconds

            JSONObject paymentData = new JSONObject();
            paymentData.put("orderCode", orderCode); // Now a numeric value
            paymentData.put("amount", (int) premiumPackage.getPrice());
            paymentData.put("description", "MTP-2K Premium - " + premiumPackage.getName());
            paymentData.put("cancelUrl", cancelUrl);
            paymentData.put("returnUrl", returnUrl);
            paymentData.put("expiredAt", expiredAt);
            
            // Add buyer info if available
            JSONObject buyerInfo = new JSONObject();
            buyerInfo.put("name", user.getUserName());
            buyerInfo.put("email", user.getEmail());
            paymentData.put("buyerInfo", buyerInfo);
            
            // Calculate checksum according to PayOS documentation
            // Format: amount=$amount&cancelUrl=$cancelUrl&description=$description&orderCode=$orderCode&returnUrl=$returnUrl
            String dataToSign = "amount=" + (int) premiumPackage.getPrice() + 
                              "&cancelUrl=" + cancelUrl + 
                              "&description=" + "MTP-2K Premium - " + premiumPackage.getName() + 
                              "&orderCode=" + orderCode + 
                              "&returnUrl=" + returnUrl;
            
            System.out.println("Data to sign: " + dataToSign);
            
            // Tạo HMAC-SHA256
            javax.crypto.Mac hmacSha256 = javax.crypto.Mac.getInstance("HmacSHA256");
            javax.crypto.spec.SecretKeySpec secretKey = new javax.crypto.spec.SecretKeySpec(
                    PAYOS_CHECKSUM_KEY.getBytes(java.nio.charset.StandardCharsets.UTF_8), "HmacSHA256");
            hmacSha256.init(secretKey);
            byte[] hash = hmacSha256.doFinal(dataToSign.getBytes(java.nio.charset.StandardCharsets.UTF_8));
            
            // Chuyển đổi byte array thành chuỗi hex
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                hexString.append(String.format("%02x", b)); // Đảm bảo luôn có 2 ký tự hex cho mỗi byte
            }
            
            // Add signature to request
            String signature = hexString.toString();
            System.out.println("Generated signature: " + signature);
            paymentData.put("signature", signature);

            // Store order info in session for verification later
            session.setAttribute("pendingOrderId", orderId);
            session.setAttribute("pendingPackageId", packageId);

            // Make API call to PayOS
            HttpClient client = HttpClient.newHttpClient();
            HttpRequest payosRequest = HttpRequest.newBuilder()
                    .uri(URI.create("https://api-merchant.payos.vn/v2/payment-requests"))
                    .header("Content-Type", "application/json")
                    .header("x-client-id", PAYOS_CLIENT_ID)
                    .header("x-api-key", PAYOS_API_KEY)
                    .POST(HttpRequest.BodyPublishers.ofString(paymentData.toString()))
                    .build();

            System.out.println("PayOS Request: " + paymentData.toString());
            
            HttpResponse<String> payosResponse = client.send(payosRequest, HttpResponse.BodyHandlers.ofString());
            String responseBody = payosResponse.body();
            System.out.println("PayOS Response: " + responseBody);
            
            JSONObject responseJson = new JSONObject(responseBody);

            if (responseJson.getInt("code") == 00) {
                JSONObject data = responseJson.getJSONObject("data");
                String checkoutUrl = data.getString("checkoutUrl");

                // Redirect to PayOS checkout page
                response.sendRedirect(checkoutUrl);
            } else {
                // Payment creation failed
                System.out.println("Payment creation failed. Response code: " + responseJson.getInt("code"));
                System.out.println("Error message: " + (responseJson.has("desc") ? responseJson.getString("desc") : "No description"));
                response.sendRedirect(request.getContextPath() + "/premium?error=payment_creation_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Exception in PayOS API call: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/premium?error=payment_error");
        }
    }

    private void processPaymentSuccess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get order info from session
        Integer orderId = (Integer) session.getAttribute("pendingOrderId");
        Integer packageId = (Integer) session.getAttribute("pendingPackageId");

        if (orderId == null || packageId == null) {
            response.sendRedirect(request.getContextPath() + "/premium?error=invalid_session");
            return;
        }

        // Clear session attributes
        session.removeAttribute("pendingOrderId");
        session.removeAttribute("pendingPackageId");

        // Verify payment with PayOS (in a real implementation)
        // For now, we'll assume payment is successful
        // Update order status
        OrderDAO orderDAO = new OrderDAO();
        boolean orderUpdated = orderDAO.updateOrderStatus(orderId, "Completed");

        if (!orderUpdated) {
            response.sendRedirect(request.getContextPath() + "/premium?error=order_update_failed");
            return;
        }

        // Get package details
        PremiumPackageDAO packageDAO = new PremiumPackageDAO();
        PremiumPackage premiumPackage = packageDAO.getPackageById(packageId);

        if (premiumPackage == null) {
            response.sendRedirect(request.getContextPath() + "/premium?error=invalid_package");
            return;
        }

        // Update user's premium expiry
        UserDAO userDAO = new UserDAO();
        boolean premiumUpdated = userDAO.updatePremiumExpiry(user.getUserID(), premiumPackage.getDuration());

        if (!premiumUpdated) {
            response.sendRedirect(request.getContextPath() + "/premium?error=premium_update_failed");
            return;
        }

        // Update user in session
        User updatedUser = userDAO.getUserById(user.getUserID());
        session.setAttribute("user", updatedUser);

        // Redirect to success page
        request.setAttribute("premiumPackage", premiumPackage);
        request.getRequestDispatcher("/view/premium/payment-success.jsp").forward(request, response);
    }
}

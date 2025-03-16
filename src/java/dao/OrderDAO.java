package dao;

import connect.DBConnection;
import java.util.Calendar;
import java.util.Date;
import model.OrderDetail;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    private Connection conn;

    // Constructor với connection
    public OrderDAO() {
        this.conn = DBConnection.getConnection();
        if (this.conn == null) {
            System.out.println("❌ Lỗi: Không thể kết nối database trong LibraryDAO!");
        } else {
            System.out.println("✅ LibraryDAO đã kết nối database thành công!");
        }
    }

    public List<OrderDetail> getAllOrderDetails() {
        List<OrderDetail> orderDetails = new ArrayList<>();
        String sql = "SELECT o.orderID, o.orderDate, o.amount, o.status, "
                + "u.userID, u.userName, u.email, u.fullName, "
                + "p.paymentID, p.name AS paymentName, "
                + "pp.premiumID, pp.name AS packageName, pp.duration "
                + "FROM Orders o "
                + "JOIN Users u ON o.userID = u.userID "
                + "JOIN Payments p ON o.paymentID = p.paymentID "
                + "JOIN Premium_Packages pp ON o.premiumID = pp.premiumID "
                + "ORDER BY o.orderDate DESC";

        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                OrderDetail orderDetail = new OrderDetail();
                orderDetail.setOrderID(rs.getInt("orderID"));
                orderDetail.setOrderDate(rs.getTimestamp("orderDate"));
                orderDetail.setAmount(rs.getDouble("amount"));
                orderDetail.setStatus(rs.getString("status"));

                // User info
                orderDetail.setUserID(rs.getInt("userID"));
                orderDetail.setUserName(rs.getString("userName"));
                orderDetail.setUserEmail(rs.getString("email"));
                orderDetail.setUserFullName(rs.getString("fullName"));

                // Payment info
                orderDetail.setPaymentID(rs.getInt("paymentID"));
                orderDetail.setPaymentName(rs.getString("paymentName"));

                // Premium package info
                orderDetail.setPremiumID(rs.getInt("premiumID"));
                orderDetail.setPackageName(rs.getString("packageName"));
                orderDetail.setDuration(rs.getInt("duration"));

                // Calculate expiry date
                Date orderDate = orderDetail.getOrderDate();
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(orderDate);
                calendar.add(Calendar.DAY_OF_MONTH, orderDetail.getDuration());
                orderDetail.setExpiryDate(calendar.getTime());

                orderDetails.add(orderDetail);
            }

            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderDetails;
    }

    public List<OrderDetail> getOrderDetailsByUserID(int userID) {
        List<OrderDetail> orderDetails = new ArrayList<>();
        String sql = "SELECT o.orderID, o.orderDate, o.amount, o.status, "
                + "u.userID, u.userName, u.email, u.fullName, "
                + "p.paymentID, p.name AS paymentName, "
                + "pp.premiumID, pp.name AS packageName, pp.duration "
                + "FROM Orders o "
                + "JOIN Users u ON o.userID = u.userID "
                + "JOIN Payments p ON o.paymentID = p.paymentID "
                + "JOIN Premium_Packages pp ON o.premiumID = pp.premiumID "
                + "WHERE o.userID = ? "
                + "ORDER BY o.orderDate DESC";

        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                OrderDetail orderDetail = new OrderDetail();
                orderDetail.setOrderID(rs.getInt("orderID"));
                orderDetail.setOrderDate(rs.getTimestamp("orderDate"));
                orderDetail.setAmount(rs.getDouble("amount"));
                orderDetail.setStatus(rs.getString("status"));

                // User info
                orderDetail.setUserID(rs.getInt("userID"));
                orderDetail.setUserName(rs.getString("userName"));
                orderDetail.setUserEmail(rs.getString("email"));
                orderDetail.setUserFullName(rs.getString("fullName"));

                // Payment info
                orderDetail.setPaymentID(rs.getInt("paymentID"));
                orderDetail.setPaymentName(rs.getString("paymentName"));

                // Premium package info
                orderDetail.setPremiumID(rs.getInt("premiumID"));
                orderDetail.setPackageName(rs.getString("packageName"));
                orderDetail.setDuration(rs.getInt("duration"));

                // Calculate expiry date
                Date orderDate = orderDetail.getOrderDate();
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(orderDate);
                calendar.add(Calendar.DAY_OF_MONTH, orderDetail.getDuration());
                orderDetail.setExpiryDate(calendar.getTime());

                orderDetails.add(orderDetail);
            }

            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderDetails;
    }

    public static void main(String[] args) {
        // Khởi tạo OrderDAO
        OrderDAO orderDAO = new OrderDAO();

        // Lấy tất cả chi tiết đơn hàng
        List<OrderDetail> orderDetails = orderDAO.getAllOrderDetails();

        // Kiểm tra và in kết quả
        if (orderDetails.isEmpty()) {
            System.out.println("Không có đơn hàng nào trong cơ sở dữ liệu!");
        } else {
            System.out.println("Danh sách tất cả đơn hàng:");
            for (OrderDetail order : orderDetails) {
                System.out.println("------------------------");
                System.out.println("Order ID: " + order.getOrderID());
                System.out.println("Order Date: " + order.getOrderDate());
                System.out.println("Amount: " + order.getAmount());
                System.out.println("Status: " + order.getStatus());
                System.out.println("User ID: " + order.getUserID());
                System.out.println("User Name: " + order.getUserName());
                System.out.println("User Email: " + order.getUserEmail());
                System.out.println("User Full Name: " + order.getUserFullName());
                System.out.println("Payment ID: " + order.getPaymentID());
                System.out.println("Payment Name: " + order.getPaymentName());
                System.out.println("Premium ID: " + order.getPremiumID());
                System.out.println("Package Name: " + order.getPackageName());
                System.out.println("Duration: " + order.getDuration() + " days");
                System.out.println("Expiry Date: " + order.getExpiryDate());
                System.out.println("------------------------");
            }
            System.out.println("Tổng số đơn hàng: " + orderDetails.size());
        }
    }
}

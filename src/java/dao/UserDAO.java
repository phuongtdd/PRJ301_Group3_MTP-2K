/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import connect.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.*;

/**
 *
 * @author HP
 */
public class UserDAO {

    private Connection conn;

    public UserDAO() {
        this.conn = DBConnection.getConnection();
        if (this.conn == null) {
            System.out.println("❌ Lỗi: Không thể kết nối database trong LibraryDAO!");
        } else {
            System.out.println("✅ LibraryDAO đã kết nối database thành công!");
        }
    }

    //---------------------------------------------- ✅ Đăng nhập-------------------------------------------------------//
    public User login(String userName, String password) {
        String sql = "SELECT * FROM Users WHERE userName = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userName);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new User(rs.getInt("userID"), rs.getString("userName"),
                        rs.getString("password"), rs.getString("email"),
                        rs.getString("fullName"), rs.getString("phone"),
                        rs.getDate("createdAt"), rs.getDate("premium_expiry"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ----------------------------------------------✅ Đăng ký--------------------------------------------------//
    public boolean register(User user) {
        String userSql = "INSERT INTO Users (userName, password, email, fullName, phone, createdAt, premium_expiry) VALUES (?, ?, ?, ?, ?, GETDATE(), NULL)";
        String roleSql = "INSERT INTO User_Roles (userID, roleID) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement userPs = conn.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS)) {

            // Đảm bảo Auto-Commit được bật
            conn.setAutoCommit(true);

            // Chèn user vào bảng Users
            userPs.setString(1, user.getUserName());
            userPs.setString(2, user.getPassword());
            userPs.setString(3, user.getEmail());
            userPs.setString(4, user.getFullName());
            userPs.setString(5, user.getPhone());

            int affectedRows = userPs.executeUpdate();
            if (affectedRows == 0) {
                System.out.println("⚠ Không có user nào được thêm vào bảng Users!");
                return false;
            }

            // Chờ một chút để đảm bảo userID đã có (nếu database có độ trễ)
            Thread.sleep(100); // Tạm dừng 100ms để database cập nhật

            // Lấy userID vừa tạo
            try (ResultSet generatedKeys = userPs.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int userID = generatedKeys.getInt(1);
                    System.out.println("✅ User được tạo với ID: " + userID);

                    // Thêm user vào bảng User_Roles với roleID = 2 (User)
                    try (PreparedStatement rolePs = conn.prepareStatement(roleSql)) {
                        rolePs.setInt(1, userID);
                        rolePs.setInt(2, 2); // roleID = 2 (User)
                        boolean roleInserted = rolePs.executeUpdate() > 0;

                        if (!roleInserted) {
                            System.out.println("⚠ Thêm vào User_Roles thất bại!");
                        }

                        return roleInserted;
                    }
                } else {
                    System.out.println("⚠ Không lấy được userID từ generatedKeys! Thử lấy lại...");

                    // Nếu không lấy được userID, thử lấy lại bằng cách query trực tiếp
                    String getIdSql = "SELECT userID FROM Users WHERE userName = ?";
                    try (PreparedStatement getIdPs = conn.prepareStatement(getIdSql)) {
                        getIdPs.setString(1, user.getUserName());
                        try (ResultSet rs = getIdPs.executeQuery()) {
                            if (rs.next()) {
                                int userID = rs.getInt("userID");
                                System.out.println("✅ Lấy lại userID thành công: " + userID);

                                // Thêm user vào bảng User_Roles với roleID = 2 (User)
                                try (PreparedStatement rolePs = conn.prepareStatement(roleSql)) {
                                    rolePs.setInt(1, userID);
                                    rolePs.setInt(2, 2); // roleID = 2 (User)
                                    return rolePs.executeUpdate() > 0;
                                }
                            }
                        }
                    }
                }
            }
        } catch (SQLException | InterruptedException e) {
            e.printStackTrace();
        }
        return false;
    }

    //---------------------------------------------- ✅ Đổi mật khẩu -------------------------------------------------------//
    public boolean updatePassword(int userID, String newPassword) {
        String sql = "UPDATE Users SET password = ? WHERE userID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword);
            ps.setInt(2, userID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    //---------------------------------------------- ✅ Đổi email -------------------------------------------------------//
    public boolean updateEmail(int userID, String newEmail) {
        String sql = "UPDATE Users SET email = ? WHERE userID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newEmail);
            ps.setInt(2, userID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    //---------------------------------------------- ✅ Đổi số điện thoại -------------------------------------------------------//
    public boolean updatePhone(int userID, String newPhone) {
        String sql = "UPDATE Users SET phone = ? WHERE userID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPhone);
            ps.setInt(2, userID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

//---------------------------------------------- ✅ Xóa tài khoản -------------------------------------------------------//
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM Users WHERE userID = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}

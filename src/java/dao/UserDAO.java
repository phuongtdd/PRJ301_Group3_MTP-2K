/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import connect.DBConnection;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
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

    // ---------------------------------------------- ✅ Đăng
    // nhập-------------------------------------------------------//
    public User login(String userName, String password) {
        String sql = "SELECT u.userID, u.userName, u.password, u.email, u.fullName, u.phone, "
                + "u.createdAt, u.premium_expiry, r.roleID, r.roleName "
                + "FROM Users u "
                + "LEFT JOIN User_Roles ur ON u.userID = ur.userID "
                + "LEFT JOIN Roles r ON ur.roleID = r.roleID "
                + "WHERE u.userName = ? AND u.password = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userName);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            User user = null;
            while (rs.next()) {
                // Nếu chưa tạo đối tượng User, tạo mới
                if (user == null) {
                    user = new User(
                            rs.getInt("userID"),
                            rs.getString("userName"),
                            rs.getString("password"),
                            rs.getString("email"),
                            rs.getString("fullName"),
                            rs.getString("phone"),
                            rs.getDate("createdAt"),
                            rs.getDate("premium_expiry")
                    );
                }

                // Thêm vai trò nếu có
                int roleID = rs.getInt("roleID");
                List<String> roles = new ArrayList<>();

                if (!rs.wasNull()) { // Kiểm tra roleID không null
                    String roleName = rs.getString("roleName");
                    roles.add(roleName);
                    user.setRoles(roles);
                }
            }

            return user; // Trả về null nếu không tìm thấy người dùng
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ----------------------------------------------✅ Đăng
    // ký--------------------------------------------------//
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

    // ---------------------------------------------- ✅ Đổi mật khẩu
    // -------------------------------------------------------//
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

    // ---------------------------------------------- ✅ Đổi email
    // -------------------------------------------------------//
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

    // ---------------------------------------------- ✅ Đổi số điện thoại
    // -------------------------------------------------------//
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

    // ---------------------------------------------- ✅ Xóa tài khoản
    // -------------------------------------------------------//
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

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String query = """
                SELECT u.*, STRING_AGG(r.roleName, ',') as roles
                FROM Users u
                LEFT JOIN User_Roles ur ON u.userID = ur.userID
                LEFT JOIN Roles r ON ur.roleID = r.roleID
                GROUP BY u.userID, u.userName, u.password, u.email, u.fullName,
                         u.phone, u.createdAt, u.premium_expiry
                """;

        try {
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                User user = new User(
                        rs.getInt("userID"),
                        rs.getString("userName"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("fullName"),
                        rs.getString("phone"),
                        rs.getTimestamp("createdAt"),
                        rs.getTimestamp("premium_expiry"));

                // Convert comma-separated roles to List
                String rolesStr = rs.getString("roles");
                if (rolesStr != null) {
                    List<String> rolesList = new ArrayList<>();
                    for (String role : rolesStr.split(",")) {
                        rolesList.add(role.trim());
                    }
                    user.setRoles(rolesList);
                }

                users.add(user);
            }
        } catch (SQLException e) {
            System.out.println("Error in getAllUsers: " + e.getMessage());
        } finally {
            closeResources(ps, rs);
        }
        return users;
    }

    public User getUserById(int userId) {
        User user = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String query = """
                SELECT u.*, STRING_AGG(r.roleName, ',') as roles
                FROM Users u
                LEFT JOIN User_Roles ur ON u.userID = ur.userID
                LEFT JOIN Roles r ON ur.roleID = r.roleID
                WHERE u.userID = ?
                GROUP BY u.userID, u.userName, u.password, u.email, u.fullName,
                         u.phone, u.createdAt, u.premium_expiry
                """;

        try {
            ps = conn.prepareStatement(query);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            if (rs.next()) {
                user = new User(
                        rs.getInt("userID"),
                        rs.getString("userName"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("fullName"),
                        rs.getString("phone"),
                        rs.getTimestamp("createdAt"),
                        rs.getTimestamp("premium_expiry"));

                // Convert comma-separated roles to List
                String rolesStr = rs.getString("roles");
                if (rolesStr != null) {
                    List<String> rolesList = new ArrayList<>();
                    for (String role : rolesStr.split(",")) {
                        rolesList.add(role.trim());
                    }
                    user.setRoles(rolesList);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getUserById: " + e.getMessage());
        } finally {
            closeResources(ps, rs);
        }
        return user;
    }

    public List<User> searchUsers(String searchTerm, String roleFilter) {
        List<User> users = new ArrayList<>();
        StringBuilder queryBuilder = new StringBuilder();
        PreparedStatement ps = null;
        ResultSet rs = null;

        queryBuilder.append("""
                    SELECT u.*, STRING_AGG(r.roleName, ',') as roles
                    FROM Users u
                    LEFT JOIN User_Roles ur ON u.userID = ur.userID
                    LEFT JOIN Roles r ON ur.roleID = r.roleID
                    WHERE 1=1
                """);

        // Add search condition if searchTerm is provided
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            queryBuilder.append("""
                        AND (
                            u.userName LIKE ? OR
                            u.email LIKE ? OR
                            u.fullName LIKE ?
                        )
                    """);
        }

        // Add role filter if provided
        if (roleFilter != null && !roleFilter.trim().isEmpty()) {
            queryBuilder.append(" AND ur.roleID = ?");
        }

        // Add group by
        queryBuilder.append("""
                    GROUP BY u.userID, u.userName, u.password, u.email, u.fullName,
                             u.phone, u.createdAt, u.premium_expiry
                """);

        try {
            ps = conn.prepareStatement(queryBuilder.toString());

            int paramIndex = 1;
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String searchPattern = "%" + searchTerm.trim() + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }

            if (roleFilter != null && !roleFilter.trim().isEmpty()) {
                ps.setString(paramIndex, roleFilter);
            }

            rs = ps.executeQuery();

            while (rs.next()) {
                User user = new User(
                        rs.getInt("userID"),
                        rs.getString("userName"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("fullName"),
                        rs.getString("phone"),
                        rs.getTimestamp("createdAt"),
                        rs.getTimestamp("premium_expiry"));

                String rolesStr = rs.getString("roles");
                if (rolesStr != null) {
                    List<String> rolesList = new ArrayList<>();
                    for (String role : rolesStr.split(",")) {
                        rolesList.add(role.trim());
                    }
                    user.setRoles(rolesList);
                }

                users.add(user);
            }
        } catch (SQLException e) {
            System.out.println("Error in searchUsers: " + e.getMessage());
        }
        return users;
    }

    private void closeResources(PreparedStatement ps, ResultSet rs) {

        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            System.out.println("Error closing resources: " + e.getMessage());
        }
    }

    public List<String> getUserRolesByID(int userID) {
        List<String> roles = new ArrayList<>();
        String sql = "SELECT r.roleName FROM Roles r "
                + "JOIN User_Roles ur ON r.roleID = ur.roleID "
                + "WHERE ur.userID = ?";

        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                roles.add(rs.getString("roleName"));
            }

            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return roles;
    }

    public static void main(String[] args) {
        UserDAO userDAO = new UserDAO();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        // Test getAllUsers
        System.out.println("=== Testing getAllUsers ===");
        List<User> users = userDAO.getAllUsers();

        for (User user : users) {
            System.out.println("\nUser Information:");
            System.out.println("ID: " + user.getUserID());
            System.out.println("Username: " + user.getUserName());
            System.out.println("Email: " + user.getEmail());
            System.out.println("Full Name: " + user.getFullName());
            System.out.println("Phone: " + user.getPhone());
            System.out
                    .println("Created At: " + (user.getCreatedAt() != null ? sdf.format(user.getCreatedAt()) : "N/A"));
            System.out.println("Premium Expiry: "
                    + (user.getPremiumExpiry() != null ? sdf.format(user.getPremiumExpiry()) : "N/A"));
            System.out.println("Roles: " + (user.getRoles() != null ? String.join(", ", user.getRoles()) : "No roles"));
            System.out.println("----------------------------------------");
        }

        // Test getUserById
        System.out.println("\n=== Testing getUserById ===");
        int testUserId = 1; // Testing with user ID 1
        User user = userDAO.getUserById(testUserId);

        if (user != null) {
            System.out.println("\nFound User Information:");
            System.out.println("ID: " + user.getUserID());
            System.out.println("Username: " + user.getUserName());
            System.out.println("Email: " + user.getEmail());
            System.out.println("Full Name: " + user.getFullName());
            System.out.println("Phone: " + user.getPhone());
            System.out
                    .println("Created At: " + (user.getCreatedAt() != null ? sdf.format(user.getCreatedAt()) : "N/A"));
            System.out.println("Premium Expiry: "
                    + (user.getPremiumExpiry() != null ? sdf.format(user.getPremiumExpiry()) : "N/A"));
            System.out.println("Roles: " + (user.getRoles() != null ? String.join(", ", user.getRoles()) : "No roles"));
        } else {
            System.out.println("User not found with ID: " + testUserId);
        }
    }
}

package dao;

import connect.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.PremiumPackage;

public class PremiumPackageDAO {

    private Connection conn;

    public PremiumPackageDAO() {
        this.conn = DBConnection.getConnection();
    }
    
    //Lấy thông tin gói PREMIUM

    public List<PremiumPackage> getAllPackages() {
        List<PremiumPackage> packages = new ArrayList<>();
        String sql = "SELECT * FROM Premium_Packages";

        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                PremiumPackage pkg = new PremiumPackage(
                        rs.getInt("premiumID"),
                        rs.getString("name"),
                        rs.getDouble("price"),
                        rs.getInt("duration")
                );
                packages.add(pkg);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return packages;
    }

    public PremiumPackage getPackageById(int premiumID) {
        String sql = "SELECT * FROM Premium_Packages WHERE premiumID = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, premiumID);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new PremiumPackage(
                            rs.getInt("premiumID"),
                            rs.getString("name"),
                            rs.getDouble("price"),
                            rs.getInt("duration")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
}

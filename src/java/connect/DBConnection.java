package connect;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String DB_Name = "MTP2K";
    private static final String DESKTOP_NAME = "DESKTOP-JEJM424";
    private static final String DB_URL = "jdbc:sqlserver://" + DESKTOP_NAME + ";databaseName=" + DB_Name + ";encrypt=false;trustServerCertificate=false;loginTimeout=30";
    private static final String USER = "sa";
    private static final String PASSWORD = "2762004";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(DB_URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return conn;
    }
}

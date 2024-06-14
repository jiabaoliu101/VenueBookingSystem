package cn.work.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/VenueBookingSystemNew?useSSL=false&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASSWORD = "12345678";

    static {
        try {
            // 加载MySQL JDBC驱动程序
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}

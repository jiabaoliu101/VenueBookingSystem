package cn.work.dao;

import cn.work.dto.VenueDTO;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class VenueDAO {

    // 数据库连接配置
    private String jdbcURL = "jdbc:mysql://localhost:3306/VenueBookingSystemNew?useSSL=false&characterEncoding=UTF-8";
    private String jdbcUsername = "root";
    private String jdbcPassword = "12345678";

    // JDBC 驱动名和数据库 URL
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";

    // 获取数据库连接
    private Connection getConnection() throws SQLException {
        Connection conn = null;
        try {
            Class.forName(JDBC_DRIVER);  // 注册 JDBC 驱动
            conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword); // 打开链接
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            System.out.println("Error loading JDBC Driver");
        }
        return conn;
    }

    // 获取所有场馆信息
    public List<VenueDTO> getAllVenues() throws SQLException {
        List<VenueDTO> venues = new ArrayList<>();
        String sql = "SELECT id, name FROM Venues";
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                VenueDTO venue = new VenueDTO(id, name);
                venues.add(venue);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new SQLException("Cannot retrieve venues from database.", e);
        }
        return venues;
    }
}

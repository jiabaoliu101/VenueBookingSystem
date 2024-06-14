package cn.work.dao;

import cn.work.dto.UserDTO;
import cn.work.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
    public UserDTO getUserByEmailAndPassword(String email, String password) throws SQLException {
        UserDTO user = null;
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT email, password, name, contact FROM users WHERE email = ? AND password = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, email);
                pstmt.setString(2, password);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        user = new UserDTO();
                        user.setEmail(rs.getString("email"));
                        user.setPassword(rs.getString("password"));
                        user.setName(rs.getString("name"));
                        user.setContact(rs.getString("contact"));
                    }
                }
            }
        }
        return user;
    }

    public boolean registerUser(UserDTO user) throws SQLException {
        boolean result = false;
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO Users (name, email, password, contact) VALUES (?, ?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, user.getName());
                pstmt.setString(2, user.getEmail());
                pstmt.setString(3, user.getPassword());
                pstmt.setString(4, user.getContact());

                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    result = true;
                }
            }
        }
        return result;
    }

}

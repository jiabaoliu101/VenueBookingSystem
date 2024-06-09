<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.DataSource" %>
<!DOCTYPE html>
<html>
<head>
    <title>注册</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<%
    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String contact = request.getParameter("contact");

        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "INSERT INTO Users (name, email, password, contact) VALUES (?, ?, ?, ?)";

        try {
            // 修改为您的数据库配置
            String jdbcURL = "jdbc:mysql://localhost:3306/VenueBookingSystemNew?useSSL=false&characterEncoding=UTF-8";
            String jdbcUsername = "root";
            String jdbcPassword = "12345678";

            Class.forName("com.mysql.cj.jdbc.Driver");

            conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, email);
            pstmt.setString(3, password); // 实际应用中应加密存储
            pstmt.setString(4, contact);

            int result = pstmt.executeUpdate();
            if (result > 0) {
                message = "注册成功！";
            } else {
                message = "注册失败！";
            }
        } catch (Exception e) {
            message = "数据库错误：" + e.getMessage();
            e.printStackTrace();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
%>
<h2>用户注册</h2>
<% if (!"".equals(message)) { %>
<p><%= message %></p>
<% } %>
<form method="POST">
    姓名: <input type="text" name="name" required><br>
    电子邮箱: <input type="email" name="email" required><br>
    密码: <input type="password" name="password" required><br>
    联系方式: <input type="text" name="contact" required><br>
    <input type="submit" value="注册">
</form>
</body>
</html>

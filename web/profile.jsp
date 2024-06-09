<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="javax.servlet.http.Part" %>
<%@ page import="java.io.File" %>
<!DOCTYPE html>
<html>
<head>
  <title>用户信息</title>
  <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<%
  // 检查用户是否已登录
  if (session.getAttribute("user") == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  String email = session.getAttribute("user").toString();
  String name = "";
  String contact = "";
  String avatarPath = "";

  Connection conn = null;
  PreparedStatement pstmt = null;
  ResultSet rs = null;
  String message = "";

  if ("POST".equalsIgnoreCase(request.getMethod())) {
    Part filePart = request.getPart("avatar");
    if (filePart != null && filePart.getSize() > 0) {
      String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
      String uploadPath = application.getRealPath("/") + "uploads";
      File uploadDir = new File(uploadPath);
      if (!uploadDir.exists()) uploadDir.mkdir();
      filePart.write(uploadPath + File.separator + fileName);
      avatarPath = "uploads/" + fileName;

      String updateSql = "UPDATE Users SET avatar_path = ? WHERE email = ?";
      try {
        String jdbcURL = "jdbc:mysql://localhost:3306/VenueBookingSystemNew?useSSL=false&characterEncoding=UTF-8";
        String jdbcUsername = "root";
        String jdbcPassword = "12345678";

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

        pstmt = conn.prepareStatement(updateSql);
        pstmt.setString(1, avatarPath);
        pstmt.setString(2, email);
        int result = pstmt.executeUpdate();
        if (result > 0) {
          message = "头像更新成功！";
        } else {
          message = "头像更新失败！";
        }
      } catch (Exception e) {
        message = "数据库错误：" + e.getMessage();
        e.printStackTrace();
      } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
      }
    }
  }

  String selectSql = "SELECT name, contact, avatar_path FROM Users WHERE email = ?";
  try {
    String jdbcURL = "jdbc:mysql://localhost:3306/VenueBookingSystemNew?useSSL=false&characterEncoding=UTF-8";
    String jdbcUsername = "root";
    String jdbcPassword = "12345678";

    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

    pstmt = conn.prepareStatement(selectSql);
    pstmt.setString(1, email);
    rs = pstmt.executeQuery();

    if (rs.next()) {
      name = rs.getString("name");
      contact = rs.getString("contact");
      avatarPath = rs.getString("avatar_path");
    }
  } catch (Exception e) {
    e.printStackTrace();
  } finally {
    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
  }
%>
<h2>用户信息</h2>
<% if (!"".equals(message)) { %>
<p><%= message %></p>
<% } %>
<p>姓名: <%= name %></p>
<p>电子邮箱: <%= email %></p>
<p>联系方式: <%= contact %></p>
<p>头像: <br><img src="<%= avatarPath %>" alt="用户头像" width="100"></p>
<form method="POST" enctype="multipart/form-data">
  修改头像: <input type="file" name="avatar"><br>
  <input type="submit" value="更新头像">
</form>
</body>
</html>

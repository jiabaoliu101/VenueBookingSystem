<%--<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>--%>
<%--<%@ page import="java.sql.*" %>--%>
<%--<%@ page import="javax.naming.*" %>--%>
<%--<%@ page import="javax.sql.DataSource" %>--%>
<%--<!DOCTYPE html>--%>
<%--<html>--%>
<%--<head>--%>
<%--  <title>登录</title>--%>
<%--  <link rel="stylesheet" type="text/css" href="style.css">--%>
<%--</head>--%>
<%--<body>--%>

<%--<div class="container">--%>
<%--  <h2>用户登录</h2>--%>
<%--  <%--%>
<%--    String email = request.getParameter("email");--%>
<%--    String password = request.getParameter("password");--%>
<%--    String message = null;--%>
<%--    boolean isAuthenticated = false;--%>

<%--    if ("POST".equalsIgnoreCase(request.getMethod()) && email != null && password != null) {--%>
<%--      // 这里写数据库验证逻辑--%>
<%--      Connection conn = null;--%>
<%--      PreparedStatement pstmt = null;--%>
<%--      ResultSet rs = null;--%>

<%--      try {--%>
<%--          String jdbcURL = "jdbc:mysql://localhost:3306/VenueBookingSystemNew?useSSL=false&characterEncoding=UTF-8";--%>
<%--        String jdbcUsername = "root";--%>
<%--        String jdbcPassword = "12345678";--%>

<%--        Class.forName("com.mysql.cj.jdbc.Driver");--%>
<%--        conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);--%>

<%--        String sql = "SELECT * FROM users WHERE email = ? AND password = ?"; // 在实际应用中，密码不应明文存储与比较--%>
<%--        pstmt = conn.prepareStatement(sql);--%>
<%--        pstmt.setString(1, email);--%>
<%--        pstmt.setString(2, password);--%>

<%--        rs = pstmt.executeQuery();--%>

<%--        if (rs.next()) {--%>
<%--          isAuthenticated = true;--%>
<%--          // 登录成功后的代码，例如设置session属性--%>
<%--          session.setAttribute("user", rs.getString("name"));--%>
<%--          // 跳转到登录成功的页面--%>
<%--          response.sendRedirect("success.jsp");--%>
<%--          return; // 跳出--%>
<%--        } else {--%>
<%--          message = "电子邮箱或密码错误，请重试。";--%>
<%--        }--%>
<%--      } catch (Exception e) {--%>
<%--        message = "数据库连接失败：" + e.getMessage();--%>
<%--        e.printStackTrace();--%>
<%--      } finally {--%>
<%--        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }--%>
<%--        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }--%>
<%--        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }--%>
<%--      }--%>
<%--    }--%>

<%--    if (message != null && !isAuthenticated) {--%>
<%--  %>--%>
<%--  <p class="message"><%= message %></p>--%>
<%--  <% } %>--%>

<%--  <form method="POST">--%>
<%--    电子邮箱: <input type="email" name="email" required><br>--%>
<%--    密码: <input type="password" name="password" required><br>--%>
<%--    <input type="submit" value="登录">--%>
<%--  </form>--%>
<%--  <p>还没有账号？<a href="register.jsp">注册新用户</a></p>--%>
<%--</div>--%>

<%--</body>--%>
<%--</html>--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.DataSource" %>
<!DOCTYPE html>
<html>
<head>
  <title>登录</title>
  <link rel="stylesheet" type="text/css" href="login.css">
</head>
<body>

<div class="login-container">
  <div class="login-box">
    <h2>用户登录</h2>
    <%
      String email = request.getParameter("email");
      String password = request.getParameter("password");
      String message = null;
      boolean isAuthenticated = false;

      if ("POST".equalsIgnoreCase(request.getMethod()) && email != null && password != null) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
          String jdbcURL = "jdbc:mysql://localhost:3306/VenueBookingSystemNew?useSSL=false&characterEncoding=UTF-8";
          String jdbcUsername = "root";
          String jdbcPassword = "12345678";

          Class.forName("com.mysql.cj.jdbc.Driver");
          conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

          String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
          pstmt = conn.prepareStatement(sql);
          pstmt.setString(1, email);
          pstmt.setString(2, password);

          rs = pstmt.executeQuery();

          if (rs.next()) {
            isAuthenticated = true;
            session.setAttribute("user", rs.getString("name"));
            response.sendRedirect("index.jsp");


            return;
          } else {
            message = "电子邮箱或密码错误，请重试。";
          }
        } catch (Exception e) {
          message = "数据库连接失败：" + e.getMessage();
          e.printStackTrace();
        } finally {
          if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
          if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
          if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
      }

      if (message != null && !isAuthenticated) {
    %>
    <p class="message"><%= message %></p>
    <% } %>

    <form method="POST">
      电子邮箱: <input type="email" name="email" required><br>
      密码: <input type="password" name="password" required><br>
      <input type="submit" value="登录">
    </form>
    <p>还没有账号？<a href="register.jsp">注册新用户</a></p>
  </div>
</div>

</body>
</html>

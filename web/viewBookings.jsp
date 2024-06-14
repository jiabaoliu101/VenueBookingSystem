<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Date" %>
<!DOCTYPE html>
<html>
<head>
  <title>查看预约</title>
  <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<div class="container">
  <h2>我的预约</h2>
  <table>
    <thead>
    <tr>
      <th>场馆</th>
      <th>日期</th>
      <th>时间</th>
      <th>操作</th>
    </tr>
    </thead>
    <tbody>
    <%
      String user = (String) session.getAttribute("user");
      String contact = (String) session.getAttribute("contact");
      if (user == null || contact == null) {
        response.sendRedirect("login.jsp");
        return;
      }
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;

      try {
        String jdbcURL = "jdbc:mysql://localhost:3306/VenueBookingSystemNew?useSSL=false&characterEncoding=UTF-8";
        String jdbcUsername = "root";
        String jdbcPassword = "12345678";

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

        String sql = "SELECT b.id, v.name, b.booking_date, b.booking_time FROM Bookings b JOIN Venues v ON b.venue_id = v.id WHERE b.contact = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, contact);
        rs = pstmt.executeQuery();

        while (rs.next()) {
          int bookingId = rs.getInt("id");
          String venueName = rs.getString("name");
          Date bookingDate = rs.getDate("booking_date");
          Time bookingTime = rs.getTime("booking_time");
    %>
    <tr>
      <td><%= venueName %></td>
      <td><%= bookingDate %></td>
      <td><%= bookingTime %></td>
      <td>
        <form method="post" action="deleteBooking">
          <input type="hidden" name="bookingId" value="<%= bookingId %>">
          <input type="submit" value="删除">
        </form>
      </td>
    </tr>
    <%
        }
      } catch (Exception e) {
        e.printStackTrace();
      } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
      }
    %>
    </tbody>
  </table>
</div>
</body>
</html>

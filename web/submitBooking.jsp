<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>提交预约</title>
  <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<%
  // 检查用户是否已登录
  if (session.getAttribute("user") == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  // 获取提交的预订数据
  String[] bookings = request.getParameterValues("booking");
  String selectedDate = request.getParameter("selectedDate");

  if (bookings != null && bookings.length > 0) {
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
      String jdbcURL = "jdbc:mysql://localhost:3306/VenueBookingSystemNew?useSSL=false&characterEncoding=UTF-8";
      String jdbcUsername = "root";
      String jdbcPassword = "12345678";

      Class.forName("com.mysql.cj.jdbc.Driver");
      conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

      String sql = "INSERT INTO Bookings (venue_id, booking_date, booking_time, status, price) VALUES (?, ?, ?, ?, ?)";
      pstmt = conn.prepareStatement(sql);

      for (String booking : bookings) {
        String[] parts = booking.split(",");
        int venueId = Integer.parseInt(parts[0]);
        String bookingTime = parts[1];

        pstmt.setInt(1, venueId);
        pstmt.setDate(2, java.sql.Date.valueOf(selectedDate));
        pstmt.setTime(3, java.sql.Time.valueOf(bookingTime));
        pstmt.setString(4, "booked");
        pstmt.setDouble(5, 60.0);
        pstmt.addBatch();
      }

      pstmt.executeBatch();

      System.out.println("预约提交成功！");
    } catch (Exception e) {
      e.printStackTrace();
      System.out.println("预约提交失败：" + e.getMessage());
    } finally {
      if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
      if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
  } else {
    System.out.println("没有选择任何预约时间段。");
  }
%>
<p><a href="booking.jsp?selectedDate=<%= selectedDate %>">返回预约页面</a></p>
</body>
</html>

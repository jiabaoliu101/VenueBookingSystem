<%--
  Created by IntelliJ IDEA.
  User: jiabaoliu
  Date: 2024/5/13
  Time: 23:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
  <title>登录成功</title>
  <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<div class="container">
  <h2>欢迎回来, <%= session.getAttribute("user") %></h2>
  <p>您已成功登录到系统。</p>
  <p>现在您可以进行如下操作：</p>
  <ul>
    <li><a href="booking.jsp">预约场馆</a></li>
    <li><a href="viewBookings.jsp">查看我的预约</a></li>
  </ul>

  <form method="post" action="logout.jsp">
    <input type="submit" value="登出">
  </form>
</div>
</body>
</html>


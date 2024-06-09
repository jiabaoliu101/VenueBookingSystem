<%--
  Created by IntelliJ IDEA.
  User: jiabaoliu
  Date: 2024/5/13
  Time: 23:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <title>Logout</title>
</head>
<body>
<%
  session.invalidate(); // Invalidate session
  response.sendRedirect("index.jsp"); // Redirect to the homepage
%>
</body>
</html>



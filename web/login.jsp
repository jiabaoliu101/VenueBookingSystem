<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <c:if test="${not empty message}">
      <p class="message">${message}</p>
    </c:if>
    <form method="POST" action="login">
      电子邮箱: <input type="email" name="email" required><br>
      密码: <input type="password" name="password" required><br>
      <input type="submit" value="登录">
    </form>
    <p>还没有账号？<a href="register.jsp">注册新用户</a></p>
  </div>
</div>

</body>
</html>

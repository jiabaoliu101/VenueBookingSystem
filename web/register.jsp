<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>注册</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<div class="register-container">
    <div class="register-box">
        <h2>用户注册</h2>
        <c:if test="${not empty message}">
            <p class="message">${message}</p>
        </c:if>
        <form method="POST" action="register">
            姓名: <input type="text" name="name" required><br>
            电子邮箱: <input type="email" name="email" required><br>
            密码: <input type="password" name="password" required><br>
            联系方式: <input type="text" name="contact" required><br>
            <input type="submit" value="注册">
        </form>
    </div>
</div>
</body>
</html>

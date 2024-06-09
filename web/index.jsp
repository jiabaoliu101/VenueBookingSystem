<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>体育馆预约系统 - 北京理工大学珠海学院</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f7f7;
            margin: 0;
            padding: 0;
            color: #333;
        }
        header {
            background-color: #fff;
            padding: 10px 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logo {
            width: 60px; /* Adjust based on your logo size */
            height: auto;
            display: block;
        }
        .navbar {
            display: flex;
            align-items: center;
        }
        .navbar ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .navbar li {
            display: inline;
            margin: 0 10px;
        }
        .navbar a {
            text-decoration: none;
            color: #333;
            font-weight: bold;
        }
        .service-container {
            display: flex;
            justify-content: space-around;
            padding: 20px 0;
            background-color: #fff;
        }
        .service {
            text-align: center;
            color: #333;
        }
        .service img {
            width: 80px;
            height: 80px;
        }

        footer {
            text-align: center;
            padding: 10px 20px; /* Reduced padding for less bulky appearance */
            background-color: #222;
            color: #fff;
            font-size: 12px; /* Reduced font size for smaller text */
        }


        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #fff;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            padding: 10px 20px;
        }

        .nav-links {
            list-style: none;
            margin: 0;
            padding: 0;
            display: flex;
        }

        .nav-links li {
            padding: 0 15px;
        }

        .nav-links a {
            text-decoration: none;
            color: #333;
            font-weight: bold;
            display: block;
        }

        @media screen and (max-width: 768px) {
            .nav-links {
                flex-direction: column;
                width: 100%;
            }

            .nav-links li {
                text-align: center;
                width: 100%;
            }

            .nav-links a {
                padding: 10px;
            }
        }
        .banner-container {
            width: 100%; /* 容器宽度为100% */
            height: auto; /* 高度自动 */
            text-align: center; /* 图片居中显示 */
            margin: 20px 0; /* 上下边距 */
        }

        .banner-image {
            width: 100%; /* 图片宽度为100% */
            height: auto; /* 高度自动，保持图片比例 */
            max-height: 500px; /* 最大高度，可调整 */
        }





    </style>
</head>
<body>
<header>
    <img src="logo1.png" alt="体育中心" class="logo">
    <nav class="navbar">
        <ul>
            <li><a href="#">首页</a></li>
            <li><a href="#">预定球场</a></li>
            <li><a href="booking.jsp">场馆预约</a></li>
            <li><a href="#">联系我们</a></li>
            <% if (session.getAttribute("user") == null) { %>
            <li><a href="login.jsp">登录</a></li>
            <li><a href="register.jsp">注册</a></li>
            <% } else { %>
            <li>您好，<%= session.getAttribute("user") %></li>
            <li><a href="logout.jsp">登出</a></li>
            <% } %>
        </ul>
    </nav>
</header>

<div class="banner-container">
    <img src="image1.png" alt="描述图片内容" class="banner-image">
</div>


<div class="service-container">
    <a href="#" class="service">
        <img src="badminton.PNG" alt="羽毛球">
        <h4>羽毛球</h4>
    </a>
    <a href="#" class="service">
        <img src="table_tennis.PNG" alt="乒乓球">
        <h4>乒乓球</h4>
    </a>
    <a href="#" class="service">
        <img src="basketball.PNG" alt="篮球">
        <h4>篮球</h4>
    </a>

    <a href="#" class="service">
        <img src="gym.PNG" alt="健身房">
        <h4>健身房</h4>
    </a>
    <a href="#" class="service">
        <img src="soccer.PNG" alt="足球">
        <h4>足球</h4>
    </a>
</div>

<footer class="footer">
    <p>© 2024 北京理工大学珠海学院体育馆预约系统. 所有权利保留。</p>
</footer>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <title>报修</title>
    <link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
<div class="container">
    <h2>报修</h2>
    <form method="post" action="submitReport" enctype="multipart/form-data">
        <label for="description">报修描述:</label>
        <textarea id="description" name="description" rows="4" cols="50" required></textarea><br>
        <label for="file">上传图片:</label>
        <input type="file" id="file" name="file" required><br><br>
        <input type="submit" value="提交报修">
    </form>

    <h3>报修记录：</h3>
    <%
        String jdbcURL = "jdbc:mysql://localhost:3306/VenueBookingSystemNew?useSSL=false&characterEncoding=UTF-8";
        String jdbcUsername = "root";
        String jdbcPassword = "12345678";
        List<String[]> reports = new ArrayList<>();

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT id, description, file_path FROM Reports");

            while (rs.next()) {
                String[] report = new String[3];
                report[0] = String.valueOf(rs.getInt("id"));
                report[1] = rs.getString("description");
                report[2] = rs.getString("file_path");
                reports.add(report);
            }
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        for (String[] report : reports) {
    %>
    <div class="report">
        <p>描述: <%= report[1] %></p>
        <p>图片: <img src="uploads/<%= report[2] %>" alt="Report Image" style="width:200px; height:auto;"></p>
        <a href="deleteReport?id=<%= report[0] %>">删除</a>
    </div>
    <%
        }
    %>
</div>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
    <title>场馆预约</title>
    <link rel="stylesheet" type="text/css" href="style.css">
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
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
        .available {
            background-color: #00FF00; /* 绿色 */
        }
        .booked {
            background-color: #FF0000; /* 红色 */
        }
        .selected {
            background-color: #FFFF00; /* 黄色 */
        }
        .locked {
            background-color: #0000FF; /* 蓝色 */
        }
        input[type=submit] {
            background-color: #4CAF50;
            color: white;
            padding: 14px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            margin-top: 20px;
        }
        input[type=submit]:hover {
            background-color: #45a049;
        }
        .pagination {
            display: flex;
            justify-content: center;
            margin: 20px 0;
        }
        .pagination a {
            margin: 0 5px;
            padding: 10px 20px;
            border: 1px solid #ddd;
            color: #333;
            text-decoration: none;
        }
        .pagination a.active {
            background-color: #4CAF50;
            color: white;
        }
        .pagination a:hover {
            background-color: #45a049;
            color: white;
        }
        .date-picker {
            margin: 20px 0;
            text-align: center;
        }
    </style>
</head>
<body>
<%
    // 检查用户是否已登录
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 获取选择的日期，默认今天
    String selectedDate = request.getParameter("selectedDate");
    if (selectedDate == null || selectedDate.trim().isEmpty()) {
        selectedDate = java.time.LocalDate.now().toString();
    }
%>
<header>
    <h1>场馆预约</h1>
</header>
<main>
    <div class="date-picker">
        <form method="get" action="booking.jsp">
            <label for="selectedDate">选择日期:</label>
            <input type="date" id="selectedDate" name="selectedDate" value="<%= selectedDate %>">
            <input type="submit" value="查询">
        </form>
    </div>
    <form method="post" action="submitBooking.jsp">
        <input type="hidden" name="selectedDate" value="<%= selectedDate %>">
        <table>
            <thead>
            <tr>
                <th>时间</th>
                <%
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    List<String> venues = new ArrayList<>();
                    try {
                        String jdbcURL = "jdbc:mysql://localhost:3306/VenueBookingSystemNew?useSSL=false&characterEncoding=UTF-8";
                        String jdbcUsername = "root";
                        String jdbcPassword = "12345678";

                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

                        String sql = "SELECT * FROM Venues";
                        pstmt = conn.prepareStatement(sql);
                        rs = pstmt.executeQuery();
                        while (rs.next()) {
                            venues.add(rs.getString("name"));
                %>
                <th><%= rs.getString("name") %></th>
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
            </tr>
            </thead>
            <tbody>
            <%
                int currentPage = 1;
                int recordsPerPage = 10;
                if (request.getParameter("page") != null)
                    currentPage = Integer.parseInt(request.getParameter("page"));

                try {
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/VenueBookingSystemNew?useSSL=false&characterEncoding=UTF-8", "root", "12345678");
                    String sql = "SELECT * FROM Bookings WHERE booking_date = ? LIMIT ?, ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setDate(1, java.sql.Date.valueOf(selectedDate));
                    pstmt.setInt(2, (currentPage - 1) * recordsPerPage);
                    pstmt.setInt(3, recordsPerPage);
                    rs = pstmt.executeQuery();

                    // 初始化二维数组来存储预约状态
                    String[][] bookingStatus = new String[venues.size()][10];

                    while (rs.next()) {
                        int venueId = rs.getInt("venue_id") - 1;
                        int timeSlot = rs.getTime("booking_time").toLocalTime().getHour() - 9;
                        bookingStatus[venueId][timeSlot] = rs.getString("status");
                    }

                    // 动态生成表格内容
                    for (int timeSlot = 0; timeSlot < 10; timeSlot++) {
            %>
            <tr>
                <td><%= (timeSlot + 9) + ":00" %></td>
                <%
                    for (int venueId = 0; venueId < venues.size(); venueId++) {
                        String status = bookingStatus[venueId][timeSlot];
                        String className = "";
                        if ("available".equals(status)) {
                            className = "available";
                        } else if ("booked".equals(status)) {
                            className = "booked";
                        } else if ("selected".equals(status)) {
                            className = "selected";
                        } else if ("locked".equals(status)) {
                            className = "locked";
                        }
                %>
                <td class="<%= className %>">
                    <input type="checkbox" name="booking" value="<%= venueId + 1 %>,<%= (timeSlot + 9) %>:00:00" <%= "booked".equals(status) || "locked".equals(status) ? "disabled" : "" %> >
                    ¥60
                </td>
                <%
                    }
                %>
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
        <input type="submit" value="提交订单">
    </form>
    <%
        // 获取总记录数，根据实际数据库查询结果修改
        int noOfRecords = 0;
        try {
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/VenueBookingSystemNew?useSSL=false&characterEncoding=UTF-8", "root", "12345678");
            String countSql = "SELECT COUNT(*) FROM Bookings WHERE booking_date = ?";
            pstmt = conn.prepareStatement(countSql);
            pstmt.setDate(1, java.sql.Date.valueOf(selectedDate));
            rs = pstmt.executeQuery();
            if (rs.next()) {
                noOfRecords = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        int noOfPages = (int) Math.ceil(noOfRecords * 1.0 / recordsPerPage);
    %>
    <div class="pagination">
        <%
            for (int i = 1; i <= noOfPages; i++) {
        %>
        <a href="booking.jsp?page=<%= i %>&selectedDate=<%= selectedDate %>" class="<%= (i == currentPage) ? "active" : "" %>"><%= i %></a>
        <%
            }
        %>
    </div>
</main>
<footer>
    <p>© 2024 北京理工大学珠海学院体育馆预约系统. 所有权利保留。</p>
</footer>
</body>
</html>

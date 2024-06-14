package cn.work.servlet;

import cn.work.dao.VenueDAO;
import cn.work.dto.VenueDTO;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/LoadBookingData")
public class LoadBookingData extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查用户是否已登录
        if (request.getSession().getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 获取从前端传来的日期参数，如果没有则使用当前日期
        String selectedDate = request.getParameter("selectedDate");
        if (selectedDate == null || selectedDate.trim().isEmpty()) {
            selectedDate = java.time.LocalDate.now().toString();
        }

        // 生成时间段
        List<String> timeSlots = generateTimeSlots();

        VenueDAO venueDAO = new VenueDAO();
        try {
            // 从数据库获取所有场馆信息
            List<VenueDTO> venues = venueDAO.getAllVenues();
            // 设置属性，供JSP页面使用
            request.setAttribute("venues", venues);
            request.setAttribute("selectedDate", selectedDate);
            request.setAttribute("timeSlots", timeSlots);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error accessing database: " + e.getMessage());
        }

        // 转发到JSP页面进行显示
        RequestDispatcher dispatcher = request.getRequestDispatcher("/booking.jsp");
        dispatcher.forward(request, response);
    }

    // 生成从9:00 AM到9:00 PM的时间段，每小时一个时段
    private List<String> generateTimeSlots() {
        List<String> timeSlots = new ArrayList<>();
        LocalTime openingTime = LocalTime.of(9, 0);  // 开放时间 9:00 AM
        LocalTime closingTime = LocalTime.of(21, 0); // 关闭时间 9:00 PM
        for (LocalTime time = openingTime; time.isBefore(closingTime); time = time.plusHours(1)) {
            timeSlots.add(time.toString());
        }
        return timeSlots;
    }
}

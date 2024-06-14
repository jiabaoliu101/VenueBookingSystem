package cn.work.servlet;

import cn.work.dao.VenueDAO;
import cn.work.dto.VenueDTO;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/Booking")
public class BookingServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        VenueDAO venueDAO = new VenueDAO();
        try {
            List<VenueDTO> venues = venueDAO.getAllVenues();
            request.setAttribute("venues", venues);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
        }

        String selectedDate = request.getParameter("selectedDate");
        if (selectedDate == null || selectedDate.trim().isEmpty()) {
            selectedDate = java.time.LocalDate.now().toString();
        }
        request.setAttribute("selectedDate", selectedDate);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/booking.jsp");
        dispatcher.forward(request, response);
    }
}

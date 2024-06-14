package cn.work.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/SubmitBooking")
public class SubmitBookingServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession().getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String selectedDate = request.getParameter("selectedDate");
        String[] bookings = request.getParameterValues("booking");
        String contact = (String) request.getSession().getAttribute("contact");

        if (bookings != null) {
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/VenueBookingSystemNew", "root", "12345678");
                 PreparedStatement pstmt = conn.prepareStatement("INSERT INTO Bookings (venue_id, booking_date, booking_time, status, price, contact) VALUES (?, ?, ?, 'booked', 60, ?)")) {

                for (String booking : bookings) {
                    String[] parts = booking.split(",");
                    int venueId = Integer.parseInt(parts[0]);
                    String bookingTime = parts[1];

                    pstmt.setInt(1, venueId);
                    pstmt.setDate(2, Date.valueOf(selectedDate));
                    pstmt.setTime(3, Time.valueOf(bookingTime + ":00"));
                    pstmt.setString(4, contact);
                    pstmt.addBatch();
                }
                pstmt.executeBatch();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("booking.jsp?selectedDate=" + selectedDate);
    }
}

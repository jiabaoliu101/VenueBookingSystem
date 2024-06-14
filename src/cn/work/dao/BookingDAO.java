package cn.work.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class BookingDAO {
    private Connection conn;

    public BookingDAO(Connection conn) {
        this.conn = conn;
    }

    public void addBooking(int venueId, String bookingDate, String bookingTime, String status, double price, String contact) throws SQLException {
        String sql = "INSERT INTO Bookings (venue_id, booking_date, booking_time, status, price, contact) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, venueId);
            pstmt.setString(2, bookingDate);
            pstmt.setString(3, bookingTime);
            pstmt.setString(4, status);
            pstmt.setDouble(5, price);
            pstmt.setString(6, contact);
            pstmt.executeUpdate();
        }
    }
}

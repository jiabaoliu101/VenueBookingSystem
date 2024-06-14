package cn.work.servlet;

import cn.work.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/submitReport")
@MultipartConfig
public class SubmitReportServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");  // 确保请求编码是 UTF-8


        String description = request.getParameter("description");
        Part filePart = request.getPart("file");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;

        // 调试输出
        System.out.println("Upload Path: " + uploadPath);
        System.out.println("File Name: " + fileName);

        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            boolean dirCreated = uploadDir.mkdir();
            System.out.println("Directory created: " + dirCreated);
        }

        File file = new File(uploadPath + File.separator + fileName);
        filePart.write(file.getAbsolutePath());
        System.out.println("File saved at: " + file.getAbsolutePath());

        Connection conn = null;
        PreparedStatement pstmt = null;
        String message = "报修提交成功！";

        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO Reports (description, file_path) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, description);
            pstmt.setString(2, fileName);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            message = "报修提交失败：" + e.getMessage();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        request.setAttribute("message", message);
        request.getRequestDispatcher("reportResult.jsp").forward(request, response);
    }
}

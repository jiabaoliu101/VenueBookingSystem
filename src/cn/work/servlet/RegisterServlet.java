package cn.work.servlet;

import cn.work.dao.UserDAO;
import cn.work.dto.UserDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String contact = request.getParameter("contact");
        String message = "";

        UserDTO user = new UserDTO();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);
        user.setContact(contact);

        UserDAO userDAO = new UserDAO();
        try {
            if (userDAO.registerUser(user)) {
                message = "注册成功！";
            } else {
                message = "注册失败！";
            }
        } catch (SQLException e) {
            message = "数据库错误：" + e.getMessage();
            e.printStackTrace();
        }

        request.setAttribute("message", message);
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
}

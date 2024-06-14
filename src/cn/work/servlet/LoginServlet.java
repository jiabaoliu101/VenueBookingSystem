package cn.work.servlet;

import cn.work.dao.UserDAO;
import cn.work.dto.UserDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String message = null;

        if (email != null && password != null) {
            UserDAO userDAO = new UserDAO();
            try {
                UserDTO user = userDAO.getUserByEmailAndPassword(email, password);
                if (user != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", user.getName());
                    session.setAttribute("contact", user.getContact());


                    System.out.println("Session中的contact信息: " + session.getAttribute("contact"));
                    if (session.getAttribute("contact") == null) {
                        System.out.println("没有从session中找到contact信息。");
                    }

                    response.sendRedirect("index.jsp");
                    return;
                } else {
                    message = "电子邮箱或密码错误，请重试。";
                }
            } catch (SQLException e) {
                message = "数据库连接失败：" + e.getMessage();
                e.printStackTrace();
            }
        }

        request.setAttribute("message", message);
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}

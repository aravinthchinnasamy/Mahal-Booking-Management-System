package com.MahalBooking.Controller;

import com.MahalBooking.DAO.AdminDAO;
import com.MahalBooking.Model.Admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/AdminLoginController")
public class AdminLoginController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private AdminDAO adminDAO;

    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Admin admin = adminDAO.authenticateAdmin(username, password);

            if (admin != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("admin", admin);
                session.setAttribute("adminId", admin.getId());
                session.setAttribute("adminName", admin.getFullName());

                response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("/admin-login.jsp")
                       .forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "System error. Please try again.");
            request.getRequestDispatcher("/admin-login.jsp")
                   .forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/admin-login.jsp")
               .forward(request, response);
    }
}

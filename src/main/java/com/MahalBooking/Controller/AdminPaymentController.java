package com.MahalBooking.Controller;

import com.MahalBooking.DAO.PaymentDAO;
import com.MahalBooking.Model.Admin;
import com.MahalBooking.Model.Payment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

//@WebServlet("/AdminPaymentController")
//public class AdminPaymentController extends HttpServlet {
//    private PaymentDAO paymentDAO;
//    
//    @Override
//    public void init() throws ServletException {
//        paymentDAO = new PaymentDAO();
//    }
//      protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        
//        HttpSession session = request.getSession();
//        Admin admin = (Admin) session.getAttribute("admin");
//        
//        if (admin == null) {
//            response.sendRedirect("admin-login.jsp");
//            return;
//        }
//
//        String action = request.getParameter("action");
//        String statusFilter = request.getParameter("status");
//        
//        try {
//            List<Payment> payments;
//            
//            if (statusFilter != null && !statusFilter.isEmpty()) {
//                payments = paymentDAO.getPaymentsByStatus(statusFilter);
//            } else {
//                payments = paymentDAO.getAllPayments();
//            }
//            
//            request.setAttribute("payments", payments);
//            request.setAttribute("filterStatus", statusFilter);
//            request.getRequestDispatcher("/admin-payments.jsp").forward(request, response);
//            
//        } catch (SQLException e) {
//            request.setAttribute("error", "Database error: " + e.getMessage());
//            request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
//        }
//    }
//    
//}

@WebServlet("/AdminPaymentController")
public class AdminPaymentController extends HttpServlet {

    private PaymentDAO paymentDAO;

    @Override
    public void init() {
        paymentDAO = new PaymentDAO();
    }

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("admin");

        if (admin == null) {
            response.sendRedirect("admin-login.jsp");
            return;
        }

        try {
            List<Payment> payments = paymentDAO.getAllPayments();

            request.setAttribute("payments", payments);

            request.getRequestDispatcher("/admin-payments.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading payments");
            request.getRequestDispatcher("/admin-payments.jsp")
                   .forward(request, response);
        }
    }
}
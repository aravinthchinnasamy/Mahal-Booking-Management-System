package com.MahalBooking.Controller;

import com.MahalBooking.DAO.BookingDAO;
import com.MahalBooking.DAO.PaymentDAO;
import com.MahalBooking.Model.Booking;
import com.MahalBooking.Model.Payment;
import com.MahalBooking.Model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/PaymentController")
public class PaymentController extends HttpServlet {
    private PaymentDAO paymentDAO;
    private BookingDAO bookingDAO;
    private static final Logger logger = Logger.getLogger(PaymentController.class.getName());

    @Override
    public void init() throws ServletException {
        paymentDAO = new PaymentDAO();
        bookingDAO = new BookingDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("user-login.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        try {
            if (action == null) {
                // Handle default case
                response.sendRedirect("BookingController");
            } else if ("process".equals(action)) {
                processPayment(request, response, user);
            } else if ("success".equals(action)) {
                paymentSuccess(request, response, user);
            } else if ("failure".equals(action)) {
                paymentFailure(request, response, user);
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing payment request", e);
            request.setAttribute("error", "Error processing payment: " + e.getMessage());
            request.getRequestDispatcher("/payment-form.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("user-login.jsp");
            return;
        }

        try {
            completePayment(request, response, user);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error completing payment", e);
            request.setAttribute("error", "Error completing payment: " + e.getMessage());
            request.getRequestDispatcher("/payment-form.jsp").forward(request, response);
        }
    }

    private void processPayment(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException, SQLException {
        
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        Booking booking = bookingDAO.getBookingWithVenueDetails(bookingId);
        
        if (booking != null && booking.getUserId() == user.getId() && 
            "confirmed".equals(booking.getStatus()) && !"paid".equals(booking.getPaymentStatus())) {
            
            request.setAttribute("booking", booking);
            request.getRequestDispatcher("/payment-form.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Booking not found or not eligible for payment");
            response.sendRedirect("BookingController?action=confirmed");
        }
    }

    private void completePayment(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            int paymentMethodId = Integer.parseInt(request.getParameter("paymentMethod"));
            String transactionId = request.getParameter("transactionId");

            if (transactionId == null || transactionId.trim().isEmpty()) {
                request.setAttribute("error", "Transaction ID is required");
                request.getRequestDispatcher("/payment-form.jsp").forward(request, response);
                return;
            }

            Booking booking = bookingDAO.getBookingWithVenueDetails(bookingId);

            if (booking == null || booking.getUserId() != user.getId()) {
                request.setAttribute("error", "Invalid booking");
                request.getRequestDispatcher("/payment-form.jsp").forward(request, response);
                return;
            }

            // Create Payment
            Payment payment = new Payment();
            payment.setBookingId(bookingId);
            payment.setUserId(user.getId());
            payment.setAmount(booking.getTotalAmount());
            payment.setPaymentMethodId(paymentMethodId);
            payment.setTransactionId(transactionId);
            payment.setStatus("completed");
            payment.setPaymentDate(new Timestamp(System.currentTimeMillis()));

            boolean isCreated = paymentDAO.createPayment(payment);

            if (isCreated) {

                // Update booking payment status
                bookingDAO.updatePaymentStatus(bookingId, "paid");

                // 🔥 IMPORTANT: Fetch saved payment
                Payment savedPayment = paymentDAO.getPaymentByBookingId(bookingId);

                request.setAttribute("payment", savedPayment);

                // ✅ DIRECTLY FORWARD TO SUCCESS PAGE
                request.getRequestDispatcher("/payment-success.jsp").forward(request, response);

            } else {
                request.setAttribute("error", "Payment failed. Try again.");
                request.getRequestDispatcher("/payment-form.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong: " + e.getMessage());
            request.getRequestDispatcher("/payment-form.jsp").forward(request, response);
        }
    }

    private void paymentSuccess(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException, SQLException {
        
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        Payment payment = paymentDAO.getPaymentByBookingId(bookingId);
        
        if (payment != null && payment.getUserId() == user.getId()) {
            request.setAttribute("payment", payment);
            request.getRequestDispatcher("/payment-success.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Payment not found");
            response.sendRedirect("BookingController?action=confirmed");
        }
    }

    private void paymentFailure(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException, SQLException {
        
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        Payment payment = paymentDAO.getPaymentByBookingId(bookingId);
        
        if (payment != null && payment.getUserId() == user.getId()) {
            request.setAttribute("payment", payment);
            request.getRequestDispatcher("/payment-failure.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Payment not found");
            response.sendRedirect("BookingController?action=confirmed");
        }
    }
}

package com.MahalBooking.Controller;

import com.MahalBooking.DAO.BookingDAO;
import com.MahalBooking.Model.Admin;
import com.MahalBooking.Model.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/AdminBookingController")
public class AdminBookingController extends HttpServlet {
	private BookingDAO bookingDAO;

	@Override
	public void init() throws ServletException {
		bookingDAO = new BookingDAO();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		Admin admin = (Admin) session.getAttribute("admin");

		if (admin == null) {
			response.sendRedirect("admin-login.jsp");
			return;
		}

		String action = request.getParameter("action");
		String filter = request.getParameter("filter");

		try {
			if (action == null) {
				// Show all bookings with filter options
				List<Booking> bookings = bookingDAO.getAllBookingsWithVenueDetails(filter);
				request.setAttribute("bookings", bookings);
				request.setAttribute("currentFilter", filter != null ? filter : "all");
				request.getRequestDispatcher("/admin-bookings.jsp").forward(request, response);
			} else if ("view".equals(action)) {
				// View booking details
				int bookingId = Integer.parseInt(request.getParameter("id"));
				Booking booking = bookingDAO.getBookingDetailsForAdmin(bookingId);

				if (booking != null) {
					request.setAttribute("booking", booking);
					request.getRequestDispatcher("/admin-booking-details.jsp").forward(request, response);
				} else {
					request.setAttribute("error", "Booking not found");
					response.sendRedirect("AdminBookingController");
				}
			} else if ("confirm".equals(action)) {
				// Confirm booking
				int bookingId = Integer.parseInt(request.getParameter("id"));
				if (bookingDAO.updateBookingStatus(bookingId, "confirmed")) {
					request.setAttribute("success", "Booking confirmed successfully");
				} else {
					request.setAttribute("error", "Failed to confirm booking");
				}
				response.sendRedirect("AdminBookingController");
			} else if ("reject".equals(action)) {
				// Reject booking
				int bookingId = Integer.parseInt(request.getParameter("id"));
				if (bookingDAO.updateBookingStatus(bookingId, "rejected")) {
					request.setAttribute("success", "Booking rejected successfully");
				} else {
					request.setAttribute("error", "Failed to reject booking");
				}
				response.sendRedirect("AdminBookingController");
			}
		} catch (SQLException e) {
			request.setAttribute("error", "Database error: " + e.getMessage());
			request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
		} catch (NumberFormatException e) {
			request.setAttribute("error", "Invalid booking ID");
			response.sendRedirect("AdminBookingController");
		}
	}

}

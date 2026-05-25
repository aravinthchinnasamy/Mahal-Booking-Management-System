package com.MahalBooking.Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.MahalBooking.DAO.DBConnection;

/**
 * Servlet implementation class VenueImageServlet
 */
@WebServlet("/VenueImageServlet")
public class VenueImageServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("🔥 VenueImageServlet Called");

        String idParam = request.getParameter("id");
        System.out.println("Received ID: " + idParam);

        if (idParam == null) {
            System.out.println("❌ ID is null");
            return;
        }

        int venueId = Integer.parseInt(idParam);

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT image_data FROM venue_images WHERE venue_id = ? LIMIT 1";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, venueId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                byte[] imageBytes = rs.getBytes("image_data");

                System.out.println("✅ Image Found. Size: " + imageBytes.length);

                response.setContentType("image/jpeg");
                response.setContentLength(imageBytes.length);

                response.getOutputStream().write(imageBytes);
                response.getOutputStream().flush();

            } else {
                System.out.println("❌ No Image Found in DB");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

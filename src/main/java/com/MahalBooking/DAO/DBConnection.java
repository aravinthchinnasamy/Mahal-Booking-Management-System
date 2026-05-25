package com.MahalBooking.DAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DBConnection {
	public static Connection getConnection() throws SQLException {
	    try {
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        Connection con = DriverManager.getConnection(
	            "jdbc:mysql://localhost:3306/wedding_booking", 
	            "root", 
	            "root");
	        return con;
	    } catch (ClassNotFoundException e) {
	        throw new SQLException("MySQL JDBC Driver not found", e);
	    }
	}
}

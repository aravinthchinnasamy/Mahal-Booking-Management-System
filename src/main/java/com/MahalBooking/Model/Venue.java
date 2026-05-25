	package com.MahalBooking.Model;
	
	import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
	
	public class Venue {
		private int id;
		private String name;
		private String location;
		private String description;
		private int capacity;
		private double price;
		private String amenities;
		private boolean isActive;
		private Timestamp createdAt;
		private Timestamp updatedAt;
		private List<byte[]> images;

		public List<byte[]> getImages() {
		    return images;
		}

		public void setImages(List<byte[]> images) {
		    this.images = images;
		}
	
		// Constructors
		
		public Venue() {
		    this.images = new ArrayList<>();
		}

	
		public Venue(int id, String name, String location, String description, int capacity, double price, String amenities,
				boolean isActive) {
			this.id = id;
			this.name = name;
			this.location = location;
			this.description = description;
			this.capacity = capacity;
			this.price = price;
			this.amenities = amenities;
			this.isActive = isActive;
		}
	
		// Getters and Setters
		public int getId() {
			return id;
		}
	
		public void setId(int id) {
			this.id = id;
		}
	
		public String getName() {
			return name;
		}
	
		public void setName(String name) {
			this.name = name;
		}
	
		public String getLocation() {
			return location;
		}
	
		public void setLocation(String location) {
			this.location = location;
		}
	
		public String getDescription() {
			return description;
		}
	
		public void setDescription(String description) {
			this.description = description;
		}
	
		public int getCapacity() {
			return capacity;
		}
	
		public void setCapacity(int capacity) {
			this.capacity = capacity;
		}
	
		public double getPrice() {
			return price;
		}
	
		public void setPrice(double price) {
			this.price = price;
		}
	
		public String getAmenities() {
			return amenities;
		}
	
		public void setAmenities(String amenities) {
			this.amenities = amenities;
		}
	
		public boolean isActive() {
			return isActive;
		}
	
		public void setActive(boolean active) {
			isActive = active;
		}
	
		public Timestamp getCreatedAt() {
			return createdAt;
		}
	
		public void setCreatedAt(Timestamp createdAt) {
			this.createdAt = createdAt;
		}
	
		public Timestamp getUpdatedAt() {
			return updatedAt;
		}
	
		public void setUpdatedAt(Timestamp updatedAt) {
			this.updatedAt = updatedAt;
		}
	
		
	}

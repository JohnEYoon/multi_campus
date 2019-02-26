package search;

public class Result {
	String book_title;
	String library_name;
	double latitude;
	double longitude;
	String site_url;
	double distance;
	

	
	public Result(String book_title, String library_name, double latitude, double longitude,
			String site_url, double distance) {
		super();
		this.book_title = book_title;
		this.library_name = library_name;
		this.latitude = latitude;
		this.longitude = longitude;
		this.site_url = site_url;
		this.distance = distance ;
	}
	public void set_distance(double distance) {
		this.distance = distance;
	}
	
	public double get_distance() {
		return distance;
	}
	
	public String getBook_title() {
		return book_title;
	}
	public void setBook_title(String book_title) {
		this.book_title = book_title;
	}
	public String getLibrary_name() {
		return library_name;
	}
	public void setLibrary_name(String library_name) {
		this.library_name = library_name;
	}
	public double getLatitude() {
		return latitude;
	}
	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}
	public double getLongitude() {
		return longitude;
	}
	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}
	public String getSite_url() {
		return site_url;
	}
	public void setSite_url(String site_url) {
		this.site_url = site_url;
	}
	
	public String toString() {
	
		return this.book_title+":" +library_name+":"+latitude+":"+longitude+":"+site_url+":"+distance;
	}
	
}

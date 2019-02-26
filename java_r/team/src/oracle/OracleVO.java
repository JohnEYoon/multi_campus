package oracle;

public class OracleVO {
	String library_name;
	double lon;
	double lat;
	String library_location;
	double distance;

	public OracleVO() {
		super();
	}

	public OracleVO(String library_name, String library_location) {
		super();
		this.library_name = library_name;
		this.library_location = library_location;
	}

	
	public OracleVO(String library_name, double lon, double lat, String library_location) {
		super();
		this.library_name = library_name;
		this.lon = lon;
		this.lat = lat;
		this.library_location = library_location;
		distance = 0;
	}

	public String getLibrary_name() {
		return library_name;
	}

	public void setLibrary_name(String library_name) {
		this.library_name = library_name;
	}
	
	public void set_distance(double distance) {
		this.distance=distance;
	}
	
	public double get_distance() {
		return this.distance;
	}
	
	public double getLon() {
		return lon;
	}

	public void setLon(double lon) {
		this.lon = lon;
	}

	public double getLat() {
		return lat;
	}

	public void setLat(double lat) {
		this.lat = lat;
	}

	public String getLibrary_location() {
		return library_location;
	}

	public void setLibrary_location(String library_location) {
		this.library_location = library_location;
	}

	@Override
	public String toString() {
		return "OracleVO [library_name=" + library_name + ", lon=" + lon + ", lat=" + lat + ", library_location="
				+ library_location + "]";
	}

}

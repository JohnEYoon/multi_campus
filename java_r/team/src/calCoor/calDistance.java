package calCoor;

public class calDistance {
	public static double ret_distance(double startLat, double startLon, double endLat, double endLon) {

		double d2r = Math.PI/180;
		double dLat = (endLat-startLat)*d2r;
		double dLon = (endLon-startLon)*d2r;
		
		double a=Math.pow(Math.sin(dLat/2.0),2) + Math.cos(startLat*d2r)
		*Math.cos(endLat*d2r)*Math.pow(Math.sin(dLon/2.0), 2);
		
		double c = Math.atan2(Math.sqrt(a), Math.sqrt(1-a))*2;
		
		return c*6378;
	}
}

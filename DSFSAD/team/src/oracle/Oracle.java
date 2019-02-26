package oracle;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class Oracle {
	
	public static ArrayList<OracleVO> get_all_information(ArrayList<String> library_loc) {
		ArrayList<OracleVO> list = new ArrayList<OracleVO>();
		
		for(int i = 0; i<library_loc.size(); i++) {
		
			try {
				Class.forName("oracle.jdbc.driver.OracleDriver");
				Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "hr", "hr");
				System.out.println("연결성공");
			
				String sql = "select * from library where library_location = ?";
			//String sql = "select * from library where library_name = ?, library_location = ?";
			
				PreparedStatement pt = con.prepareStatement(sql);
				pt.setString(1, library_loc.get(i));
				ResultSet rs = pt.executeQuery();
				
				System.out.println( "업데이트 성공");
			
				while(rs.next()) {
								
					String library_name = rs.getString("library_name");
					double lon = rs.getDouble("lon");
					double lat = rs.getDouble("lat");
					String library_location = rs.getString("library_location");
					OracleVO vo = new OracleVO();
				
					vo.setLibrary_name(library_name);
					vo.setLon(lon);
					vo.setLat(lat);
					vo.setLibrary_location(library_location);
					list.add(vo);
				}
				con.close();
				System.out.println("연결해제");
				
				} catch(Exception e) {
					e.printStackTrace();
				}
				
	}

		return list;
	}	
}

package calCoor;
import java.util.ArrayList;
import calCoor.calDistance;


class District{
	String name;
	double x;
	double y;
	double distance;
	String path;
	District(String name, double x, double y, String path){
		this.name=name;
		this.x = x;
		this.y= y;
		distance = 0;
		this.path=path;
	}
}


public class ReturnDistrict {
	public static ArrayList<String> district(double lati, double longi){
		ArrayList<String> ret_districts= new ArrayList<String>(2);
		ArrayList<District> districts = new ArrayList<District>(12);
		
		
		districts.add(new District("seo_de", 37.579181, 126.936782, "서대문&C:/multi_campus/R/Rsrc/seo_de_moon.R&http://lib.sdm.or.kr/main/main.asp"));
		districts.add(new District("sung_dong",37.563276, 127.036941, "성동&C:/multi_campus/R/Rsrc/sung_dong.R&https://www.sdlib.or.kr/SD/"));
		districts.add(new District("sung_buk", 37.589321, 127.016738, "성북&C:/multi_campus/R/Rsrc/sung_buk.R&https://www.sblib.seoul.kr/library/index.do"));
		districts.add(new District("song_pa",37.532513, 126.990064, "송파&C:/multi_campus/R/Rsrc/song_pa.R&http://www.splib.or.kr/"));
		districts.add(new District("yong_san",37.532513, 126.990064, "용산&C:/multi_campus/R/Rsrc/yong_san.R&https://www.yslibrary.or.kr/intro/index.do"));
		districts.add(new District("joong_gu",37.563699,126.997499, "중&C:/multi_campus/R/Rsrc/joong.R&https://www.e-junggulib.or.kr/SJGL/"));
		districts.add(new District("gang_nam",37.517294,127.047399, "강남&C:/multi_campus/R/Rsrc/gang_nam.R&https://library.gangnam.go.kr/"));
		districts.add(new District("gang_dong",37.530185,127.123734894, "강동&C:/multi_campus/R/Rsrc/gang_dong.R&http://www.gdlibrary.or.kr/intro/main.do"));
		districts.add(new District("gang_seo",37.550894,126.849531, "강서&C:/multi_campus/R/Rsrc/gang_seo.R&http://lib.gangseo.seoul.kr/"));
		districts.add(new District("gwan_ak",37.478112,126.951500, "관악&C:/multi_campus/R/Rsrc/gwan_ak.R&http://lib.gwanak.go.kr/"));
		districts.add(new District("dong_jak",37.512475,126.939487, "동작&C:/multi_campus/R/Rsrc/dong_jak.R&http://lib.dongjak.go.kr/dj/index.do"));
		districts.add(new District("gwang_jin",37.538510,127.082396, "광진&C:/multi_campus/R/Rsrc/gwang_jin.R&https://www.gwangjinlib.seoul.kr/intro.do"));
		
		int min1 = 0;
		int min2 = 0;
		
		for(int i = 0; i < districts.size(); i++) {
			double tempX = districts.get(i).x;
			double tempY = districts.get(i).y;
			
			districts.get(i).distance=calDistance.ret_distance(lati, longi, tempX, tempY);
			
			if(districts.get(min1).distance > districts.get(i).distance) {
				min2 = min1;
				min1 = i ;
			}
			else if(districts.get(min2).distance > districts.get(i).distance) {
				min2 = i ;
			}
			
		}
		
		ret_districts.add(districts.get(min1).path);
		ret_districts.add(districts.get(min2).path);
		
		return ret_districts;
		
	}
}

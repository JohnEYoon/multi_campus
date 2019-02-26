package search;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.rosuda.REngine.REXP;
import org.rosuda.REngine.REXPMismatchException;
import org.rosuda.REngine.RList;
import org.rosuda.REngine.Rserve.RConnection;
import org.rosuda.REngine.Rserve.RserveException;

import calCoor.ReturnDistrict;
import oracle.Oracle;
import oracle.OracleVO;
import calCoor.calDistance;

/**
 * Servlet implementation class SearchServlet
 * 중요
 */
@WebServlet("/search4")


public class SearchServlet4 extends HttpServlet {
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
   System.out.println("search4");
   String booktitle=request.getParameter("booktitle");
   System.out.println(booktitle);
   
   
   String lati = request.getParameter("latitude");
   String longi = request.getParameter("longitude");
   
   if(lati.length()>=12) {
   lati = lati.substring(0, 11);
   }
   if(longi.length()>=12) {
	   longi = longi.substring(0,11);
	   }
   double latitude = Double.parseDouble(lati);
   double longitude = Double.parseDouble(longi);
   request.setAttribute("latitude", latitude);
   request.setAttribute("longitude", longitude);
   ArrayList<String> districts = ReturnDistrict.district(latitude, longitude);
   ArrayList<String> ko_districts = new  ArrayList<String>(2);
   ArrayList<OracleVO> libraries = new ArrayList<OracleVO>();
   
   String path1 = districts.get(0).split("&")[1];
   String path2 = districts.get(1).split("&")[1];
   ko_districts.add(districts.get(0).split("&")[0]);
   ko_districts.add(districts.get(1).split("&")[0]);
   System.out.println(districts.get(1).split("&")[0]);
   libraries = Oracle.get_all_information(ko_districts);//인근 구에 위치한 도서관들의 리스트

   String result = "";
   try {
      RConnection conn = new RConnection();

      conn.eval("library(rvest)");
      conn.assign("search", booktitle);
      
      REXP x=conn.eval("imsi<-source('"+path1+"',encoding='UTF-8'); imsi$value");
      RList list = x.asList();
      int v_size = list.size();
      int d_length = list.at(0).length();
      System.out.println("데이터(관측치)의 갯수 : " +d_length);
      System.out.println("변수의 갯수 : " +  v_size);
     
      
      int arrayRows =  v_size;
      int arrayCols =d_length;
      String[][] temp1 = new String[arrayRows][];  // 데이터프레임의 변수 갯수로 행의 크기를 정한다.
      String[][] s = new String[arrayCols][arrayRows];
      for (int i = 0; i < arrayRows; i++) {
         temp1[i] = list.at(i).asStrings();
      }
    
      REXP x2=conn.eval("imsi2<-source('"+path2+"',encoding='UTF-8'); imsi2$value");
      RList list2 = x2.asList();
      int v_size2 = list2.size();
      int d_length2 = list2.at(0).length();
      System.out.println("데이터(관측치)의 갯수 : " +d_length2);
      System.out.println("변수의 갯수 : " +  v_size2);
      
      int arrayRows2 =  v_size2;
      int arrayCols2 =d_length2;
      String[][] temp2 = new String[arrayRows2][];  // 데이터프레임의 변수 갯수로 행의 크기를 정한다.
      String[][] s2 = new String[arrayCols][arrayRows];
      for (int i = 0; i < arrayRows2; i++) {
         temp2[i] = list2.at(i).asStrings();
      };
      
      
      String[][] final_result = new String[arrayCols+arrayCols2][arrayRows];
      for (int i = 0; i < arrayCols; i++) {
          for (int j = 0; j < arrayRows; j++) {
        	  final_result[i][j] = temp1[j][i];
          }
      }
      
      for (int i = 0; i < arrayCols2; i++) {
          for (int j = 0; j < arrayRows2; j++) {
        	  final_result[i+arrayCols][j] = temp2[j][i];
          }
      }
      
      for(int i = 0 ; i < libraries.size(); i++) {
    	  double tempX = libraries.get(i).getLat();
    	  double tempY = libraries.get(i).getLon();
    	  
    	  libraries.get(i).set_distance(calDistance.ret_distance(latitude, longitude, tempX, tempY));
      }
      
      Collections.sort(libraries, new Comparator<OracleVO>()
      {  @Override
    	public int compare(OracleVO o1, OracleVO o2) {
    			return o1.get_distance() < o2.get_distance() ? -1: o1.get_distance() > o2.get_distance() ? 1:0;
    		}
      });
      
      System.out.println("최종결과 출력");
      for (int i = 0; i < arrayCols2+arrayCols; i++) {
          for (int j = 0; j < arrayRows2; j++) {
             System.out.print("["+i+","+j+"]"+final_result[i][j]+"\t");
          }
          System.out.println();
      }
      
      System.out.println("최종결과 출력: 도서관 거리");
      for (int i = 0; i < libraries.size(); i++) {
    	  System.out.println(libraries.get(i).getLibrary_name()+": distance="+libraries.get(i).get_distance());
      }
      
      
      ArrayList<Result> result2send = new ArrayList<Result>(); 
 
      String url;
      for (int i = 0; i<libraries.size(); i++) {
    	  for(int j = 0; j<arrayCols+arrayCols2;j++) {
    		  if(libraries.get(i).getLibrary_name().equals(final_result[j][1])) {
    			  if(libraries.get(i).getLibrary_location().equals(districts.get(0).split("&")[0])) {
    				  url=districts.get(0).split("&")[2];
    			  }else {
    				  url=districts.get(1).split("&")[2];
    			  }
    			  result2send.add(new Result(final_result[j][0], final_result[j][1], libraries.get(i).getLat(), libraries.get(i).getLon(), url, libraries.get(i).get_distance()));
    		  }
    	  }
      }
    
      Collections.sort(result2send, new Comparator<Result>()
      {  @Override
    	public int compare(Result o1, Result o2) {
    			return o1.get_distance() < o2.get_distance() ? -1: o1.get_distance() > o2.get_distance() ? 1:0;
    		}
      });
     
      
      for (int i = 0 ; i < result2send.size() ; i++) {
    	  System.out.println(result2send.get(i).toString());
      }
      
      
      
      request.setAttribute("final_result", result2send);
      
		
      
      RequestDispatcher rd=request.getRequestDispatcher("/resultbook.jsp");
      rd.forward(request,response);

      conn.close();
      

      
   } catch (RserveException e) {
      e.printStackTrace();
   } catch (REXPMismatchException e) {
      e.printStackTrace();
   }
}

}






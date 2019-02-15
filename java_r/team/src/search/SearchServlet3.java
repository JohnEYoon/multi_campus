package search;

import java.io.IOException;
import java.io.PrintWriter;

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

/**
 * Servlet implementation class SearchServlet
 */
@WebServlet("/search3")
public class SearchServlet3 extends HttpServlet {
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	System.out.println("search3");
	String booktitle=request.getParameter("booktitle");
	System.out.println(booktitle);
	
	PrintWriter out = response.getWriter();

	
	String result = "";
	try {
		RConnection conn = new RConnection();

		conn.eval("library(rvest)");

		conn.assign("search", booktitle);

		REXP x=conn.eval("imsi<-source('c:/RStudy/resultmapo.R',encoding='UTF-8'); imsi$value");
		RList list = x.asList();
		int v_size = list.size();
		int d_length = list.at(0).length();
		System.out.println("데이터(관측치)의 갯수 : " +d_length);
		System.out.println("변수의 갯수 : " +  v_size);
		
		int arrayRows =  v_size;
		int arrayCols =d_length;
		String[][] s = new String[arrayRows][];  // 데이터프레임의 변수 갯수로 행의 크기를 정한다.

		for (int i = 0; i < arrayRows; i++) {
			s[i] = list.at(i).asStrings();
		}

		for (int i = 0; i < arrayRows; i++) {
			for (int j = 0; j < arrayCols; j++) {
				System.out.print(s[i][j]+"\t");
			}
			System.out.println();
		}
		
		/*
			 * 
			 * REXP x2=conn.
			 * eval("imsi2<-source('c:/RStudy/resultseongbook.R',encoding='UTF-8'); imsi2$value"
			 * );
			 * 
			 * //conn.eval("search<-'정의란 무엇인가'");
			 * 
			 * 
			 * RList list2 = x2.asList(); int v_size2 = list2.size(); int d_length2 =
			 * list2.at(0).length(); System.out.println("데이터(관측치)의 갯수 : " +d_length);
			 * System.out.println("변수의 갯수 : " + v_size);
			 * 
			 * int arrayRows2 = v_size; int arrayCols2 =d_length; String[][] s2 = new
			 * String[arrayRows2][]; // 데이터프레임의 변수 갯수로 행의 크기를 정한다.
			 * 
			 * for (int i = 0; i < arrayRows2; i++) { s2[i] = list2.at(i).asStrings(); }
			 * 
			 * for (int i = 0; i < arrayRows2; i++) { for (int j = 0; j < arrayCols2; j++) {
			 * System.out.print(s2[i][j]+"\t"); } System.out.println(); }
			 * 
			 * conn.close();
			 */

		
	} catch (RserveException e) {
		e.printStackTrace();
	} catch (REXPMismatchException e) {
		e.printStackTrace();
	}
	//System.out.println(result);
}

}


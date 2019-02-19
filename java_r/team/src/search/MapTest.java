package search;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.rosuda.REngine.REXP;
import org.rosuda.REngine.REXPMismatchException;

import org.rosuda.REngine.Rserve.RConnection;
import org.rosuda.REngine.Rserve.RserveException;

/**
 * Servlet implementation class MapTest
 */
@WebServlet("/map")
public class MapTest extends HttpServlet {

protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	try {
		RConnection conn = new RConnection();

		conn.eval("library(rvest)");
		conn.eval("library(wordcloud2)");
		conn.eval("library('devtools')");
		conn.eval("library(leaflet)");
		conn.eval("library('ggmap')");
		conn.eval("library(ggplot2)");
		
		
		REXP x=conn.eval("imsi<-source('c:/RStudy/rmaptest.R',encoding='UTF-8'); imsi$value");
			
		conn.close();
		
		
	} catch (RserveException e) {
		e.printStackTrace();
	} 
}

}

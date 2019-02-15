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
import org.rosuda.REngine.Rserve.RConnection;
import org.rosuda.REngine.Rserve.RserveException;

/**
 * Servlet implementation class SearchServlet
 */
@WebServlet("/search")
public class SearchServlet extends HttpServlet {
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	String booktitle=request.getParameter("booktitle");
	System.out.println(booktitle);
	String result = "";
	PrintWriter out = response.getWriter();


	try {
		RConnection conn = new RConnection();
		conn.assign("msg", booktitle);
		//REXP x = conn.eval("info <- paste(iconv(msg, 'CP949','UTF-8'), ' : ', R.version.string); info");
		REXP x = conn.eval("info <- paste(msg,' : ', R.version.string); info");
		result = x.asString();
		conn.close();
	} catch (RserveException e) {
		e.printStackTrace();
	} catch (REXPMismatchException e) {
		e.printStackTrace();
	}
	System.out.println(result);
	out.println(result);
}}


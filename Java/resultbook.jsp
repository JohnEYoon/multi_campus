<%@page import="java.io.PrintWriter"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.apache.catalina.startup.SetAllPropertiesRule"%>
<%@page import="search.SearchServlet4"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

</head>
<body>

<% 
//ArrayList<String[][]> list_book = new ArrayList<String[][]>();
/*    //request.getAttribute("list_book");
   ArrayList<String[][]> list_book = (ArrayList<String[][]>)request.getAttribute("list_book");
   System.out.println(list_book); */
   
   String [][] songpa =(String[][])request.getAttribute("songpa");
   String [][] seongbuk =(String[][])request.getAttribute("seongbuk");
   
   int arrayRows=(int)request.getAttribute("arrayRows");
   int arrayCols=(int)request.getAttribute("arrayCols");
   int arrayRows2=(int)request.getAttribute("arrayRows2");
   int arrayCols2=(int)request.getAttribute("arrayCols2");
   
  // System.out.println(songpa[0][0]);
  
 	ArrayList<String> title = new ArrayList<String>();
 	ArrayList<String> library = new ArrayList<String>();
 	
/*  	for (int i = 0; i < arrayCols; i++) {
        for (int j = 0; j < arrayRows; j++) {
        	out.print(songpa[j][i]+"&nbsp");
        	title.add(songpa[0][i]);
        }
        out.print("<br>");
 	} */

	for(int i=0;i<arrayCols;i++){
		title.add(songpa[0][i]);
		library.add(songpa[1][i]);
	}
	
 	
/*  	for (int i = 0; i < arrayCols2; i++) {
        for (int j = 0; j < arrayRows2; j++) {
        	out.print(seongbuk[j][i]+"&nbsp");
        	title.add(seongbuk[0][i]);
        }
        out.print("<br>");
     } */
	for(int i=0;i<arrayCols2;i++){
			title.add(seongbuk[0][i]);
			library.add(seongbuk[1][i]);
		} 	

 	for(int i=0;i<title.size();i++){
	 	out.print(title.get(i)+"&nbsp"+library.get(i));
	 	out.print("<br>");
 	}
 	
 	


%>


</body>

</html>
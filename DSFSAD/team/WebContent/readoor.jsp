<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.lang.String"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<script src="http://code.jquery.com/jquery-1.11.0.js"></script>
<script>

	var lati;
	var longi;
	var old=false;
	
    $(function() {        
        // Geolocation API에 액세스할 수 있는지를 확인
        if (navigator.geolocation) {
            //위치 정보를 얻기
            navigator.geolocation.getCurrentPosition (function(pos) {
                
            	<%if(request.getParameter("lat")==null){%>
            	$('#latitude').html(pos.coords.latitude);     // 위도\
                $('#longitude').html(pos.coords.longitude); // 경도
  
                
               location.href="readoor.jsp?lat="+pos.coords.latitude+"&long="+pos.coords.longitude;
                <%}%>
            });
        } else {
            alert("이 브라우저에서는 Geolocation이 지원되지 않습니다 chrome을 이용해주시기 바랍니다.");
        }
    });
    
</script>
</head>
<body>
	<%
	String lati = request.getParameter("lat");
	String longi = request.getParameter("long");
	
	%>
	
	<h2>검색할 책을 입력하세요</h2>
	<hr>
	<form action="/team/search4" method="get">
		제목: <input type="text" id=title name=booktitle><br>

		
		<input type="hidden" name="latitude" value=<%=lati %>>
		<input type="hidden" name="longitude" value=<%=longi %>>
		<input type="submit" value="검색">
		</form>
	</body>
    
        

</html>
<%@page import="java.util.ArrayList"%>
<%@page import="search.Oracle"%>
<%@page import="search.OracleVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang = "ko">
	<head>
		<meta charset="utf-8">
		<title>leaflet map example01</title>
		<link rel="stylesheet" href="script/leaflet.css">
 		<script type="text/javascript" src="script/leaflet.js"></script>
		<style>
			 html, body, #mapid {
	  				height: 100%;
					max-width: 80%;	
	  			}
	 </style>
</head>
<script src= "jquery-3.2.1.min.js" ></script>
<form>
<body>



<%
user_location_lat = request.getparameter('user_location_lat'); // 유저 위치 받아오기 ( lon)
user_location_lon = request.getparameter('user_location_lon'); // 유저 위치 받아오기 ( lon)
library_list = request.getParameterValues('library'); // 도서관 정보들 받아오기 ( list형식으로 )
%>

<script>
var map = L.map('mapid').setView([<%user_location_lat,user_location_lon%>],20);
</script>
<% 
for (int i = 0; i<library_list.size(); i++){

	libaray_name = library_list[i][1];
	library_lon = library_list[i][2];
	library_lat = library_list[i][3];
	libary_location = library_list[i][4];
%>
<script>
	var marker = L.marker([<%library_lat, library_lon%>]).addTo(map);
	marker.bindPopup(<b><%library_name%></b>).openPopup();
	
	var osm = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',{
	    attribution:'&copy; <a href="http://openstreetmap.org">OpenStreetMap</a> Contributors'
	}).addTo(map);
</script>	
<%}%>

</form>
</body>

</html> 
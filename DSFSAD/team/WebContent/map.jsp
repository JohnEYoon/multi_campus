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

<body>
	<div id="mapid">
	</div>
</body>
	<script>

	
	var x = 37.8;
	var y = 128.0;
	var map = L.map('mapid').setView([37.559097,127.032776],20);
	
	var marker = L.marker([37.559097, 127.032776]).addTo(map);
	marker.bindPopup("<b>성동구립</b>").openPopup();
	
	var osm = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',{
	    attribution:'&copy; <a href="http://openstreetmap.org">OpenStreetMap</a> Contributors'
	}).addTo(map);
	</script>

</html>
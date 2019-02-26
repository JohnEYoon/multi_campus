<%@page import="java.io.PrintWriter"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.apache.catalina.startup.SetAllPropertiesRule"%>
<%@page import="search.SearchServlet4"%>
<%@page import="search.Result"%>
<%@page import="java.lang.String"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
   <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>추악한 까마귀</title>
    <script src="http://maps.google.com/maps/api/js?key=AIzaSyDcSiP_YUmvtf5SVuhe2gY4zsZ2OLb-QWQ" type="text/javascript"></script>
	<script src="http://code.jquery.com/jquery-1.11.0.js"></script>
	  
    <!--Bootstrap core CSS-->
    <link rel="stylesheet" href="/css/bootstrap.css"> 
    <link href="css/bootstrap.min.css" rel="stylesheet">
    
    <!--Custom Fonts-->
    <link href='http://fonts.googleapis.com/css?family=Open+Sans:300italic,400italic,600italic,700italic,800italic,400,300,600,700,800' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Merriweather:400,300,300italic,400italic,700,700italic,900,900italic' rel='stylesheet' type='text/css'>
   

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

    <!-- Custom styles for this template -->
    <link href="css/custom.css" rel="stylesheet">
    <link rel="stylesheet" href="css/contact-input-style.css">
    <link rel="stylesheet" href="css/hover-effect.css">
    <link rel="stylesheet" type="text/css" href="css/font-awesome.min.css" />
    <style>

	#th th
{
    text-align: center; 
    vertical-align: middle;
}
.jumbotron {
  background-image: url("WebContent/img/grand.jpg");
  transition: 1000ms;
}

.jumbotron:hover {
  background-image: url("WebContent/img/grand2.jpg");  
  transition: 1000ms;
}

</style>

</head>
<body>
<% 
   ArrayList<Result> result =(ArrayList<Result>)request.getAttribute("final_result");

   double latitude = (double)request.getAttribute("latitude");
   double longitude = (double)request.getAttribute("longitude");
 %>
  
<section class="banner-sec">
<div class="container">
<div class="jumbotron">
<br><br><br><br><br>
<h1>SEARCH BOOK</h1>
<div class="input-group">
<span class="input-group-btn">
   <form action="/team/search4" method="get">
      <input type="text" placeholder="책 검색" class="form-control" id=title name=booktitle>
      
      <input type="hidden" name="latitude" value=<%=latitude %>>
      <input type="hidden" name="longitude" value=<%=longitude %>>
	<button type="submit" class="btn btn-search">Search</button>
	</form>
</span>
 </div>
</div>
</div>
</section>

<section class="text-center">
<div class="table-responsive">
<div class="jumbotron">
    <form id="boardForm" name="boardForm" method="post">
        <table class="table table-bordered table-hover">
            <thead style='text-align:center;vertical-align:middle'>
                <tr id="th">
                    <th>서명</th>
                    <th>소장도서관</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="result" items="${list }" varStatus="status">
                <tr>
                	<td>
                    	<%
						 	for(int i=0;i<result.size();i++){
							 	%><ul><a href="<%= result.get(i).getSite_url()%>"><% out.print(result.get(i).getBook_title());%></a></ul><%
							 	}
						  %>
				  	</td>
				  	<td>
                    	<%
						 	for(int i=0;i<result.size();i++){
							 	%><ul><% out.print(result.get(i).getLibrary_name());%></ul><%
							 	}
						  %>
			  		</td>
			  	</tr>
                </c:forEach>
            </tbody>
        </table>
        
    </form>
</div>
</div>
</section>

<section class="text-center">
<div class="jumbotron">
   <div id="map" style="height: 500px; width: 100%;">
</div>
<script type="text/javascript">
    
    var locations=new Array();
    
    <%for(int i = 0 ; i < result.size(); i++){%>
   
       var name = "<%=result.get(i).getLibrary_name()%>";
      locations[<%=i%>]=[name, <%=result.get(i).getLatitude()%>, <%=result.get(i).getLongitude()%>, <%=i%>];
    <%}%>

    var map = new google.maps.Map(document.getElementById('map'), {
      zoom: 13,
      center: new google.maps.LatLng(<%=latitude%>, <%=longitude%>),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });

    var infowindow = new google.maps.InfoWindow();

    var marker, i;

    for (i = 0; i < locations.length; i++) { 
      marker = new google.maps.Marker({
        position: new google.maps.LatLng(locations[i][1], locations[i][2]),
        map: map
      });

      google.maps.event.addListener(marker, 'click', (function(marker, i) {
        return function() {
          infowindow.setContent(locations[i][0]);
          infowindow.open(map, marker);
        }
      })(marker, i));
    }
  </script>
</div>
</section>


    <!-- Bootstrap core JavaScript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="js/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="js/ie10-viewport-bug-workaround.js"></script>
    <script src="js/oppear_1.1.2.min.js"></script>
    <script> 
	
	$(window).scroll(function () {
		var sticky = $('.navbar-brand'),
		    scroll = $(window).scrollTop();
			
			if (scroll >= 250) sticky.addClass('dark');
			else sticky.removeClass('dark');
			
	});
	
	$('.service-box').Oppear({
		delay : 500,
		});
	$('.main-text').Oppear({
		direction:'right',
	});
	$('.points').Oppear({
		direction:'left',
	});
	$('.up-effect').Oppear({
		direction:'up',
	});
	$('.down-effect').Oppear({
		direction:'down',
	});
	$('.left-effect').Oppear({
		direction:'right',
	});
	$('.right-effect').Oppear({
		direction:'left',
	});
	
	
		
    </script>
    <script>
	$('a[href^="#"]').on('click', function(event) {

    var target = $( $(this).attr('href') );

    if( target.length ) {
        event.preventDefault();
        $('html, body').animate({
            scrollTop: target.offset().top
        }, 1000);
    }

});

</script>

</body>

</html>
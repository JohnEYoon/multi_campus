<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>효원이네 도서관</title>
<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    
    <title></title>

    <!--Bootstrap core CSS-->
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
</head>
<body>


<section class="banner-sec" id="home">
<div class="container">
<div class="jumbotron">
<br><br><br><br><br>
<h1>Search BOOK</h1>
<div class="input-group">
<span class="input-group-btn">
	<form action="/team/search4" method="get">
	<input type="text" placeholder="책 검색" class="form-control" id=title name=booktitle>
	<button type="submit" class="btn btn-search">Search</button>
	</form>
</span>
</div>
</div>
</div>
</section>


<section class="team-sec" id="team">
  <div class="container">
    <div class="row">
      <h2 class="text-center">Our Team<br></h2>

      <div class="col-lg-3 col-md-6 col-sm-6 text-center member-block"> <img class="up-effect" src="img/team-member-02.png">
        <h3 class="up-effect">김희영</h3>
        <div class="contact-con down-effect"><i class="fa fa-phone fa-2x"></i><i class="fa fa-envelope-o fa-2x"></i><i class="fa fa-heart-o fa-2x"></i></div>
              </div>
      <div class="col-lg-3 col-md-6 col-sm-6 text-center member-block"> <img class="up-effect" src="img/team-member-02.png">
        <h3 class="up-effect">윤효원</h3>
                <div class="contact-con down-effect"><i class="fa fa-phone fa-2x"></i><i class="fa fa-envelope-o fa-2x"></i><i class="fa fa-heart-o fa-2x"></i></div>                
      </div>
      <div class="col-lg-3 col-md-6 col-sm-6 text-center member-block"> <img class="up-effect" src="img/team-member-01.png">
        <h3 class="up-effect">이윤지</h3>
        <div class="contact-con down-effect"><i class="fa fa-phone fa-2x"></i><i class="fa fa-envelope-o fa-2x"></i><i class="fa fa-heart-o fa-2x"></i></div>
      </div>
      <div class="col-lg-3 col-md-6 col-sm-6 text-center member-block"> <img class="up-effect" src="img/team-member-02.png">
        <h3 class="up-effect">차재현</h3>
                <div class="contact-con down-effect"><i class="fa fa-phone fa-2x"></i><i class="fa fa-envelope-o fa-2x"></i><i class="fa fa-heart-o fa-2x"></i></div>
      </div>
    </div>
  </div>
</section>

<footer>
<div class="container">
<div class="row">
<p class="text-center">Shared by <i class="fa fa-love"></i><a href="https://bootstrapthemes.co">BootstrapThemes</a>
</p>
</div>
</div>
</footer>
    


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
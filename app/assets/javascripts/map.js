
$(function() {

	function initialize() {
	  var myLatlng = new google.maps.LatLng(33, -84);
	  var mapOptions = {
	    zoom: 4,
	    center: myLatlng
	  }
	  var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

	  var marker = new google.maps.Marker({
	      position: myLatlng,
	      map: map,
	      title: 'Hello World!'
	  });

  	  // ----------------------------------------------

		  // var triangleCoords = [
		  //   new google.maps.LatLng(25.774252, -80.190262),
		  //   new google.maps.LatLng(18.466465, -66.118292),
		  //   new google.maps.LatLng(32.321384, -64.75737)
		  // ];

		  // var bermudaTriangle = new google.maps.Polygon({
		  //   paths: triangleCoords
		  // });

	  // ----------------------------------------------

		  var centralTZCoords = [];
		  for (var i=0; i<gon.central.length; i++) {
		  	centralTZCoords.push(new google.maps.LatLng(gon.central[i][0], gon.central[i][1]))
		  }

		  var centralTZ = new google.maps.Polygon({
		  	paths: centralTZCoords
		  });

		  // ---

		  var easternTZCoords = [];
		  for (var i=0; i<gon.eastern.length; i++) {
		  	easternTZCoords.push(new google.maps.LatLng(gon.eastern[i][0], gon.eastern[i][1]))
		  }

		  var easternTZ = new google.maps.Polygon({
		  	paths: easternTZCoords
		  });

		  // ---

		  var alaskaTZCoords = [];
		  for (var i=0; i<gon.alaska.length; i++) {
		  	alaskaTZCoords.push(new google.maps.LatLng(gon.alaska[i][0], gon.alaska[i][1]))
		  }

		  var alaskaTZ = new google.maps.Polygon({
		  	paths: alaskaTZCoords
		  });

		  // ---

		  var pacificTZCoords = [];
		  for (var i=0; i<gon.pacific.length; i++) {
		  	pacificTZCoords.push(new google.maps.LatLng(gon.pacific[i][0], gon.pacific[i][1]))
		  }

		  var pacificTZ = new google.maps.Polygon({
		  	paths: pacificTZCoords
		  });

		  // ---

		  var hawaii_aleutianTZCoords = [];
		  for (var i=0; i<gon.hawaii_aleutian.length; i++) {
		  	hawaii_aleutianTZCoords.push(new google.maps.LatLng(gon.hawaii_aleutian[i][0], gon.hawaii_aleutian[i][1]))
		  }

		  var hawaii_aleutianTZ = new google.maps.Polygon({
		  	paths: hawaii_aleutianTZCoords
		  });

		  // ---

		  var mountainTZCoords = [];
		  for (var i=0; i<gon.mountain.length; i++) {
		  	mountainTZCoords.push(new google.maps.LatLng(gon.mountain[i][0], gon.mountain[i][1]))
		  }

		  var mountainTZ = new google.maps.Polygon({
		  	paths: mountainTZCoords
		  });

	  // ----------------------------------------------

	  console.log("alaska coords below");
	  console.log(gon.alaska);
	  console.log("alaska coords above");

	  // ----------------------------------------------

	  var searchString = $('#search').val();
	  $('#search').keypress(function(e) {
	      if(e.which == 13) {
	          whichTZ();
	      }
	  });

	  google.maps.event.addListener(map, 'click', function(e) {
	  	var latlong = $(e.latLng);
	  	var lat = latlong[0].A;
	  	var lng = latlong[0].F;
	  	var geocoding_url = "https://maps.googleapis.com/maps/api/geocode/json?latlng="+ lat +","+ lng +"&key=AIzaSyBgUT0t3K3y9cKJgITa8X1O7uGYjguNZT4";

	  	var formatted_address;
	  	var inUSA;
	  	var ajaxRequest = $.ajax({
	  		url: geocoding_url,
	  		type: 'GET'
	  	});
	  	ajaxRequest.done(function(response) {
	  		formatted_address = $(response)[0].results[0].formatted_address;
	  		if (formatted_address.includes("USA")) {
  				inUSA = true;
  			} else {
  				inUSA = false;
  			}

  			if (inUSA === true) {
  				if (google.maps.geometry.poly.containsLocation(e.latLng, centralTZ)) {
  					console.log("you're in the central time zone");
  				} else if (google.maps.geometry.poly.containsLocation(e.latLng, easternTZ)) {
  					console.log("you're in the eastern time zone");
  				} else if (google.maps.geometry.poly.containsLocation(e.latLng, alaskaTZ)) {
  					console.log("you're in the alaska time zone");
  				} else if (google.maps.geometry.poly.containsLocation(e.latLng, hawaii_aleutianTZ)) {
  					console.log("you're in the hawaii_aleutian time zone");
  				} else if (google.maps.geometry.poly.containsLocation(e.latLng, pacificTZ)) {
  					console.log("you're in the pacific time zone");
  				} else {
  					console.log("you're in the mountain time zone");
  				}
  			} else {
  				console.log("Unable to determine timezone because location is outside of the United States.");
  			}
	  	});
	  	ajaxRequest.fail(function() {
	  		console.log("error");
	  	});
	  });

	}

	google.maps.event.addDomListener(window, 'load', initialize);

});
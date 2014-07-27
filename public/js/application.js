$(document).ready(function() {
	
  function initialize() {
    var mapOptions = {
      center: new google.maps.LatLng(33.189708, -14.765625),
      zoom: 3
    };
    map = new google.maps.Map(document.getElementById("map-canvas"),
      mapOptions);

    google.maps.event.addListener(map, 'click', function(e) {
    var latitude = e.latLng.lat();
    var longitude = e.latLng.lng();
    console.log(latitude + ', ' + longitude);
  });
  }

    google.maps.event.addDomListener(window, 'load', initialize); 

});
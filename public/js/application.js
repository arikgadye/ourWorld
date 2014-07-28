$(document).ready(function() {
	
  function initialize() {
    var geocoder = new google.maps.Geocoder();
    var mapOptions = {
      center: new google.maps.LatLng(33.189708, -14.765625),
      zoom: 3
    };
    map = new google.maps.Map(document.getElementById("map-canvas"),
      mapOptions);

    google.maps.event.addListener(map, 'click', function(e) {
    var latitude = e.latLng.lat();
    var longitude = e.latLng.lng();
    var latlng = new google.maps.LatLng(latitude, longitude)
    geocoder.geocode({'latLng': latlng}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        if (results[1]) {
          console.log(results[1].formatted_address);         
           
        }
      }
    });
  });
  }
////// END INITIALIZE
  google.maps.event.addDomListener(window, 'load', initialize); 

});
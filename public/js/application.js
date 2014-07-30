$(document).ready(function() {	
  function initialize() {
    var data;
    var geocoder = new google.maps.Geocoder();
    var mapOptions = {
      center: new google.maps.LatLng(38.854306, -97.625295),
      zoom: 4
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
            data = results[1].address_components[2].long_name
            getData(data);
          }
        }
      });
    });
  }

function getData(data) {
  $('#ball').show();
  var ajax = $.ajax({
    url: '/times',
    type: 'GET',
    data: {state: data}
  });
  ajax.done(displayData);
}

function displayData(data) { 
  var parsed = JSON.parse(data);
  console.log(parsed);
  var feed = $('#feed');
  $('#ball').hide();
  feed.append('<div> <a href="' + parsed.url + '">' + parsed.headline + '</a></div>');
}
google.maps.event.addDomListener(window, 'load', initialize); 
});
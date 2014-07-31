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
        // console.log(results)
        if (status == google.maps.GeocoderStatus.OK) {
          if (results[4]) {
            if (results[4].formatted_address.split(',')[0] === 'United States') {
              data = results[3].formatted_address.split(',')[0]
            } else {
              data = results[4].formatted_address.split(',')[0]
            }
            console.log(data)
            // console.log(results[4].formatted_address.split(','))
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
      data: {state: data},
      statusCode: {
        500: function() {
          $('#ball').hide()
          $('#feed').append('<div id="error">No news here... try clicking somewhere else!</div>').css('color','white')
          setTimeout(function() {
            $('#feed #error').hide();
          }, 5000);
        }
      }
    });
    ajax.done(displayData);
  }

  function displayData(data) {
    console.log(data) 

    var parsed = JSON.parse(data);
    console.log(parsed);
    var feed = $('#feed');
    var status = false
    $('#ball').hide();
    feed.append('<h5>' + parsed.state + '</h5>');
    feed.append('<div id=' + parsed.id + '><a href="' + parsed.url + '" target=_blank>' + parsed.headline + '</a><br><i class="fa fa-star" id="favorite" style="color:white;"></i></div>');
    feed.append('<hr>')
    $('#' + parsed.id + ' #favorite').on('click', function() {
      if (status === false) {
        $(this).css('color', 'yellow')
        status = true
      } else {
        $(this).css('color', 'white')
        status = false
      }
    });
  }
  google.maps.event.addDomListener(window, 'load', initialize); 
});

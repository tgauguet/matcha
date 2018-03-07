
$('#somecomponent').locationpicker({
  location: {
      latitude: 48.8582,
      longitude: 2.3387
  },
  radius: 500,
  zoom: 15,
  mapTypeId: google.maps.MapTypeId.ROADMAP,
  styles: [],
  mapOptions: {},
  scrollwheel: true,
  inputBinding: {
    latitudeInput: $('#us2-lat'),
    longitudeInput: $('#us2-lon'),
    radiusInput: $('#us2-radius'),
    locationNameInput: $('#us2-address')
  },
  enableAutocomplete: false,
  enableAutocompleteBlur: false,
  autocompleteOptions: null,
  addressFormat: 'postal_code',
  enableReverseGeocode: true,
  draggable: true,
  onchanged: function(currentLocation, radius, isMarkerDropped) {},
  onlocationnotfound: function(locationName) {},
  oninitialized: function (component) {},
  // must be undefined to use the default gMaps marker
  markerIcon: undefined,
  markerDraggable: true,
  markerVisible : true
  }
);

getLocation();
var x = document.getElementById("demo");

function getLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showPosition,showError);
    } else {
        x.innerHTML = "Geolocation is not supported by this browser.";}
}

function showPosition(position) {

    lat = position.coords.latitude;
    lon = position.coords.longitude;
    document.getElementById('lat').value = lat;
    document.getElementById('lon').value = lon;

    latlon = new google.maps.LatLng(lat, lon)

    var myOptions={
    center:latlon,zoom:14,
    mapTypeId:google.maps.MapTypeId.ROADMAP,
    mapTypeControl:false,
    navigationControlOptions:{style:google.maps.NavigationControlStyle.SMALL}
    }

}

function showError(error) {
    switch(error.code) {
        case error.PERMISSION_DENIED:
            x.innerHTML = "User denied the request for Geolocation."
            break;
        case error.POSITION_UNAVAILABLE:
            x.innerHTML = "Location information is unavailable."
            break;
        case error.TIMEOUT:
            x.innerHTML = "The request to get user location timed out."
            break;
        case error.UNKNOWN_ERROR:
            x.innerHTML = "An unknown error occurred."
            break;
    }

}

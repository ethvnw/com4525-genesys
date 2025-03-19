// Loads data into the search bars and map markers when the page loads.

import {
  updateLocationPin, startMarker, tripAutocomplete,
} from './trips_new';

const locationName = document.getElementById('location_name_input').value;
const latitude = parseFloat(document.getElementById('latitude_input').value);
const longitude = parseFloat(document.getElementById('longitude_input').value);

// Set the start and end location values if they are present.
if (latitude && longitude) {
  tripAutocomplete.setQuery(locationName);
  updateLocationPin(startMarker, latitude, longitude);
}

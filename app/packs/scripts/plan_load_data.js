// Loads data into the search bars and map markers when the page loads.

import {
  updateLocationPin, startMarker, endMarker,
  updateEndLocationInput, startAutocomplete, endAutocomplete,
} from './plans_new';

// Show the end location input if the plan type is a travel plan.
updateEndLocationInput();

const startName = document.getElementById('plan_start_location_name').value;
const startLat = parseFloat(document.getElementById('plan_start_location_latitude').value);
const startLng = parseFloat(document.getElementById('plan_start_location_longitude').value);
const endName = document.getElementById('plan_end_location_name').value;
const endLat = parseFloat(document.getElementById('plan_end_location_latitude').value);
const endLng = parseFloat(document.getElementById('plan_end_location_longitude').value);

// Set the start and end location values if they are present.
if (startLat && startLng) {
  startAutocomplete.setQuery(startName);
  updateLocationPin(startMarker, startLat, startLng);
}
if (endLat && endLng) {
  endAutocomplete.setQuery(endName);
  updateLocationPin(endMarker, endLat, endLng);
}

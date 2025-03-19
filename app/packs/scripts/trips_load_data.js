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

const startDate = document.getElementById('start_date_input').getAttribute('value');
const endDate = document.getElementById('end_date_input').getAttribute('value');

// Set the start and end date values into the date range picker
if (startDate && endDate) {
  const dateRangePicker = document.getElementById('datetimepicker1');
  dateRangePicker.defaultDate = new Date(startDate);
}

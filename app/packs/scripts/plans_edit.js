import {
  updateLocationPin, startMarker, endMarker, updateEndLocationInput,
} from './plans_new';

// Make map show start and end location pins if they exist.
updateEndLocationInput();

const startLat = parseFloat(document.getElementById('plan_start_location_latitude').value);
const startLng = parseFloat(document.getElementById('plan_start_location_longitude').value);
const endLat = parseFloat(document.getElementById('plan_end_location_latitude').value);
const endLng = parseFloat(document.getElementById('plan_end_location_longitude').value);

if (startLat && startLng) {
  updateLocationPin(startMarker, startLat, startLng);
}

if (endLat && endLng) {
  updateLocationPin(endMarker, endLat, endLng);
}

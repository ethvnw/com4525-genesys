import $ from 'jquery';
import {
  updateLocationPin, startMarker, endMarker, updateEndLocationInput,
} from './plans_new';

/**
 * Make map show start and end location pins if they exist.
 */
$(document).ready(() => {
  updateEndLocationInput();
  const startLat = parseFloat($('#plan_start_location_latitude').val());
  const startLng = parseFloat($('#plan_start_location_longitude').val());
  const endLat = parseFloat($('#plan_end_location_latitude').val());
  const endLng = parseFloat($('#plan_end_location_longitude').val());

  if (startLat && startLng) {
    updateLocationPin(startMarker, startLat, startLng);
  }

  if (endLat && endLng) {
    updateLocationPin(endMarker, endLat, endLng);
  }
});

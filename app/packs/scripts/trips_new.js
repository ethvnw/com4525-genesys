// Intialises the map and location searches for new plan page.

import createAutocomplete, { updateLocationPin, startMarker } from './lib/AlgoliaAutocomplete';
import setupPicker from './date_range_picker';
import RoamioMap from './lib/map/RoamioMap';

let tripAutocomplete = null;

/**
 * Initialises the trip form with map and location search functionality
 */
function setupTripForm() {
  setupPicker(false);
  RoamioMap.initialise();

  // Clean up and reinitialise autocomplete
  // Algolia doesn't support multiple simultaneous instances
  if (tripAutocomplete) {
    tripAutocomplete.destroy();
  }
  tripAutocomplete = createAutocomplete('#trip-location-autocomplete', 'trip');

  // Restore existing location if present
  const locationName = document.getElementById('trip_location_name_input').value;
  const latitude = parseFloat(document.getElementById('trip_location_latitude_input').value);
  const longitude = parseFloat(document.getElementById('trip_location_longitude_input').value);

  if (latitude && longitude) {
    tripAutocomplete.setQuery(locationName);
    updateLocationPin(startMarker, latitude, longitude, locationName);
  }
}

// Initialise form on page load and reinitialise on content updates
document.addEventListener('turbo:load', () => {
  setupTripForm();

  const tripFormObserver = new MutationObserver(setupTripForm);
  tripFormObserver.observe(document.querySelector('#content .container'), { childList: true });
});

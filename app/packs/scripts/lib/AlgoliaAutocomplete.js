import { autocomplete } from '@algolia/autocomplete-js';
import '@algolia/autocomplete-theme-classic';
import { getLocationSearchApiRoute } from '../constants/api_routes';

const DEBOUNCE_MS = 300;

// const startMarker = L.marker([0, 0]);
// const endMarker = L.marker([0, 0]);
// const line = L.polyline([], { color: 'red' });

// /**
//  * Update the location pin on the map with the new latitude and longitude.
//  * Also updates the line between the start and end locations if both are set.
//  * @param {L.Marker} marker The marker to update
//  * @param {number} lat The new latitude
//  * @param {number} lng The new longitude
//  * @param {string} locationLabel The label to display on the marker
//  */
// const updateLocationPin = (marker, lat, lng, locationLabel) => {
//   marker.remove();
//   marker.setLatLng([lat, lng]);
//   marker.addTo(RoamioMap.map);
//   marker.bindPopup(locationLabel).openPopup();
//   RoamioMap.map.setView([lat, lng], 10);
//
//   if (startMarker.getLatLng().lat !== 0 && endMarker.getLatLng().lat !== 0) {
//     line.remove();
//     line.setLatLngs([startMarker.getLatLng(), endMarker.getLatLng()]);
//     line.addTo(RoamioMap.map);
//     RoamioMap.map.fitBounds(line.getBounds());
//   }
// };

/**
 * Debounce a promise-returning function.
 * @param {Function} fn - Function to debounce
 * @param {number} time - Debounce delay in milliseconds
 * @returns {Function} Debounced function
 */
function debouncePromise(fn, time) {
  let timer;
  return function debounced(...args) {
    clearTimeout(timer);
    return new Promise((resolve) => {
      timer = setTimeout(() => resolve(fn(...args)), time);
    });
  };
}

const debouncedPromise = debouncePromise((items) => Promise.resolve(items), DEBOUNCE_MS);

/**
   * Formats a place object into a displayable string
   * @param {Object} place - Place object from Photon API
   * @returns {string} Formatted location string
   */
function formatPlaceName(place) {
  const { name, city, country } = place.properties;
  return [name, city, country].filter(Boolean).join(', ');
}

/**
 * Creates an autocomplete instance for location search
 * @param {string} containerId - DOM element ID for the autocomplete container
 * @param {string} searchType - Type of location search
 * @param {function} onSelect - Callback for when an item is selected
 * @returns {Object} Autocomplete instance
 */
const createAutocomplete = (containerId, searchType, onSelect) => autocomplete({
  container: containerId,
  placeholder: 'Where are you going?',
  detachedMediaQuery: '',
  stallThreshold: 700,
  classNames: { input: 'fw-bold' },
  getSources({ query }) {
    return debouncedPromise([{
      sourceId: 'places',
      async getItems() {
        const response = await fetch(getLocationSearchApiRoute(query));
        const data = await response.json();
        return data.features.map((place) => ({
          name: formatPlaceName(place),
          lat: place.geometry.coordinates[1],
          lng: place.geometry.coordinates[0],
        }));
      },
      getItemInputValue: ({ item }) => item.name,
      onSelect,
      templates: {
        item: ({ item }) => item.name,
      },
    }]);
  },
});

export default createAutocomplete;
export {
  debouncedPromise,
};

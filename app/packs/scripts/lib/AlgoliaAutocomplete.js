import L from 'leaflet';
import { autocomplete } from '@algolia/autocomplete-js';
import '@algolia/autocomplete-theme-classic';
import RoamioMap from './map/RoamioMap';

const DEBOUNCE_MS = 300;

const startMarker = L.marker([0, 0]);
const endMarker = L.marker([0, 0]);
const line = L.polyline([], { color: 'red' });

/**
 * Update the location pin on the map with the new latitude and longitude.
 * Also updates the line between the start and end locations if both are set.
 * @param {L.Marker} marker The marker to update
 * @param {number} lat The new latitude
 * @param {number} lng The new longitude
 * @param {string} locationLabel The label to display on the marker
 */
const updateLocationPin = (marker, lat, lng, locationLabel) => {
  marker.remove();
  marker.setLatLng([lat, lng]);
  marker.addTo(RoamioMap.map);
  marker.bindPopup(locationLabel).openPopup();
  RoamioMap.map.setView([lat, lng], 10);

  if (startMarker.getLatLng().lat !== 0 && endMarker.getLatLng().lat !== 0) {
    line.remove();
    line.setLatLngs([startMarker.getLatLng(), endMarker.getLatLng()]);
    line.addTo(RoamioMap.map);
    RoamioMap.map.fitBounds(line.getBounds());
  }
};

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
 * @returns {Object} Autocomplete instance
 */
const createAutocomplete = (containerId, searchType) => autocomplete({
  container: containerId,
  placeholder: `Search for a ${searchType} location`,
  detachedMediaQuery: '',
  stallThreshold: 700,
  classNames: { input: 'fw-bold' },
  getSources({ query }) {
    return debouncedPromise([{
      sourceId: 'places',
      async getItems() {
        const response = await fetch(`https://photon.komoot.io/api/?q=${query}&limit=5`);
        const data = await response.json();
        return data.features.map((place) => ({
          name: formatPlaceName(place),
          lat: place.geometry.coordinates[1],
          lng: place.geometry.coordinates[0],
        }));
      },
      getItemInputValue: ({ item }) => item.name,
      onSelect({ item }) {
        const locationNameInput = document.getElementById(`${searchType}_location_name_input`);
        const latitudeInput = document.getElementById(`${searchType}_location_latitude_input`);
        const longitudeInput = document.getElementById(`${searchType}_location_longitude_input`);

        locationNameInput.value = item.name;
        latitudeInput.value = item.lat;
        longitudeInput.value = item.lng;

        const marker = searchType === 'end' ? endMarker : startMarker;
        updateLocationPin(marker, item.lat, item.lng, item.name);
      },
      templates: {
        item: ({ item }) => item.name,
      },
    }]);
  },
});

export default createAutocomplete;
export {
  updateLocationPin, startMarker, endMarker, line,
};

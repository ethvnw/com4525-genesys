// Intialises the map and location searches for new plan page.
// Adapted from Ethan & Ellis' code, excuse the messiness
// TODO: Try and make reusable geolocation stuff over Easter

import { autocomplete } from '@algolia/autocomplete-js';
import '@algolia/autocomplete-theme-classic';
import L from 'leaflet';
import setupPicker from './date_range_picker';
import RoamioMap from './lib/map/RoamioMap';

// Constants
const DEBOUNCE_MS = 300;

// Required global variables
let startMarker;
let endMarker;
let tripAutocomplete = null;

/**
 * Updates a location marker on the map and centres the view
 * @param {L.Marker} marker - The marker to update
 * @param {number} lat - The new latitude
 * @param {number} lng - The new longitude
 */
const updateLocationPin = (marker, lat, lng) => {
  marker.setLatLng([lat, lng]);
  marker.addTo(RoamioMap.map);
  marker.bindPopup('Trip Location').openPopup();
  map.setView([lat, lng], 10);
};

/**
 * Debounce a promise returning function.
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
 * @param {'start' | 'end'} searchType - Type of location search
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
      getItems() {
        return fetch(`https://photon.komoot.io/api/?q=${query}&limit=5`)
          .then((response) => response.json())
          .then((data) => data.features.map((place) => ({
            name: formatPlaceName(place),
            lat: place.geometry.coordinates[1],
            lng: place.geometry.coordinates[0],
          })));
      },
      getItemInputValue: ({ item }) => item.name,
      onSelect({ item }) {
        const locationNameInput = document.getElementById('location_name_input');
        const latitudeInput = document.getElementById('latitude_input');
        const longitudeInput = document.getElementById('longitude_input');

        locationNameInput.value = item.name;
        latitudeInput.value = item.lat;
        longitudeInput.value = item.lng;

        const marker = searchType === 'start' ? startMarker : endMarker;
        updateLocationPin(marker, item.lat, item.lng);
      },
      templates: {
        item: ({ item }) => item.name,
      },
    }]);
  },
});

/**
 * Initialises the trip form with map and location search functionality
 */
function setupTripForm() {
  setupPicker(false);

  RoamioMap.initialise();
  startMarker = L.marker([0, 0]);
  endMarker = L.marker([0, 0]);

  // Clean up and reinitialise autocomplete
  // Algolia doesn't support multiple simultaneous instances
  if (tripAutocomplete) {
    tripAutocomplete.destroy();
  }
  tripAutocomplete = createAutocomplete('#trip-location-autocomplete', 'trip');

  // Restore existing location if present
  const locationName = document.getElementById('location_name_input').value;
  const latitude = parseFloat(document.getElementById('latitude_input').value);
  const longitude = parseFloat(document.getElementById('longitude_input').value);

  if (latitude && longitude) {
    tripAutocomplete.setQuery(locationName);
    updateLocationPin(startMarker, latitude, longitude);
  }
}

// Initialise form on page load and reinitialise on content updates
document.addEventListener('turbo:load', () => {
  setupTripForm();

  const tripFormObserver = new MutationObserver(setupTripForm);
  tripFormObserver.observe(document.querySelector('#content .container'), { childList: true });
});

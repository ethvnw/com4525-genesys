// Intialises the map and location searches for new plan page.
// Adapted from Ethan & Ellis' code, excuse the messiness
// TODO: Try and make reusable geolocation stuff over Easter

import { autocomplete } from '@algolia/autocomplete-js';
import '@algolia/autocomplete-theme-classic';
import L from 'leaflet';

const startMarker = L.marker([0, 0]);
const endMarker = L.marker([0, 0]);
const googleHybrid = L.tileLayer('http://{s}.google.com/vt/lyrs=s,h&x={x}&y={y}&z={z}', {
  maxZoom: 20,
  subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
});
const map = L.map('map', {
  center: [0, 0],
  zoom: 1,
  maxZoom: 20,
  minZoom: 1,
  maxBounds: [
    [-90, -180],
    [90, 180],
  ],
});
map.addLayer(googleHybrid);

/**
 * Update the location pin on the map with the new latitude and longitude.
 * Also updates the line between the start and end locations if both are set.
 * @param {L.marker} marker The marker to update
 * @param {float} lat The new latitude
 * @param {float} lng The new longitude
 */
const updateLocationPin = (marker, lat, lng) => {
  marker.setLatLng([lat, lng]);
  marker.addTo(map);
  marker.bindPopup('Trip Location').openPopup();
  map.setView([lat, lng], 10);
};

/**
 * Debounce a promise returning function.
 * @param {*} fn The function to debounce
 * @param {*} time The time to debounce by
 * @returns {function} The debounced function
 */
function debouncePromise(fn, time) {
  let timer;

  return function debounced(...args) {
    if (timer) {
      clearTimeout(timer); // Clear the timeout first if it's already defined.
    }

    return new Promise((resolve) => {
      timer = setTimeout(() => resolve(fn(...args)), time);
    });
  };
}

const DEBOUNCE_MS = 300;
const debounced = debouncePromise((items) => Promise.resolve(items), DEBOUNCE_MS);

/**
 * Create an autocomplete object for a given container id and text.
 * @param {string} containerId The id of the container to create the autocomplete in
 * @param {string} text The text to display in the placeholder
 * @returns {object} The created autocomplete object
 */
const createAutocomplete = (containerId, text) => autocomplete({
  container: containerId,
  placeholder: `Search for a ${text} location`,
  detachedMediaQuery: '',
  stallThreshold: 700,
  classNames: {
    input: 'fw-bold',
  },
  getSources({ query }) {
    return debounced([
      {
        sourceId: 'places',
        getItems() {
          return fetch(
            `https://photon.komoot.io/api/?q=${query}&limit=5`,
          ).then((response) => response.json())
            .then((data) => data.features.map((place) => ({
              name: [place.properties.name, place.properties.city, place.properties.country].filter(Boolean).join(', '),
              lat: place.geometry.coordinates[1],
              lng: place.geometry.coordinates[0],
            })));
        },
        getItemInputValue({ item }) {
          return item.name;
        },
        onSelect({ item }) {
          // Update the values in the form input fields with the name and geolocation.
          const locationNameInput = document.getElementById('location_name_input');
          const latitudeInput = document.getElementById('latitude_input');
          const longitudeInput = document.getElementById('longitude_input');

          locationNameInput.value = item.name;
          latitudeInput.value = item.lat;
          longitudeInput.value = item.lng;

          updateLocationPin(text === 'start' ? startMarker : endMarker, item.lat, item.lng);
        },
        templates: {
          item({ item }) {
            return item.name;
          },
        },
      },
    ]);
  },
});

const tripAutocomplete = createAutocomplete('#trip-location-autocomplete', 'trip');

export {
  updateLocationPin, startMarker, endMarker,
  tripAutocomplete,
};

// Intialises the map and location searches for new plan page.

import { autocomplete } from '@algolia/autocomplete-js';
import '@algolia/autocomplete-theme-classic';
import L from 'leaflet';

const startMarker = L.marker([0, 0]);
const endMarker = L.marker([0, 0]);
const typeDropdown = document.getElementById('plan_plan_type');
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

let line = L.polyline([], { color: 'red' });

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
  marker.bindPopup(marker === startMarker ? 'Start Location' : 'End Location').openPopup();
  map.setView([lat, lng], 10);

  if (startMarker.getLatLng().lat !== 0 && endMarker.getLatLng().lat !== 0) {
    line.remove();
    line = L.polyline([startMarker.getLatLng(), endMarker.getLatLng()], { color: 'red' });
    line.addTo(map);
    map.fitBounds(line.getBounds());
  }
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
          const inputName = document.querySelector(`#plan_${text}_location_name`);
          const inputLat = document.querySelector(`#plan_${text}_location_latitude`);
          const inputLng = document.querySelector(`#plan_${text}_location_longitude`);
          inputName.value = item.name;
          inputLat.value = item.lat;
          inputLng.value = item.lng;

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

const startAutocomplete = createAutocomplete('#start-location-autocomplete', 'start');
const endAutocomplete = createAutocomplete('#end-location-autocomplete', 'end');

/**
 * Show the end location input if the plan type is a travel plan.
*/
const updateEndLocationInput = () => {
  const endLocationSearch = document.querySelector('#end-location-autocomplete');
  const endLocationInput = document.querySelector('#plan_end_location_name');
  const typeValue = typeDropdown.value;

  if (typeValue.split('_')[0] === 'travel') {
    endLocationSearch.classList.remove('d-none');
    endLocationInput.disabled = false;
    endLocationInput.required = true;
  } else {
    endLocationSearch.classList.add('d-none');
    endAutocomplete.setQuery('');
    endLocationInput.disabled = true;
    endLocationInput.required = false;
    endLocationInput.value = '';

    endMarker.remove();
    endMarker.setLatLng([0, 0]);
    line.remove();
  }
};

typeDropdown.addEventListener('change', updateEndLocationInput);

export {
  updateLocationPin, startMarker, endMarker,
  updateEndLocationInput, startAutocomplete, endAutocomplete,
};

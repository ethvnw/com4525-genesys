import $ from 'jquery';
import 'jquery-ui/ui/widgets/autocomplete';
import { EsriProvider } from 'leaflet-geosearch';
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

let line = L.polyline([], { color: 'red' });

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
 * Show the end location input if the plan type is a travel plan.
 */
typeDropdown.addEventListener('change', () => {
  const endLocationInput = document.getElementById('plan_end_location_name');
  const typeValue = typeDropdown.value;

  if (typeValue.split('_')[0] === 'travel') {
    endLocationInput.disabled = false;
    endLocationInput.required = true;
    endLocationInput.classList.remove('d-none');
  } else {
    endLocationInput.disabled = true;
    endLocationInput.required = false;
    endLocationInput.classList.add('d-none');
    endLocationInput.value = '';
    endMarker.remove();
    endMarker.setLatLng([0, 0]);
    line.remove();
  }
});

/**
 * Setup the autocomplete for the location input.
 * @param {string} elementId The id of the input element to setup the autocomplete for.
 */
const setupAutocomplete = (elementId) => {
  $(elementId).autocomplete({
    async source(request, response) {
      const providerform = new EsriProvider({
        params: {
          limit: 5,
        },
      });

      const results = await providerform.search({ query: request.term });
      if (results.length === 0) {
        response([{ label: 'No Results Found', value: '' }]);
        return;
      }

      if (elementId === '#plan_start_location_name') {
        document.getElementById('plan_start_location_latitude').value = results[0].y;
        document.getElementById('plan_start_location_longitude').value = results[0].x;
      } else {
        document.getElementById('plan_end_location_latitude').value = results[0].y;
        document.getElementById('plan_end_location_longitude').value = results[0].x;
      }

      updateLocationPin(elementId === '#plan_start_location_name' ? startMarker : endMarker, results[0].y, results[0].x);
      response(results);
    },
    delay: 100,
    minLength: 1,
  });
};

setupAutocomplete('#plan_start_location_name');
setupAutocomplete('#plan_end_location_name');

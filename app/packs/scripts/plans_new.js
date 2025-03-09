import $ from 'jquery';
import 'jquery-ui/ui/widgets/autocomplete';
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
const updateEndLocationInput = () => {
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
};

typeDropdown.addEventListener('change', updateEndLocationInput);

/**
 * Setup the autocomplete for the location input.
 * @param {string} elementId The id of the input element to setup the autocomplete for.
 */
const setupAutocomplete = (elementId) => {
  $(elementId).autocomplete({
    source: async (request, response) => {
      const url = `https://photon.komoot.io/api/?q=${request.term}&limit=5`;

      try {
        const data = await $.getJSON(url);
        const results = data.features.map((feature) => ({
          value: [feature.properties.name, feature.properties.city, feature.properties.country].filter(Boolean).join(', '),
          latitude: feature.geometry.coordinates[1],
          longitude: feature.geometry.coordinates[0],
        }));

        response(results);
      } catch (error) {
        response([{ label: 'No Results Found', value: '' }]);
      }
    },
    minLength: 3,
    select: (event, ui) => {
      if (elementId === '#plan_start_location_name') {
        document.getElementById('plan_start_location_latitude').value = ui.item.latitude;
        document.getElementById('plan_start_location_longitude').value = ui.item.longitude;
      } else {
        document.getElementById('plan_end_location_latitude').value = ui.item.latitude;
        document.getElementById('plan_end_location_longitude').value = ui.item.longitude;
      }

      updateLocationPin(elementId === '#plan_start_location_name' ? startMarker : endMarker, ui.item.latitude, ui.item.longitude);
    },
  });
};

setupAutocomplete('#plan_start_location_name');
setupAutocomplete('#plan_end_location_name');

export {
  updateLocationPin, startMarker, endMarker, updateEndLocationInput,
};

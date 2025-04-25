import { Controller } from '@hotwired/stimulus';
import L from 'leaflet';
import { newRoamioMap } from '../lib/map/RoamioMap';
import createAutocomplete from '../lib/AlgoliaAutocomplete';
import { MAP_ICONS } from '../lib/map/map_config';

let mapObject;

export default class extends Controller {
  connect() {
    if (!mapObject) {
      mapObject = newRoamioMap('plan-form-map');
    }

    this.map = mapObject;
    this.map.initialise();

    this.planTypeDropdown = document.getElementById('plan_plan_type');
    this.planTypeDropdown.addEventListener('change', this.updateEndLocationInput.bind(this));

    this.startLocationContainer = document.getElementById('start-location-container');
    this.startLocationInput = document.getElementById('start_location_name_input');
    this.startLocationLatitudeInput = document.getElementById('start_location_latitude_input');
    this.startLocationLongitudeInput = document.getElementById('start_location_longitude_input');

    this.endLocationContainer = document.getElementById('end-location-container');
    this.endLocationInput = document.getElementById('end_location_name_input');
    this.endLocationLatitudeInput = document.getElementById('end_location_latitude_input');
    this.endLocationLongitudeInput = document.getElementById('end_location_longitude_input');

    this.startLocationAutocomplete = createAutocomplete('#start-location-autocomplete', 'start', ({ item }) => {
      this.startLocationInput.value = item.name;
      this.startLocationLatitudeInput.value = item.lat;
      this.startLocationLongitudeInput.value = item.lng;
      this.updateMarker('start', item);
    });

    this.endLocationAutocomplete = createAutocomplete('#end-location-autocomplete', 'end', ({ item }) => {
      this.endLocationInput.value = item.name;
      this.endLocationLatitudeInput.value = item.lat;
      this.endLocationLongitudeInput.value = item.lng;
      this.updateMarker('end', item);
    });

    // Set end location visible if necessary
    this.updateEndLocationInput();

    // Restore existing locations if present
    const startName = this.startLocationInput.value;
    const startLat = parseFloat(this.startLocationLatitudeInput.value);
    const startLng = parseFloat(this.startLocationLongitudeInput.value);
    const endName = this.endLocationInput.value;
    const endLat = parseFloat(this.endLocationLatitudeInput.value);
    const endLng = parseFloat(this.endLocationLongitudeInput.value);

    // Set the start and end location values if they are present.
    if (startLat && startLng) {
      this.startLocationAutocomplete.setQuery(startName);
      this.updateMarker('start', { lat: startLat, lng: startLng, name: startName });
    }
    if (endLat && endLng) {
      this.endLocationAutocomplete.setQuery(endName);
      this.updateMarker('end', { lat: endLat, lng: endLng, name: endName });
    }
  }

  /**
   * Show/hide the end location input based on whether the plan type is a travel plan.
   */
  updateEndLocationInput() {
    const typeValue = this.planTypeDropdown.value;

    const isTravelPlan = typeValue.split('_')[0] === 'travel';

    this.endLocationContainer.classList.toggle('d-none', !isTravelPlan);
    this.endLocationInput.disabled = !isTravelPlan;
    this.endLocationInput.required = isTravelPlan;

    if (!isTravelPlan) {
      // Clear end location data
      this.endLocationAutocomplete.setQuery('');
      this.endLocationInput.value = '';
      this.endLocationLatitudeInput.value = '';
      this.endLocationLongitudeInput.value = '';

      // Clear end map marker and line
      this.map.removeMarker('end-location');
      this.map.removeConnectingLine('connector');
    }
  }

  updateMarker(marker, item) {
    this.map.removeMarker(`${marker}-location`);
    this.map.addMarker(L.latLng(item.lat, item.lng), {
      key: `${marker}-location`,
      icon: MAP_ICONS.tripText(item.name, null),
    });

    // Draw line if required
    if (!this.endLocationContainer.classList.contains('d-none')
      && this.startLocationInput.value !== ''
      && this.endLocationInput.value !== ''
    ) {
      this.map.addConnectingLine([
        L.latLng(this.startLocationLatitudeInput.value, this.startLocationLongitudeInput.value),
        L.latLng(this.endLocationLatitudeInput.value, this.endLocationLongitudeInput.value),
      ], 0, 'connector');
    }
  }
}

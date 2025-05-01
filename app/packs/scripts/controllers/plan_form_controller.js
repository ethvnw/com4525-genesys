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
    this.planTypeDropdown.addEventListener('change', this.updateLocationInputsAndMap.bind(this));

    this.setupLocationInputs();
    // Set end location visible if necessary
    this.updateLocationInputsAndMap();
    // Restore existing locations if present
    this.restoreExistingLocation();
  }

  /**
   * Store location input elements as instance variables
   */
  setupLocationInputs() {
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

    this.ticketsContainer = document.getElementById('tickets-container');
  }

  /**
   * Restore location from hidden inputs if one exists
   */
  restoreExistingLocation() {
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
   * Show/hide the start and end location inputs and the map based on the plan type.
   */
  updateLocationInputsAndMap() {
    const typeValue = this.planTypeDropdown.value;

    const isFreeTimePlan = typeValue === 'free_time';
    const isTravelPlan = typeValue.split('_')[0] === 'travel';

    document.getElementById('plan-form-map').classList.toggle('d-none', isFreeTimePlan);

    // Clear and disable the start location input
    this.startLocationContainer.classList.toggle('d-none', isFreeTimePlan);
    this.startLocationInput.disabled = isFreeTimePlan;
    this.startLocationInput.required = !isFreeTimePlan;
    this.startLocationInput.value = '';
    this.startLocationLatitudeInput.value = '';
    this.startLocationLongitudeInput.value = '';

    // Clear and disable the end location input
    this.endLocationContainer.classList.toggle('d-none', isFreeTimePlan || !isTravelPlan);
    this.endLocationInput.disabled = isFreeTimePlan || !isTravelPlan;
    this.endLocationInput.required = !isFreeTimePlan && isTravelPlan;
    this.endLocationInput.value = '';
    this.endLocationLatitudeInput.value = '';
    this.endLocationLongitudeInput.value = '';

    this.ticketsContainer.classList.toggle('d-none', isFreeTimePlan);

    if (isFreeTimePlan) {
      this.map.removeMarker('start-location');
    }
    if (!isTravelPlan) {
      this.endLocationAutocomplete.setQuery('');
      this.map.removeMarker('end-location');
      this.map.removeConnectingLine('connector');
    }
  }

  /**
   * Update a marker with a new response from the autocomplete
   * @param {String} marker - the name of the marker to update
   * @param {{ name: String, lat: float, lng: float }} item - the item retrieved by the autocomplete
   */
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

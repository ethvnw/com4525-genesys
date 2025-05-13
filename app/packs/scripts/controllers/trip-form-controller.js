import { Controller } from '@hotwired/stimulus';
import L from 'leaflet';
import { newRoamioMap } from '../lib/map/RoamioMap';
import createAutocomplete from '../lib/AlgoliaAutocomplete';
import { MAP_ICONS } from '../lib/map/map_config';
import setupPicker from '../date_range_picker';
import { showOverlay, hideOverlay, addSearchLocationButtonHandler } from '../lib/map/map_overlay';
import setupPicker from '../date_range_picker_combined';

let mapObject;

export default class extends Controller {
  connect() {
    if (!mapObject) {
      mapObject = newRoamioMap('trip-form-map');
    }

    this.map = mapObject;
    this.map.initialise();

    this.locationInput = document.getElementById('trip_location_name_input');
    this.locationLatitudeInput = document.getElementById('trip_location_latitude_input');
    this.locationLongitudeInput = document.getElementById('trip_location_longitude_input');

    setupPicker(false);

    // Clean up and reinitialise autocomplete
    // Algolia doesn't support multiple simultaneous instances
    if (this.tripAutocomplete) {
      this.tripAutocomplete.destroy();
    }
    this.tripAutocomplete = createAutocomplete('#trip-location-autocomplete', 'trip', ({ item }) => {
      this.locationInput.value = item.name;
      this.locationLatitudeInput.value = item.lat;
      this.locationLongitudeInput.value = item.lng;
      this.updateMarker(item);
    });

    // Restore existing location if present
    this.restoreExistingLocation();

    // Add a 'search for a location' button to the placeholder on the map
    addSearchLocationButtonHandler();
  }

  /**
   * Restore location from hidden inputs if one exists
   */
  restoreExistingLocation() {
    const locationName = this.locationInput.value;
    const latitude = parseFloat(this.locationLatitudeInput.value);
    const longitude = parseFloat(this.locationLongitudeInput.value);

    if (latitude && longitude) {
      this.tripAutocomplete.setQuery(locationName);
      this.updateMarker({ lat: latitude, lng: longitude, name: locationName });
      hideOverlay();
      this.map.enableMapInteraction();
    } else {
      showOverlay();
      this.map.disableMapInteraction();
    }
  }

  /**
   * Update the marker with a new response from the autocomplete
   * @param {{ name: String, lat: number, lng: number }} item - the item from the autocomplete
   */
  updateMarker(item) {
    hideOverlay();
    this.map.enableMapInteraction();
    this.map.removeMarker('trip-location');
    this.map.addMarker(L.latLng(item.lat, item.lng), {
      key: 'trip-location',
      icon: MAP_ICONS.tripText(item.name, null),
    });
    this.map.fitToFeatures(5);
  }
}

import L from 'leaflet';
import { MAP_CONFIG, TILE_LAYER_CONFIG } from './map_config';

/**
 * Wrapper class for Leaflet map instances
 */
class _RoamioMap {
  /**
   * Create a Roamio map.
   * @param {string} [mapId='map'] - The HTML element ID to render the map within.
   */
  constructor(mapId = 'map') {
    this.mapId = mapId;
    this.markerFG = L.featureGroup();
  }

  /**
   * Creates a new Leaflet map instance and adds a tile layer
   * with configurations predefined in map_config.js.
   */
  initialise() {
    this.map = L.map(this.mapId, MAP_CONFIG);
    this.markerFG = L.featureGroup();
    this.markerFG.addTo(this.map);

    const tileLayer = L.tileLayer(TILE_LAYER_CONFIG.url, TILE_LAYER_CONFIG.options);
    this.map.addLayer(tileLayer);
  }

  addMarker(latLng) {
    const marker = L.marker(latLng);
    this.markerFG.addLayer(marker);

    // Fit map to bounds of feature group
    this.map.fitBounds(this.markerFG.getBounds());

    // Zoom out so all markers can be viewed without being right against the map border
    this.map.setZoom(this.map.getZoom() - 2);
  }
}

/**
 * Create a new RoamioMap instance.
 * @param {string} mapId - The ID of the map element.
 * @returns {_RoamioMap} A new RoamioMap instance.
 */
function newRoamioMap(mapId) {
  return new _RoamioMap(mapId);
}

// Create and export singleton instance of RoamioMap
const RoamioMap = newRoamioMap('map');
export default RoamioMap;
export { newRoamioMap };

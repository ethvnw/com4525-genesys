import L from 'leaflet';
import { VariablesDiv } from './lib/VariablesDiv';
import RoamioMap from './lib/map/RoamioMap';

/**
 * Initialises the map, and displays all trips/plans on there
 */
function display() {
  RoamioMap.initialise();
  const jsVariables = new VariablesDiv('map-variables');
  const markerPoints = JSON.parse(jsVariables.get('marker-coords'));

  markerPoints?.forEach((point) => {
    RoamioMap.addMarker(L.latLng(point.coords));
  });
}

document.addEventListener('turbo:load', () => {
  if (document.getElementById('map')) {
    display();
  }

  // MutationObserver that detects when view is changed from list to map
  const observer = new MutationObserver(((records) => {
    records?.forEach((record) => {
      record.addedNodes.forEach((node) => {
        if (node.id === 'map') {
          display();
        }
      });
    });
  }));

  observer.observe(document.getElementById('trips-view'), { childList: true });
});

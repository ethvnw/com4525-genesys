import { Controller } from '@hotwired/stimulus';
import L from 'leaflet';
import { newRoamioMap } from '../lib/map/RoamioMap';
import { VariablesDiv } from '../lib/VariablesDiv';

let mapObject;

export default class extends Controller {
  connect() {
    if (!mapObject) {
      mapObject = newRoamioMap(this.identifier);
    }

    this.map = mapObject;
    this.map.initialise();
    const jsVariables = new VariablesDiv('map-variables');
    const markerPoints = JSON.parse(jsVariables.get('marker-coords'));

    let previousCoords = null;
    let directionSign = 1;

    markerPoints?.forEach((point) => {
      const coords = L.latLng(point.coords);

      if (this.element.dataset.drawLines && previousCoords) {
        this.map.addConnectingLine([coords, previousCoords], directionSign *= -1);
      }
      previousCoords = coords;

      if (point.endCoords) {
        const endCoords = L.latLng(point.endCoords);
        this.map.addConnectingLine([coords, endCoords], 0);
        this.map.addMarker(endCoords, {
          key: `${point.id.toString()}-end`,
          popup: point.title,
        });
        previousCoords = endCoords;
      }

      this.map.addMarker(coords, {
        key: point.id.toString(),
        popup: point.title,
      });
    });
  }
}

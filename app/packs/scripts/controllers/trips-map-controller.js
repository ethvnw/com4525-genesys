import { Controller } from '@hotwired/stimulus';
import L from 'leaflet';
import { newRoamioMap } from '../lib/map/RoamioMap';
import { VariablesDiv } from '../lib/VariablesDiv';
import { MAP_ICONS } from '../lib/map/map_config';

let mapObject;

export default class extends Controller {
  connect() {
    if (!mapObject) {
      mapObject = newRoamioMap(this.element.id);
    }

    this.map = mapObject;
    this.map.initialise(true);
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

      const key = point.id.toString();
      const icon = MAP_ICONS.tripText(point.title, point.href, point.icon, point.endCoords ? 'Start' : undefined);
      this.map.addMarker(coords, { key, icon });

      if (point.endCoords) {
        const endCoords = L.latLng(point.endCoords);
        this.map.addConnectingLine([coords, endCoords], 0);
        this.map.addMarker(endCoords, {
          key: `${key}-end`,
          icon: MAP_ICONS.tripText(point.title, point.href, point.icon, 'End'),
        });
        previousCoords = endCoords;
      }
    });
  }
}

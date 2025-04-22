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

    markerPoints?.forEach((point) => {
      this.map.addMarker(L.latLng(point.coords), {
        key: point.id,
        popup: point.title,
      });
    });
  }
}

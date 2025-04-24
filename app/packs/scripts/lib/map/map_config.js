import L from 'leaflet';
import tripIconShadow from '../../../images/leaflet/trip-icon-shadow.png';
import { createElement } from '../DOMUtils';
import { tripIconSvg } from './icon_svgs';

function buildDivIconWithSVG(svg) {
  const imgElement = createElement('img', {
    src: tripIconShadow,
    className: 'shadow',
  });

  return `${svg}\n${imgElement.outerHTML}`;
}

const MAP_CONFIG = {
  center: [0, 0],
  zoom: 1,
  maxZoom: 20,
  minZoom: 1,
  maxBounds: [
    [-90, -180],
    [90, 180],
  ],
};

const TILE_LAYER_CONFIG = {
  url: '/api/map/tile/{x}/{y}/{z}',
  options: {
    maxZoom: 20,
  },
};

const MAP_ICONS = {
  trip: L.divIcon({
    html: buildDivIconWithSVG(tripIconSvg),
    iconSize: [48, 48],
    iconAnchor: [4, 44],
    popupAnchor: [24, -40],
  }),
};

export { MAP_CONFIG, TILE_LAYER_CONFIG, MAP_ICONS };

import L from 'leaflet';
import tripIconShadow from '../../../images/leaflet/trip-icon-shadow.png';
import { appendChildren, createElement } from '../DOMUtils';
import { tripIconSvg } from './icon_svgs';

function buildDivIconWithSVG(svg) {
  const imgElement = createElement('img', {
    src: tripIconShadow,
    className: 'shadow',
  });

  return `${svg}\n${imgElement.outerHTML}`;
}

function buildDivTripMarker(title, link) {
  const markerEl = createElement(link !== null ? 'a' : 'span', { className: 'btn-trip' });
  if (link !== null) {
    markerEl.href = link;
  }

  const titleEl = createElement('span', {});
  const iconEl = createElement('i', { className: 'bi bi-geo-alt-fill' });
  appendChildren(titleEl, [iconEl, document.createTextNode(` ${title}`)]);
  markerEl.appendChild(titleEl);
  return markerEl.outerHTML;
}

const MAP_CONFIG = {
  center: [0, 0],
  zoom: 5,
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
  tripText: (title, link) => L.divIcon({
    html: buildDivTripMarker(title, link),
    iconSize: [200, 48],
    iconAnchor: [100, 48],
  }),
};

export { MAP_CONFIG, TILE_LAYER_CONFIG, MAP_ICONS };

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

function buildDivTripMarker(title, link, icon = 'bi bi-geo-alt-fill', description = null) {
  const markerEl = createElement(link !== null ? 'a' : 'span', { className: 'btn-trip' });
  if (link !== null) {
    markerEl.href = link;
  }

  const titleEl = createElement('span', {});
  const iconEl = createElement('i', { className: icon });
  appendChildren(titleEl, [iconEl, document.createTextNode(` ${title}`)]);
  markerEl.appendChild(titleEl);
  if (description) {
    const descriptionEl = createElement('span', { className: 'marker-description' });
    descriptionEl.textContent = description;
    markerEl.appendChild(descriptionEl);
  }
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
  renderer: L.canvas(),
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
  tripText: (title, link, icon, description) => {
    const anchorY = 48 + (description ? 12 : 0);
    return L.divIcon({
      html: buildDivTripMarker(title, link, icon, description),
      iconSize: [200, anchorY],
      iconAnchor: [100, anchorY],
    });
  },
};

export { MAP_CONFIG, TILE_LAYER_CONFIG, MAP_ICONS };

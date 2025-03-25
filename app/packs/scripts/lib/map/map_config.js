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
  url: 'http://{s}.google.com/vt/lyrs=s,h&x={x}&y={y}&z={z}',
  options: {
    maxZoom: 20,
    subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
  },
};

export { MAP_CONFIG, TILE_LAYER_CONFIG };

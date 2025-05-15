import { autocomplete } from '@algolia/autocomplete-js';
import '@algolia/autocomplete-theme-classic';
import { getLocationSearchApiRoute } from '../constants/api_routes';

const DEBOUNCE_MS = 300;

/**
 * Debounce a promise-returning function.
 * @param {Function} fn - Function to debounce
 * @param {number} time - Debounce delay in milliseconds
 * @returns {Function} Debounced function
 */
function debouncePromise(fn, time) {
  let timer;
  return function debounced(...args) {
    clearTimeout(timer);
    return new Promise((resolve) => {
      timer = setTimeout(() => resolve(fn(...args)), time);
    });
  };
}

const debouncedPromise = debouncePromise((items) => Promise.resolve(items), DEBOUNCE_MS);

/**
   * Formats a place object into a displayable string
   * @param {Object} place - Place object from Photon API
   * @returns {string} Formatted location string
   */
function formatPlaceName(place) {
  const { name, city, country } = place.properties;
  return [name, city, country].filter(Boolean).join(', ');
}

/**
 * Creates an autocomplete instance for location search
 * @param {string} containerId - DOM element ID for the autocomplete container
 * @param {string} searchType - Type of location search
 * @param {function} onSelect - Callback for when an item is selected
 * @returns {Object} Autocomplete instance
 */
const createAutocomplete = (containerId, searchType, onSelect) => autocomplete({
  container: containerId,
  placeholder: `Search for a ${searchType} location`,
  detachedMediaQuery: '',
  stallThreshold: 700,
  classNames: { input: 'fw-bold' },
  getSources({ query }) {
    return debouncedPromise([{
      sourceId: 'places',
      async getItems() {
        const response = await fetch(getLocationSearchApiRoute(query));
        const data = await response.json();
        return data.features.map((place) => ({
          name: formatPlaceName(place),
          lat: place.geometry.coordinates[1],
          lng: place.geometry.coordinates[0],
        }));
      },
      getItemInputValue: ({ item }) => item.name,
      onSelect,
      templates: {
        item: ({ item }) => item.name,
      },
    }]);
  },
});

export default createAutocomplete;
export {
  debouncedPromise,
};

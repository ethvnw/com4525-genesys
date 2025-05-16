import { autocomplete } from '@algolia/autocomplete-js';
import { debouncedPromise } from './lib/AlgoliaAutocomplete';
import { getUserSearchApiRoute } from './constants/api_routes';

/**
 * Creates an autocomplete instance for user searching with
 * @param {string} containerId - DOM element ID for autocomplete container
 * @returns {Object} - Autocomplete instance
 */
const createAutocomplete = (containerId) => {
  const container = document.querySelector(containerId);
  const tripId = container.dataset.trip;

  return autocomplete({
    container: containerId,
    placeholder: 'Search for a user to invite',
    detachedMediaQuery: '',
    stallThreshold: 700,
    classNames: { input: 'fw-bold' },
    getSources({ query }) {
      return debouncedPromise([{
        sourceId: 'users',
        async getItems() {
          const response = await fetch(getUserSearchApiRoute(query.toLowerCase(), tripId));
          return response.json();
        },
        getItemInputValue: ({ item }) => item.username,
        onSelect({ item }) {
          const userIdInput = document.getElementById('trip_membership_user_id');
          userIdInput.value = item.username;
        },
        templates: {
          item: ({ item }) => item.username,
        },
      }]);
    },
  });
};

const setupForm = () => {
  createAutocomplete('#user-autocomplete');
};

// Initialise form on page load and reinitialise on content updates
document.addEventListener('turbo:load', () => {
  setupForm();
  const autocompleteObserver = new MutationObserver(setupForm);
  autocompleteObserver.observe(document.querySelector('#content .container'), { childList: true });
});

import { autocomplete } from '@algolia/autocomplete-js';
import { debouncedPromise } from './lib/AlgoliaAutocomplete';

/**
 * Creates an autocomplete instance for user searching with
 * @param {string} containerId - DOM element ID for autocomplete container
 * @returns {Object} - Autocomplete instance
 */
const createAutocomplete = (containerId) => {
  const container = document.querySelector(containerId);
  const users = JSON.parse(container.dataset.users);

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
          return users.filter((user) => user.username.toLowerCase().includes(query.toLowerCase()));
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

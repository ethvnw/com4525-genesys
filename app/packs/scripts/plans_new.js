// Initialises the map and location searches for new plan page.
import createAutocomplete, {
  updateLocationPin, startMarker, endMarker, line,
} from './lib/AlgoliaAutocomplete';
import RoamioMap from './lib/RoamioMap';

let startAutocomplete = null;
let endAutocomplete = null;

/**
 * Show/hide the end location input based on whether the plan type is a travel plan.
 * @param {Event} e - Change event from the plan type dropdown
 */
const updateEndLocationInput = (e) => {
  const targetDropdown = e?.target || document.getElementById('plan_plan_type');
  const endLocationSearch = document.getElementById('end-location-container');
  const endLocationInput = document.getElementById('end_location_name_input');
  const typeValue = targetDropdown.value;

  const isTravelPlan = typeValue.split('_')[0] === 'travel';

  endLocationSearch.classList.toggle('d-none', !isTravelPlan);
  endLocationInput.disabled = !isTravelPlan;
  endLocationInput.required = isTravelPlan;

  if (!isTravelPlan) {
    // Clear end location data
    endAutocomplete.setQuery('');
    endLocationInput.value = '';
    document.getElementById('end_location_latitude_input').value = '';
    document.getElementById('end_location_longitude_input').value = '';

    // Clear end map marker and line
    endMarker.remove();
    endMarker.setLatLng([0, 0]);
    line.remove();
  }
};

/**
 * Initialises the plan form with map and location search functionality
 */
function setupPlanForm() {
  const startLocationNameInput = document.getElementById('start_location_name_input');

  // Return if we are not on the new plan page
  if (!startLocationNameInput) {
    return;
  }

  RoamioMap.initialise();

  // Clean up and reinitialise autocomplete instances
  if (startAutocomplete) {
    startAutocomplete.destroy();
  }
  if (endAutocomplete) {
    endAutocomplete.destroy();
  }

  startAutocomplete = createAutocomplete('#start-location-autocomplete', 'start');
  endAutocomplete = createAutocomplete('#end-location-autocomplete', 'end');

  const typeDropdown = document.getElementById('plan_plan_type');
  typeDropdown.addEventListener('change', updateEndLocationInput);

  // Set end location visible if necessary
  updateEndLocationInput();

  // Restore existing locations if present
  const startName = startLocationNameInput.value;
  const startLat = parseFloat(document.getElementById('start_location_latitude_input').value);
  const startLng = parseFloat(document.getElementById('start_location_longitude_input').value);
  const endName = document.getElementById('end_location_name_input').value;
  const endLat = parseFloat(document.getElementById('end_location_latitude_input').value);
  const endLng = parseFloat(document.getElementById('end_location_longitude_input').value);

  // Set the start and end location values if they are present.
  if (startLat && startLng) {
    startAutocomplete.setQuery(startName);
    updateLocationPin(startMarker, startLat, startLng, startName);
  }
  if (endLat && endLng) {
    endAutocomplete.setQuery(endName);
    updateLocationPin(endMarker, endLat, endLng, endName);
  }
}

// Initialise form on page load and reinitialise on content updates
document.addEventListener('turbo:load', () => {
  setupPlanForm();

  const formContainer = document.querySelector('#content .container');

  if (!formContainer) {
    return;
  }

  const planFormObserver = new MutationObserver(setupPlanForm);
  planFormObserver.observe(formContainer, { childList: true });
});

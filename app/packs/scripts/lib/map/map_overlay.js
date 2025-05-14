/**
 * Adds a click handler to the "search location" button to
 * trigger the location search autocomplete.
 */
export function addSearchLocationButtonHandler() {
  const searchLocationButton = document.getElementById('search-location-btn');
  const autocompleteButton = document.getElementById('autocomplete-0-label');

  if (searchLocationButton && autocompleteButton) {
    searchLocationButton.addEventListener('click', () => {
      autocompleteButton.click();
    });
  }
}

/**
 * Show the interactive map by hiding the overlay.
 * Enables user interaction with the map and makes the overlay transparent and non-blocking.
 */
export function showOverlay() {
  const overlay = document.getElementById('form-map-overlay');
  if (overlay) {
    overlay.style.zIndex = '9999';
    overlay.style.opacity = '1';
  }
}

/**
 * Show the interactive map by hiding the overlay.
 * Enables user interaction with the map and makes the overlay transparent and non-blocking.
 */
export function hideOverlay() {
  const overlay = document.getElementById('form-map-overlay');
  if (overlay) {
    overlay.style.zIndex = '0';
    overlay.style.opacity = '0';
  }
}

/**
 * Handles the visibility of questions in the admin panel.
 */
import CSRF_TOKEN from './constants/ajax_constants';

const visibilityUpdateForms = document.querySelectorAll('form.update-visibility');
// Get the containers and counts for visible and hidden items to update later
const visibleContainer = document.getElementById('visible-items');
const hiddenContainer = document.getElementById('hidden-items');
const visibleCount = document.getElementById('visible-count');
const hiddenCount = document.getElementById('hidden-count');

// When an item is given visibility, update the pre-existing order of the visible items
const updateVisibleItemOrders = (hiddenItemOrder) => {
  const items = visibleContainer.querySelectorAll('.item');
  items.forEach((item) => {
    if (item.getAttribute('data-order') > hiddenItemOrder) {
      item.setAttribute('data-order', item.getAttribute('data-order') - 1);
    }
  });
  document.getElementById('save-form').dispatchEvent(new Event('submit', { cancelable: true }));
};

visibilityUpdateForms.forEach((form) => {
  form.addEventListener('submit', (event) => {
    event.preventDefault();
    const item = form.closest('.item');
    const isVisible = item.parentElement === visibleContainer;

    // If the item is visible, update the order of the visible items
    if (isVisible) {
      updateVisibleItemOrders(item.getAttribute('data-order'));
    }

    item.setAttribute('data-order', isVisible ? 0 : visibleContainer.children.length + 1);

    const formData = new FormData(form);
    formData.append('order', item.getAttribute('data-order'));

    // When submitting the form, update the visibility of the item and its eye-icon
    fetch(form.action, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': CSRF_TOKEN,
      },
      body: formData,
    }).then(() => {
      const targetContainer = isVisible ? hiddenContainer : visibleContainer;
      // Change the eye-icon to the opposite of what it was
      const eyeIcon = item.querySelector(isVisible ? '.bi-eye-slash-fill' : '.bi-eye-fill');

      // Update the visible and hidden counts based on the visibility of the item
      visibleCount.innerText = parseInt(visibleCount.innerText, 10) + (isVisible ? -1 : 1);
      hiddenCount.innerText = parseInt(hiddenCount.innerText, 10) + (isVisible ? 1 : -1);

      // Move the item to the correct container
      item.remove();
      item.querySelector('.order-arrows').classList.toggle('d-none', isVisible);
      targetContainer.appendChild(item);
      eyeIcon.classList.toggle('bi-eye-fill', isVisible);
      eyeIcon.classList.toggle('bi-eye-slash-fill', !isVisible);
    });
  });
});

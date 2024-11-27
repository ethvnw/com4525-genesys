/**
 * Handles the visibility of questions in the admin panel.
 */

const visibilityUpdateForms = document.querySelectorAll('form.update-visibility');
const visibleContainer = document.getElementById('visible-items');
const hiddenContainer = document.getElementById('hidden-items');
const visibleCount = document.getElementById('visible-count');
const hiddenCount = document.getElementById('hidden-count');

const updateVisibleItemOrders = (hiddenItemOrder) => {
  const items = visibleContainer.querySelectorAll('.item');
  items.forEach((item) => {
    if (item.getAttribute('data-order') > hiddenItemOrder) {
      item.setAttribute('data-order', item.getAttribute('data-order') - 1);
    }
  });
  document.getElementById('save-form').dispatchEvent(new Event('submit'), { cancelable: true });
};

visibilityUpdateForms.forEach((form) => {
  form.addEventListener('submit', (event) => {
    event.preventDefault();
    const item = form.closest('.item');
    const isVisible = item.parentElement === visibleContainer;

    if (isVisible) {
      updateVisibleItemOrders(item.getAttribute('data-order'));
    }

    item.setAttribute('data-order', isVisible ? 0 : visibleContainer.children.length);

    const formData = new FormData(form);
    formData.append('order', item.getAttribute('data-order'));

    fetch(form.action, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      },
      body: formData,
    }).then(() => {
      const targetContainer = isVisible ? hiddenContainer : visibleContainer;
      const eyeIcon = item.querySelector(isVisible ? '.bi-eye-slash-fill' : '.bi-eye-fill');

      visibleCount.innerText = parseInt(visibleCount.innerText, 10) + (isVisible ? -1 : 1);
      hiddenCount.innerText = parseInt(hiddenCount.innerText, 10) + (isVisible ? 1 : -1);

      item.remove();
      item.querySelector('.order-arrows').classList.toggle('d-none', isVisible);
      targetContainer.appendChild(item);
      eyeIcon.classList.toggle('bi-eye-fill', isVisible);
      eyeIcon.classList.toggle('bi-eye-slash-fill', !isVisible);
    });
  });
});

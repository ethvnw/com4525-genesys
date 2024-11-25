/**
 * Handles the visibility of reviews in the admin panel.
 */

const visibilityUpdateForms = document.querySelectorAll('form.update-visibility');
const visibleContainer = document.getElementById('visible-reviews');
const hiddenContainer = document.getElementById('hidden-reviews');
const visibleCount = document.getElementById('visible-count');
const hiddenCount = document.getElementById('hidden-count');

const updateVisibleReviewOrders = (hiddenReviewOrder) => {
  const reviews = visibleContainer.querySelectorAll('.review');
  reviews.forEach((review) => {
    if (review.getAttribute('data-order') > hiddenReviewOrder) {
      review.setAttribute('data-order', review.getAttribute('data-order') - 1);
    }
  });
  document.getElementById('save-form').dispatchEvent(new Event('submit'), { cancelable: true });
};

visibilityUpdateForms.forEach((form) => {
  form.addEventListener('submit', (event) => {
    event.preventDefault();
    const review = form.closest('.review');
    const isVisible = review.parentElement === visibleContainer;

    if (isVisible) {
      updateVisibleReviewOrders(review.getAttribute('data-order'));
    }

    review.setAttribute('data-order', isVisible ? 0 : visibleContainer.children.length);

    const formData = new FormData(form);
    formData.append('order', review.getAttribute('data-order'));

    fetch(form.action, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      },
      body: formData,
    }).then(() => {
      const targetContainer = isVisible ? hiddenContainer : visibleContainer;
      const eyeIcon = review.querySelector(isVisible ? '.bi-eye-slash-fill' : '.bi-eye-fill');

      visibleCount.innerText = parseInt(visibleCount.innerText, 10) + (isVisible ? -1 : 1);
      hiddenCount.innerText = parseInt(hiddenCount.innerText, 10) + (isVisible ? 1 : -1);

      review.remove();
      review.querySelector('.order-arrows').classList.toggle('d-none', isVisible);
      targetContainer.appendChild(review);
      eyeIcon.classList.toggle('bi-eye-fill', isVisible);
      eyeIcon.classList.toggle('bi-eye-slash-fill', !isVisible);
    });
  });
});

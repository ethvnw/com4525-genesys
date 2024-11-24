const forms = document.querySelectorAll('form.update-visibility');
const visibleReviews = document.getElementById('visible-reviews');
const hiddenReviews = document.getElementById('hidden-reviews');

forms.forEach((form) => {
  form.addEventListener('submit', (event) => {
    event.preventDefault();
    const formData = new FormData(form);

    fetch(form.action, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      },
      body: formData,
    });

    const review = form.closest('.review');
    const isVisible = review.parentElement === visibleReviews;
    const targetContainer = isVisible ? hiddenReviews : visibleReviews;
    const eyeIcon = review.querySelector(isVisible ? '.bi-eye-slash-fill' : '.bi-eye-fill');
    const visibleCount = document.getElementById('visible-count');
    const hiddenCount = document.getElementById('hidden-count');

    visibleCount.innerText = parseInt(visibleCount.innerText, 10) + (isVisible ? -1 : 1);
    hiddenCount.innerText = parseInt(hiddenCount.innerText, 10) + (isVisible ? 1 : -1);

    review.remove();
    targetContainer.appendChild(review);
    review.querySelector('.order-arrows').classList.toggle('d-none', isVisible);
    eyeIcon.classList.toggle('bi-eye-fill', isVisible);
    eyeIcon.classList.toggle('bi-eye-slash-fill', !isVisible);
  });
});

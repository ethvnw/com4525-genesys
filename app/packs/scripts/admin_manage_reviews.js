const forms = document.querySelectorAll('form.update-visibility');
const visibleReviews = document.getElementById('visible-reviews');
const hiddenReviews = document.getElementById('hidden-reviews');
const reviews = document.querySelectorAll('.review');

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
    review.setAttribute('data-order', isVisible ? 0 : visibleReviews.children.length);
    targetContainer.appendChild(review);
    review.querySelector('.order-arrows').classList.toggle('d-none', isVisible);
    eyeIcon.classList.toggle('bi-eye-fill', isVisible);
    eyeIcon.classList.toggle('bi-eye-slash-fill', !isVisible);
  });
});

reviews.forEach((review) => {
  const upArrow = review.querySelector('.order-up-arrow');
  const downArrow = review.querySelector('.order-down-arrow');

  const moveReview = (currentReview, targetReview, direction) => {
    document.querySelector('.save-button').classList.remove('d-none');

    const currentOrder = currentReview.getAttribute('data-order');
    const targetOrder = targetReview.getAttribute('data-order');

    currentReview.setAttribute('data-order', targetOrder);
    targetReview.setAttribute('data-order', currentOrder);

    if (direction === 'up') {
      currentReview.parentNode.insertBefore(currentReview, targetReview);
    } else {
      currentReview.parentNode.insertBefore(targetReview, currentReview);
    }
  };

  upArrow.addEventListener('click', () => {
    const previousReview = review.previousElementSibling;
    if (previousReview) {
      moveReview(review, previousReview, 'up');
    }
  });

  downArrow.addEventListener('click', () => {
    const nextReview = review.nextElementSibling;
    if (nextReview) {
      moveReview(review, nextReview, 'down');
    }
  });
});

const saveForm = document.getElementById('save-form');
saveForm.addEventListener('submit', (event) => {
  event.preventDefault();

  const reviewData = {};
  reviews.forEach((review) => {
    reviewData[review.id.split('_')[1]] = parseInt(review.getAttribute('data-order'), 10);
  });

  const formData = new FormData(saveForm);
  formData.append('reviews', JSON.stringify(reviewData));

  fetch(saveForm.action, {
    method: 'POST',
    body: formData,
  }).then(() => {
    window.location.reload();
  });
});

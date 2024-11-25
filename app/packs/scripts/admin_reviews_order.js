/**
 * Handles the reordering of reviews in the admin panel.
 */

const reviews = document.querySelectorAll('.review');
const saveButton = document.querySelector('.save-button');
let unsaved = false;

reviews.forEach((review) => {
  const upArrow = review.querySelector('.order-up-arrow');
  const downArrow = review.querySelector('.order-down-arrow');

  const moveReview = (currentReview, targetReview, direction) => {
    saveButton.classList.remove('d-none');
    unsaved = true;

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
const saveFunction = (event) => {
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
    unsaved = false;
    saveButton.classList.add('d-none');
  });
};
saveForm.addEventListener('submit', saveFunction);

// eslint-disable-next-line consistent-return
window.addEventListener('beforeunload', (event) => {
  if (unsaved) {
    const message = 'You have unsaved changes. Are you sure you want to leave?';
    // eslint-disable-next-line no-param-reassign
    event.returnValue = message;
    return message;
  }
});

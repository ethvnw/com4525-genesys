/**
 * Handle like button clicks for reviews.
 * Save the like state in localStorage and send the like state to the server.
 */

const likeButtons = document.querySelectorAll('button.review');

likeButtons.forEach((button) => {
  const reviewId = button.id;
  const reviewLiked = localStorage.getItem(reviewId);

  if (reviewLiked === null) {
    localStorage.setItem(reviewId, false);
  }

  if (reviewLiked === 'true') {
    button.classList.add('active');
    button.setAttribute('aria-pressed', 'true');
  }

  button.addEventListener('click', () => {
    const likeCount = button.querySelector('.like-count');
    const isLiked = localStorage.getItem(reviewId) === 'true';

    likeCount.innerText = parseInt(likeCount.innerText, 10) + (isLiked ? -1 : 1);
    localStorage.setItem(reviewId, !isLiked);

    const form = button.closest('form');
    const formData = new FormData(form);
    formData.append('like', !isLiked);

    fetch(form.action, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      },
      body: formData,
    });
  });
});

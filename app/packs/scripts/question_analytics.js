import { getQuestionClickApiRoute } from './constants/api_routes';
import CSRF_TOKEN from './constants/ajax_constants';

// button[data-id] will select all accordion buttons on the FAQ page, as these are the ones with
// question IDs
document.querySelectorAll('button[data-id]').forEach((button) => {
  button.addEventListener('click', () => {
    // No need to check whether dataset.id exists, as it the selector used in querySelectorAll
    fetch(getQuestionClickApiRoute(button.dataset.id), {
      method: 'POST',
      headers: {
        'X-CSRF-Token': CSRF_TOKEN,
      },
    }).then();
  });
});

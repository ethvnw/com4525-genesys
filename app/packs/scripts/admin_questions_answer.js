/**
 * Handles the submission of answers for questions in the admin panel.
 */

// Using the bootstrap modal for submitting an answer
import { Modal } from 'bootstrap';

const answerForms = document.querySelectorAll('form.answer-form');

answerForms.forEach((form) => {
  form.addEventListener('submit', (event) => {
    event.preventDefault();

    // Get the question ID from the form's data attribute
    const questionId = form.getAttribute('data-question-id');
    if (!questionId) {
      // eslint-disable-next-line no-console
      console.error('No question ID found for form:', form);
      return;
    }

    const formData = new FormData(form);

    // Submit the form via fetch so we can validate the CSRF token
    fetch(form.action, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      },
      body: formData,
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error('Failed to submit the answer');
        }
        return response.json();
      })
      .then((data) => {
        // Update the ui with the new answer
        const answerElement = document.querySelector(`#question_${questionId} .card-body .fw-bold.text-secondary`);
        answerElement.textContent = data.answer || 'No answer yet';

        // Close the modal by getting the Bootstrap modal instance
        const modal = document.getElementById(`answerModal_${questionId}`);
        // If the modal cant be found, create a new instance of the modal and close it
        const modalInstance = Modal.getInstance(modal) || new Modal(modal);
        modalInstance.hide();
      })
      .catch((error) => {
        // eslint-disable-next-line no-console
        console.error('Error submitting the answer:', error);
        // eslint-disable-next-line no-alert
        alert('An error occurred while submitting the answer.');
      });
  });
});

function enableAnswerForm(ev) {
  const { questionId } = ev.target.dataset;
  const textarea = document.querySelector(`#answer-form-${questionId} textarea`);
  const submitButton = document.querySelector(`#answer-form-${questionId} button`);

  textarea.classList.toggle('form-control-plaintext');
  textarea.classList.toggle('form-control');
  textarea.classList.toggle('text-secondary');
  textarea.toggleAttribute('disabled');

  if (!textarea.hasAttribute('disabled')) {
    textarea.focus();

    // Reset value of textarea to move cursor to end
    textarea.value = '';
  }

  textarea.value = textarea.dataset.defaultValue;
  submitButton.classList.toggle('d-none');
}

function buttonSetup() {
  const answerButtons = document.querySelectorAll('button[data-question-id]');

  answerButtons.forEach((answerButton) => {
    // Remove event listeners to prevent duplicate listeners for non-turbo reloaded buttons
    answerButton.removeEventListener('click', enableAnswerForm);
    answerButton.addEventListener('click', enableAnswerForm);
  });
}

document.addEventListener('turbo:load', buttonSetup);
document.addEventListener('turbo:frame-load', buttonSetup);

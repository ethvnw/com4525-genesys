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

  textarea.value = textarea.dataset.defaultValue || '';
  submitButton.classList.toggle('d-none');
}

function buttonSetup(records) {
  records?.forEach((record) => {
    record.addedNodes.forEach((questionCard) => {
      if (questionCard.nodeType === Node.ELEMENT_NODE) {
        questionCard.querySelector('[data-question-id]').addEventListener('click', enableAnswerForm);
      }
    });
  });
}

// Initial setup
document.querySelectorAll('[data-question-id]').forEach(((button) => {
  button.addEventListener('click', enableAnswerForm);
}));

// MutationObserver to catch any changes from turbo streams
const questionObserver = new MutationObserver(buttonSetup);
questionObserver.observe(document.getElementById('visible-items'), { childList: true });
questionObserver.observe(document.getElementById('hidden-items'), { childList: true });

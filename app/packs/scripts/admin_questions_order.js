/**
 * Handles the reordering of questions in the admin panel.
 */

const questions = document.querySelectorAll('.question');
const saveButton = document.querySelector('.save-button');
let unsaved = false;

questions.forEach((question) => {
  const upArrow = question.querySelector('.order-up-arrow');
  const downArrow = question.querySelector('.order-down-arrow');

  const moveQuestion = (currentQuestion, targetQuestion, direction) => {
    saveButton.classList.remove('d-none');
    unsaved = true;

    const currentOrder = currentQuestion.getAttribute('data-order');
    const targetOrder = targetQuestion.getAttribute('data-order');

    currentQuestion.setAttribute('data-order', targetOrder);
    targetQuestion.setAttribute('data-order', currentOrder);

    if (direction === 'up') {
      currentQuestion.parentNode.insertBefore(currentQuestion, targetQuestion);
    } else {
      currentQuestion.parentNode.insertBefore(targetQuestion, currentQuestion);
    }
  };

  upArrow.addEventListener('click', () => {
    const previousQuestion = question.previousElementSibling;
    if (previousQuestion) {
      moveQuestion(question, previousQuestion, 'up');
    }
  });

  downArrow.addEventListener('click', () => {
    const nextQuestion = question.nextElementSibling;
    if (nextQuestion) {
      moveQuestion(question, nextQuestion, 'down');
    }
  });
});

const saveForm = document.getElementById('save-form');
const saveFunction = (event) => {
  event.preventDefault();

  const questionData = {};
  questions.forEach((question) => {
    questionData[question.id.split('_')[1]] = parseInt(question.getAttribute('data-order'), 10);
  });

  const formData = new FormData(saveForm);
  formData.append('questions', JSON.stringify(questionData));

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

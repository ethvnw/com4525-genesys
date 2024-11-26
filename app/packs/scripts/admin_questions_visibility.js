/**
 * Handles the visibility of questions in the admin panel.
 */

const visibilityUpdateForms = document.querySelectorAll('form.update-visibility');
const visibleContainer = document.getElementById('visible-questions');
const hiddenContainer = document.getElementById('hidden-questions');
const visibleCount = document.getElementById('visible-count');
const hiddenCount = document.getElementById('hidden-count');

const updateVisibleQuestionOrders = (hiddenQuestionOrder) => {
  const questions = visibleContainer.querySelectorAll('.question');
  questions.forEach((question) => {
    if (question.getAttribute('data-order') > hiddenQuestionOrder) {
      question.setAttribute('data-order', question.getAttribute('data-order') - 1);
    }
  });
  document.getElementById('save-form').dispatchEvent(new Event('submit'), { cancelable: true });
};

visibilityUpdateForms.forEach((form) => {
  form.addEventListener('submit', (event) => {
    event.preventDefault();
    const question = form.closest('.question');
    const isVisible = question.parentElement === visibleContainer;

    if (isVisible) {
      updateVisibleQuestionOrders(question.getAttribute('data-order'));
    }

    question.setAttribute('data-order', isVisible ? 0 : visibleContainer.children.length);

    const formData = new FormData(form);
    formData.append('order', question.getAttribute('data-order'));

    fetch(form.action, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      },
      body: formData,
    }).then(() => {
      const targetContainer = isVisible ? hiddenContainer : visibleContainer;
      const eyeIcon = question.querySelector(isVisible ? '.bi-eye-slash-fill' : '.bi-eye-fill');

      visibleCount.innerText = parseInt(visibleCount.innerText, 10) + (isVisible ? -1 : 1);
      hiddenCount.innerText = parseInt(hiddenCount.innerText, 10) + (isVisible ? 1 : -1);

      question.remove();
      question.querySelector('.order-arrows').classList.toggle('d-none', isVisible);
      targetContainer.appendChild(question);
      eyeIcon.classList.toggle('bi-eye-fill', isVisible);
      eyeIcon.classList.toggle('bi-eye-slash-fill', !isVisible);
    });
  });
});

import { Tooltip } from 'bootstrap';

// Move modals to the end of the body to prevent them from being hidden by other elements
document.addEventListener('turbo:load', () => {
  const modals = document.querySelectorAll('.modal');
  modals.forEach((modal) => {
    document.body.appendChild(modal);
  });

  const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
  [...tooltipTriggerList].map((tooltipTriggerEl) => new Tooltip(tooltipTriggerEl));
});

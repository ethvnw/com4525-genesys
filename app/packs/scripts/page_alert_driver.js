import { Toast } from 'bootstrap';

// Check for toasts every time a turbo pageload occurs
document.addEventListener('turbo:load', () => {
  // Show all pre-filled toasts
  Array.from(document.getElementsByClassName('toast')).forEach((e) => {
    new Toast(e).show();
  });
});

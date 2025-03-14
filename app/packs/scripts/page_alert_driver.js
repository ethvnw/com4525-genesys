import { Toast } from 'bootstrap';
import buildNewToast from './lib/ToastUtils';

const toastContainer = document.getElementById('toast-list');

// Show all pre-filled toasts
Array.from(document.getElementsByClassName('toast')).forEach((e) => {
  new Toast(e).show();
});

// Check for toasts every time a turbo frame loads
document.addEventListener('turbo:frame-load', () => {
  // Delete old toasts
  Array.from(toastContainer.children).forEach((elem) => {
    if (!elem.classList.contains('show')) {
      toastContainer.removeChild(elem);
    }
  });

  document.querySelectorAll('[data-turbo-toast]').forEach((turboToastContainer) => {
    if (!Object.prototype.hasOwnProperty.call(turboToastContainer.dataset, 'notifications')) {
      return;
    }

    JSON.parse(turboToastContainer.dataset.notifications).forEach((notification) => {
      buildNewToast(notification.message, notification.notification_type).show();
    });
  });
});

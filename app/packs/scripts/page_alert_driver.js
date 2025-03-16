import { Toast } from 'bootstrap';
import buildNewToast from './lib/ToastUtils';

/**
 * Show toasts from turbo frames
 */
function showNewToasts() {
  // Clear old toasts to prevent showing them twice
  const toastContainer = document.getElementById('toast-list');
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
      buildNewToast(notification.message, notification.notification_type);
    });
  });
}

/**
 * Checks for & displays new toasts. For page load & turbo reloads
 */
function showToasts(records, observer) {
  console.log(records);
  records?.forEach((record) => {
    record.addedNodes.forEach((toastElement) => {
      if (toastElement.nodeType === Node.ELEMENT_NODE) {
        new Toast(toastElement, { autohide: toastElement.dataset?.toastPersistent !== 'true' }).show();
      }
    });
  });
}

showToasts();
// Use mutation observer to listen to changes in toast list
// e.g. new toasts being added by turbo streams
const toastObserver = new MutationObserver(showToasts);
toastObserver.observe(document.getElementById('toast-list'), { childList: true });

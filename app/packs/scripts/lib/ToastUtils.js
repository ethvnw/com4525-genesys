/**
 * A collection of utility functions relating to bootstrap toasts.
 */
import { Toast } from 'bootstrap';
import { createElement } from './DOMUtils';

/**
 * Builds and returns a new bootstrap toast, to be shown to the user
 * @param message {string} the message that the toast should contain
 * @param notificationType {string} one of the 8 bootstrap alert types: https://getbootstrap.com/docs/4.0/components/alerts/
 * @param spinner {boolean} whether the toast should contain a spinner and be persistent
 *        (used for disconnects/requests)
 * @returns {Toast} a bootstrap toast object
 */
export default function buildNewToast(message, notificationType, spinner = false) {
  // Build toast element-by-element, following structure in _toast.html.haml
  let toastButton;
  if (!spinner) {
    toastButton = createElement('button', {
      class: `btn-close btn-close-on-${notificationType} me-2 m-auto`,
      'data-bs-dismiss': 'toast',
      'aria-label': 'close',
    });
  } else {
    toastButton = createElement('div', {
      class: 'spinner-border spinner-border-sm me-2 m-auto',
      role: 'status',
    });
  }

  const toastIcon = createElement('i', {
    class: `bi user-select-none me-2 toast-icon-${notificationType}`,
  });

  const toastText = createElement('p', {
    class: 'mb-0 me-md-5',
  });

  toastText.innerText = message;

  const toastBody = createElement('div', {
    class: 'toast-body d-flex align-items-center',
  }, [toastIcon, toastText]);

  const bodyButtonContainer = createElement('div', {
    class: 'd-flex',
  }, [toastBody, toastButton]);

  const toastElement = createElement('div', {
    class: `toast align-items-center text-bg-${notificationType} border-0`,
    role: 'alert',
    'aria-live': 'assertive',
    'aria-atomic': true,
    'data-bs-delay': 3000,
  }, [bodyButtonContainer]);

  // Add toast element to DOM by appending it to toast list
  // (will stack with any server-initialised toasts)
  document.getElementById('toast-list').appendChild(toastElement);

  return new Toast(toastElement, { autohide: !spinner });
}

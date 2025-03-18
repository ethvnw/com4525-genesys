import { Toast } from 'bootstrap';

/**
 * Checks for & displays new toasts. For page load & turbo reloads
 */
function showToasts(records) {
  records?.forEach((record) => {
    record.addedNodes.forEach((toastElement) => {
      if (toastElement.nodeType === Node.ELEMENT_NODE) {
        new Toast(toastElement, { autohide: toastElement.dataset?.toastPersistent !== 'true' }).show();
      }
    });
  });
}

// Fire showToasts once on initial pageload with a dummy mutation record, to show prerendered toasts
showToasts([{ addedNodes: Array.from(document.getElementById('toast-list').children) }]);

// Use mutation observer to listen to changes in toast list
// e.g. new toasts being added by turbo streams
const toastObserver = new MutationObserver(showToasts);
toastObserver.observe(document.getElementById('toast-list'), { childList: true });

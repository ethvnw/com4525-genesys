// Close the alert upon receipt of an alert close event
import { defaultVariablesDiv } from './lib/VariablesDiv';
import { alertCloseEvent, pageAlert } from './lib/PageAlert';

window.addEventListener(alertCloseEvent.type, () => {
  // Close page alert if it is not autoClosing
  if (!pageAlert.autoClosing) {
    pageAlert.close();
  }
});

// Display existing message if page alert is pre-filled
if (pageAlert.flashElem.dataset?.prefilled !== null) {
  pageAlert.flash(true, 3000);
  pageAlert.flashElem.removeAttribute('data-prefilled');
}

const alertMessage = defaultVariablesDiv.get('alert-message');
const alertType = defaultVariablesDiv.get('alert-type') || 'info'; // use info as default type
if (typeof alertMessage === 'string') {
  pageAlert.setMessage(alertMessage, alertType);
  pageAlert.flash(true, 3000);
}

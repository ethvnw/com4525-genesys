// Close the alert upon receipt of an alert close event
import { defaultVariablesDiv } from './lib/VariablesDiv';
import { alertCloseEvent, pageAlert } from './lib/FlashAlert';

window.addEventListener(alertCloseEvent.type, () => {
  // Close page alert if it is not autoClosing
  if (!pageAlert.autoClosing) {
    pageAlert.close();
  }
});

const alertMessage = defaultVariablesDiv.get('alert-message');
const alertType = defaultVariablesDiv.get('alert-type') || 'info'; // use info as default type
if (typeof alertMessage === 'string') {
  pageAlert.flash(alertMessage, alertType, true, 3000);
}

import { Toast } from 'bootstrap';

// Show all pre-filled toasts
Array.from(document.getElementsByClassName('toast')).forEach((e) => {
  new Toast(e).show();
});

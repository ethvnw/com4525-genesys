/**
 * This file contains a helper class used to show alerts to the user
 */
import variables from '../../styles/page-alert_export.module.scss';
import { createElementWithAttributes, setChildList } from './DomUtils';

// Get animation time from stylesheet, to ensure consistency between
// scripted events and CSS transitions
const ANIM_TIME = parseInt(variables.animationTime, 10);
// A custom event that can be dispatched to window when an alert should be closed
export const alertCloseEvent = new Event('alert-close');

const BASE_CLASSES = 'alert .alert-transition';
const BASE_ICON_CLASSES = 'bi user-select-none me-2';

/**
 * @class PageAlert
 * @constructor
 * @private
 *
 * A class used to drive flash alerts, to convey information to the user
 */
class PageAlert {
  constructor(id) {
    this.shouldHideTimeout = null;
    this.autoClosing = true; // When true, will prevent message from being closed by alertCloseEvent

    this.flashElem = document.getElementById(id);

    // Initial setup
    if (this.flashElem.dataset.prefilled === null) {
      // If not prefilled we need to manually build the alert
      this.flashElem.className = BASE_CLASSES;

      // Create and add required children of alert div
      this.flashIcon = createElementWithAttributes('i', { class: BASE_ICON_CLASSES });
      this.flashText = document.createElement('p');
      setChildList(this.flashElem, [this.flashIcon, this.flashText]);
    } else {
      this.flashIcon = document.querySelector('#page-alert i');
      this.flashText = document.querySelector('#page-alert p');
    }
  }

  /**
   * Restores the alert to default (only base classes, no animations in queue, no text/icon)
   * @private
   */
  reset() {
    // Clear alert-related timeouts
    clearTimeout(this.shouldHideTimeout);

    this.flashIcon.innerText = '';
    this.flashText.innerText = '';
    this.flashElem.className = BASE_CLASSES;
  }

  /**
   * Closes the alert
   */
  close() {
    this.flashElem.classList.remove('show');
  }

  /**
   * Sets the alert to be a given type, and to contain a given message
   * @param text {string} the text to display in the alert
   * @param alertType {string} the type of alert to use (see wiki entry)
   */
  setMessage(text, alertType) {
    // Reset alert before flashing
    this.reset();

    this.flashText.innerText = text;
    this.flashElem.classList.add(`alert-${alertType}`);
    this.flashIcon.classList.add(`alert-icon-${alertType}`);
  }

  /**
   * Flashes the message across the top of the user's screen
   * @param autoClose {boolean} whether or not the alert should automatically close
   * @param openTime {number} milliseconds that the alert should stay open for (default: 1500)
   */
  flash(autoClose = true, openTime = 1500) {
    this.flashElem.classList.add('alert-transition', 'show');
    this.autoClosing = autoClose;
    if (autoClose) {
      // Set a timeout to hide after a number of milliseconds (defined by openTime)
      this.shouldHideTimeout = setTimeout(() => {
        this.close();
      }, ANIM_TIME + openTime);
    }
  }
}

/**
 * PageAlert public object
 * @type {PageAlert}
 */
export const pageAlert = new PageAlert('page-alert');

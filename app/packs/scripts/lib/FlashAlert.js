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

const BASE_CLASSES = 'alert';
const BASE_ICON_CLASSES = 'bi user-select-none me-2';

const TYPE_ICONS = {
  primary: 'bi-check-circle',
  secondary: 'bi-check-circle',
  success: 'bi-check-circle',
  danger: 'bi-x-circle',
  warning: 'bi-exclamation-triangle',
  info: 'bi-exclamation-circle',
  light: 'bi-check-circle',
  dark: 'bi-check-circle',
};

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

    this.flashElem = document.getElementById(id);
    this.flashElem.className = BASE_CLASSES;

    this.autoClosing = true;

    // Create and add required children of alert div
    this.flashIcon = createElementWithAttributes('i', { class: BASE_ICON_CLASSES });
    this.flashText = document.createElement('p');
    setChildList(this.flashElem, [this.flashIcon, this.flashText]);
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
   * Flashes a message across the top of the user's screen
   * @param text {string} the text to display in the alert
   * @param alertType {string} the type of alert to use (see wiki entry)
   * @param autoClose {boolean} whether or not the alert should automatically close
   * @param openTime {number} milliseconds that the alert should stay open for (default: 1500)
   */
  flash(text, alertType, autoClose = true, openTime = 1500) {
    // Reset alert before flashing
    this.reset();

    // Replace rails alert types with bootstrap types
    const bootstrapType = alertType
      .replace('alert', 'warning')
      .replace('notice', 'info');

    this.flashText.innerText = text;

    this.flashElem.classList.add(`alert-${bootstrapType}`, 'show');
    this.flashIcon.classList.add(TYPE_ICONS[bootstrapType]);
    this.autoClosing = false;

    if (autoClose) {
      this.autoClosing = true;

      // Set a timeout to hide after a number of milliseconds (defined by openTime)
      this.shouldHideTimeout = setTimeout(() => {
        this.flashElem.classList.remove('show');
      }, ANIM_TIME + openTime);
    }
  }
}

/**
 * PageAlert public object
 * @type {PageAlert}
 */
export const pageAlert = new PageAlert('page-alert');

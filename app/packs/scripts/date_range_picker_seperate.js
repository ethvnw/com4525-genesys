import '@popperjs/core';
import { TempusDominus } from '@eonasdan/tempus-dominus';
import * as DateTimeUtils from './lib/DateTimeUtils';

/**
 * Sets up the start and end date pickers
 * @param {boolean} allowTime - Whether to allow the datepicker to select the time as well
 */
export default function setupPickers(allowTime) {
  const startDatetimepickerElement = document.getElementById('start-datetimepicker-element');
  const endDatetimepickerElement = document.getElementById('end-datetimepicker-element');
  const startDateElement = document.getElementById('start_date_input');
  const endDateElement = document.getElementById('end_date_input');

  // Get preset dates from the hidden inputs (for edit form).
  const presetStartDate = startDateElement.getAttribute('value');
  const presetEndDate = endDateElement.getAttribute('value');

  // Minimum date is either today or the start date in the hidden input
  const minDateValue = presetStartDate
    ? DateTimeUtils.getEarlierDate(new Date(), new Date(presetStartDate)) : new Date();

  // Initialize Tempus Dominus for start date picker
  const startDatetimepicker = new TempusDominus(startDatetimepickerElement, {
    dateRange: false, // Single date picker for start date
    useCurrent: false,
    restrictions: {
      minDate: minDateValue,
    },
    display: {
      buttons: {
        today: true,
        clear: true,
        close: true,
      },
      components: {
        clock: allowTime,
      },
      theme: 'light',
      icons: {
        date: 'bi bi-calendar',
        up: 'bi bi-arrow-up',
        down: 'bi bi-arrow-down',
        previous: 'bi bi-chevron-left',
        next: 'bi bi-chevron-right',
        today: 'bi bi-calendar-check',
        clear: 'bi bi-trash',
        close: 'bi bi-x',
        time: 'bi bi-clock',
      },
    },
    localization: {
      dayViewHeaderFormat: { year: 'numeric', month: 'long' },
    },
  });

  // Initialize Tempus Dominus for end date picker
  const endDatetimepicker = new TempusDominus(endDatetimepickerElement, {
    dateRange: false, // Single date picker for end date
    useCurrent: false,
    restrictions: {
      minDate: minDateValue,
    },
    display: {
      buttons: {
        today: true,
        clear: true,
        close: true,
      },
      components: {
        clock: allowTime,
      },
      theme: 'light',
      icons: {
        date: 'bi bi-calendar',
        up: 'bi bi-arrow-up',
        down: 'bi bi-arrow-down',
        previous: 'bi bi-chevron-left',
        next: 'bi bi-chevron-right',
        today: 'bi bi-calendar-check',
        clear: 'bi bi-trash',
        close: 'bi bi-x',
        time: 'bi bi-clock',
      },
    },
    localization: {
      dayViewHeaderFormat: { year: 'numeric', month: 'long' },
    },
  });

  // Listen for changes in the start date picker
  startDatetimepickerElement.addEventListener('change.td', () => {
    // ._dates is the variable Tempus Dominus uses to store the selected dates.
    // eslint-disable-next-line no-underscore-dangle
    const date = startDatetimepicker.dates._dates[0];
    if (date) {
      startDateElement.value = DateTimeUtils.formatDateForJS(date);
      document.getElementById('start-datetimepicker-input').value = DateTimeUtils.formatDateForButton(date, allowTime);
    } else {
      startDateElement.value = '';
      document.getElementById('start-datetimepicker-input').value = 'Input the start date...';
    }
  });

  // Listen for changes in the end date picker
  endDatetimepickerElement.addEventListener('change.td', () => {
    // ._dates is the variable Tempus Dominus uses to store the selected dates.
    // eslint-disable-next-line no-underscore-dangle
    const date = endDatetimepicker.dates._dates[0];
    if (date) {
      endDateElement.value = DateTimeUtils.formatDateForJS(date);
      document.getElementById('end-datetimepicker-input').value = DateTimeUtils.formatDateForButton(date, allowTime);
    } else {
      endDateElement.value = '';
      document.getElementById('end-datetimepicker-input').value = 'Input the end date...';
    }
  });

  if (presetStartDate) {
    const newStartDate = presetStartDate.replace(' ', 'T').split(' ')[0];
    document.getElementById('start-datetimepicker-input').value = DateTimeUtils.formatDateForButton(newStartDate, allowTime);
    startDateElement.value = DateTimeUtils.formatDateForJS(newStartDate);
  }
  if (presetEndDate) {
    const newEndDate = presetEndDate.replace(' ', 'T').split(' ')[0];
    document.getElementById('end-datetimepicker-input').value = DateTimeUtils.formatDateForButton(newEndDate, allowTime);
    endDateElement.value = DateTimeUtils.formatDateForJS(newEndDate);
  }
}

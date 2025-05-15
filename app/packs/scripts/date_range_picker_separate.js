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
  const tripData = document.querySelector('.d-flex[data-min-date]');

  // Minimum and maximum dates are the bounds of the trip
  const minDate = new Date(tripData.dataset.minDate);
  const maxDate = new Date(tripData.dataset.maxDate);

  // Get preset dates from the hidden inputs (for edit form).
  const presetStartDate = startDateElement.getAttribute('value');
  const presetEndDate = endDateElement.getAttribute('value');

  // Initialize Tempus Dominus for start date picker
  const startDatetimepicker = new TempusDominus(startDatetimepickerElement, {
    dateRange: false, // Single date picker for start date
    useCurrent: false,
    defaultDate: presetStartDate ? new Date(presetStartDate) : minDate,
    restrictions: {
      minDate,
      maxDate,
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
    defaultDate: presetEndDate ? new Date(presetEndDate) : undefined,
    restrictions: {
      minDate,
      maxDate,
    },
    promptTimeOnDateChange: allowTime,
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

  // Need to access eventEmitters to subscribe to click event.
  // Private member but the docs are very little help and source code suggests this is
  // the only way of accessing the click event for some reason.
  // eslint-disable-next-line no-underscore-dangle
  startDatetimepicker._eventEmitters.action.subscribe(() => {
    // ._dates is the variable Tempus Dominus uses to store the selected dates.
    // eslint-disable-next-line no-underscore-dangle
    const date = startDatetimepicker.dates._dates[0];
    if (date) {
      startDateElement.value = DateTimeUtils.formatDateForJS(date);
      document.getElementById('start-datetimepicker-input').value = DateTimeUtils.formatDateForButton(date, allowTime);
      // Set the end date picker to be at least the start date
      endDatetimepicker.updateOptions({
        restrictions: {
          minDate: date,
        },
      });
    } else {
      startDateElement.value = '';
      document.getElementById('start-datetimepicker-input').value = 'When does the plan start?';
      endDatetimepicker.updateOptions({
        restrictions: {
          minDate,
        },
      });
    }
  });

  // As above
  // eslint-disable-next-line no-underscore-dangle
  endDatetimepicker._eventEmitters.action.subscribe(() => {
    // ._dates is the variable Tempus Dominus uses to store the selected dates.
    // eslint-disable-next-line no-underscore-dangle
    const date = endDatetimepicker.dates._dates[0];
    if (date) {
      endDateElement.value = DateTimeUtils.formatDateForJS(date);
      document.getElementById('end-datetimepicker-input').value = DateTimeUtils.formatDateForButton(date, allowTime);
      // Set the start date picker to be at most the end date
      startDatetimepicker.updateOptions({
        restrictions: {
          maxDate: date,
        },
      });
    } else {
      endDateElement.value = '';
      document.getElementById('end-datetimepicker-input').value = 'When does the plan end?';
      startDatetimepicker.updateOptions({
        restrictions: {
          maxDate,
        },
      });
    }
  });

  // Set the default values for the date pickers
  if (presetStartDate) {
    const newStartDate = presetStartDate.replace(' ', 'T').split(' ')[0];
    document.getElementById('start-datetimepicker-input').value = DateTimeUtils.formatDateForButton(newStartDate, allowTime);
    startDateElement.value = DateTimeUtils.formatDateForJS(newStartDate);
  } else {
    // If no preset start date, then it is not the edit form, so set to the trip start date
    document.getElementById('start-datetimepicker-input').value = 'When does the plan start?';
  }
  if (presetEndDate) {
    const newEndDate = presetEndDate.replace(' ', 'T').split(' ')[0];
    document.getElementById('end-datetimepicker-input').value = DateTimeUtils.formatDateForButton(newEndDate, allowTime);
    endDateElement.value = DateTimeUtils.formatDateForJS(newEndDate);
  }
}

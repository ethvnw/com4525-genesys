import '@popperjs/core';
import { TempusDominus } from '@eonasdan/tempus-dominus';

/**
 * Pads a number with leading zeros to ensure it has at least two digits
 * @param {number} datePart - The 'date part' to pad (e.g. month, day, hour, minute)
 * @returns {string} The padded number as a string
 */
function padDatePart(datePart) {
  return datePart.toString().padStart(2, '0');
}

/**
 * Compares two dates and returns the earlier one
 * @param {Date} date1 - First date to compare
 * @param {Date} date2 - Second date to compare
 * @returns {Date} The earlier of the two dates
 */
function getEarlierDate(date1, date2) {
  return date1 < date2 ? date1 : date2;
}

/**
 * Formats a date string into ISO8601 format (but ignoring timezone stuff)
 * @param {string|Date} date - The date to format
 * @returns {string} Formatted date string in YYYY-MM-DDThh:mm format
 */
function formatDateForJS(date) {
  if (!date) return '';
  // Remove timezone info from date
  const d = new Date(date);

  const month = padDatePart(d.getMonth() + 1);
  const day = padDatePart(d.getDate());
  const hours = padDatePart(d.getHours());
  const minutes = padDatePart(d.getMinutes());
  return `${d.getFullYear()}-${month}-${day}T${hours}:${minutes}`;
}

/**
 * Formats a date for display in the date range picker button
 * @param {string|Date} date - The date to format
 * @param {boolean} withTime - Whether to display the time as well
 * @returns {string} Formatted date string using locale-specific format
 */
function formatDateForButton(date, withTime) {
  if (!date) return '';
  const d = new Date(date);
  return d.toLocaleString('en-GB', { dateStyle: 'short', timeStyle: withTime ? 'short' : undefined });
}

/**
 * Clears the date input fields and resets the daterangepicker options
 * @param {boolean} rangeToggle - Whether the date range picker is in range mode or single day mode
 */
function clearDateInput(rangeToggle) {
  const startDateElement = document.getElementById('start_date_input');
  const endDateElement = document.getElementById('end_date_input');
  const datetimepickerInput = document.getElementById('datetimepicker-input');

  startDateElement.value = '';
  endDateElement.value = '';
  datetimepickerInput.value = `Input the date${rangeToggle ? '' : ' range'}...`;
  datetimepickerInput.classList.add('form-control-btn');
  datetimepickerInput.classList.remove('form-control-btn-selected');
}

/**
 * Sets up the date range picker functionality
 * Initialises the Tempus Dominus date picker with custom configuration
 * and handles date selection events
 * @param {boolean} allowTime - Whether to allow the datepicker to select the time as well
 */
export default function setupPicker(allowTime) {
  const datetimepickerElement = document.getElementById('datetimepicker-element');
  const datetimepickerInput = document.getElementById('datetimepicker-input');
  const startDateElement = document.getElementById('start_date_input');
  const endDateElement = document.getElementById('end_date_input');
  const singleDaySwitch = document.getElementById('single-day-switch');

  // Get preset dates from the hidden inputs (for edit form).
  const presetStartDate = startDateElement.getAttribute('value');
  const presetEndDate = endDateElement.getAttribute('value');

  // Minimum date is either today or the start date in the hidden input
  const minDateValue = presetStartDate
    ? getEarlierDate(new Date(), new Date(presetStartDate)) : new Date();

  const datetimepicker = new TempusDominus(datetimepickerElement, {
    dateRange: true,
    useCurrent: false, // Do not automatically pick today as the first date in the range
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
      theme: 'light', // Force light theme as it looks better with the Roamio theme
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

  // Listen for changes in the date range picker
  // Then, update the hidden input fields once a range is selected.
  datetimepickerElement.addEventListener('change.td', () => {
    // ._dates is the variable Tempus Dominus uses to store the selected dates.
    // eslint-disable-next-line no-underscore-dangle
    const dates = datetimepicker.dates._dates;
    if (dates.length === 2) {
      if (!allowTime) {
        dates[0].setHours(0);
        dates[0].setMinutes(0);
        dates[0].setSeconds(0);
        dates[0].setMilliseconds(0);

        dates[1].setHours(23);
        dates[1].setMinutes(59);
        dates[1].setSeconds(59);
        dates[1].setMilliseconds(999);
      }

      startDateElement.value = formatDateForJS(dates[0]);
      endDateElement.value = formatDateForJS(dates[1]);
      datetimepickerInput.value = `${formatDateForButton(dates[0], allowTime)} - ${formatDateForButton(dates[1], allowTime)}`;
      datetimepickerInput.classList.remove('form-control-btn');
      datetimepickerInput.classList.add('form-control-btn-selected');
    } else if (dates.length === 1 && singleDaySwitch.checked) {
      const date = dates[0];
      if (!allowTime) {
        date.setHours(0);
        date.setMinutes(0);
        date.setSeconds(0);
        date.setMilliseconds(0);
      }

      startDateElement.value = formatDateForJS(date);
      endDateElement.value = formatDateForJS(date);
      datetimepickerInput.value = formatDateForButton(date, allowTime);
      datetimepickerInput.classList.remove('form-control-btn');
      datetimepickerInput.classList.add('form-control-btn-selected');
    } else {
      clearDateInput(singleDaySwitch.checked);
    }
  });

  // If the single day switch is checked, set the date range to false
  singleDaySwitch.addEventListener('change', () => {
    const singleDay = singleDaySwitch.checked;
    datetimepicker.clear();
    datetimepicker.updateOptions({
      dateRange: !singleDay,
    });
    clearDateInput(singleDay);
  });

  // If there are preset dates, set the input field button to show them.
  // This is for the edit form.
  if (presetStartDate && presetEndDate) {
    const newStartDate = presetStartDate.replace(' ', 'T').split(' ')[0];
    const newEndDate = presetEndDate.replace(' ', 'T').split(' ')[0];

    if (presetStartDate === presetEndDate) {
      datetimepickerInput.value = formatDateForButton(newStartDate, allowTime);
    } else {
      datetimepickerInput.value = `${formatDateForButton(newStartDate, allowTime)} - ${formatDateForButton(newEndDate, allowTime)}`;
    }
    datetimepickerInput.classList.remove('form-control-btn');
    datetimepickerInput.classList.add('form-control-btn-selected');

    startDateElement.value = formatDateForJS(newStartDate);
    endDateElement.value = formatDateForJS(newEndDate);
  }
}

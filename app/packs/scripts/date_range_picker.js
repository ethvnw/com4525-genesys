import '@popperjs/core';
import { TempusDominus } from '@eonasdan/tempus-dominus';

const datetimepickerElement = document.getElementById('datetimepicker1');
const datetimepickerInput = document.getElementById('datetimepicker1-input');
const startDateElement = document.getElementById('start_date');
const endDateElement = document.getElementById('end_date');

const datetimepicker = new TempusDominus(datetimepickerElement, {
  dateRange: true,
  useCurrent: false, // Do not automatically pick today as the first date in the range
  restrictions: {
    minDate: new Date(), // Cannot set a trip to be in the past
  },
  display: {
    theme: 'light', // Force light theme as it looks better with the Roamio theme
    icons: {
      time: 'bi bi-clock',
      date: 'bi bi-calendar',
      up: 'bi bi-arrow-up',
      down: 'bi bi-arrow-down',
      previous: 'bi bi-chevron-left',
      next: 'bi bi-chevron-right',
      today: 'bi bi-calendar-check',
      clear: 'bi bi-trash',
      close: 'bi bi-x',
    },
    buttons: {
      today: true,
      clear: true,
      close: true,
    },
  },
  localization: {
    dayViewHeaderFormat: { year: 'numeric', month: 'long' },
  },

});

// Helper functions to format date for datetime-local input.
function formatDateForInput(date) {
  if (!date) return '';
  const d = new Date(date);
  return d.toISOString().slice(0, 16); // Extract YYYY-MM-DDTHH:mm (16 chars).
}

function formatDateForButton(date) {
  if (!date) return '';
  const d = new Date(date);
  // Extract "DD/MM/YYYY HH:mm"
  return `${d.getDate()}/${d.getMonth() + 1}/${d.getFullYear()} ${d.getHours()}:${d.getMinutes()}`;
}

// Listen for changes in the date range picker
// Then, update the hidden input fields once a range is selected.
datetimepickerElement.addEventListener('change.td', () => {
  // ._dates is the variable Tempus Dominus uses to store the selected dates.
  // eslint-disable-next-line no-underscore-dangle
  const dates = datetimepicker.dates._dates;
  if (dates.length === 2) {
    startDateElement.value = formatDateForInput(dates[0]);
    endDateElement.value = formatDateForInput(dates[1]);
    datetimepickerInput.value = `${formatDateForButton(dates[0])} - ${formatDateForButton(dates[1])}`;
    datetimepickerInput.classList.remove('form-control-btn');
    datetimepickerInput.classList.add('form-control-btn-selected');
  } else {
    startDateElement.value = '';
    endDateElement.value = '';
    datetimepickerInput.value = 'Input the date range...';
    datetimepickerInput.classList.add('form-control-btn');
    datetimepickerInput.classList.remove('form-control-btn-selected');
  }
});

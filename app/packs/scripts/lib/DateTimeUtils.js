/**
 * Pads a number with leading zeros to ensure it has at least two digits
 * @param {number} datePart - The 'date part' to pad (e.g. month, day, hour, minute)
 * @returns {string} The padded number as a string
 */
export function padDatePart(datePart) {
  return datePart.toString().padStart(2, '0');
}

/**
 * Compares two dates and returns the earlier one
 * @param {Date} date1 - First date to compare
 * @param {Date} date2 - Second date to compare
 * @returns {Date} The earlier of the two dates
 */
export function getEarlierDate(date1, date2) {
  return date1 < date2 ? date1 : date2;
}

/**
 * Formats a date string into ISO8601 format (but ignoring timezone stuff)
 * @param {string|Date} date - The date to format
 * @returns {string} Formatted date string in YYYY-MM-DDThh:mm format
 */
export function formatDateForJS(date) {
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
export function formatDateForButton(date, withTime) {
  if (!date) return '';
  const d = new Date(date);
  return d.toLocaleString('en-GB', { dateStyle: 'short', timeStyle: withTime ? 'short' : undefined });
}

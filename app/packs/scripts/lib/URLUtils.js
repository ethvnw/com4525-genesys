/**
 * Checks the validity of a URL
 * @param url {string} the URL to check
 * @returns {boolean} true if the URL is valid, false otherwise
 */
export default function isValidHttpUrl(string) {
  try {
    const url = new URL(string);
    return url.protocol === 'http:' || url.protocol === 'https:';
  } catch (_) {
    return false;
  }
}

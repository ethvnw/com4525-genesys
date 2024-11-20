/**
 * Converts a string from snake_case or kebab-case to camelCase
 * @param str {string} the string to convert
 * @returns {string} the original string in camel case
 */
export default function toCamelCase(str) {
  return str.replace(
    /([-_][a-z])/gi,
    (match) => match[1].toUpperCase(),
  );
}

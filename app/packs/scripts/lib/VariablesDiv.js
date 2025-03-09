import toCamelCase from './StringUtils';

/**
 * A class that can be used to interact with hidden divs containing variables from the backend.
 * A singleton, `defaultVariablesDiv`, is provided to interact with the default one.
 * @param divId {string} the ID of the div to wrap
 */
export class VariablesDiv {
  constructor(divId = 'js-variables') {
    const divElem = document.getElementById(divId);
    this.dataset = { ...divElem.dataset };
  }

  /**
   * Safely attempts to retrieve a value from the data-* attributes of the js-variables div
   * @param key {string} the key to retrieve the value for
   * @returns {any} the value at the key (if one exists, otherwise null)
   */
  get(key) {
    // All dataset attributes are camel case, so convert first
    return this.dataset[toCamelCase(key)] || null;
  }
}

/**
 * A singleton used to interact with the default variables div (id: js-variables),
 * which is present on all pages.
 * @type {VariablesDiv}
 */
export const defaultVariablesDiv = new VariablesDiv();

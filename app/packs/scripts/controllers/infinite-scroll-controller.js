import { Controller } from '@hotwired/stimulus';
import { useIntersection } from 'stimulus-use';
import { createElement } from '../lib/DOMUtils';

function convertToLoadingSpinner(loaderElement) {
  loaderElement.outerHTML = createElement('div', { className: 'spinner' }).outerHTML;
}

export default class extends Controller {
  connect() {
    useIntersection(this, { threshold: 1 });

    this.element.addEventListener('click', () => convertToLoadingSpinner(this.element));
  }

  appear(entry) {
    this.element.click();
  }
}

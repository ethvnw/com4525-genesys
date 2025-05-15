import { Controller } from '@hotwired/stimulus';
import { useIntersection } from 'stimulus-use';
import { createElement } from '../lib/DOMUtils';

export default class extends Controller {
  connect() {
    useIntersection(this, { threshold: 1 });

    this.element.addEventListener('click', () => {
      this.element.outerHTML = createElement('div', { className: 'spinner' }).outerHTML;
    });
  }

  appear() {
    this.element.click();
  }
}

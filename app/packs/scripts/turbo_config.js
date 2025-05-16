import { Turbo } from '@hotwired/turbo-rails';
import { appendChildren } from './lib/DOMUtils';

Turbo.session.drive = false;

/* eslint-disable func-names */
// Custom action to handle redirects after form submissions
Turbo.StreamActions.redirect = function () {
  Turbo.visit(this.target);
};

// Custom action to change URL from a stream response (e.g. view=list -> view=map)
Turbo.StreamActions.changeUrl = function () {
  window.history.replaceState({}, '', this.target);
};

// Custom action to merge elements (merge children if exists in the DOM, otherwise create)
Turbo.StreamActions.merge = function () {
  const container = document.getElementById(this.target);
  if (!container) {
    return;
  }
  // Retrieve document fragment from stream action
  const fragment = this.childNodes[0].content;

  // Entire rendered partial
  const htmlContent = fragment.firstElementChild;

  // Identify the element that we want to merge
  const mergeId = htmlContent.dataset?.mergeId || htmlContent.id;
  const toMerge = fragment.querySelector(`#${mergeId}`) || htmlContent;

  // If element that we want to merge already exists in the DOM, merge children.
  // Otherwise append entire fragment to the target
  if (toMerge.id && container.querySelector(`#${toMerge.id}`)) {
    appendChildren(container.querySelector(`#${toMerge.id}`), Array.from(toMerge.children));
  } else {
    container.appendChild(htmlContent);
  }
};

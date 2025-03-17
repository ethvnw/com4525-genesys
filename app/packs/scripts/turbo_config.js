import { Turbo } from '@hotwired/turbo-rails';

Turbo.session.drive = false;

/* eslint-disable func-names */
// Custom action to handle redirects after form submissions
Turbo.StreamActions.redirect = function () {
  Turbo.visit(this.target);
};

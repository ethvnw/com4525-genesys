import { Turbo } from '@hotwired/turbo-rails';

Turbo.session.drive = false;

// Custom action to handle redirects after form submissions
Turbo.StreamActions.redirect = function () {
  Turbo.visit(this.target);
};

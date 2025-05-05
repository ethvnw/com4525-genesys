/* eslint-disable import/no-unresolved */
import StimulusControllerResolver from 'stimulus-controller-resolver';
import application from './application';
<<<<<<< HEAD
import TripsMapController from './trips_map_controller';
import PlanFormController from './plan_form_controller';
import TripFormController from './trip_form_controller';
import PlanQRController from './plan_qr_controller';
import BookingReferencesController from './booking_references_controller';
import TicketLinksController from './ticket_links_controller';
import CustomImageController from './custom_image_controller';
import TripShowController from './trip_show_controller';

application.register('trips-map', TripsMapController);
application.register('plans-map', TripsMapController);
application.register('plan-form', PlanFormController);
application.register('trip-form', TripFormController);
application.register('plan-qr', PlanQRController);
application.register('booking-references', BookingReferencesController);
application.register('ticket-links', TicketLinksController);
application.register('custom-image', CustomImageController);
application.register('trip-show', TripShowController);
=======

StimulusControllerResolver.install(application, async (controllerName) => (
  (await import(`./${controllerName}-controller.js`)).default
));
>>>>>>> 7f427db (fix(js-loading): added stimulus resolver for lazy controller loading)

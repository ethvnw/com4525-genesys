import application from './application';
import TripsMapController from './trips_map_controller';
import PlanFormController from './plan_form_controller';
import TripFormController from './trip_form_controller';
import PlanQRController from './plan_qr_controller';

application.register('trips-map', TripsMapController);
application.register('plans-map', TripsMapController);
application.register('plan-form', PlanFormController);
application.register('trip-form', TripFormController);
application.register('plan-qr', PlanQRController);

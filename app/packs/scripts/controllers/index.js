import application from './application';
import TripsMapController from './trips_map_controller';
import PlanFormController from './plan_form_controller';

application.register('trips-map', TripsMapController);
application.register('plans-map', TripsMapController);
application.register('plan-form', PlanFormController);

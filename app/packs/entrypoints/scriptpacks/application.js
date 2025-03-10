import Rails from '@rails/ujs';
import 'bootstrap';
import { Turbo } from '@hotwired/turbo-rails';

import '../../scripts/page_alert_driver';

Turbo.session.drive = false;
Rails.start();

/* eslint-disable no-unused-vars */
/* eslint-disable no-undef */
import Rails from '@rails/ujs';
import { Tooltip } from 'bootstrap';
import '@popperjs/core';

import '../../scripts/turbo_config';
import '../../scripts/page_alert_driver';

Rails.start();
const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
const tooltipList = [...tooltipTriggerList].map(
  (tooltipTriggerEl) => new Tooltip(tooltipTriggerEl),
);

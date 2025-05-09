/* eslint-disable import/no-unresolved */
import StimulusControllerResolver from 'stimulus-controller-resolver';
import application from './application';

StimulusControllerResolver.install(application, async (controllerName) => (
  (await import(`./${controllerName}-controller.js`)).default
));

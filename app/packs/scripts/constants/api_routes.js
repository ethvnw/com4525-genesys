const API_ROUTE = '/api';

export const getFeatureShareRoute = (featureId, method) => `${API_ROUTE}/features/${featureId}/share?method=${method}`;

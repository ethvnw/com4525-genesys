const API_BASE_ROUTE = '/api';

export const getFeatureShareRoute = (featureId, method) => `${API_BASE_ROUTE}/features/${featureId}/share?method=${method}`;

const API_BASE_ROUTE = '/api';

export const getFeatureShareApiRoute = (featureId, method) => `${API_BASE_ROUTE}/features/${featureId}/share?method=${method}`;
export const getQuestionClickApiRoute = (questionId) => `${API_BASE_ROUTE}/questions/${questionId}/click`;
export const getLocationSearchApiRoute = (query) => `${API_BASE_ROUTE}/locations/search?query=${encodeURIComponent(query)}`;
export const getUserSearchApiRoute = (query, tripId) => `${API_BASE_ROUTE}/users/search?trip_id=${tripId}&query=${encodeURIComponent(query)}`;

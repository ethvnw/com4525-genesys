const API_BASE_ROUTE = '/api';

export const getFeatureShareApiRoute = (featureId, method) => `${API_BASE_ROUTE}/features/${featureId}/share?method=${method}`;
export const getQuestionClickApiRoute = (questionId) => `${API_BASE_ROUTE}/questions/${questionId}/click`;

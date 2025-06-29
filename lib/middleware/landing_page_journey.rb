# frozen_string_literal: true

##
# Middleware to handle storing a user's landing page journey.
# Journey is stored in the user's session, under the :journey key, as a list of journey points,
# which are of the form "type-id" (example journey below)
#
# @example Example journey structure
#   {
#     features: [
#         {
#           id: 3,
#           method: "twitter",
#           timestamp: <Time Object>
#         },
#         {
#           id: 1,
#           method: "whatsapp",
#           timestamp: <Time Object>
#         }
#     ],
#     reviews: [
#         {
#           id: 12,
#           timestamp: <Time Object>
#         }
#     ],
#     questions: [
#         {
#           id: 5,
#           timestamp: <Time Object>
#         }
#     ],
#   }
class LandingPageJourneyMiddleware
  ##
  # Initialises a new instance of the middleware
  #
  # @param app [Object] The Rack application
  def initialize(app)
    @app = app
  end

  ##
  # @param env [Hash] The Rack environment
  # @return [Array] The Rack response array
  def call(env)
    handle_analytics(env)

    # Pass request along middleware stack
    @app.call(env)
  end

  private

  # The routes that should trigger adding/removing a journey
  # Can't use route variables from routes.rb in middleware
  # Omit the :id path param
  LIKE_REVIEW_ROUTE = "api/reviews/like"
  SHARE_FEATURE_ROUTE = "api/features/share"
  CLICK_QUESTION_ROUTE = "api/questions/click"

  ROUTES_TO_JOURNEY = {
    LIKE_REVIEW_ROUTE => "reviews",
    SHARE_FEATURE_ROUTE => "features",
    CLICK_QUESTION_ROUTE => "questions",
  }

  ##
  # Handles a route that has been intercepted by the middleware.
  # Creates and adds/removes a journey point if necessary.
  #
  # @param env [Hash] The Rack environment
  # @return [void]
  def handle_analytics(env)
    # Safely get route info (if route doesn't exist then a RoutingError will be thrown, which we should rescue)
    route_info = begin
      Rails.application.routes.recognize_path(env["PATH_INFO"], method: env["REQUEST_METHOD"])
    rescue
      {}
    end

    full_route = "#{route_info[:controller]}/#{route_info[:action]}"
    # Guard clause to catch all actions that we don't need analytics for
    unless ROUTES_TO_JOURNEY.key?(full_route)
      return
    end

    request = Rack::Request.new(env)
    interaction = { id: route_info[:id], timestamp: Time.now.utc }

    if full_route == SHARE_FEATURE_ROUTE
      # Add feature-specific info
      interaction[:method] = env["QUERY_STRING"].sub("method=", "")
    end

    if adding?(request.session, full_route, interaction)
      add_to_session(request.session, ROUTES_TO_JOURNEY[full_route], interaction)
    else
      remove_from_session(request.session, ROUTES_TO_JOURNEY[full_route], interaction)
    end
  end

  ##
  # Checks whether we are adding to the journey or not
  #
  # @param user_session [Hash] the user's session to check for liked reviews
  # @param action [String] the action that has been called
  # @param interaction [Hash] the interaction to check for equivalency within the reviews journey
  # @return [Boolean] true if adding, otherwise false
  def adding?(user_session, action, interaction)
    action != LIKE_REVIEW_ROUTE || !find_equivalent_journey_point(user_session, "reviews", interaction)
  end

  ##
  # Checks whether a journey feature is present within the session hash
  #
  # @param user_session [Hash] the user's session to check
  # @param journey_feature [String] the journey feature to check for
  # @return [Boolean] true if journey_feature is present within user_session, otherwise false
  def feature_exists_in_session?(user_session, journey_feature)
    user_session.key?(:journey) && user_session[:journey].key?(journey_feature)
  end

  ##
  # Checks whether two journey points are equivalent - excluding the timestamp
  #
  # @param p1 [Hash] the first journey point to check
  # @param p2 [Hash] the second journey point to check
  # @return [Boolean] true if p1 and p2 are equivalent (excluding timestamp), otherwise false
  def equivalent_journey_points?(p1, p2)
    p1.except(:timestamp) == p2.except(:timestamp)
  end

  ##
  # Searches for an equivalent to a target point within a given journey in the user's session hash
  #
  # @param user_session [Hash] the user's session hash
  # @param journey_feature [String] the journey feature to search within
  # @param target_point [Hash] the journey point to find an equivalent of
  # @return [Hash, nil] the equivalent journey point if one exists, otherwise nil
  def find_equivalent_journey_point(user_session, journey_feature, target_point)
    unless feature_exists_in_session?(user_session, journey_feature)
      return
    end

    user_session[:journey][journey_feature].detect do |journey_point|
      equivalent_journey_points?(journey_point, target_point)
    end
  end

  ##
  # Adds a journey point (feature shared, review/question liked) to the user's session
  #
  # @param user_session [Hash] the user's session hash
  # @param journey_feature [String] the journey feature to add the journey point for
  # @param journey_point [Hash] the hash to add to the list of points for the journey feature
  # @return [void]
  def add_to_session(user_session, journey_feature, journey_point)
    unless user_session.key?(:journey)
      user_session[:journey] = {}
    end

    unless feature_exists_in_session?(user_session, journey_feature)
      user_session[:journey][journey_feature] = []
    end

    # Add journey_point only if it's not already in the session (we don't want duplicates)
    unless find_equivalent_journey_point(user_session, journey_feature, journey_point)
      user_session[:journey][journey_feature].push(journey_point)
    end
  end

  ##
  # Removes a journey point (feature shared, review/question liked) from the user's session
  #
  # @param user_session [Hash] the user's session hash
  # @param journey_feature [String] the journey feature to remove the journey point for
  # @param journey_point [Hash] the journey_point to remove
  # @return [void]
  def remove_from_session(user_session, journey_feature, journey_point)
    equivalent_point = find_equivalent_journey_point(user_session, journey_feature, journey_point)
    unless equivalent_point.nil?
      user_session[:journey][journey_feature].delete(equivalent_point)
    end
  end
end

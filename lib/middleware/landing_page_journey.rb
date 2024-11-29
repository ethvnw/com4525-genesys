# frozen_string_literal: true

##
# Middleware to handle storing a user's landing page journey.
# Journey is stored in the user's session, under the :journey key, as a list of journey points,
# which are of the form "type-id" (example journey below)
#
#   {
#     :features: [
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
#     :reviews: [
#         {
#           id: 12,
#           timestamp: <Time Object>
#         }
#     ],
#     :questions: [
#         {
#           id: 5,
#           timestamp: <Time Object>
#         }
#     ],
#   }
class LandingPageJourneyMiddleware
  # The actions that should trigger adding/removing a journey point
  QUESTION_REVIEW_ACTIONS = [
    "update_like_count",
    "update_question_like_count",
  ]

  FEATURE_ACTION = "share_feature"

  def initialize(app)
    @app = app
  end

  def call(env)
    # Safely get route info (if route doesn't exist then a RoutingError will be thrown, which we should rescue)
    route_info = begin
      Rails.application.routes.recognize_path(env["PATH_INFO"], method: env["REQUEST_METHOD"])
    rescue
      { action: nil }
    end

    request = Rack::Request.new(env)

    # Handle questions/reviews separately as they need to be removable as well
    if QUESTION_REVIEW_ACTIONS.include?(route_info[:action])
      interaction = { id: route_info[:id], timestamp: Time.now.utc }
      if request.params["like"] == "true"
        add_to_session(request.session, route_info[:controller], interaction)
      else
        remove_from_session(request.session, route_info[:controller], interaction)
      end
    end

    if route_info[:action] == FEATURE_ACTION
      interaction = { id: route_info[:id], method: route_info[:method], timestamp: Time.now.utc }
      add_to_session(request.session, "feature", interaction)
    end
    puts(request.session[:journey])
    # Pass request along middleware stack
    @app.call(env)
  end

  private

  ##
  # Checks whether a journey feature is present within the session hash
  # @param [Hash] user_session the user's session to check
  # @param [String] journey_feature the journey feature to check for
  # @return [Boolean] true if journey_feature is present within user_session, otherwise false
  def feature_exists_in_session?(user_session, journey_feature)
    user_session.key?(:journey) && user_session[:journey].key?(journey_feature)
  end

  ##
  # Checks whether two journey points are equivalent by excluding the timestamp, and
  # checking of the new timestamp-free hashes (as timestamp will be different every time)
  # @param [Hash] p1 the first journey point to check
  # @param [Hash] p2 the second journey point to check
  # @return [Boolean] true if p1 and p2 are equivalent, otherwise false
  def equivalent_journey_points?(p1, p2)
    p1.except(:timestamp) == p2.except(:timestamp)
  end

  ##
  # Searches for an equivalent to a target point within a given journey in the user's
  # session hash
  # @param user_session [Hash] the user's session hash
  # @param journey_feature [String] the journey feature to search within
  # @param target_point [Hash] the journey point to find an equivalent of
  # @return [Hash] the equivalent journey point - if one exists, otherwise nil
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
  # @param user_session [Hash] the user's session hash
  # @param journey_feature [String] the journey feature to add the journey point for
  # @param journey_point [Hash] the hash to add to the list of points for the journey feature
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
  # @param user_session [Hash] the user's session hash
  # @param journey_feature [String] the journey feature to remove the journey point for
  # @param journey_point [Integer] the journey_point to remove
  def remove_from_session(user_session, journey_feature, journey_point)
    equivalent_point = find_equivalent_journey_point(user_session, journey_feature, journey_point)
    unless equivalent_point.nil?
      user_session[:journey][journey_feature].delete(equivalent_point)
    end
  end
end

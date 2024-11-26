# frozen_string_literal: true

##
# Middleware to handle storing a user's landing page journey.
# Journey is stored in the user's session, under the :journey key, as a list of journey points,
# which are of the form "type-id"
#
# For example: ["reviews-1", "questions-4", "features-3"] means that the user liked the review with ID 1,
# then the question with ID 4, and then shared the feature with ID 3
class LandingPageJourneyMiddleware
  # The actions that should trigger adding/removing a journey point
  JOURNEY_ACTIONS = [
    "update_like_count",
    "update_question_like_count",
  ]

  REVIEWS_CONTROLLER = "reviews"
  QUESTIONS_CONTROLLER = "questions"

  def initialize(app)
    @app = app
  end

  def call(env)
    # Safely get route info (if route doesn't exist then a RoutingError will be thrown, which we should rescue)
    route_info = begin
      Rails.application.routes.recognize_path(env["PATH_INFO"], method: env["REQUEST_METHOD"])
    rescue
      nil
    end

    if !route_info.nil? && JOURNEY_ACTIONS.include?(route_info[:action])
      request = Rack::Request.new(env)
      # Handle reviews and questions together as they have the same format
      if [REVIEWS_CONTROLLER, QUESTIONS_CONTROLLER].include?(route_info[:controller])
        if request.params["like"] == "true"
          add_to_session(request.session, route_info[:controller], route_info[:id])
        else
          remove_from_session(request.session, route_info[:controller], route_info[:id])
        end
      end
    end

    # Pass request along middleware stack
    @app.call(env)
  end

  ##
  # Adds a journey point (feature shared, review/question liked) to the user's story session
  # @param user_session [Hash] the user's session hash
  # @param controller [Symbol] the controller to add the story point for
  # @param to_add [Integer] the ID of the story object to add
  def add_to_session(user_session, controller, to_add)
    unless user_session.key?(:journey)
      user_session[:journey] = []
    end

    # Add to_add only if it's not already in the session (we don't want duplicates)
    user_session[:journey] |= ["#{controller}-#{to_add}"]
  end

  ##
  # Removes a journey point (feature shared, review/question liked) from the user's story session
  # @param user_session [Hash] the user's session hash
  # @param controller [Symbol] the controller to remove the story point for
  # @param to_remove [Integer] the ID of the story object to remove
  def remove_from_session(user_session, controller, to_remove)
    if user_session.key?(:journey)
      user_session[:journey].delete("#{controller}-#{to_remove}")
    end
  end
end

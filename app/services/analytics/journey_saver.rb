# frozen_string_literal: true

module Analytics
  ##
  # Base class for saving landing page journey to the database
  class JourneySaver < ApplicationService
    # @param registration_id [Integer] the ID of the registration to save the journey for
    # @param journey [Array<Hash>] the array of journey points
    def initialize(registration_id, journey)
      super()
      @registration_id = registration_id
      @journey = journey || {}
    end

    def call
      save_feature_shares(@journey["features"] || [])
      save_question_clicks(@journey["questions"] || [])
      save_review_likes(@journey["reviews"] || [])
    end

    private

    ##
    # Saves all instances of the user sharing a feature to the feature_shares table of the DB
    # @param feature_shares [Array<Hash>] all of the feature share instances from the user's landing page journey
    def save_feature_shares(feature_shares)
      feature_shares.each do |feature_share|
        FeatureShare.create(
          registration_id: @registration_id,
          app_feature_id: feature_share[:id],
          share_method: feature_share[:method],
          created_at: feature_share[:timestamp],
        )
      end
    end

    ##
    # Saves all instances of the user clicking on a question to the question_clicks table of the DB
    # @param question_clicks [Array<Hash>] all of the question click instances from the user's landing page journey
    def save_question_clicks(question_clicks)
      question_clicks.each do |question_click|
        QuestionClick.create(
          registration_id: @registration_id,
          question_id: question_click[:id],
          created_at: question_click[:timestamp],
        )
      end
    end

    ##
    # Saves all instances of the user liking a review to the review_likes table of the DB
    # @param [Array<Hash>] review_likes all of the review like instances from the user's landing page journey
    def save_review_likes(review_likes)
      review_likes.each do |review_like|
        ReviewLike.create(
          registration_id: @registration_id,
          review_id: review_like[:id],
          created_at: review_like[:timestamp],
        )
      end
    end
  end
end

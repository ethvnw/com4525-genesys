# frozen_string_literal: true

module Api
  ##
  # Controller for features, handling sharing
  class FeaturesController < ApplicationController
    SHARERS = {
      "email" => Sharing::EmailSharer,
      "facebook" => Sharing::FacebookSharer,
      "twitter" => Sharing::TwitterSharer,
      "whatsapp" => Sharing::WhatsappSharer,
    }.freeze

    def share
      unless can_share?(params)
        head(:bad_request) and return
      end

      # Get the app feature and increment its engagement counter
      app_feature = AppFeature.find_by_id(params[:id])
      app_feature.increment_engagement_counter!
      app_feature.save

      sharer = SHARERS[params[:method]]
      redirect_to(sharer.call(app_feature), allow_other_host: true)
    end

    private

    ##
    # Checks whether a given share method is valid
    # @param [ActionController::Parameters] params the params to check for validity
    # @return [bool] true if share is possible, else false
    def can_share?(params)
      AppFeature.exists?(id: params[:id]) && params[:method].present? && SHARERS.key?(params[:method].to_s)
    end
  end
end

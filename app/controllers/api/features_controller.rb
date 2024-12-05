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

      sharer = SHARERS.fetch(params[:method].downcase, Sharing::SocialMediaSharer)
      redirect_to(sharer.call(AppFeature.find_by_id(params[:id])), allow_other_host: true)
    end

    private

    ##
    # Checks whether a given share method is valid
    # @param [ActionController::Parameters] params the params to check for validity
    # @return [bool] true if share is possible, else false
    def can_share?(params)
      AppFeature.exists?(id: params[:id]) && params[:method].present? && SHARERS.key?(params[:method].downcase)
    end
  end
end

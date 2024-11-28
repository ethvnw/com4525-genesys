# frozen_string_literal: true

class DummyFeature
  attr_reader :name
  attr_reader :description

  def initialize(id)
    @name = "Feature #{id}"
    @description = "Test description"
  end
end

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
      unless valid_share_method?(params[:method])
        head(:unprocessable_entity) and return
      end

      sharer = SHARERS.fetch(params[:method].to_s, Sharing::SocialMediaSharer)
      redirect_to(sharer.call(DummyFeature.new(params[:id])), allow_other_host: true)
    end

    private

    ##
    # Checks whether a given share method is valid
    # @param [ActionController::Parameters] method the method to check for validity
    # @return [bool] true if method is valid, else false
    def valid_share_method?(method)
      method.present? && SHARERS.key?(method.to_s)
    end
  end
end

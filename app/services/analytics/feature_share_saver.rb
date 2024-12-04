# frozen_string_literal: true

module Analytics
  ##
  # Analytics saver for feature shares
  class FeatureShareSaver < JourneySaver
    def call
      @journey.each do |feature_share|
        FeatureShare.create(
          registration_id: @registration_id,
          app_feature_id: feature_share[:id],
          share_method: feature_share[:method],
        )
      end
    end
  end
end

# frozen_string_literal: true

module Sharing
  ##
  # Base class for sharing features to social media
  class SocialMediaSharer < ApplicationService
    def initialize(feature)
      super() # Explicitly specify 0 arguments, otherwise it tries to call super with `feature`
      @feature = feature
    end

    def share_message
      ERB::Util.url_encode(
        "With #{@feature.name}, you can #{@feature.description.downcase}\n\nCheck it out on #{ROOT_URL}!",
      )
    end

    def share_subject
      ERB::Util.url_encode("Check out #{@feature.name} on Roamio!")
    end
  end
end

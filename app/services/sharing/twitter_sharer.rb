# frozen_string_literal: true

module Sharing
  ##
  # Service class for sharing a feature via Twitter/X.
  # `call` returns the intent link, to allow the user to tweet out the feature.
  class TwitterSharer < SocialMediaSharer
    def call
      "https://x.com/intent/tweet?text=#{share_message}&url=#{ROOT_URL}"
    end
  end
end

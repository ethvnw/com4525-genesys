# frozen_string_literal: true

module Sharing
  ##
  # Service class for sharing a feature via Facebook.
  # `call` returns the Facebook sharer link, to allow the user to share the feature.
  class FacebookSharer < SocialMediaSharer
    def call
      "https://www.facebook.com/sharer/sharer.php?u=#{ROOT_URL}"
    end
  end
end

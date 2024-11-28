# frozen_string_literal: true

module Sharing
  ##
  # Service class for sharing a feature via WhatsApp.
  # `call` returns the WhatsApp share link, to allow the user to share the feature.
  class WhatsappSharer < SocialMediaSharer
    def call
      "https://wa.me/?text=#{share_message}"
    end
  end
end

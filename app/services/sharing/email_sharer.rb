# frozen_string_literal: true

module Sharing
  ##
  # Service class for sharing a feature via email.
  # `call` simply returns the mailto link to redirect to.
  class EmailSharer < SocialMediaSharer
    def call
      "mailto:?body=#{share_message}&subject=#{share_subject}"
    end
  end
end

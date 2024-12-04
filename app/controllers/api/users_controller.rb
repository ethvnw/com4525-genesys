# frozen_string_literal: true

module Api
  # Users controller
  class UsersController < ApplicationController
    require "open-uri"
    before_action :authenticate_user!

    def avatar
      # Get avatar from DiceBear [https://www.dicebear.com]
      # Thumbs by DiceBear, licensed under CC0 1.0
      avatar_url = "https://api.dicebear.com/9.x/thumbs/svg?seed=#{current_user.id}"

      # Render the avatar
      render(plain: URI.parse(avatar_url).open.read, content_type: "image/svg+xml")
    end
  end
end

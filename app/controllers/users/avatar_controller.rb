module Users
  class AvatarController < ApplicationController
    require 'open-uri'
    before_action :authenticate_user!

    def show
      # Get avatar from DiceBear [https://www.dicebear.com]
      # Thumbs by DiceBear, licensed under CC0 1.0
      avatar_url = "https://api.dicebear.com/9.x/thumbs/svg?seed=#{current_user.email}"

      # Render the avatar
      render plain: URI.open(avatar_url).read, content_type: 'image/svg+xml'
    end
  end
end
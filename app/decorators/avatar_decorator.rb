# frozen_string_literal: true

# Decorator for avatar
class AvatarDecorator < ApplicationDecorator
  delegate_all

  def avatar_url
    # Get avatar from DiceBear [https://www.dicebear.com]
    # Thumbs by DiceBear, licensed under CC0 1.0
    avatar_url = "https://api.dicebear.com/9.x/thumbs/svg?seed=#{current_user.id}"

    # Render the avatar
    render(plain: URI.parse(avatar_url).open.read, content_type: "image/svg+xml")
  end
end

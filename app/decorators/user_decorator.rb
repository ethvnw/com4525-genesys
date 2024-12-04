# frozen_string_literal: true

# Decorator for users
class UserDecorator < ApplicationDecorator
  delegate_all

  def avatar_url
    # Get avatar from DiceBear [https://www.dicebear.com]
    # Thumbs by DiceBear, licensed under CC0 1.0
    if object.id.present?
      dicebear_url = "https://api.dicebear.com/9.x/thumbs/svg?seed=#{object.id}"
      dicebear_url
    else
      "images/fallback_avatar.png"
    end
  end

  def show_role
    object.user_role.present? ? object.user_role.titleize : ""
  end
end

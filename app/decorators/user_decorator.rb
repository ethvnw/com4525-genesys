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

  def avatar_or_default
    if object.avatar.attached? && object.avatar.persisted?
      object.avatar
    else
      avatar_url
    end
  end

  def show_role
    object.user_role.present? ? User.user_roles[object.user_role] : ""
  end

  def you?
    h.current_user.id == object.id
  end
end

# frozen_string_literal: true

# Decorator for users
class UserDecorator < ApplicationDecorator
  delegate_all

  ##
  # Returns the URL for the user's default avatar, from DiceBear [https://www.dicebear.com]
  # Thumbs by DiceBear, licensed under CC0 1.0
  #
  # @return [String] the user avatar URL
  def avatar_url
    if object.id.present?
      Rails.application.routes.url_helpers.api_avatar_path(object.id)
      # ApiRoutes.default_avatar(object.username)
    else
      "images/fallback_avatar.png"
    end
  end

  ##
  # Returns the user avatar (or the default avatar, if no avatar is present)
  #
  # @return [ActiveStorage::Attachment, String] the user avatar
  def avatar_or_default
    # Check whether avatar is persisted to ensure there were no validation errors
    if object.avatar.attached? && object.avatar.persisted?
      # Convert avatar to webp to improve page load speed. Call .processed to save converted avatar to DB after
      object.avatar.variant(resize_to_limit: [100, 100], convert: :webp, format: :webp).processed
    else
      avatar_url
    end
  end

  ##
  # Returns the user role in a human-readable format
  #
  # @return [String] the user role
  def show_role
    object.user_role.present? ? User.user_roles[object.user_role] : ""
  end

  ##
  # Returns true if the current user is the same as the decorated user
  #
  # @return [Boolean] whether the current user is the same as the decorated user
  def you?
    h.current_user.id == object.id
  end
end

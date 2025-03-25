# frozen_string_literal: true

# Handles user information
class AvatarsController < ApplicationController
  include Streamable

  before_action :authenticate_user!
  def update
    message = if avatar_uploaded?
      if current_user.update(avatar_params)
        { content: "Avatar updated successfully.", type: "success" }
      else
        { content: current_user.errors.full_messages.to_sentence, type: "danger" }
      end
    else
      { content: "No avatar photo uploaded.", type: "danger" }
    end

    turbo_redirect_to(edit_user_registration_path, message)
  end

  def destroy
    current_user.avatar.purge_later
    turbo_redirect_to(edit_user_registration_path, { content: "Avatar successfully removed.", type: "success" })
  end

  private

  def avatar_params
    params.require(:user).permit(:avatar)
  end

  def avatar_uploaded?
    params[:user] && params[:user][:avatar].present?
  end
end

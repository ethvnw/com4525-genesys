# frozen_string_literal: true

# Handles user information
class AvatarsController < ApplicationController
  before_action :authenticate_user!
  def update
    if avatar_uploaded?
      if current_user.update(avatar_params)
        flash[:notice] = "Avatar updated successfully."
      else
        flash[:alert] = current_user.errors.full_messages.to_sentence
      end
    else
      flash[:alert] = "No avatar photo uploaded."
    end

    redirect_to(edit_user_registration_path)
  end

  def destroy
    current_user.avatar.purge_later
    redirect_to(edit_user_registration_path, notice: "Avatar successfully removed.")
  end

  private

  def avatar_params
    params.require(:user).permit(:avatar)
  end

  def avatar_uploaded?
    params[:user] && params[:user][:avatar].present?
  end
end

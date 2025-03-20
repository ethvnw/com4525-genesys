# frozen_string_literal: true

# Handles user information
class UsersController < ApplicationController
  before_action :authenticate_user!

  def destroy_avatar
    user = User.find(params[:id])
    user.avatar.purge_later
    redirect_to(edit_user_registration_path, notice: "Profile photo successfully removed.")
  end

  def update_avatar
    # Check that an avatar has been uploaded for saving
    if params[:user] && params[:user][:avatar].present?
      if current_user.update(avatar_params)
        redirect_to(edit_user_registration_path, notice: "Profile photo updated successfully.")
      else
        redirect_to(edit_user_registration_path, alert: "Failed to update Profile photo.")
      end
    else
      redirect_to(edit_user_registration_path, alert: "No profile photo uploaded.")
    end
  end

  private

  def avatar_params
    params.require(:user).permit(:avatar)
  end
end

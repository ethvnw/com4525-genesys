# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def destroy_avatar
    user = User.find(params[:id])
    user.avatar.purge_later
    redirect_to(edit_user_registration_path, notice: "Avatar successfully removed.")
  end
end

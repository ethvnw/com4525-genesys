# frozen_string_literal: true

module Admin
  # Dashboard controller
  class DashboardController < Admin::BaseController
    def index
      @users = User.where.not(id: current_user.id).decorate
      @registrations = Registration.all.order(created_at: :desc).decorate

      # Variables for invitation form
      @user = if session[:user_data]
        User.new(session[:user_data])
      else
        User.new
      end

      @errors = flash[:errors]
    end
  end
end

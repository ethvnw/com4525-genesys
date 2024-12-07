# frozen_string_literal: true

module Admin
  # Dashboard controller
  class DashboardController < Admin::BaseController
    def index
      @users = User.all.decorate
      @registrations = Registration.all.order(created_at: :desc).decorate
    end
  end
end

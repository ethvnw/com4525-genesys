# frozen_string_literal: true

module Admin
  # Dashboard controller
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    include AdminAuthorisation
    def index
      @users = User.all
    end
  end
end

# frozen_string_literal: true

module Admin
  # Staff controller
  class StaffController < ApplicationController
    before_action :authenticate_user!
    include AdminAuthorisation

    def edit
      @user = User.find(params[:id])
    end
  end
end

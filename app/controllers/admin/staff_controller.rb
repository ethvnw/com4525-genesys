# frozen_string_literal: true

module Admin
  # Staff controller
  class StaffController < Admin::BaseController
    def edit
      @user = User.find(params[:id])
    end
  end
end

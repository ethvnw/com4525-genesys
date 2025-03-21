# frozen_string_literal: true

module Admin
  # Staff controller
  class StaffController < Admin::BaseController
    def edit
      @user = User.find(params[:id])
      @errors = flash[:errors]
    end
  end
end

# frozen_string_literal: true

module Api
  # Staff controller
  class StaffController < Admin::BaseController
    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to(admin_dashboard_path, notice: "#{@user.email} updated successfully.")
      end
    end

    def destroy
      @user = User.find(params[:id])
      if @user.destroy
        redirect_to(admin_dashboard_path, notice: "Access removed for #{@user.email}")
      end
    end

    private

    def user_params
      params.require(:user).permit(:user_role)
    end
  end
end

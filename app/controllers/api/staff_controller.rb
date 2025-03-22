# frozen_string_literal: true

module Api
  # Staff controller
  class StaffController < Admin::BaseController
    include Streamable

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        turbo_redirect_to(
          admin_dashboard_path,
          { content: "#{@user.email} updated successfully.", type: "success" },
        )
      else
        flash[:edited_data] = user_params.slice("user_role")
        flash[:errors] = @user.errors.to_hash(true)
        stream_response("admin/staff/update", edit_admin_staff_path(id: @user.id))
      end
    end

    def destroy
      user = User.find(params[:id])
      if user.destroy
        turbo_redirect_to(admin_dashboard_path, { content: "Access removed for #{user.email}", type: "success" })
      end
    end

    private

    def user_params
      params.require(:user).permit(:user_role)
    end
  end
end

# frozen_string_literal: true

module Api
  # Staff controller
  class StaffController < Admin::BaseController
    include Streamable

    def update
      user = User.find(params[:id])
      if user.update(user_params)
        turbo_redirect_to(
          admin_dashboard_path,
          { content: "#{user.email} updated successfully.", type: "success" },
        )
      else
        flash[:edited_data] = user_params.slice("user_role")
        flash[:errors] = user.errors.to_hash(true)
        stream_response(
          streams: turbo_stream.replace(
            "edit_user_#{user.id}",
            partial: "admin/staff/edit",
            locals: { user: user, errors: flash[:errors] },
          ),
          redirect_path: edit_admin_staff_path(id: user.id),
        )
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

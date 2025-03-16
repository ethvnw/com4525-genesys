# frozen_string_literal: true

# Handles account creation invitations
class InvitationsController < Devise::InvitationsController
  before_action :authorize_invitation, only: [:new, :create]
  before_action :update_sanitized_params, only: :update
  before_action :block_default_new_invitation_path

  def create
    user = User.new(invite_params)
    user.valid?
    user.valid_invite? # invitation-specific validation
    invitation_errors = user.errors.messages.slice(:email, :user_role) # Only validate email and user role

    respond_to do |format|
      if invitation_errors.any?
        format.html do
          render(
            partial: "admin/dashboard/invite_form",
            status: :unprocessable_entity,
            locals: { user: user, errors: user.errors.to_hash(true) },
          )
        end
      else
        user.invite!
        session.delete(:user_data)
        format.turbo_stream do
          render(turbo_stream: [
            turbo_stream.append(
              "staff-table-body",
              partial: "admin/dashboard/staff_row",
              locals: { user: user.decorate },
            ),
            turbo_stream.append(
              "toast-list",
              partial: "partials/toast",
              locals: {
                notification_type: "success",
                message: "Invitation sent successfully to #{user.email}.",
              },
            ),
          ])
          format.html { redirect_to(admin_dashboard_path) }
        end
      end
    end
  end

  private

  # Update strong params to allow user to set username when accepting invite
  def update_sanitized_params
    devise_parameter_sanitizer.permit(
      :accept_invitation,
      keys: [:username, :password, :password_confirmation, :invitation_token],
    )
  end

  # Prevent access to devise invitable's default invitation view
  def block_default_new_invitation_path
    if request.path == new_user_invitation_path
      head(:not_found)
    end
  end

  def authorize_invitation
    authorize!(:invite, User)
  end

  def invite_params
    params.require(:user).permit(:email, :user_role)
  end
end

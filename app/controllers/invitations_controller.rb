# frozen_string_literal: true

# Handles account creation invitations
class InvitationsController < Devise::InvitationsController
  before_action :authorize_invitation, only: [:new, :create]

  def create
    self.resource = invite_resource
    resource.user_role = params[:user][:user_role]

    if resource.errors.empty?
      flash[:notice] = "Invitation sent successfully to #{resource.email}."
    else
      flash[:alert] = "There was an issue sending an invitation: #{resource.errors.full_messages.to_sentence}."
    end
    redirect_to(admin_dashboard_path)
  end

  private

  def authorize_invitation
    authorize!(:invite, User)
  end

  def invite_params
    params.require(:user).permit(:email, :user_role)
  end
end

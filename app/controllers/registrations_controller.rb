# frozen_string_literal: true

##
# Subclass of devise's registration controller, to change redirect on account edit
class RegistrationsController < Devise::RegistrationsController
  protected

  # Redirect back to user edit path after editing account
  def after_update_path_for(resource)
    edit_user_registration_path
  end
end

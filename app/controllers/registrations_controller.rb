# frozen_string_literal: true

# Handles custom js loading for devise registrations
class RegistrationsController < Devise::RegistrationsController
  def edit
    # Load the custom js pack for the edit registration page (Custom avatar button)
    @script_packs = ["registrations"]
    super
  end

  protected

  # Redirect back to user edit path after editing account
  def after_update_path_for(resource)
    edit_user_registration_path
  end
end

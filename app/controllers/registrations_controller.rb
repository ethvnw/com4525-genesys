# frozen_string_literal: true

# Handles custom js loading for devise registrations
class RegistrationsController < Devise::RegistrationsController
  def edit
    # Load the custom js pack for the edit registration page (Custom avatar button)
    @script_packs = ["registrations"]
    super
  end
end

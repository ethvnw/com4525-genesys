# frozen_string_literal: true

# Handles custom js loading for devise registrations
class RegistrationsController < Devise::RegistrationsController
  include Streamable

  def new
    super do |resource|
      if flash[:sign_up_params].present?
        # Update resource to keep data in form (when javascript is disabled)
        resource.email = flash[:sign_up_params][:email]
        resource.username = flash[:sign_up_params][:username]
      end
      @errors = flash[:errors]
    end
  end

  def create
    build_resource(sign_up_params)

    resource.save

    if resource.persisted?
      if resource.active_for_authentication?
        message = find_message(:signed_up)
        sign_up(resource_name, resource)
        location = after_sign_up_path_for(resource)
      else
        message = find_message(:"signed_up_but_#{resource.inactive_message}")
        expire_data_after_sign_in!
        location = after_inactive_sign_up_path_for(resource)
      end

      turbo_redirect_to(location, { content: message, type: "success" })
    else
      clean_up_passwords(resource)
      set_minimum_password_length

      flash[:sign_up_params] = sign_up_params.slice("email", "username")
      flash[:errors] = resource.errors.to_hash(true)

      @resource = resource
      stream_response("devise/registrations/create", new_user_registration_path)
    end
  end

  def edit
    if flash[:edited_data].present?
      # Update resource to keep data in form (when javascript is disabled)
      resource.email = flash[:edited_data][:email]
      resource.username = flash[:edited_data][:username]
    end
    @errors = flash[:errors]
    @script_packs = ["registrations"]

    super
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    updated = update_resource(resource, account_update_params)

    if updated
      turbo_redirect_to(
        after_sign_up_path_for(resource),
        { content: "Account updated successfully.", type: "success" },
      )
    else
      clean_up_passwords(resource)
      set_minimum_password_length

      flash[:edited_data] = account_update_params.slice("email", "username")
      flash[:errors] = resource.errors.to_hash(true)

      @resource = resource
      stream_response("devise/registrations/update", edit_user_registration_path)
    end
  end
end

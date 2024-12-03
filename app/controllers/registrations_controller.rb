# frozen_string_literal: true

##
# Controls registrations of interests
class RegistrationsController < ApplicationController
  # POST /api/registrations
  def create
    registration = Registration.new(registration_params)

    # The geocoder gem won't work over localhost (as 'localhost' is not a geocodable IP), so use GB as default
    registration.country_code = request.location.country_code.presence || "GB"

    unless registration.save
      if registration.errors.key?(:email)
        flash[:email_error] = true
        flash[:alert] = "Email " + registration.errors[:email].first
      end

      redirect_back_or_to(subscription_tiers_pricing_path) and return
    end

    flash[:notice] = "Successfully registered. Keep an eye on your inbox for updates!"
    redirect_to(root_path)
  end

  private

  def registration_params
    params.require(:registration).permit(:email, :subscription_tier_id)
  end
end

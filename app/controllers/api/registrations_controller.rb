# frozen_string_literal: true

module Api
  # Controls registrations of interests
  class RegistrationsController < ApplicationController
    include Streamable

    # POST /api/registrations
    def create
      @registration = Registration.new(registration_params)

      # The geocoder gem won't work over localhost (as 'localhost' is not a geocodable IP), so use GB as default
      @registration.country_code = request.location&.country_code.presence || "GB"
      if @registration.save
        Analytics::JourneySaver.call(@registration.id, session[:journey])

        # Reset session
        session.delete(:journey)
        session.delete(:registration_data)

        turbo_redirect_to(root_path, notice: "Successfully registered. Keep an eye on your inbox for updates!")
      else
        flash[:errors] = @registration.errors.to_hash(true)
        session[:registration_data] = @registration.attributes.slice("email")

        @subscription_tier_id = registration_params[:subscription_tier_id]
        stream_response("registrations/create", new_subscription_path(s_id: @subscription_tier_id))
      end
    end

    private

    def registration_params
      params.require(:registration).permit(:email, :subscription_tier_id)
    end
  end
end

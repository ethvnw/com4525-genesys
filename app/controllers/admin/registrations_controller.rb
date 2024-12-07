# frozen_string_literal: true

module Admin
  # Registrations controller
  class RegistrationsController < Admin::BaseController
    def show
      registration = Registration.find(params[:id])
      @landing_page_journey = registration.landing_page_journey
    end
  end
end

# frozen_string_literal: true

module Api
  ##
  # API controller used to redirect the user to the trip form, whilst completing
  # details from a featured location
  class FeaturedLocationsController < ApplicationController
    def show
      featured_location = FeaturedLocation.find(params[:id]).decorate
      session[:featured_location] = {
        title: featured_location.trip_name,
        location_name: featured_location.location_name,
        location_latitude: featured_location.latitude,
        location_longitude: featured_location.longitude,
      }
      redirect_to(new_trip_path)
    end
  end
end

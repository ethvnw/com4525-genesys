# frozen_string_literal: true

module Api
  # Handles the creation of trips
  class TripsController < ApplicationController
    def create
      @trip = Trip.new(trip_params)

      if @trip.save
        session.delete(:trip_data)
        redirect_to(trip_test_path, notice: "Your trip has been submitted.")
      else
        flash[:errors] = @trip.errors.full_messages
        session[:trip_data] = @trip.attributes.slice("trip")
        redirect_to(trip_test_path)
      end
    end

    def trip_params
      params.require(:trip).permit(
        :title,
        :description,
        :start_date,
        :end_date,
        :location_name,
        :location_latitude,
        :location_longitude,
      )
    end
  end
end

# frozen_string_literal: true

module Api
  # Handles the creation of trips
  class TripsController < ApplicationController
    def create
<<<<<<< HEAD
      # First, the trip is created using the form params
=======
>>>>>>> 2099fd1 (feat(trips): added trip creation form)
      @trip = Trip.new(trip_params)

      if @trip.save
        session.delete(:trip_data)
        redirect_to(trip_test_path, notice: "Your trip has been submitted.")
      else
        flash[:errors] = @trip.errors.full_messages
        session[:trip_data] = @trip.attributes.slice("trip")
        redirect_to(trip_test_path)
      end
<<<<<<< HEAD

      # Next, a TripMembership is created between the current logged in user and the new trip
      @membership = TripMembership.new
      @membership.trip_id = @trip.id
      @membership.user_id = @current_user.id
      # Assumed that the creator of a trip accepts the invite.
      @membership.is_invite_accepted = true
      @membership.user_display_name = "TODO" # TODO, fill in username when Kush's changes are merged in !!
      @membership.save
=======
>>>>>>> 2099fd1 (feat(trips): added trip creation form)
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

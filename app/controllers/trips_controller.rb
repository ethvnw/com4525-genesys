# frozen_string_literal: true

# Handles the creation of trips
class TripsController < ApplicationController
  before_action :authenticate_user!

  def index
    @script_packs = ["trips"]
    @trips = Trip.all.decorate
  end

  def new
    @script_packs = ["trips"]
    @trip = if session[:trip_data]
      Trip.new(session[:trip_data])
    else
      Trip.new
    end

    @errors = flash[:errors]
  end

  def create
    # First, the trip is created using the form params
    @trip = Trip.new(trip_params)

    if @trip.save
      session.delete(:trip_data)
      # Next, a TripMembership is created between the current logged in user and the new trip
      @membership = TripMembership.new
      @membership.trip_id = @trip.id
      @membership.user_id = @current_user.id
      # It is assumed that the creator of a trip accepts the invite.
      @membership.is_invite_accepted = true
      @membership.user_display_name = "TODO" # TODO, fill in username when Kush's changes are merged in !!
      @membership.save
      redirect_to(trips_path, notice: "Your trip has been submitted.")
    else
      flash[:errors] = @trip.errors.full_messages
      session[:trip_data] = @trip.attributes.slice("trip")
      redirect_to(trips_path)
    end
  end

  def edit
    @script_packs = ["trips"]
    @trip = Trip.find(params[:id])
    @errors = flash[:errors]
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

  def show
    @trip = Trip.find(params[:id]).decorate
  end
end

# frozen_string_literal: true

# Handles the creation of trips
class TripsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Only show trips that the user is a member of (use TripMemberships in db)
    @trips = Trip.where(id: TripMembership.where(user_id: @current_user.id).pluck(:trip_id)).decorate
    @photo_urls = {}
    @trips.each do |trip|
      photo = Unsplash::Photo.search(trip.location_name.split(",", 2).first).first
      @photo_urls[trip.id] = photo.urls["regular"]
    end
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
      @membership.user_display_name = @current_user.username
      @membership.save
      redirect_to(trips_path, notice: "Your trip has been submitted.")
    else
      flash[:errors] = @trip.errors.full_messages
      session[:trip_data] =
        @trip.attributes.slice(
          "title",
          "description",
          "start_date",
          "end_date",
          "location_name",
          "location_latitude",
          "location_longitude",
        )
      redirect_to(new_trip_path)
    end
  end

  def edit
    @script_packs = ["trips"]
    @trip = Trip.find(params[:id])
    @errors = flash[:errors]
  end

  def update
    @trip = Trip.find(params[:id])
    if @trip.update(trip_params)
      redirect_to(trip_path, notice: "Trip updated successfully.")
    else
      flash[:errors] = @trip.errors.full_messages
      redirect_to(edit_trip_path(@trip))
    end
  end

  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy
    redirect_to(trips_path, notice: "Trip deleted successfully.")
  end

  def show
    @trip = Trip.find(params[:id]).decorate
    plans = @trip.plans.order(:start_date)
    @plan_groups = plans.group_by { |plan| plan.start_date.to_date }
    @plan_groups.each do |date, plans|
      @plan_groups[date] = plans.map(&:decorate)
    end
  end

  private

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

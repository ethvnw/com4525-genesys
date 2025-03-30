# frozen_string_literal: true

# open-uri allows for opening URLs as files (downloading)
require "open-uri"
# uri is used here to encode location names for filenames
require "uri"

# Handles the creation of trips
class TripsController < ApplicationController
  include Streamable

  layout "user"
  before_action :authenticate_user!

  def index
    # Only show trips that the user is a member of (use TripMemberships in db)
    @trips = current_user.trips
      .joins(:trip_memberships)
      .where(trip_memberships: { is_invite_accepted: true })
      .distinct
      .decorate
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
      upload_unsplash_image(@trip.location_name)
      session.delete(:trip_data)
      # Next, a TripMembership is created between the current logged in user and the new trip
      membership = TripMembership.new
      membership.trip_id = @trip.id
      membership.user_id = current_user.id
      # It is assumed that the creator of a trip accepts the invite.
      membership.is_invite_accepted = true
      membership.user_display_name = current_user.username
      membership.save

      redirect_to(trips_path, notice: "Your trip has been submitted.")
    else
      flash[:errors] = @trip.errors.to_hash(true)
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

      # Merge the errors from start_date and end_date into the date error, as this is the one used by the date field
      flash[:errors][:date] ||= []
      flash[:errors][:date].concat(flash[:errors][:start_date]) if flash[:errors][:start_date]
      flash[:errors][:date].concat(flash[:errors][:end_date]) if flash[:errors][:end_date]

      stream_response("trips/create", new_trip_path)
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
      if @trip.saved_change_to_location_name?
        upload_unsplash_image(@trip.location_name)
      end
      redirect_to(trip_path, notice: "Trip updated successfully.")
    else
      flash[:errors] = @trip.errors.to_hash(true)
      stream_response("trips/update", edit_trip_path(@trip))
    end
  end

  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy
    redirect_to(trips_path, notice: "Trip deleted successfully.")
  end

  def show
    @trip = Trip.find(params[:id]).decorate
    plans = @trip.plans.order(:start_date).decorate
    @plan_groups = plans.group_by { |plan| plan.start_date.to_date }
  end

  private

  def upload_unsplash_image(location_name)
    photo = Unsplash::Photo.search(@trip.location_name.split(",", 2).first).first

    if photo
      image_url = photo.urls["regular"]
      downloaded_image = URI.parse(image_url).open
      @trip.image.attach(
        io: downloaded_image,
        # Encode it to prevent special characters in the filename
        filename: "unsplash_#{URI.encode_www_form_component(@trip.location_name)}.jpg",
        content_type: downloaded_image.content_type,
      )
    else
      @trip.image.attach(
        # attach fallback_location_img.png in packs/images
        io: File.open(Rails.root.join("app", "packs", "images", "fallback_location_img.png")),
        filename: "fallback_location_img.png",
        content_type: "image/png",
      )
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

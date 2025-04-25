# frozen_string_literal: true

# open-uri allows for opening URLs as files (downloading)
require "open-uri"
# uri is used here to encode location names for filenames
require "uri"

# Handles the creation of trips
class TripsController < ApplicationController
  include Streamable
  load_and_authorize_resource

  layout "user"
  before_action :authenticate_user!

  def index
    # Enforce presence of "view" query parameter
    unless ["list", "map"].include?(params[:view].to_s)
      flash.keep(:notifications) # Persist notifications across redirect
      default_view = session.fetch(:trip_index_view, "list")
      redirect_to(trips_path(request.query_parameters.merge({ view: default_view }))) and return
    end

    # Store view so that we can redirect user back to their preferred one when creating/deleting a trip
    session[:trip_index_view] = params[:view]

    @trips = current_user.joined_trips.decorate
    stream_response("trips/index")
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
      membership.invite_accepted_date = Time.current
      membership.user_display_name = current_user.username
      membership.sender_user_id = current_user.id
      membership.save

      view_param = session.fetch(:trips_index_view, "list")
      turbo_redirect_to(trips_path(view: view_param), notice: "Trip created successfully.")
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
      view_param = session.fetch(:trips_index_view, "list")
      turbo_redirect_to(trips_path(view: view_param), notice: "Trip updated successfully.")
    else
      flash[:errors] = @trip.errors.to_hash(true)
      stream_response("trips/update", edit_trip_path(@trip))
    end
  end

  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy
    view_param = session.fetch(:trips_index_view, "list")
    turbo_redirect_to(trips_path(view: view_param), notice: "Trip deleted successfully.")
  end

  def show
    # Enforce presence of "view" query parameter
    unless ["list", "map"].include?(params[:view].to_s)
      flash.keep(:notifications) # Persist notifications across redirect
      default_view = session.fetch(:trip_index_view, "list")
      turbo_redirect_to(trip_path(params[:id], request.query_parameters.merge({ view: default_view }))) and return
    end

    # Store view so that we can redirect user back to their preferred one when creating/deleting a plan
    session[:trip_show_view] = params[:view]

    @trips = current_user.joined_trips.decorate

    @trip = Trip.find(params[:id]).decorate
    @trip_membership = TripMembership.find_by(trip_id: @trip.id, user_id: current_user.id)
    plans = @trip.plans.order(:start_date).decorate
    @plan_groups = plans.group_by { |plan| plan.start_date.to_date }

    stream_response("trips/show")
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

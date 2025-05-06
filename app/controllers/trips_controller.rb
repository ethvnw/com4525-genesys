# frozen_string_literal: true

# open-uri allows for opening URLs as files (downloading)
require "open-uri"
# uri is used here to encode location names for filenames
require "uri"

# Handles the creation of trips
class TripsController < ApplicationController
  include Streamable
  include ParamPresenceEnforceable

  before_action :authenticate_user!
  before_action :restrict_admin_and_reporter_access!

  load_and_authorize_resource
  layout "user"

  def index
    enforce_required_parameter(:view, ["list", "map"], :trip_index_view)
    enforce_required_parameter(:order, ["asc", "desc"], :trip_index_order)

    if any_params_enforced?
      # puts params[:view]
      # puts enforced_query_params
      flash.keep(:notifications) # Persist notifications across redirect
      redirect_to(trips_path(enforced_query_params)) and return
    end

    # Store view so that we can redirect user back to their preferred one when creating/deleting a trip
    session[:trip_index_view] = params[:view]
    session[:trip_index_order] = params[:order]

    trip_include_list = []
    if params[:view] == "list"
      trip_include_list += [trip_memberships: { user: { avatar_attachment: :blob } }, image_attachment: :blob]
    end

    @trips = current_user
      .joined_trips
      .includes(trip_include_list)
      .order(start_date: params[:order].to_sym)
      .decorate

    stream_response("trips/index")
  end

  def new
    # Prefill with featured location data if available
    @trip = Trip.new(session[:featured_location] || {})
    @errors = flash[:errors]
  end

  def create
    @trip = Trip.new(trip_params)

    if @trip.save
      if params[:trip][:image].present?
        @trip.image.attach(params[:trip][:image])
      else
        upload_unsplash_image(@trip.location_name)
      end

      TripMembership.create(
        trip_id: @trip.id,
        user_id: current_user.id,
        is_invite_accepted: true,
        invite_accepted_date: Time.current,
        user_display_name: current_user.username,
        sender_user_id: current_user.id,
      )

      view_param = session.fetch(:trips_index_view, "list")
      turbo_redirect_to(trips_path(view: view_param), notice: "Trip created successfully.")
    else
      flash[:errors] = @trip.errors.to_hash(true)

      # Merge the errors from start_date and end_date into the date error, as this is the one used by the date field
      flash[:errors][:date] ||= []
      flash[:errors][:date].concat(flash[:errors][:start_date]) if flash[:errors][:start_date]
      flash[:errors][:date].concat(flash[:errors][:end_date]) if flash[:errors][:end_date]

      stream_response("trips/create", new_trip_path)
    end
  end

  def edit
    @trip = Trip.find(params[:id])
    @errors = flash[:errors]
  end

  def update
    @trip = Trip.find(params[:id])
    if @trip.update(trip_params)
      if params[:trip][:image].present?
        @trip.image.attach(params[:trip][:image])
      elsif @trip.saved_change_to_location_name?
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
    # Enforce presence of required query parameters
    enforce_required_parameter(:view, ["list", "map"], :trip_show_view)

    # If viewing trip in map view, enforce nil order param and avoid lines between plans going to wrong way
    if param_enforced_as?(:view, "map")
      enforce_required_parameter(:order, [nil], :null_key)
    else
      enforce_required_parameter(:order, ["asc", "desc"], :trip_show_order)
    end

    if any_params_enforced?
      flash.keep(:notifications) # Persist notifications across redirect
      turbo_redirect_to(trip_path(params[:id], enforced_query_params)) and return
    end

    # Store view so that we can redirect user back to their preferred one when creating/deleting a plan
    session[:trip_show_view] = params[:view]

    # Don't update saved order if in map view
    if params[:view] != "map"
      session[:trip_show_order] = params[:order]
    end

    @trips = current_user.joined_trips.decorate

    trip_include_list = []
    if params[:view] == "list"
      trip_include_list += [trip_memberships: { user: { avatar_attachment: :blob } }]
    end

    @trip = Trip.includes(trip_include_list).find(params[:id]).decorate
    @trip_membership = TripMembership.find_by(trip_id: @trip.id, user_id: current_user.id)

    # Only include tickets/documents if in list view, as they are not visible in map view
    plans_includes_list = if params[:view] == "list"
      [:scannable_tickets, :ticket_links, :booking_references, documents_attachments: :blob]
    else
      []
    end

    @plans = get_plans_excluding_backups(@trip)
      .includes(plans_includes_list)
      .order(start_date: params[:order] || :asc)
      .decorate

    @plan_groups = @plans.group_by { |plan| plan.start_date.to_date }

    stream_response("trips/show")
  end

  def export_pdf
    trip = Trip.find(params[:id]).decorate
    plans = get_plans_excluding_backups(@trip).order(:start_date).decorate
    plan_groups = plans.group_by { |plan| plan.start_date.to_date }

    html_content = render_to_string(
      template: "pdf_templates/trip",
      layout: false,
      locals: { trip: trip, plan_groups: plan_groups },
    )
    pdf = Grover.new(html_content).to_pdf
    send_data(pdf, filename: "#{trip.title}.pdf", type: "application/pdf", disposition: "attachment")
  end

  private

  def get_plans_excluding_backups(trip)
    trip.plans.where.not(id: Plan.where.not(backup_plan_id: nil).pluck(:backup_plan_id))
  end

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
        io: File.open(Rails.root.join("app", "packs", "images", "fallback_location_img.webp")),
        filename: "fallback_location_img.webp",
        content_type: "image/webp",
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
      :image,
    )
  end
end

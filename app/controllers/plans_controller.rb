# frozen_string_literal: true

# Handles the creation of plans
class PlansController < ApplicationController
  include Streamable
  before_action :authenticate_user!
  before_action :restrict_admin_and_reporter_access!

  load_and_authorize_resource :trip
  load_and_authorize_resource :plan, through: :trip

  layout "user"

  def new
    @trip = Trip.find(params[:trip_id])
    @plan = if session[:plan_data]
      Plan.new(session[:plan_data])
    else
      Plan.new
    end
    @errors = flash[:errors]
    @plan.attributes = session[:plan_data] if session[:plan_data]
  end

  def new_backup_plan
    @script_packs = ["plans_create"]
    @primary_plan = Plan.find(params[:id])

    if @primary_plan.backup_plan.present?
      redirect_back_or_to(trip_plan_path(@trip), alert: "Plan already has a backup plan.")
      return
    end

    @trip = Trip.find(params[:trip_id])
    @plan = if session[:plan_data]
      Plan.new(session[:plan_data])
    else
      Plan.new(
        start_date: @primary_plan.start_date,
        end_date: @primary_plan.end_date,
      )
    end
    @errors = flash[:errors]
    @plan.attributes = session[:plan_data] if session[:plan_data]
  end

  def create
    @plan = Plan.new(plan_params)
    @plan.trip = Trip.find(params[:trip_id])
    if @plan.primary_plan_id.present?
      @plan.is_backup_plan = true
      @primary_plan = Plan.find(@plan.primary_plan_id)
    end

    if @plan.save
      if @plan.primary_plan_id.present?
        @primary_plan.update(backup_plan_id: @plan.id)
      end
      # Create scannable tickets if provided
      qr_codes = params[:scannable_tickets].present? ? JSON.parse(params[:scannable_tickets]) : []
      qr_titles = params[:scannable_ticket_titles].present? ? JSON.parse(params[:scannable_ticket_titles]) : []

      qr_codes.each_with_index do |code, index|
        @plan.scannable_tickets.create(code: code, title: qr_titles[index], ticket_format: :qr)
      end

      # Create booking references and ticket libks if provided
      Plans::BookingReferencesSaver.call(plan: @plan, data: params[:booking_references_data])
      Plans::TicketLinksSaver.call(plan: @plan, data: params[:ticket_links_data])

      session.delete(:plan_data)
      turbo_redirect_to(trip_path(@plan.trip), notice: "Plan created successfully.")
    else
      flash[:errors] = @plan.errors.to_hash(true)

      # If the plan is invalid, tickets and documents are lost. This flag is used to alert the user of this
      lost_uploads_alert = @plan.documents.attached? || params[:scannable_tickets].present?

      # Reset the documents to avoid loading the documents card in the create form with non-existent documents
      @plan.documents = []

      session[:plan_data] =
        @plan.attributes.slice(
          "title",
          "provider_name",
          "plan_type",
          "start_location_name",
          "start_location_latitude",
          "start_location_longitude",
          "end_location_name",
          "end_location_latitude",
          "end_location_longitude",
          "start_date",
          "end_date",
        )

      if @plan.primary_plan_id.present?
        stream_response(
          "plans/create_backup",
          new_backup_plan_trip_plan_path(@plan.trip, @primary_plan),
          lost_uploads_alert ? { type: "danger", content: "Please re-add your documents and/or tickets." } : nil,
        )
      else
        stream_response(
          "plans/create",
          new_trip_plan_path(@plan.trip),
          lost_uploads_alert ? { type: "danger", content: "Please re-add your documents and/or tickets." } : nil,
        )
      end
    end
  end

  def edit
    @trip = Trip.find(params[:trip_id])
    @plan = Plan.find(params[:id]).decorate
    @errors = flash[:errors]
  end

  def update
    @plan = Plan.find(params[:id])
    # Saving the uploaded documents (if any) so current attachments do not get removed on save
    documents = params[:plan][:documents] if params[:plan] && params[:plan][:documents].present?
    if @plan.update(plan_params.except(:documents))
      if documents
        @plan.documents.attach(documents)
      end

      # Create scannable tickets if provided
      any_duplicate_codes = false
      qr_codes = params[:scannable_tickets].present? ? JSON.parse(params[:scannable_tickets]) : []
      qr_titles = params[:scannable_ticket_titles].present? ? JSON.parse(params[:scannable_ticket_titles]) : []

      qr_codes.each_with_index do |code, index|
        # Check if the code already exists before creating a new one
        if @plan.scannable_tickets.exists?(code: code)
          any_duplicate_codes = true
        else
          @plan.scannable_tickets.create(code: code, title: qr_titles[index], ticket_format: :qr)
        end
      end

      # Delete all existing booking references
      @plan.booking_references.destroy_all
      # Create booking references if provided
      JSON.parse(params[:booking_references_data] || []).each do |ref|
        @plan.booking_references.create(name: ref["name"], reference_number: ref["number"])
      end

      # Delete all existing ticket links
      @plan.ticket_links.destroy_all
      # Create ticket links if provided
      JSON.parse(params[:ticket_links_data] || []).each do |link|
        @plan.ticket_links.create(name: link["name"], link: link["url"])
      end

      # The notice message indicates whether any QR codes already existed to the plan
      turbo_redirect_to(trip_path(@plan.trip), notice: "Plan updated successfully.
      #{any_duplicate_codes ? "Some QR codes already existed..." : ""}")
    else
      flash[:errors] = @plan.errors.to_hash(true)
      if @plan.is_backup_plan
        @primary_plan = Plan.find(@plan.primary_plan_id)
        stream_response("plans/update_backup", edit_backup_plan_trip_plan_path(@plan.trip, @primary_plan))
      else
        stream_response("plans/update", edit_trip_plan_path(@plan.trip))
      end
    end
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy
    turbo_redirect_to(trip_path(@plan.trip), notice: "Plan deleted successfully.")
  end

  def show
    @script_packs = ["plans_show"]
    @plan = Plan.find(params[:id]).decorate
    @trip = @plan.trip.decorate
    # Redirect back to the trip page if there are no tickets
    unless @plan.any_tickets?
      redirect_back_or_to(trip_path(@trip), notice: "No tickets available for this plan.")
    end
  end

  private

  def plan_params
    params.require(:plan).permit(
      :title,
      :provider_name,
      :plan_type,
      :start_location_name,
      :start_location_latitude,
      :start_location_longitude,
      :end_location_name,
      :end_location_latitude,
      :end_location_longitude,
      :start_date,
      :end_date,
      :booking_references_data,
      :primary_plan_id,
      documents: [],
    )
  end
end

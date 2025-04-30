# frozen_string_literal: true

# Handles the creation of plans
class PlansController < ApplicationController
  include Streamable
  load_and_authorize_resource :trip
  load_and_authorize_resource :plan, through: :trip

  layout "user"
  before_action :authenticate_user!

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

  def create
    @plan = Plan.new(plan_params)
    @plan.trip = Trip.find(params[:trip_id])
    if @plan.save
      # Create scannable tickets if provided
      qr_codes = params[:scannable_tickets].present? ? JSON.parse(params[:scannable_tickets]) : []
      qr_titles = params[:scannable_ticket_titles].present? ? JSON.parse(params[:scannable_ticket_titles]) : []

      qr_codes.each_with_index do |code, index|
        @plan.scannable_tickets.create(code: code, title: qr_titles[index], ticket_format: :qr)
      end

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

      stream_response(
        "plans/create",
        new_trip_plan_path(@plan.trip),
        lost_uploads_alert ? { type: "danger", content: "Please re-add your documents and/or tickets." } : nil,
      )
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

      # The notice message indicates whether any QR codes already existed to the plan
      turbo_redirect_to(trip_path(@plan.trip), notice: "Plan updated successfully.
      #{any_duplicate_codes ? "Some QR codes already existed..." : ""}")
    else
      flash[:errors] = @plan.errors.to_hash(true)
      stream_response("plans/update", edit_trip_plan_path(@plan))
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
    if @plan.scannable_tickets.empty?
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
      documents: [],
    )
  end
end

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
    @plan = Plan.new.decorate
    @errors = flash[:errors]
    @plan.attributes = session[:plan_data] if session[:plan_data]
  end

  def new_backup_plan
    @primary_plan = Plan.find(params[:id])
    @trip = Trip.find(params[:trip_id])

    if @primary_plan.backup_plan.present?
      redirect_back_or_to(trip_plan_path(@trip), alert: "Plan already has a backup plan.") and return
    elsif @primary_plan.backup_plan?
      redirect_back_or_to(trip_plan_path(@trip), alert: "Backup plans cannot have their own backup plans.") and return
    end

    @plan = Plan.new(
      start_date: @primary_plan.start_date,
      end_date: @primary_plan.end_date,
    ).decorate

    @errors = flash[:errors]
  end

  def create
    @plan = Plan.new(plan_params).decorate
    @plan.trip = Trip.find(params[:trip_id])

    if @plan.save
      @plan.primary_plan&.update(backup_plan_id: @plan.id)

      # Create scannable tickets if provided
      Plans::ScannableTicketsSaver.call(
        plan: @plan,
        scannable_tickets: params[:scannable_tickets],
        titles: params[:scannable_ticket_titles],
      )

      # Create booking references and ticket links if provided
      Plans::BookingReferencesSaver.call(plan: @plan, data: params[:booking_references_data])
      Plans::TicketLinksSaver.call(plan: @plan, data: params[:ticket_links_data])

      turbo_redirect_to(trip_path(@plan.trip), notice: "Plan created successfully.")
    else
      flash[:errors] = @plan.errors.to_hash(true)
      # Merge the errors from start_date and end_date into the date error, as this is the one used by the date field
      flash[:errors][:date] ||= []
      flash[:errors][:date].concat(flash[:errors][:start_date]) if flash[:errors][:start_date]
      flash[:errors][:date].concat(flash[:errors][:end_date]) if flash[:errors][:end_date]
      lost_uploads_alert = if @plan.documents.attached? || params[:scannable_tickets].present?
        {
          type: "danger",
          content: "Please re-add your documents and/or tickets.",
        }
      end

      # Reset the documents to avoid loading the documents card in the create form with non-existent documents
      @plan.documents = []

      if @plan.primary_plan.present?
        stream_response(
          "plans/create_backup",
          new_backup_plan_trip_plan_path(@plan.trip, @plan.primary_plan),
          lost_uploads_alert,
        )
      else
        stream_response(
          "plans/create",
          new_trip_plan_path(@plan.trip),
          lost_uploads_alert,
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
    @plan = Plan.find(params[:id]).decorate
    # Saving the uploaded documents (if any) so current attachments do not get removed on save
    documents = params[:plan][:documents] if params[:plan] && params[:plan][:documents].present?
    if @plan.update(plan_params.except(:documents))
      if documents
        @plan.documents.attach(documents)
      end

      # Create scannable tickets if provided
      any_duplicate_codes = Plans::ScannableTicketsSaver.call(
        plan: @plan,
        scannable_tickets: params[:scannable_tickets],
        titles: params[:scannable_ticket_titles],
      )

      # Delete all existing booking references and ticket links
      @plan.booking_references.destroy_all
      @plan.ticket_links.destroy_all
      # Create booking references and ticket links if provided
      Plans::BookingReferencesSaver.call(plan: @plan, data: params[:booking_references_data])
      Plans::TicketLinksSaver.call(plan: @plan, data: params[:ticket_links_data])

      # The notice message indicates whether any QR codes already existed to the plan
      turbo_redirect_to(trip_path(@plan.trip), notice: "Plan updated successfully.
      #{any_duplicate_codes ? "Some QR codes already existed..." : ""}")
    else
      flash[:errors] = @plan.errors.to_hash(true)
      # Merge the errors from start_date and end_date into the date error, as this is the one used by the date field
      flash[:errors][:date] ||= []
      flash[:errors][:date].concat(flash[:errors][:start_date]) if flash[:errors][:start_date]
      flash[:errors][:date].concat(flash[:errors][:end_date]) if flash[:errors][:end_date]
      if @plan.backup_plan?
        stream_response("plans/update_backup", edit_trip_plan_path(@plan.trip, @plan.primary_plan))
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
    @plan = Plan.includes(documents_attachments: :blob).find(params[:id]).decorate
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

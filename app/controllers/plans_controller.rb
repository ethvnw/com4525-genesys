# frozen_string_literal: true

# Handles the creation of plans
class PlansController < ApplicationController
  include Streamable

  layout "user"
  before_action :authenticate_user!

  def new
    @script_packs = ["plans"]
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
      qr_codes.each do |code|
        @plan.scannable_tickets.create(code: code, ticket_format: :qr)
      end
      session.delete(:plan_data)
      redirect_to(trip_path(@plan.trip), notice: "Plan created successfully.")
    else
      flash[:errors] = @plan.errors.to_hash(true)
      session[:plan_data] =
        @plan.attributes.slice(
          "title",
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

      stream_response("plans/create", new_trip_plan_path(@plan.trip))
    end
  end

  def edit
    @script_packs = ["plans"]
    @trip = Trip.find(params[:trip_id])
    @plan = Plan.find(params[:id])
    @errors = flash[:errors]
  end

  def update
    @plan = Plan.find(params[:id])
    if @plan.update(plan_params)
      existing_flag = false
      qr_codes = params[:scannable_tickets].present? ? JSON.parse(params[:scannable_tickets]) : []
      qr_codes.each do |code|
        # Check if the code already exists before creating a new one
        if @plan.scannable_tickets.exists?(code: code)
          existing_flag = true
        else
          @plan.scannable_tickets.create(code: code, ticket_format: :qr)
        end
      end
      # The notice message indicates whether any QR codes already existed to the plan
      redirect_to(trip_path(@plan.trip), notice: "Plan updated successfully.
        #{existing_flag ? "Some QR codes already existed..." : ""}")
    else
      flash[:errors] = @plan.errors.to_hash(true)
      stream_response("plans/update", edit_trip_plan_path(@plan))
    end
  end

  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy
    redirect_back_or_to(trip_path(@plan.trip), notice: "Plan deleted successfully.")
  end

  private

  def plan_params
    params.require(:plan).permit(
      :title,
      :plan_type,
      :start_location_name,
      :start_location_latitude,
      :start_location_longitude,
      :end_location_name,
      :end_location_latitude,
      :end_location_longitude,
      :start_date,
      :end_date,
    )
  end
end

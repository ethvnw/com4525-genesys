# frozen_string_literal: true

# Handles the creation of plans
class PlansController < ApplicationController
  before_action :authenticate_user!

  def index
    @plans = Plan.order(:start_date)
  end

  def new
    @script_packs = ["plans"]
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
    @plan.trip = Trip.first
    if @plan.save
      redirect_to(root_path)
      session.delete(:plan_data)
    else
      flash[:errors] = @plan.errors.full_messages
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
      redirect_to(new_plan_path)
    end
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

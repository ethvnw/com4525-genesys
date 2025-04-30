# frozen_string_literal: true

# Handles the deletion of scannable tickets
class ScannableTicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_plan

  def destroy
    scannable_ticket = @plan.scannable_tickets.find(params[:ticket_id])
    if scannable_ticket.destroy
      redirect_back_or_to(trip_path(@plan.trip), notice: "Scannable ticket deleted successfully.")
    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end
end

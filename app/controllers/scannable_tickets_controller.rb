# frozen_string_literal: true

# Handles the deletion of scannable tickets
class ScannableTicketsController < ApplicationController
  include Streamable
  before_action :authenticate_user!
  before_action :set_plan

  def destroy
    @plan = Plan.find(params[:plan_id])
    @scannable_ticket_id = params[:ticket_id]
    scannable_ticket = @plan.scannable_tickets.find(params[:ticket_id])
    scannable_ticket.destroy
    stream_response(
      "scannable_tickets/destroy",
      edit_trip_plan_path(@plan.trip, @plan),
      { type: "success", content: "Scannable Ticket deleted successfully." },
    )
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end
end

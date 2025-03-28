# frozen_string_literal: true

# Handles the documents
class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_plan

  def upload
    @plan = Plan.find(params[:plan_id])
    if params[:documents].present?
      @plan.documents.attach(params[:documents])
      redirect_to(new_trip_plan_path, notice: "Documents uploaded successfully.")
    else
      redirect_to(new_trip_plan_path, alert: "No documents selected.")
    end
  end

  def remove
    @plan = Plan.find(params[:plan_id])

    begin
      document = @plan.documents.find(params[:document_id])
      document.purge
      redirect_back_or_to(trip_path(@plan.trip), notice: "Document deleted successfully.")
    rescue ActiveRecord::RecordNotFound
      redirect_back_or_to(trip_path(@plan.trip), alert: "Document not found.")
    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end
end

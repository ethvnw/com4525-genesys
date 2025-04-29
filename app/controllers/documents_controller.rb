# frozen_string_literal: true

# Handles the documents
class DocumentsController < ApplicationController
  include Streamable
  before_action :authenticate_user!
  before_action :set_plan

  def destroy
    @plan = Plan.find(params[:plan_id])

    begin
      @document_id = params[:document_id]
      document = @plan.documents.find(@document_id)
      document.purge
      stream_response(
        "documents/destroy",
        edit_trip_plan_path(@plan.trip, @plan),
        { type: "success", content: "Document deleted successfully." },
      )
    rescue ActiveRecord::RecordNotFound
      respond_with_toast({ type: "danger", content: "Document not found." }, edit_trip_plan_path(@plan.trip, @plan))
    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end
end

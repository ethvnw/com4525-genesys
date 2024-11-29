# frozen_string_literal: true

# Reporter controller
class ReporterController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_reporter

  # GET: Reporter dashboard route ("/reporter/dashboard")
  def dashboard
  end

  private

  def authorize_reporter
    unless current_user.reporter?
      flash[:alert] = "Unauthorized Access."
      redirect_to(root_path)
    end
  end
end

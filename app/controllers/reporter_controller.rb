# frozen_string_literal: true

# Reporter controller
class ReporterController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_reporter

  def dashboard
  end

  private

  def authorize_reporter
    authorize!(:access, :reporter_dashboard)
  end
end

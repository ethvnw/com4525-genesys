# frozen_string_literal: true

module Reporter
  # Dashboard controller
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    include ReporterAuthorisation

    def index
    end

    private

    def authorize_reporter
      unless can?(:access, :reporter_dashboard)
        flash[:alert] = "Unauthorized Access."
        redirect_to(root_path)
      end
    end
  end
end

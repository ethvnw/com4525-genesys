# frozen_string_literal: true

module Reporter
  # Dashboard controller
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    include ReporterAuthorisation

    def index
    end
  end
end

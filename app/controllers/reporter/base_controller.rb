# frozen_string_literal: true

module Reporter
  # Base controller
  class BaseController < ApplicationController
    before_action :authenticate_user!
    include ReporterAuthorization
  end
end

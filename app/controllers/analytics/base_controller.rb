# frozen_string_literal: true

module Analytics
  # Base controller
  class BaseController < ApplicationController
    before_action :authenticate_user!
    include ReporterAuthorization
  end
end

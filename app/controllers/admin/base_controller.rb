# frozen_string_literal: true

module Admin
  # Base controller
  class BaseController < ApplicationController
    before_action :authenticate_user!
    include AdminAuthorization
  end
end

# frozen_string_literal: true

# Admin controller
class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  # GET: Admin dashboard route ("/admin/dashboard")
  def dashboard
  end

  private

  def authorize_admin
    authorize!(:access, :admin_dashboard)
  end
end

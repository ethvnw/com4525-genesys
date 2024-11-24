# frozen_string_literal: true

# Admin controller
class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  # GET: Admin dashboard route ("/admin/dashboard")
  def dashboard
  end

  def manage_reviews
    @reviews = Review.all.order(order: :asc)
  end

  private

  def authorize_admin
    unless can?(:access, :admin_dashboard)
      flash[:alert] = "Unauthorised Access."
      redirect_to(root_path)
    end
  end
end

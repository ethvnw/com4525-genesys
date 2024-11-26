# frozen_string_literal: true

# Admin controller
class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  # GET: Admin dashboard route ("/admin/dashboard")
  def dashboard
    @script_packs = ["dashboard"]
  end

  def manage_reviews
    @script_packs = ["admin_manage_reviews"]
    @visible_reviews = Review.where(is_hidden: false).order(order: :asc)
    @hidden_reviews = Review.where(is_hidden: true).order(order: :asc)
  end

  private

  def authorize_admin
    unless can?(:access, :admin_dashboard)
      flash[:alert] = "Unauthorised Access."
      redirect_to(root_path)
    end
  end
end

# frozen_string_literal: true

# Admin controller
class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  # GET: Admin dashboard route ("/admin/dashboard")
  def dashboard
    @users = User.all
  end

  # GET: Edit staff account route ("/admin/staff/:id/edit")
  def edit_staff
    @user = User.find(params[:id])
  end

  # PATCH: Update staff account route ("/admin/staff/:id")
  def update_staff
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to(admin_dashboard_path, notice: "#{@user.email} updated successfully.")
    else
      redirect_to(admin_dashboard_path, notice: "Error updating #{@user.email}.")
    end
  end

  # DELETE: Delete staff account route ("/admin/staff/:id")
  def destroy_staff
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to(admin_dashboard_path, notice: "Access removed for #{@user.email}")
    else
      redirect_to(admin_dashboard_path, notice: "Failed to remove access for #{@user.email}.")
    end
  end

  def manage_reviews
    @script_packs = ["admin_manage_reviews"]
    @visible_reviews = Review.where(is_hidden: false).order(order: :asc)
    @hidden_reviews = Review.where(is_hidden: true).order(order: :asc)
  end

  def manage_questions
    @script_packs = ["admin_manage_questions"]
    @visible_questions = Question.where(is_hidden: false).order(order: :asc)
    @hidden_questions = Question.where(is_hidden: true).order(order: :asc)
  end

  private

  def authorize_admin
    unless current_user.admin?
      flash[:alert] = "Unauthorized Access."
      redirect_to(root_path)
    end
  end

  def user_params
    params.require(:user).permit(:user_role)
  end
end

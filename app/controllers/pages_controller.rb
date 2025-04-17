# frozen_string_literal: true

# A basic controller from the template app
class PagesController < ApplicationController
  layout "user", only: [:home, :inbox]
  before_action :authorize_members_access, only: [:landing, :faq]
  before_action :authenticate_user!, only: :home

  def landing
    @script_packs = ["landing"]

    # Record the visit
    landing_page_vist = LandingPageVisit.new
    landing_page_vist.country_code = request.location&.country_code.presence || "GB"
    landing_page_vist.save

    @review = if session[:review_data]
      Review.new(session[:review_data])
    else
      Review.new
    end
    @errors = flash[:errors]
    @reviews = Review.where.not(is_hidden: true).order(order: :asc)
    @app_features = SubscriptionTier.find_by(name: "Free")&.app_features
  end

  def faq
    @question = if session[:question_data]
      Question.new(session[:question_data])
    else
      Question.new
    end
    @errors = flash[:errors]
    @questions = Question.where.not(is_hidden: true).order(order: :asc)
  end

  def home
    @script_packs = ["home"]
    @inbox_count = 0
    @errors = flash[:errors]
  end

  def inbox
  end
end

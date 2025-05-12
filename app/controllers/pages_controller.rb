# frozen_string_literal: true

# A basic controller from the template app
class PagesController < ApplicationController
  include Streamable

  layout "user", only: [:home, :inbox]
  before_action :authorize_members_access!, only: [:landing, :faq]
  before_action :authenticate_user!, only: [:home, :inbox]
  before_action :restrict_admin_and_reporter_access!, only: [:home, :inbox]

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
    @errors = flash[:errors]
    @referral_email = session[:referral_email]
    @trips = current_user.joined_trips.order(start_date: :asc).limit(9).includes(
      image_attachment: :blob,
      trip_memberships: { user: { avatar_attachment: :blob } },
    ).decorate
    @featured_locations = FeaturedLocation.all.includes(image_attachment: :blob).decorate
  end

  def inbox
    user_invites = current_user
      .trip_memberships
      .includes(:sender_user, :trip)
      .where(is_invite_accepted: false)
    @pagy, @inbox_messages = pagy(user_invites)

    stream_response("pages/inbox")
  end
end

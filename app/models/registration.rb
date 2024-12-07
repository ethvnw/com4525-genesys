# frozen_string_literal: true

# == Schema Information
#
# Table name: registrations
#
#  id                   :bigint           not null, primary key
#  country_code         :string
#  email                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  subscription_tier_id :bigint           not null
#
# Indexes
#
#  index_registrations_on_subscription_tier_id  (subscription_tier_id)
#
# Foreign Keys
#
#  fk_rails_...  (subscription_tier_id => subscription_tiers.id)
#
class Registration < ApplicationRecord
  belongs_to :subscription_tier

  has_many :feature_shares, dependent: :destroy
  has_many :app_features, through: :feature_shares

  has_many :question_clicks, dependent: :destroy
  has_many :questions, through: :question_clicks

  has_many :review_likes, dependent: :destroy
  has_many :reviews, through: :review_likes

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :country_code, presence: true, length: { is: 2 }
  validate :validate_subscription_tier

  class << self
    def by_day
      Registration.all.group_by do |registration|
        registration.created_at.beginning_of_day
      end.transform_values(&:count)
    end

    def by_week
      Registration.all.group_by do |registration|
        registration.created_at.beginning_of_week
      end.transform_values(&:count)
    end

    def by_month
      Registration.all.group_by do |registration|
        registration.created_at.beginning_of_month
      end.transform_values(&:count)
    end

    def by_country
      Registration.all
        .group_by(&:country_code)
        .transform_keys { |code| ISO3166::Country.new(code) }
        .transform_values(&:count)
    end
  end

  def landing_page_journey
    feature_shares = FeatureShare.where(registration_id: id).decorate
    question_clicks = QuestionClick.where(registration_id: id).decorate
    review_likes = ReviewLike.where(registration_id: id).decorate

    landing_page_journey = feature_shares + question_clicks + review_likes

    landing_page_journey.sort_by(&:created_at)
  end

  private

  def validate_subscription_tier
    errors.add(:subscription_tier, "does not exist") unless subscription_tier.present?
  end
end

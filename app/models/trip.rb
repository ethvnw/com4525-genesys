# frozen_string_literal: true

# == Schema Information
#
# Table name: trips
#
#  id                     :bigint           not null, primary key
#  description            :string
#  end_date               :datetime
#  location_latitude      :decimal(, )
#  location_longitude     :decimal(, )
#  location_name          :string
#  regular_plans_count    :integer          default(0), not null
#  start_date             :datetime
#  title                  :string           not null
#  travel_plans_count     :integer          default(0), not null
#  trip_memberships_count :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class Trip < ApplicationRecord
  include Countable

  has_one_attached :image
  validates :image,
    content_type: ["image/png", "image/jpeg"],
    size: { less_than: 10.megabytes },
    # 3840px accounts for 4k resolution
    dimension: { width: { min: 32, max: 3840 }, height: { min: 32, max: 3840 } },
    if: -> { image.attached? }

  has_many :plans, dependent: :destroy
  has_many :ticket_links, through: :plans
  has_many :trip_memberships, dependent: :destroy
  has_many :users, through: :trip_memberships

  # Validations for the trip attributes
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 500 }
  validate :date_range_cant_be_blank
  validate :location_cant_be_blank
  validate :start_date_cant_be_in_the_past
  validates_with DateValidator
  validate :single_date_validation

  private

  def date_range_cant_be_blank
    if start_date.blank? || end_date.blank?
      errors.add(:date, "can't be blank")
    end
  end

  def location_cant_be_blank
    if location_name.blank? || location_latitude.blank? || location_longitude.blank?
      errors.add(:location, "can't be blank")
    end
  end

  # Validates start date by checking that it is not in the past
  def start_date_cant_be_in_the_past
    if start_date.present? && start_date < Date.current
      errors.add(:start_date, "cannot be in the past")
    end
  end

  # Validates that a single day trip has the start and end times set correctly (00:00 and 23:59)
  def single_date_validation
    return unless start_date && end_date

    if start_date.to_date == end_date.to_date
      self.start_date = start_date.beginning_of_day
      self.end_date = end_date.end_of_day
    end
  end
end

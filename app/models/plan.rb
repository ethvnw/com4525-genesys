# frozen_string_literal: true

# Validates the plan's end location name if the plan type is a travel plan
class PlanValidator < ActiveModel::Validator
  def validate(record)
    unless record.plan_type.blank?
      unless record.plan_type.starts_with?("travel_by")
        record.end_location_name = nil
        record.end_location_latitude = nil
        record.end_location_longitude = nil
      end

      if record.plan_type.starts_with?("travel_by") && record.end_location_name.blank?
        record.errors.add(:end_location_name, "must be present for travel plans")
      end

      if record.start_date.present? && record.start_date < Time.current.change(sec: 0)
        record.errors.add(:start_date, "cannot be in the past")
      end
    end
  end
end

# == Schema Information
#
# Table name: plans
#
#  id                       :bigint           not null, primary key
#  end_date                 :datetime
#  end_location_latitude    :decimal(, )
#  end_location_longitude   :decimal(, )
#  end_location_name        :string
#  plan_type                :integer          not null
#  provider_name            :string
#  start_date               :datetime
#  start_location_latitude  :decimal(, )
#  start_location_longitude :decimal(, )
#  start_location_name      :string
#  title                    :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  trip_id                  :bigint
#
# Indexes
#
#  index_plans_on_trip_id  (trip_id)
#
class Plan < ApplicationRecord
  include Countable

  belongs_to :trip
  has_many_attached :documents
  has_many :ticket_links, dependent: :destroy
  has_many :scannable_tickets, dependent: :destroy

  enum plan_type: {
    clubbing: 0,
    live_music: 1,
    restaurant: 2,
    entertainment: 3,
    wellness: 4,
    active: 5,
    sightseeing: 6,
    travel_by_boat: 7,
    travel_by_bus: 8,
    travel_by_car: 9,
    travel_by_foot: 10,
    travel_by_plane: 11,
    travel_by_train: 12,
    other: 13,
  }

  validates :plan_type, inclusion: { in: plan_types.keys }
  validates :title, presence: true, length: { maximum: 250 }
  validates :start_location_name, :start_date, presence: true
  validates_with PlanValidator
  validates_with DateValidator

  def travel_plan?
    plan_type.starts_with?("travel_by")
  end

  def regular_plan?
    !travel_plan?
  end
end

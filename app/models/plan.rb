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

    # Prevent a plan from being its own backup
    if record.backup_plan_id.present? && record.backup_plan_id == record.id
      record.errors.add(:base, "A plan cannot be a backup of itself")
    end

    # Prevent a backup plan from having its own backup
    if record.id.present? && record.backup_plan_id.present? && Plan.exists?(backup_plan_id: record.id)
      record.errors.add(:base, "A backup plan cannot have its own backup")
    end
  end
end

# == Schema Information
#
# Table name: plans
#
#  id                       :bigint           not null, primary key
#  booking_references_count :integer          default(0), not null
#  end_date                 :datetime
#  end_location_latitude    :decimal(, )
#  end_location_longitude   :decimal(, )
#  end_location_name        :string
#  plan_type                :integer          not null
#  provider_name            :string
#  scannable_tickets_count  :integer          default(0), not null
#  start_date               :datetime
#  start_location_latitude  :decimal(, )
#  start_location_longitude :decimal(, )
#  start_location_name      :string
#  ticket_links_count       :integer          default(0), not null
#  title                    :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  backup_plan_id           :bigint
#  trip_id                  :bigint
#
# Indexes
#
#  index_plans_on_backup_plan_id  (backup_plan_id)
#  index_plans_on_trip_id         (trip_id)
#
# Foreign Keys
#
#  fk_rails_...  (backup_plan_id => plans.id)
#
class Plan < ApplicationRecord
  include Countable
  attr_accessor :primary_plan_id

  belongs_to :trip
  belongs_to :backup_plan, class_name: "Plan", optional: true, foreign_key: "backup_plan_id"
  has_many_attached :documents
  has_many :ticket_links, dependent: :destroy
  has_many :booking_references, dependent: :destroy
  has_many :scannable_tickets, dependent: :destroy
  has_one :primary_plan, class_name: "Plan", foreign_key: "backup_plan_id", dependent: :nullify

  after_create :add_counter_cache
  after_update :update_counter_cache
  after_destroy :remove_counter_cache

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
    free_time: 14,
  }

  validates :plan_type, inclusion: { in: plan_types.keys }
  validates :title, presence: true, length: { maximum: 250 }
  validates :start_location_name, presence: true, unless: :free_time_plan?
  validates :start_date, presence: true
  validate :start_within_trip_dates
  validate :end_within_trip_dates
  validates_with PlanValidator
  validates_with DateValidator

  def start_within_trip_dates
    if start_date.present? && trip.start_date.present? && (start_date < trip.start_date || start_date > trip.end_date)
      errors.add(:start_date, "must be within the trip dates")
    end
  end

  def end_within_trip_dates
    if end_date.present? && trip.end_date.present? && (end_date > trip.end_date || end_date < trip.start_date)
      errors.add(:end_date, "must be within the trip dates")
    end
  end

  def travel_plan?
    plan_type.starts_with?("travel_by")
  end

  def regular_plan?
    !travel_plan?
  end

  def any_tickets?
    ticket_links_count > 0 || booking_references_count > 0 || scannable_tickets_count > 0
  end

  def free_time_plan?
    plan_type == "free_time"
  end

  def backup_plan?
    primary_plan.present?
  end

  ##
  # Increments the trip's counter cache for the relevant plan type when creating the plan
  def add_counter_cache
    if travel_plan?
      trip.increment!(:travel_plans_count)
    else
      trip.increment!(:regular_plans_count)
    end
  end

  ##
  # Decrements the trip's counter cache for the relevant plan type when deleting the plan
  def remove_counter_cache
    if travel_plan?
      trip.decrement!(:travel_plans_count)
    else
      trip.decrement!(:regular_plans_count)
    end
  end

  ##
  # Updates the trip's counter cache for the relevant plan type when editing the plan
  def update_counter_cache
    if plan_type_before_last_save.starts_with?("travel_by") != plan_type.starts_with?("travel_by")
      old_type = travel_plan? ? :regular_plans_count : :travel_plans_count
      new_type = travel_plan? ? :travel_plans_count : :regular_plans_count

      trip.transaction do
        trip.decrement!(old_type)
        trip.increment!(new_type)
      end
    end
  end
end

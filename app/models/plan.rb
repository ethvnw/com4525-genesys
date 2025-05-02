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
#  is_backup_plan           :boolean          default(FALSE), not null
#  plan_type                :integer          not null
#  provider_name            :string
#  start_date               :datetime
#  start_location_latitude  :decimal(, )
#  start_location_longitude :decimal(, )
#  start_location_name      :string
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
#  fk_rails_...  (backup_plan_id => plans.id) ON DELETE => nullify
#
class Plan < ApplicationRecord
  include Countable
  attr_accessor :primary_plan_id

  belongs_to :trip
  has_many_attached :documents
  has_many :ticket_links, dependent: :destroy
  has_many :booking_references, dependent: :destroy
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
    free_time: 14,
  }

  belongs_to :backup_plan, class_name: "Plan", optional: true

  validates :plan_type, inclusion: { in: plan_types.keys }
  validates :title, presence: true, length: { maximum: 250 }
  validates :start_location_name, presence: true, unless: :free_time_plan?
  validates :start_date, presence: true
  validates_with PlanValidator
  validates_with DateValidator

  # Custom validations
  validate :only_one_backup_plan
  validate :backup_plan_cannot_have_its_own_backup

  def travel_plan?
    plan_type.starts_with?("travel_by")
  end

  def regular_plan?
    !travel_plan?
  end

  def any_tickets?
    ticket_links.any? || booking_references.any? || scannable_tickets.any?
  end

  def free_time_plan?
    plan_type == "free_time"
  end

  private

  # Ensure a plan can only have one backup plan
  def only_one_backup_plan
    if Plan.exists?(backup_plan_id: id)
      errors.add(:base, "This plan already has a backup plan.")
    end
  end

  # Ensure a backup plan cannot have its own backup plan
  def backup_plan_cannot_have_its_own_backup
    if is_backup_plan && backup_plan_id.present?
      errors.add(:base, "A backup plan cannot have its own backup plan.")
    end
  end
end

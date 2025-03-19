# frozen_string_literal: true

# == Schema Information
#
# Table name: trips
#
#  id                 :bigint           not null, primary key
#  description        :string
#  end_date           :datetime
#  location_latitude  :decimal(, )
#  location_longitude :decimal(, )
#  location_name      :string
#  start_date         :datetime
#  title              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Trip < ApplicationRecord
  has_one_attached :image

  has_many :plans, dependent: :destroy
  has_many :ticket_links, through: :plans
  has_many :trip_memberships, dependent: :destroy
  has_many :users, through: :trip_memberships

  # Validations for the trip attributes
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 500 }
  validate :date_range_cant_be_blank
  validate :location_cant_be_blank

  private

  def date_range_cant_be_blank
    if start_date.blank? || end_date.blank?
      errors.add(:base, "Date range can't be blank")
    end
  end

  def location_cant_be_blank
    if location_name.blank? || location_latitude.blank? || location_longitude.blank?
      errors.add(:base, "Location can't be blank")
    end
  end
end

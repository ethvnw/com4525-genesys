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
  has_many :document_links, through: :plans
  has_many :trip_memberships, dependent: :destroy
  has_many :users, through: :trip_memberships
end

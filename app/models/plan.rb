# frozen_string_literal: true

# == Schema Information
#
# Table name: plans
#
#  id                       :bigint           not null, primary key
#  end_date                 :datetime
#  end_location_latitude    :decimal(, )
#  end_location_longitude   :decimal(, )
#  end_location_name        :string
#  start_date               :datetime
#  start_location_latitude  :decimal(, )
#  start_location_longitude :decimal(, )
#  start_location_name      :string
#  title                    :string           not null
#  type                     :integer          not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  trip_id                  :bigint
#
# Indexes
#
#  index_plans_on_trip_id  (trip_id)
#
class Plan < ApplicationRecord
  belongs_to :trip
  has_many_attached :documents
  has_many :ticket_links, dependent: :destroy
  has_many :scannable_tickets, dependent: :destroy

  enum type: [:sightseeing]

  validates :type, inclusion: { in: types }
end

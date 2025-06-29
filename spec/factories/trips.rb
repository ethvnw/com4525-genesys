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
# Indexes
#
#  index_trips_on_start_date  (start_date)
#
FactoryBot.define do
  ##
  factory :trip do
    title { "Mock Trip" }
    description { "Mock Trip Description" }

    start_date { Time.current }
    end_date { Time.current + 6.day }

    location_name { "The Peak District" }
    location_latitude { 53.3673 }
    location_longitude { 1.8158 }

    image do
      safely_create_file("mock_trip_image.jpg", "image/jpeg")
    end
  end
end

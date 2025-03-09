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
#  plan_type                :integer          not null
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
FactoryBot.define do
  ##
  # No start/end times set - when testing, use travel_to to set time for a specific test,
  # and specify the dates when using the factory.
  factory :plan do
    title { "Mock Plan" }
    plan_type { :travel_by_plane }
    start_date { Time.current + 1.day }
    end_date { Time.current + 2.days }
    start_location_name { "Edale, Peak District, UK" }
    start_location_latitude { 53.3673 }
    start_location_longitude { 1.8158 }
    end_location_name { "Kinder Scout, Peak District, UK" }
    end_location_latitude { 53.3849 }
    end_location_longitude { 1.8734 }

    association :trip
  end
end

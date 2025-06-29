# frozen_string_literal: true

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
#  index_plans_on_start_date      (start_date)
#  index_plans_on_trip_id         (trip_id)
#
# Foreign Keys
#
#  fk_rails_...  (backup_plan_id => plans.id)
#  fk_rails_...  (trip_id => trips.id)
#
FactoryBot.define do
  ##
  # No start/end times set - when testing, use travel_to to set time for a specific test,
  # and specify the dates when using the factory.
  factory :plan do
    title { "Mock Plan" }
    provider_name { "Company Name" }
    plan_type { :travel_by_plane }
    start_date { Time.current + 1.day }
    end_date { Time.current + 2.days }
    start_location_name { "Edale, Peak District, UK" }
    start_location_latitude { 53.3673 }
    start_location_longitude { 1.8158 }
    end_location_name { "Kinder Scout, Peak District, UK" }
    end_location_latitude { 53.3849 }
    end_location_longitude { 1.8734 }

    trait :no_end_location do
      plan_type { :other }
      end_location_name { nil }
      end_location_latitude { nil }
      end_location_longitude { nil }
    end

    trait :with_ticket do
      scannable_tickets { [create(:scannable_ticket)] }
    end

    trait :with_ticket_link do
      ticket_links { [create(:ticket_link)] }
    end

    trait :with_booking_reference do
      booking_references { [create(:booking_reference)] }
    end

    association :trip
  end
end

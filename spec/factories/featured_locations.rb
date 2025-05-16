# frozen_string_literal: true

# == Schema Information
#
# Table name: featured_locations
#
#  id               :bigint           not null, primary key
#  country_code_iso :string
#  latitude         :decimal(, )
#  longitude        :decimal(, )
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :featured_location do
    name { "The Peak District" }
    latitude { 53.3673 }
    longitude { 1.8158 }
    country_code_iso { "GB" }

    image do
      safely_create_file("mock_trip_image.jpg", "image/jpeg")
    end
  end
end

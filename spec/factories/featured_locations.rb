# frozen_string_literal: true

# == Schema Information
#
# Table name: featured_locations
#
#  id         :bigint           not null, primary key
#  latitude   :decimal(, )
#  longitude  :decimal(, )
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :featured_location do
    name { "The Peak District" }
    latitude { 53.3673 }
    longitude { 1.8158 }

    image do
      Rack::Test::UploadedFile.new(
        File.join(Rails.root, "spec", "support", "files", "mock_trip_image.jpg"),
        "image/jpeg",
      )
    end
  end
end
